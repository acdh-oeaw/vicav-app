<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs = "http://www.w3.org/2001/XMLSchema"
    xmlns:_ = "urn:_"
    version="3.1">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="baseURIPublic"/>
    <xsl:param name="teiSource">https://github.com/acdh-oeaw/vicav-content</xsl:param>
  
    <xsl:include href="vicavIDToLabel.xslt"/>
    
    <xsl:function name="_:cleanID" as="xs:string">
      <xsl:param name="in" as="xs:string"/>
      <xsl:variable name="ret" select="replace($in, '^((sub)?[nN]av)|^(li_?)', '')"/>
      <xsl:choose>
        <xsl:when test="starts-with($ret, 'VicavDict')"><xsl:value-of select="replace($ret, 'VicavDict', 'dictFrontPage')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$ret"/></xsl:otherwise>
      </xsl:choose>
    </xsl:function>
    
    <xsl:template match="/">
      <json objects="json projectConfig logo frontpage menu params map center styleSettings colors static__data" arrays="panel param main item subnav scope geo table" numbers="zoom lat lng">
        <xsl:apply-templates/>
      </json>
    </xsl:template>
    
    <xsl:template match="projectConfig">
      <projectConfig>
        <baseURIPublic><xsl:value-of select="$baseURIPublic"/></baseURIPublic>
        <xsl:apply-templates/>
      </projectConfig>
    </xsl:template>
    
    <xsl:template match="text()[parent::logo]">
        <string><xsl:value-of select="."/></string>
    </xsl:template>
    
    <xsl:template match="img">
        <img><xsl:value-of select="$baseURIPublic||'/'||@src"/></img>
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
          <xsl:apply-templates select="@* except @type"/>
          <title><xsl:value-of select="normalize-space(string-join(text(), ' '))"/></title>
          <type><xsl:value-of select="local-name()"/></type>
          <targetType>
            <xsl:choose>
              <xsl:when test="@type">
                <xsl:choose>
                  <xsl:when test="data(@type) = 'vicavTexts'">Text</xsl:when>                  
                  <xsl:otherwise><xsl:value-of select="upper-case(substring(@type,1,1)) || substring(@type,2)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="ends-with(@xml:id, 'List')">DataList</xsl:when>
              <xsl:when test="contains(lower-case(@xml:id), 'nav')">WMap</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'liVicavDict')">Text</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'li_')">Text</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'liSample')">SampleText</xsl:when>
              <xsl:when test="data(@xml:id) = 'liBiblNewQuery'">BiblioEntries</xsl:when>
              <xsl:when test="data(@xml:id) = 'liVicavCrossDictQuery'">CrossDictQuery</xsl:when>
              <xsl:when test="@targetType"><xsl:value-of select="@targetType"/></xsl:when>
              <xsl:otherwise>UnknownTypeWarning</xsl:otherwise>
            </xsl:choose>
          </targetType>
          <label>
            <xsl:variable name="caption" select="$captionFromMenuID(_:cleanID(data((@target, @xml:id)[1])))"/>
            <xsl:value-of select="if (normalize-space($caption) eq '') then normalize-space(string-join(text(), ' ')) else $caption"/>
          </label>
          <xsl:choose>
            <xsl:when test="contains(@xml:id, 'avBiblGeoMarkers')">
              <params>
                <endpoint>bibl_markers_tei</endpoint>
                <queryString type="string">.*</queryString>
                <scope><_>geo</_></scope>
              </params>              
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avBiblRegMarkers')">
              <params>
                <endpoint>bibl_markers_tei</endpoint>
                <queryString type="string">.*</queryString>
                <scope><_>reg</_></scope>
              </params>
            </xsl:when>            
            <xsl:when test="contains(@xml:id, 'avBiblDiaGroupMarkers')">
              <params>
                <endpoint>bibl_markers_tei</endpoint>                
                <queryString type="string">This feature is unused at the moment</queryString>                
                <scope><_>diaGroup</_></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avDictGeoRegMarkers')">
              <params>
                <endpoint>bibl_markers_tei</endpoint>
                <queryString type="string">vt:dictionary</queryString>
                <scope><_>geo</_><_>reg</_></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avTextbookGeoRegMarkers')">
              <params>
                <endpoint>bibl_markers_tei</endpoint>
                <queryString type="string">vt:textbook</queryString>
                <scope><_>geo</_><_>reg</_></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avProfilesGeoRegMarkers')">
              <params>
                <endpoint>profile_markers</endpoint>
                <queryString type="string"></queryString>
                <scope></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avFeaturesGeoRegMarkers')">
              <params>
                <endpoint>feature_markers</endpoint>
                <queryString type="string"></queryString>
                <scope></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avSamplesGeoRegMarkers')">
              <params>
                <endpoint>sample_markers</endpoint>
                <queryString type="string"></queryString>
                <scope></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avVicavDictMarkers')">
              <params>
                <endpoint>dict_markers</endpoint>
                <queryString type="string"></queryString>
                <scope></scope>
              </params>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'liBiblNewQuery')">
              <params>
                <queryString type="string"></queryString>
              </params>
            </xsl:when>
            <xsl:otherwise>
              <params>
                <textId><xsl:value-of select="_:cleanID(data((@target,@xml:id)[1]))"/></textId>
                <teiSource><xsl:value-of select="$teiSource"/></teiSource>
                <xsl:apply-templates select="params/*"/>
              </params>
            </xsl:otherwise>
          </xsl:choose>
        </_>
    </xsl:template>
    
    <xsl:template match="separator">
        <_ type="object">
            <type>separator</type>
        </_>
    </xsl:template>
    
    <xsl:template match="@xml:id[../@target]">
      <id><xsl:value-of select="."/></id>
    </xsl:template>
    
    <xsl:template match="@target[../@xml:id]">
      <target><xsl:value-of select="_:cleanID(data(.))"/></target>
    </xsl:template>
    
    <xsl:template match="@xml:id|@target">
      <id><xsl:value-of select="."/></id>
      <target><xsl:value-of select="_:cleanID(data(.))"/></target>
    </xsl:template>
    
    <xsl:template match="icon">
      <icon><xsl:value-of select="$baseURIPublic||'/vendor/images'||."/></icon>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
       <xsl:element name="{local-name(.)}"><xsl:apply-templates/></xsl:element>
    </xsl:template>

</xsl:stylesheet>