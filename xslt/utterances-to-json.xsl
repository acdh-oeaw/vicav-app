<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="3.0">
    
    <xsl:import href="xml-to-basex-json-xml.xsl"/>
    
    <xsl:variable name="dictById" select="map:merge(//tei:entry!map {data(./@xml:id): .})"/>
    
    <xsl:template match="tei:u">
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array"><xsl:apply-templates select="tei:w|tei:pc|tei:gap|tei:media" mode="array"/></_0024_0024>
    </xsl:template>
    
    <xsl:template match="tei:u" mode="array">
        <_ type="object">
          <xsl:apply-templates select="@*"/>
          <_0024_0024 type="array"><xsl:apply-templates select="tei:w|tei:pc|tei:gap|tei:media" mode="array"/></_0024_0024>
        </_>
    </xsl:template>
    
    <xsl:template match="tei:w|tei:pc|tei:gap|tei:media" mode="array">
        <_ type="object">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="type">object</xsl:attribute>
                <xsl:apply-templates select="."/>
                <xsl:if test=".[@lemmaRef]">
                    <xsl:variable name="id" select="replace(data(@lemmaRef), 'dict:', '')"/>
                    <xsl:apply-templates select="$dictById($id)/tei:gramGrp/tei:gram"></xsl:apply-templates>
                </xsl:if>
            </xsl:element>
        </_>
    </xsl:template>
    
    <xsl:template match="tei:gram">
        <xsl:element name="{@type}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:w[count((text(),*)) > 1]">        
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array">
            <xsl:apply-templates select="." mode="sequence"/>
        </_0024_0024> 
    </xsl:template>
    
</xsl:stylesheet>