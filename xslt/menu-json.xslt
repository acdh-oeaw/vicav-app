<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="3.1">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <json objects="json projectConfig logo frontpage menu query" arrays="panel param main item subnav scope"><xsl:apply-templates/></json>
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
            <type><xsl:value-of select="local-name()"/></type>
        </_>
    </xsl:template>
    
    <xsl:template match="panel|item">
        <_ type="object">
          <xsl:apply-templates select="@*"/>
          <title><xsl:value-of select="text()"/></title>
          <xsl:if test="not(@type)">
            <type><xsl:value-of select="local-name()"/></type>
          </xsl:if>
          <componentName>
            <xsl:choose>
              <xsl:when test="ends-with(@xml:id, 'List')">DataList</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'nav')">WMap</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'liVicavDict')">DictQuery</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'li_')">Text</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'liSample')">SampleText</xsl:when>
              <xsl:when test="data(@xml:id) = 'liBiblNewQuery'">BiblioQuery</xsl:when>
              <xsl:when test="data(@xml:id) = 'liVicavCrossDictQuery'">CrossDictQuery</xsl:when>
              <xsl:otherwise>UnknownTypeWarning</xsl:otherwise>
            </xsl:choose>
          </componentName>
          <xsl:choose>
            <xsl:when test="starts-with(@xml:id, 'navBiblGeoMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query>.*</query>
                <scope><_>geo</_></scope>
              </query>              
            </xsl:when>
            <xsl:when test="starts-with(@xml:id, 'navBiblRegMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query>.*</query>
                <scope><_>reg</_></scope>
              </query>
            </xsl:when>            
            <xsl:when test="starts-with(@xml:id, 'navBiblDiaGroupMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>                
                <query>This feature is unused at the moment</query>                
                <scope><_>diaGroup</_></scope>
              </query>
            </xsl:when>
            <xsl:when test="starts-with(@xml:id, 'navDictGeoRegMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query>vt:dictionary</query>
                <scope><_>geo</_><_>reg</_></scope>
              </query>
            </xsl:when>
            <xsl:when test="starts-with(@xml:id, 'navTextbookGeoRegMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query>vt:textbook</query>
                <scope><_>geo</_><_>reg</_></scope>
              </query>
            </xsl:when>
            <xsl:when test="starts-with(@xml:id, 'navProfilesGeoRegMarkers')">
              <query>
                <endpoint>profile_markers</endpoint>
                <query></query>
                <scope></scope>
              </query>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </_>
    </xsl:template>
    
    <xsl:template match="separator">
        <_ type="object">
            <type>separator</type>
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