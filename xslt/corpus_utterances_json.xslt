<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="2.0">
    <xsl:preserve-space elements="span"/>

    <xsl:param name="hits_str"/>
    <xsl:param name="assetsBaseURIpattern" />
    <xsl:param name="assetsBaseURIto" />

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
            <xsl:for-each select="$u/*">
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
                </span>
                <xsl:if test="not(./@join = 'right' or following-sibling::*[1]/name() = 'pc')">
                    <span xml:space="preserve"> </span>
                </xsl:if>
                <xsl:if test="./@join = 'right' and ./@rend='withDash'">
                    <span>-</span>
                </xsl:if>
            </xsl:for-each>
            </div>
        </div>
        </xsl:variable>
        <xsl:value-of select='serialize($html, map{"method":"html"})'/>
    </xsl:function>

    <xsl:template match="/doc">
        <id><xsl:value-of select="@id"/></id>
        <utterances>
        <xsl:for-each select="./tei:u">
            <_ type="object">
                <id><xsl:value-of select="@xml:id"/></id>
                <audio>
                    <xsl:if test="./tei:media[@type='distributionFile']">
                        <xsl:value-of select="replace(
                        replace(./tei:media[@type = 'distributionFile'][1]/@url, 'assets:', ''), 
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