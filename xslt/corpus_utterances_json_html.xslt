<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="2.0">
    <xsl:preserve-space elements="span"/>

    <xsl:param name="hits_str"/>
    
    <xsl:variable name="assetsBaseURIpattern">^(.+)$</xsl:variable>
    <xsl:variable name="assetsBaseURIto">/static/audio/$1</xsl:variable>

    <xsl:template match="/">
        <json objects="json" arrays="utterances">
            <xsl:apply-templates />
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

    <xsl:template match="/doc">
        <id><xsl:value-of select="@id"/></id>
        <utterances>
        <xsl:for-each select=".//tei:u">
            <_ type="object">
                <id><xsl:value-of select="@xml:id"/></id>
                <audio>
                    <xsl:if test="./tei:media[@mimeType='audio/mp3']">
                        <xsl:value-of select="replace(
                            substring-after(./tei:media[@mimeType='audio/mp3']/@url, ':'), 
                        $assetsBaseURIpattern, 
                        $assetsBaseURIto)" />
                    </xsl:if>
                </audio>
                <content>
                    <xsl:apply-templates select="acdh:render-u(.)"/>
                </content>
            </_>
        </xsl:for-each>
        </utterances>
    </xsl:template>
</xsl:stylesheet>
