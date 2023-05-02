<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:preserve-space elements="span"/>

    
    <xsl:template match="/">
        <div class="corpus-utterances">
        <xsl:for-each select="./doc/tei:u">
                <div class="u">
                    <xsl:attribute name="id" select="@xml:id"/>
                    <xsl:for-each select="./*">
                    <span>
                        <xsl:attribute name="class" select="./name()"/>
                        <xsl:attribute name="id" select="@xml:id"/>
                        <xsl:value-of select="."/>
                    </span>
                    <xsl:if test="not(./@join = 'right')  or following-sibling::*[1]/name() = 'pc'">
                        <span xml:space="preserve"> </span>
                    </xsl:if>
                </xsl:for-each>
                </div>

        </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>