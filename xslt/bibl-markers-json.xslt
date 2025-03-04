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
            <xd:p><xd:b>Created on:</xd:b> May 5, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b>Omar Siam</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="target-type" as="xs:string?" select='()'/>
    <xsl:param name="data-type" as="xs:string?" select='()'/>
    <xsl:param name="current-query" as="xs:string?" select='()'/>
    
    <xsl:template match="/">
        <json objects="geometry properties params" arrays="json coordinates" numbers="hitCount">
          <xsl:apply-templates select=".//r"/>
        </json>
    </xsl:template>
    
    <xsl:variable name="translateType" select='map {
      "geo": "geo",
      "reg": "reg",
      "place": "geo",
      "region": "reg"
    }'/>

    <xsl:variable name="translateTargetType" select='map {
        "linguistic feature list": "Feature",
        "profile": "Profile",
        "sample text": "SampleText"
    }'/>
    
    <xd:doc>
        <xd:desc>One marker</xd:desc>
    </xd:doc>
    <xsl:template match="r">
        <xsl:variable name="coords" select="tokenize((geo,loc)[1], '(,? |,)')"/>
        <xsl:variable name="coords" as="xs:double+">
            <xsl:try>
                <xsl:sequence select="(xs:double($coords[1]), xs:double($coords[2]))"/>
                <xsl:catch errors="err:FORG0001">
                    <xsl:sequence select="_:degtodec(loc[not(@type)])"/>
                </xsl:catch>
            </xsl:try>
        </xsl:variable>
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
                <type><xsl:value-of select="$translateType(@type)"/></type>
                <name><xsl:value-of select="(locName, alt)[1]"/></name>
                <!-- Keep name consistent with menu items,
                     @todo deprecate when moved everythings to new frontend. -->
                <label><xsl:value-of select="(locName, alt)[1]"/></label>
                <xsl:if test="exists(alt) and exists(locName)">
                <alt><xsl:value-of select="alt"/></alt>
                </xsl:if>
                <hitCount><xsl:value-of select="freq"/></hitCount>
                <textId>
                    <xsl:choose>
                        <xsl:when test="exists(@xml:id)">
                            <xsl:value-of select="@xml:id"/>
                        </xsl:when>
                        <xsl:when test="exists(textId)">
                            <xsl:value-of select="textId"/>
                        </xsl:when>
                    </xsl:choose>
                </textId>
                <targetType>
                    <xsl:choose>
                        <xsl:when test="exists(targetType)">
                            <xsl:value-of select="targetType"/>
                        </xsl:when>
                        <xsl:when test="exists(taxonomy)">
                            <xsl:value-of select="$translateTargetType(taxonomy)"/>
                        </xsl:when>
                        <xsl:when test="exists($target-type)">
                            <xsl:value-of select="$target-type"/>
                        </xsl:when>
                    </xsl:choose>
                </targetType>
                <xsl:copy-of select="./params"/>
                <xsl:if test="exists($current-query)">
                    <queryString><xsl:value-of select="$current-query||'+'||(locName, alt)[1]"/></queryString>
                </xsl:if>
            </properties>
        </_>
    </xsl:template>

    <xd:doc>
        <xd:desc>Convert Lat and Long to DMS</xd:desc>
        <xd:param name="loc">Position in degree location</xd:param>
    </xd:doc>
    <xsl:function name="_:degtodec" as="xs:double+">
        <xsl:param name="loc" as="xs:string"/>
        <xsl:analyze-string select="$loc" regex="(\d+)\s*°\s*((\d+)\s*'\s*((\d+)\s*&quot;\s*)?)?\s*([NS])\s+(\d+)\s*°\s*((\d+)\s*'\s*((\d+)\s*&quot;\s*)?)?\s*([EW])">
            <xsl:matching-substring>
                <xsl:sequence select="(_:ws2neg(regex-group(6)) * (_:str2num(regex-group(1)) + _:str2num(regex-group(3)) div 60 + _:str2num(regex-group(5)) div 3600), _:ws2neg(regex-group(12)) * (_:str2num(regex-group(7)) + _:str2num(regex-group(9)) div 60 + _:str2num(regex-group(11)) div 3600))"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>ERROR in <xsl:value-of select="$loc"/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Convert string to double with 0 for ""</xd:desc>
        <xd:param name="in">The number as string to convert</xd:param>
    </xd:doc>
    <xsl:function name="_:str2num" as="xs:double">
        <xsl:param name="in" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$in eq ''"><xsl:sequence select="0.0"/></xsl:when>
            <xsl:otherwise><xsl:sequence select="xs:double($in)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xd:doc>
        <xd:desc>Convert S and W to -1.0 else return 1.0"</xd:desc>
        <xd:param name="in">Direction to convert</xd:param>
    </xd:doc>    
    <xsl:function name="_:ws2neg" as="xs:double">
        <xsl:param name="in" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$in = ('S', 'W')"><xsl:sequence select="-1.0"/></xsl:when>
            <xsl:otherwise><xsl:sequence select="1.0"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>