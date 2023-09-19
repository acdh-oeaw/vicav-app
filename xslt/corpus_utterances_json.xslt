<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:preserve-space elements="span"/>

    <xsl:include href="serialize-html.xslt"/>
    <xsl:param name="hits_str"/>

    <xsl:template match="/">
        <json objects="json" arrays="utterances">
            <xsl:apply-templates />
        </json>
    </xsl:template>

    <xsl:function name="acdh:render-u">
        <xsl:param name="u"/>
        <xsl:variable name="hits" select="tokenize($hits_str, ',')" />

        <div class="u">
            <xsl:attribute name="id" select="$u/@xml:id"/>
            <div class="xmlId">
                <xsl:value-of select="$u/@xml:id"/>
            </div>
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
    </xsl:function>

    <xsl:template match="/doc">
        <id><xsl:value-of select="@id"/></id>
        <utterances>
        <xsl:for-each select="./tei:u">
            <_ type="object">
                <id><xsl:value-of select="@xml:id"/></id>
                <content>
                    <xsl:apply-templates select="acdh:render-u(.)" mode="serialize"/>
                </content>
            </_>
        </xsl:for-each>
        </utterances>
    </xsl:template>
</xsl:stylesheet>