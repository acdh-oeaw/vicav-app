<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    version="2.0">
    <xsl:param name="xslt"/>

    <xsl:preserve-space elements="*"/>

    <xsl:template match="@*|node()">
        <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
    </xsl:template>

    <xsl:template match="xsl:include">
        <xsl:copy>
            <xsl:attribute name="href"><xsl:value-of select="$xslt"/></xsl:attribute>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
