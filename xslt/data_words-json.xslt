<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:_="urn:_"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    exclude-result-prefixes="xd _ xs err"
    version="3.1">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 9, 2024</xd:p>
            <xd:p><xd:b>Author:</xd:b>Maura Zsofia Abraham</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
        
    <xsl:template match="/">
        <json arrays="json">
          <xsl:apply-templates select=".//word"/>
        </json>
    </xsl:template>

    <xd:doc>
        <xd:desc>One word</xd:desc>
    </xd:doc>
    <xsl:template match="word">
        <_ type="string">
            <xsl:value-of select="."/>
        </_>
    </xsl:template>
</xsl:stylesheet>