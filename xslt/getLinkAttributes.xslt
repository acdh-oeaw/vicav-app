<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
  <xsl:include href="vicavIDToLabel.xslt"/>
  
  <xsl:variable name="openDictFuncToDictID" select='map{
    "func:openDict_Damascus()": "dc_apc_eng_publ",
    "func:openDict_Tunis()": "dc_tunico",
    "func:openDict_Cairo()": "dc_arz_eng_publ",
    "func:openDict_Baghdad()": "dc_acm_baghdad_eng_publ",
    "func:openDict_MSA()": "dc_ar_eng_publ"
  }'/>
    
  <xsl:function name="tei:getLinkAttributes" as="attribute()+">
    <xsl:param name="target" as="xs:string"/>
    <xsl:variable name="targetSplit" as="xs:string+">
      <xsl:choose>
        <xsl:when test="starts-with($target, 'func:createNewQueryBiblioPanel')">
          <xsl:sequence select="('Bibl')"/>
        </xsl:when>
        <xsl:when test="starts-with($target, 'func:openDict_')">
          <xsl:sequence select="('DictQuery', $openDictFuncToDictID($target), replace($target, 'func:openDict_([^(]+)\(.*', '$1 Dictionary Query'))"/>
        </xsl:when>
        <xsl:when test="starts-with($target, 'bibl:')">
          <xsl:sequence select="('Bibl', '', replace($target,'^bibl:([^/]+)(/[^/,]+)?', '$1'), replace($target,'^bibl:([^/]+)(/[^/,]+)?', '$1'))"/>
          <!-- The part after the / is the label for the new window. We get those labels usint the lookup table.  -->
        </xsl:when>
        <xsl:when test="starts-with($target, 'mapMarkers:')">
          <xsl:sequence select="('WMap', 'bibl_markers_tei', replace($target,'^mapMarkers:([^/]+)(/[^/,]+)?', '$1')), replace($target,'^mapMarkers:([^/]+)(/[^/,]+)?', '$1')"/>
          <!-- The part after the / is the label for the new window. We get those labels usint the lookup table.  -->
        </xsl:when>
        <xsl:when test="starts-with($target, 'text:')">
          <xsl:sequence select="('Text', replace($target,'^text:([^/]+)(/[^/,]+)?', '$1'), $captionFromMenuID(replace($target,'^text:([^/]+)(/[^/,]+)?', '$1')))"/>
          <!-- The part after the / is the label for the new window. We get those labels usint the lookup table.  -->
        </xsl:when>
        <xsl:when test="starts-with($target, 'corpusText:')">
          <xsl:sequence select="('corpusText', replace($target,'^corpusText:([^/]+)(/[^/,]+)?', '$1'), replace($target,'^corpusText:([^/]+)(/[^/,]+)?', '$1'))"/>
          <!-- The part after the / is the label for the new window. We get those labels usint the lookup table.  -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:analyze-string select="$target" regex="^([^:]+):([^/]+)/([^/,]+)[,/]?(([^/,]+)[,/]?)?(([^/,]+)[,/]?)?(([^/,]+)[,/]?)?(([^/,]+)[,/]?)?">
            <xsl:matching-substring>
              <xsl:sequence select="(regex-group(1), regex-group(2),regex-group(3),regex-group(5),regex-group(7),regex-group(9),regex-group(11))[. != '']"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:sequence select="('external-link')"/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="matches($targetSplit[1], 'https?')">
        <xsl:sequence>
          <xsl:attribute name="data-target-type"><xsl:value-of select="'external-link'"/></xsl:attribute>
       </xsl:sequence>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence>
          <xsl:variable name="target-type" select="upper-case(substring($targetSplit[1], 1, 1))||substring($targetSplit[1], 2)"/>
          <xsl:attribute name="data-target-type"><xsl:value-of select="$target-type"/></xsl:attribute>
          <xsl:if test="exists($targetSplit[2]) and $targetSplit[2] != '' and $target-type != 'WMap'">
            <xsl:attribute name="data-text-id"><xsl:value-of select="$targetSplit[2]"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="exists($targetSplit[2]) and $target-type = 'WMap'">
            <xsl:attribute name="data-endpoint"><xsl:value-of select="$targetSplit[2]"/></xsl:attribute>
          </xsl:if>          
          <xsl:if test="exists($targetSplit[3]) and $target-type != 'WMap'">
            <xsl:attribute name="data-label"><xsl:value-of select="translate($targetSplit[3], '_', ' ')"/></xsl:attribute>
          </xsl:if>
          <xsl:for-each select="$targetSplit[position() > 3]"><xsl:attribute name="data-query-{position()}"><xsl:value-of select="."/></xsl:attribute></xsl:for-each>      
        </xsl:sequence>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>