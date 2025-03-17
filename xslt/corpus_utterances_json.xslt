<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="3.0">    
    <xsl:import href="utterances-to-json.xsl"/>
    <xsl:preserve-space elements="span"/>
    <xsl:output method="xml" indent="no"/>

    <xsl:param name="hits_str"/>
    <xsl:param name="assetsBaseURIpattern" />
    <xsl:param name="assetsBaseURIto" />

    <xsl:template match="/">
        <json objects="json">
            <xsl:apply-templates mode="docwrap"/>
        </json>
    </xsl:template>
    
    <xsl:template match="doc" mode="docwrap">
        <doc type="object">           
            <xsl:apply-templates select="." mode="#default"/>
        </doc> 
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
</xsl:stylesheet>
