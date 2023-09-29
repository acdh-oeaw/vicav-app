<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs = "http://www.w3.org/2001/XMLSchema"
    xmlns:_ = "urn:_"
    version="3.1">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="baseURIPublic"/>
    
    <xsl:variable name="captionFromMenuID" select=" map{
    'vicavArabicTools': 'Arabic Tools',
    'vicavContributeBibliography': 'Contribute to Bibliography',
    'vicavContributeDictionary': 'Contribute a Dictionary',
    'vicavContributeFeature': 'Contribute a Feature List',
    'vicavContributeProfile': 'Contribute a Profile',
    'vicavContributeSample': 'Contribute a Sample',

    'vicavContributors': 'Contributors',
    'vicavDictionaryEncoding': 'Dictionaries (Encoding)',
    'vicavDictionariesTechnicalities': 'Dictionaries (Technicalities)',
    'vicavOverview_corpora_spoken': 'Corpora of Spoken Arabic',
    'vicavOverview_corpora_msa': 'MSA Corpora',
    'vicavOverview_special_corpora': 'Special Corpora',
    'vicavOverview_corpora_historical_varieties': 'Corpora of Historical Language',
    'vicavOverview_dictionaries': 'Dictionary Projects',
    'vicavOverview_nlp': 'Arabic NLP',
    'vicavOverview_otherStuff': 'Other Websites &amp; Projects',
    'vicavLearning': 'Learning',
    'vicavLearningTextbookDamascus': 'Textbook Damascus',
    'vicavLearningSmartphone': 'VOCABULARIES on Smartphones',
    'vicavLearningPrograms': 'Learning Programs',
    'vicavLearningData': 'Learning Data',
    'vicavKeyboards': 'Keyboards',
    'vicavVLE': 'Dictionary Editor (VLE)',

    'vicavExplanationBibliography': 'Bibliography (Details)',
    'vicavExplanationCorpusTexts': 'Corpus Texts (Details)',
    'vicavExplanationFeatures': 'Features (Details)',
    'vicavExplanationProfiles': 'rofiles (Details)',
    'vicavExplanationSamples': 'Samples (Details)',
    'vicavExploreFeatures': 'Explore Features',


    'vicavLinguistics': 'Linguistics',
    'vicavMission': 'Mission',
    'vicavNews': 'VICAV News',
    'vicavTypesOfText': 'Types of Text'}"/>
    
    <xsl:function name="_:cleanID" as="xs:string">
      <xsl:param name="in" as="xs:string"/>
      <xsl:variable name="ret" select="replace($in, '((sub)?[nN]av)|(li_?)', '')"/>
      <xsl:choose>
        <xsl:when test="starts-with($ret, 'VicavDict')"><xsl:value-of select="replace($ret, 'VicavDict', 'dictFrontPage')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$ret"/></xsl:otherwise>
      </xsl:choose>
    </xsl:function>
    
    <xsl:template match="/">
        <json objects="json projectConfig logo frontpage menu query map center styleSettings colors" arrays="panel param main item subnav scope" numbers="zoom lat lng"><xsl:apply-templates/></json>
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
          <title><xsl:value-of select="text()"/></title>
          <type><xsl:value-of select="local-name()"/></type>
          <componentName>
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
              <xsl:when test="data(@xml:id) = 'liBiblNewQuery'">BiblioQuery</xsl:when>
              <xsl:when test="data(@xml:id) = 'liVicavCrossDictQuery'">CrossDictQuery</xsl:when>
              <xsl:when test="@componentName"><xsl:value-of select="@componentName"/></xsl:when>
              <xsl:otherwise>UnknownTypeWarning</xsl:otherwise>
            </xsl:choose>
          </componentName>
          <label>
            <xsl:variable name="caption" select="$captionFromMenuID(_:cleanID(data((@target, @xml:id)[1])))"/>
            <xsl:value-of select="if (normalize-space($caption) eq '') then text() else $caption"/>
          </label>
          <xsl:choose>
            <xsl:when test="contains(@xml:id, 'avBiblGeoMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query type="string">.*</query>
                <scope><_>geo</_></scope>
              </query>              
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avBiblRegMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query type="string">.*</query>
                <scope><_>reg</_></scope>
              </query>
            </xsl:when>            
            <xsl:when test="contains(@xml:id, 'avBiblDiaGroupMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>                
                <query type="string">This feature is unused at the moment</query>                
                <scope><_>diaGroup</_></scope>
              </query>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avDictGeoRegMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query type="string">vt:dictionary</query>
                <scope><_>geo</_><_>reg</_></scope>
              </query>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avTextbookGeoRegMarkers')">
              <query>
                <endpoint>bibl_markers_tei</endpoint>
                <query type="string">vt:textbook</query>
                <scope><_>geo</_><_>reg</_></scope>
              </query>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avProfilesGeoRegMarkers')">
              <query>
                <endpoint>profile_markers</endpoint>
                <query type="string"></query>
                <scope></scope>
              </query>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avFeaturesGeoRegMarkers')">
              <query>
                <endpoint>feature_markers</endpoint>
                <query type="string"></query>
                <scope></scope>
              </query>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avSamplesGeoRegMarkers')">
              <query>
                <endpoint>sample_markers</endpoint>
                <query type="string"></query>
                <scope></scope>
              </query>
            </xsl:when>
            <xsl:when test="contains(@xml:id, 'avVicavDictMarkers')">
              <query>
                <endpoint>dict_markers</endpoint>
                <query type="string"></query>
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