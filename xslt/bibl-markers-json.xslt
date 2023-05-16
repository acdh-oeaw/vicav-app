<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 5, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b>Omar Siam</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <json objects="geometry properties" arrays="json coordinates">
          <xsl:apply-templates select=".//r"/>
        </json>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>One marker</xd:desc>
    </xd:doc>
    <xsl:template match="r">
        <xsl:variable name="coords" select="tokenize(geo, ' ')"/>
        <_ type="object">
            <type>Feature</type>
            <geometry>
                <type>Point</type>
                <coordinates>
                    <_ type="number"><xsl:value-of select="$coords[2]"/></_>
                    <_ type="number"><xsl:value-of select="$coords[1]"/></_>
                </coordinates>
            </geometry>
            <properties>
                <type><xsl:value-of select="@type"/></type>
                <name><xsl:value-of select="alt"/></name>
                <hitCount><xsl:value-of select="freq"/></hitCount>
            </properties>
        </_>
    </xsl:template>
    
</xsl:stylesheet>