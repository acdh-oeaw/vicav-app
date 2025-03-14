<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="2.0">
    <xsl:preserve-space elements="span"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="hits_str"/>
    <xsl:param name="assetsBaseURIpattern" />
    <xsl:param name="assetsBaseURIto" />
    
    <xsl:variable name="dictById" select="map:merge(//tei:entry!map {data(./@xml:id): .})"/>

    <xsl:template match="/">
        <json objects="json">
            <xsl:apply-templates mode="docwrap"/>
        </json>
    </xsl:template>

    <xsl:function name="acdh:render-u">
        <xsl:param name="u"/>
        <xsl:variable name="hits" select="tokenize($hits_str, ',')" />        
        <xsl:variable name="html">
        <div class="u">
            <!-- <xsl:attribute name="id" select="$u/@xml:id"/>
            <div class="xml-id">
                <xsl:value-of select="$u/@xml:id"/>
            </div> -->
            <div class="content">
            <xsl:variable name="ana-exists" select="exists($u//@ana)"/>
            <xsl:for-each select="$u/*">
                <xsl:variable name="ana-id" select="substring(@ana, 2)"/>
                <span>
                    <xsl:attribute name="class">
                        <xsl:value-of select="./name()"/>
                        <xsl:if test="@xml:id = $hits">
                          <xsl:value-of select="' '"/>
                          <xsl:value-of select="'hit'"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:attribute name="id" select="@xml:id"/>
                    <xsl:value-of select="."/>
                    <xsl:if test="$ana-exists">
                    <span class="ana">
                      <xsl:apply-templates select="//*[@xml:id=$ana-id]/tei:f"/>
                      &#xA0;
                    </span>
                    </xsl:if>
                </span>
                <xsl:if test="not(./@join = 'right' or following-sibling::*[1]/name() = 'pc')">
                    <span class="c">&#xA0;<xsl:if test="$ana-exists"><span class="ana">&#xA0;</span></xsl:if></span>
                </xsl:if>
                <xsl:if test="./@join = 'right' and ./@rend='withDash'">
                    <span class="c">-<xsl:if test="$ana-exists"><span class="ana">&#xA0;</span></xsl:if></span>
                </xsl:if>
            </xsl:for-each>
            </div>
        </div>
        </xsl:variable>
        <xsl:value-of select='serialize($html, map{"method":"html"})'/>
    </xsl:function>
    
    <xsl:template match="tei:f">
    <span class="sep">/</span><span class="{@name}"><xsl:value-of select="(tei:string|@fVal)"/></span>
    </xsl:template>
    
    <xsl:template match="tei:f[@name='dict']">
    <xsl:variable name="dict" select="replace(//tei:prefixDef[@ident='dict']/@replacementPattern, '.+/(.+)\.xml#\$1$', '$1')"/>
    <span class="sep">/</span><a class="{@name}" data-target-type="DictQuery" data-text-id="{$dict}" data-query-params="{{&quot;id&quot;: &quot;{replace((tei:string|@fVal), '^dict:', '')}&quot;}}" href="#"><i class="fa-solid fa-book"></i></a> 
    </xsl:template>
    
    <xsl:template match="doc" mode="docwrap">
       <doc type="object">           
           <xsl:apply-templates select="." mode="#default"/>
       </doc> 
    </xsl:template>
    
    <xsl:template match="tei:u">
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array"><xsl:apply-templates select="tei:w|tei:pc|tei:gap" mode="array"/></_0024_0024>
    </xsl:template>
    
    <xsl:template match="tei:w|tei:pc|tei:gap" mode="array">
        <_ type="object">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="type">object</xsl:attribute>
                <xsl:apply-templates select="."/>
                <xsl:if test=".[@lemmaRef]">
                    <xsl:variable name="id" select="replace(data(@lemmaRef), 'dict:', '')"/>
                    <xsl:apply-templates select="$dictById($id)/tei:gramGrp/tei:gram"></xsl:apply-templates>
                </xsl:if>
            </xsl:element>
        </_>
    </xsl:template>
    
    <xsl:template match="tei:gram">
        <xsl:element name="{@type}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:w[count((text(),*)) > 1]">        
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array">
            <xsl:apply-templates select="." mode="sequence"/>
        </_0024_0024> 
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:apply-templates select="@*"/>
        <xsl:for-each-group select="*|text()[normalize-space(.) ne '']" group-adjacent="local-name()">
          <xsl:choose>
              <xsl:when test="current-group()/local-name() = ''">
                  <xsl:apply-templates select="current-group()" mode="#default"/> 
              </xsl:when>
              <xsl:when test="count(current-group()) > 1">
                  <xsl:element name="{local-name()||'s'}">
                      <xsl:attribute name="type">array</xsl:attribute>
                      <xsl:apply-templates select="current-group()" mode="array"/>
                  </xsl:element>
              </xsl:when>
              <xsl:when test="self::tei:dict|self::standOff"/> <!-- only for lookup -->
              <xsl:otherwise>
                  <xsl:element name="{local-name()}">
                      <xsl:attribute name="type">object</xsl:attribute>
                      <xsl:apply-templates select="current-group()" mode="#default"/>
                  </xsl:element>
              </xsl:otherwise>
          </xsl:choose>  
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="*" mode="array">
        <_ type="object">
        <xsl:apply-templates select="@*"/>
            <xsl:for-each-group select="*|text()[normalize-space(.) ne '']" group-adjacent="local-name()">
            <xsl:choose>
                <xsl:when test="current-group()/local-name() = ''">
                    <xsl:apply-templates select="current-group()" mode="#default"/> 
                </xsl:when>
                <xsl:when test="count(current-group()) > 1">
                    <xsl:element name="{local-name()||'s'}">
                        <xsl:attribute name="type">array</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="array"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{local-name()}">                       
                        <xsl:attribute name="type">object</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="#default"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>  
        </xsl:for-each-group>
        </_>
    </xsl:template>
    
    <xsl:template match="*" mode="sequence">
        <xsl:for-each-group select="*|text()[normalize-space(.) ne '']" group-adjacent="local-name()">
            <_ type="object">
            <xsl:choose>
                <xsl:when test="current-group()/local-name() = ''">
                    <xsl:apply-templates select="current-group()" mode="#default"/> 
                </xsl:when>
                <xsl:when test="count(current-group()) > 1">
                    <xsl:element name="{local-name()||'s'}">
                        <xsl:attribute name="type">array</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="array"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{local-name()}">                       
                        <xsl:attribute name="type">object</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="#default"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            </_>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="*[normalize-space(string-join(text())) ne '' and count(text()) > 1]">        
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array">
            <xsl:attribute name="type">array</xsl:attribute>
            <xsl:apply-templates select="." mode="sequence"/>
        </_0024_0024>        
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:element name="{'_0040'||local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="text()">
      <_0024><xsl:value-of select="."/></_0024>
    </xsl:template>
    
    <xsl:template match="text()" mode="array">
        <_><_0024><xsl:value-of select="."/></_0024></_>
    </xsl:template>
</xsl:stylesheet>
