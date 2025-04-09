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
</xsl:stylesheet>
