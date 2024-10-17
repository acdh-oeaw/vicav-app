<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs = "http://www.w3.org/2001/XMLSchema"
    xmlns:_ = "urn:_"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="3.1">
    
    <xsl:output method="xml" indent="no"/>
    
    <xsl:template match="t:teiCorpus">
        <json type="object">
            <xsl:apply-templates select="@*|* except t:TEI"/>
            <TEIs type="array">
                <xsl:apply-templates select="t:TEI" mode="arrayItem"/>
            </TEIs>
        </json>
    </xsl:template>
    
    <xsl:template match="t:titleStmt">
        <titleStmt type="object">
            <titles type="array"><xsl:apply-templates select="t:title" mode="arrayItem"/></titles>
            <xsl:apply-templates select="@*|* except (t:respStmt, t:title)"/>
            <respStmts type="array"><xsl:apply-templates select="t:respStmt" mode="arrayItem"/></respStmts>
        </titleStmt>
    </xsl:template>    
    
    <xsl:template match="t:publicationStmt">
        <publicationStmt type="object">
            <xsl:apply-templates select="@*|* except t:publisher"/>
            <publishers type="array"><xsl:apply-templates select="t:publisher" mode="arrayItem"/></publishers>
        </publicationStmt>
    </xsl:template>
    
    <xsl:template match="t:revisionDesc">
        <revisionDesc type="object">
            <xsl:apply-templates select="@*|* except t:change"/>
            <changes type="array"><xsl:apply-templates select="t:change" mode="arrayItem"/></changes>
        </revisionDesc>
    </xsl:template>
    
    <xsl:template match="t:tagsDecl">
        <tagsDecl type="object">
            <xsl:apply-templates select="@*|* except t:rendition"/>
            <renditions type="array"><xsl:apply-templates select="t:rendition" mode="arrayItem"/></renditions>
        </tagsDecl>
    </xsl:template>
    
    <xsl:template match="t:taxonomy">
        <taxonomy type="object">
            <categories type="array"><xsl:apply-templates select="t:category" mode="arrayItem"/></categories>
        </taxonomy>
    </xsl:template>
    
    <xsl:template match="t:settlement">
        <settlement type="object">
            <name type="array"><xsl:apply-templates select="t:name" mode="arrayItem"/></name>
        </settlement>
    </xsl:template>
    

    <xsl:template match="t:listPrefixDef">
        <listPrefixDef type="array">
            <xsl:apply-templates select="t:prefixDef" mode="arrayItem"/>
        </listPrefixDef>
    </xsl:template>    
    
    <xsl:template match="t:listPerson">
        <listPerson type="array">
            <xsl:apply-templates select="t:person" mode="arrayItem"/>
        </listPerson>
    </xsl:template>

    <xsl:template match="t:particDesc">
        <particDesc type="array">
            <xsl:apply-templates select="t:person" mode="arrayItem"/>
        </particDesc>
    </xsl:template>
    
    <xsl:template match="t:*" mode="arrayItem">
        <_ type="object">
            <xsl:apply-templates select="@*|*"/>
            <xsl:if test="normalize-space(string-join(./text(), ' ')) ne '' and normalize-space(string-join(.//text(), ' ')) ne ''">
                <_0024 type="string"><xsl:value-of select="normalize-space(string-join(.//text(), ' '))"/></_0024>
            </xsl:if>
        </_>
    </xsl:template>
    
    <xsl:template match="t:*">
        <xsl:element name="{local-name()}">
            <xsl:attribute name="type">object</xsl:attribute>
            <xsl:apply-templates select="@*|*"/>
            <xsl:if test="normalize-space(string-join(./text(), ' ')) ne '' and normalize-space(string-join(.//text(), ' ')) ne ''">
                <_0024 type="string"><xsl:value-of select="normalize-space(string-join(.//text(), ' '))"/></_0024>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="t:text"/> <!-- not interested in content -->
    
    <xsl:template match="@*">
        <xsl:element name="_0040{local-name()}">
            <xsl:attribute name="type">string</xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:if test="normalize-space(.) ne ''">
            <_0024 type="string"><xsl:value-of select="."/></_0024>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>