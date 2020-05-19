<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">    
    <xsl:include href="sampletexts_common.xslt"/>
    <xsl:template match="/">        
        <div>                       
            <!-- <div class="h2Profile"> -->
            <table class="tbHeader">
                <tr><td><h2><xsl:value-of select="//tei:head"/></h2></td><td class="tdTeiLink">{teiLink}</td></tr>
            </table>            
            
            <!-- </div> -->
            
            <p>By&#160;<i><xsl:value-of select="//tei:author"/>
                <xsl:if test="//tei:publicationStmt/tei:date">&#160;(<xsl:value-of select="//tei:publicationStmt/tei:date"/>)</xsl:if>
            </i></p>
            <xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/text()">
                <p xml:space="preserve">Informant ID: 
                    <i><xsl:value-of select="//tei:profileDesc/tei:particDesc/tei:person"/></i><xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/@sex">, Sex: <i><xsl:value-of select="//tei:profileDesc/tei:particDesc/tei:person/@sex"/></i></xsl:if><xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/@age">, Age: <i><xsl:value-of select="//tei:profileDesc/tei:particDesc/tei:person/@age"/></i></xsl:if>
                </p>
            </xsl:if>
            
            <xsl:if test="string-length(//tei:teiHeader/tei:profileDesc/tei:particDesc/tei:p[1])&gt;0">
                <xsl:for-each select="//tei:teiHeader/tei:profileDesc/tei:particDesc/tei:p">
                    <xsl:apply-templates/>
                </xsl:for-each>
                <hr/>
            </xsl:if>

            <xsl:apply-templates select=".//tei:div[@type='sampleText']//tei:s"/>
        </div> 
    </xsl:template>   
</xsl:stylesheet>

