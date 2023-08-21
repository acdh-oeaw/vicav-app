<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:preserve-space elements="span"/>
    <xsl:param name="hits_str" select="()" />

    <xsl:template match="/doc">
        <xsl:variable name="hits" select="tokenize($hits_str, ',')" />

        <div class="corpus-utterances">
        <xsl:for-each select="./tei:u">
            <div class="u">
                <div class="xmlId">
                    <xsl:value-of select="@xml:id"/>
                </div>
                <div class="content">
                    <xsl:attribute name="id" select="@xml:id"/>
                    <xsl:for-each select="./*">
                        <span>
                            <xsl:attribute name="class">
                                <xsl:value-of select="./name()"/>
                                <xsl:if test="@xml:id = $hits">
                                    <xsl:value-of select="' '"/>
                                  hit
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
        </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>