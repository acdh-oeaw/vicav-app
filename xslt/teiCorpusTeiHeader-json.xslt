<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs = "http://www.w3.org/2001/XMLSchema"
    xmlns:_ = "urn:_"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="3.1">
    
    <!--xsl:mode on-no-match="shallow-copy"/ -->
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="t:teiCorpus">
        <json object="teiHeader fileDesc titleStmt publicationStmt persName
            encodingDesc classDecl availability address"
              array="TEIs categories respStmts">
            <xsl:apply-templates select="@*|* except t:TEI"/>
            <TEIs>
                <xsl:apply-templates select="t:TEI"/>
            </TEIs>
        </json>
    </xsl:template>
    
    <xsl:template match="t:titleStmt">
        <titleStmt>
            <xsl:apply-templates select="@*|* except t:respStmt"/>
            <respStmts><xsl:apply-templates select="t:respStmt"/></respStmts>
        </titleStmt>
    </xsl:template>
    
    <xsl:template match="t:taxonomy">
        <taxonomy><categories><xsl:for-each select="t:category"><xsl:apply-templates/></xsl:for-each></categories></taxonomy>
    </xsl:template>
    
    <xsl:template match="t:TEI|t:respStmt|t:category">
        <_><xsl:apply-templates select="@*|*"/></_>
    </xsl:template>
    
    <xsl:template match="t:*">
        <xsl:element name="{local-name()}"><xsl:apply-templates select="@*|*"/></xsl:element>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:element name="_0040{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>

</xsl:stylesheet>