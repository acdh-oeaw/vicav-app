<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="3.1">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="captionFromMenuID" select=" map{
    'vicavArabicTools': 'ARABIC TOOLS',
    'vicavContributeBibliography': 'CONTRIBUTE TO BIBLIOGRAPHY',
    'vicavContributeDictionary': 'CONTRIBUTE A DICTIONARY',
    'vicavContributeFeature': 'CONTRIBUTE A FEATURE LIST',
    'vicavContributeProfile': 'CONTRIBUTE A PROFILE',
    'vicavContributeSample': 'CONTRIBUTE A SAMPLE',

    'vicavContributors': 'CONTRIBUTORS',
    'vicavDictionaryEncoding': 'DICTIONARIES (ENCODING)',
    'vicavDictionariesTechnicalities': 'DICTIONARIES (TECHNICALITIES)',
    'vicavOverview_corpora_spoken': 'CORPORA OF SPOKEN ARABIC',
    'vicavOverview_corpora_msa': 'MSA CORPORA',
    'vicavOverview_special_corpora': 'SPECIAL CORPORA',
    'vicavOverview_corpora_historical_varieties': 'CORPORA OF HISTORICAL LANGUAGE',
    'vicavOverview_dictionaries': 'DICTIONARY PROJECTS',
    'vicavOverview_nlp': 'ARABIC NLP',
    'vicavOverview_otherStuff': 'OTHER STUFF',
    'vicavLearning': 'LEARNING',
    'vicavLearningTextbookDamascus': 'TEXTBOOK DAMASCUS',
    'vicavLearningSmartphone': 'VOCABULARIES ON SMARTPHONES',
    'vicavLearningPrograms': 'LEARNING PROGRAMS',
    'vicavLearningData': 'LEARNING DATA',
    'vicavKeyboards': 'KEYBOARDS',
    'vicavVLE': 'DICTIONARY EDITOR (VLE)',

    'vicavExplanationBibliography': 'BIBLIOGRAPHY (DETAILS)',
    'vicavExplanationCorpusTexts': 'CORPUS TEXTS (DETAILS)',
    'vicavExplanationFeatures': 'FEATURES (DETAILS)',
    'vicavExplanationProfiles': 'PROFILES (DETAILS)',
    'vicavExplanationSamples': 'SAMPLES (DETAILS)',
    'vicavExploreFeatures': 'EXPLORE FEATURES',


    'vicavLinguistics': 'LINGUISTICS',
    'vicavMission': 'MISSION',
    'vicavNews': 'VICAV NEWS',
    'vicavTypesOfText': 'TYPES OF TEXT'}"/>
    
    <xsl:template match="/">
        <json objects="json projectConfig logo frontpage menu query map center styleSettings colors" arrays="panel param main item subnav scope" numbers="zoom lat lng"><xsl:apply-templates/></json>
    </xsl:template>
    
    <xsl:template match="text()[parent::logo]">
        <string><xsl:value-of select="."/></string>
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
              <xsl:when test="starts-with(@xml:id, 'liVicavDict')">DictQuery</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'li_')">Text</xsl:when>
              <xsl:when test="starts-with(@xml:id, 'liSample')">SampleText</xsl:when>
              <xsl:when test="data(@xml:id) = 'liBiblNewQuery'">BiblioQuery</xsl:when>
              <xsl:when test="data(@xml:id) = 'liVicavCrossDictQuery'">CrossDictQuery</xsl:when>
              <xsl:when test="@componentName"><xsl:value-of select="@componentName"/></xsl:when>
              <xsl:otherwise>UnknownTypeWarning</xsl:otherwise>
            </xsl:choose>
          </componentName>
          <label>
            <xsl:value-of select="$captionFromMenuID(replace(data((@xml:id, @target)[1]),'^li_?',''))"/>
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
    
    <xsl:template match="@*">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
       <xsl:element name="{local-name(.)}"><xsl:apply-templates/></xsl:element>
    </xsl:template>

</xsl:stylesheet>