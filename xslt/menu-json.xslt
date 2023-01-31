<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="3.1">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <json objects="json projectConfig logo frontpage menu" arrays="panel param main item subnav"><xsl:apply-templates/></json>
    </xsl:template>
    
    <xsl:template match="img">
        <img><xsl:value-of select="@src"/></img>
    </xsl:template>
    
    <xsl:template match="frontpage">
        <param><xsl:apply-templates select="param"/></param>
        <panel><xsl:apply-templates select="panel"/></panel>
    </xsl:template>
    
    <xsl:template match="param">
        <_><xsl:apply-templates/></_>
    </xsl:template>
    
    <xsl:template match="dropdown">
        <_ type="object">
            <xsl:apply-templates select="@*"/>
            <item><xsl:apply-templates/></item>
        <xsl:apply-templates/></_>
    </xsl:template>
    
    <xsl:template match="panel|item">
        <_ type="object">
          <xsl:apply-templates select="@*"/>
          <title><xsl:value-of select="text()"/></title>
        </_>
    </xsl:template>
    
    <xsl:template match="separator">
        <_ type="object">
            <title>---</title>
        </_>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="subnav">
        <subnav><xsl:apply-templates/></subnav>
    </xsl:template>
    
    <xsl:template match="*">
       <xsl:element name="{local-name(.)}"><xsl:apply-templates/></xsl:element>
    </xsl:template>

</xsl:stylesheet>