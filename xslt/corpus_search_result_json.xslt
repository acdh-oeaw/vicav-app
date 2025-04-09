<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei acdh"
    version="2.0">
    <xsl:import href="utterances-to-json.xsl"/>

    <xsl:output method="xml" indent="no"/>
    <xsl:param name="query"></xsl:param>
    <xsl:template match="/">
        <json objects="json hits">
            <xsl:apply-templates mode="docwrap"/>
        </json>
    </xsl:template>

    <xsl:template match="*:hits" mode="docwrap">
        <query><xsl:value-of select="$query"/></query>
        <hits>
          <xsl:apply-templates select="." mode="#default"/>
        </hits>
    </xsl:template>

    <xsl:template match="@hits">
        <hits type="array">
            <xsl:for-each select="tokenize(.)">
                <_><xsl:value-of select="."/></_>
            </xsl:for-each>
        </hits>
    </xsl:template>
</xsl:stylesheet>