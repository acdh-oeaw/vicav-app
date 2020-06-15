<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    version="2.0">
    <xsl:include href="features_common.xslt"/>

    <xsl:preserve-space elements="*"/>
    <xsl:template match="/">
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
            
            <div>
                <table class="tbHeader">
                    <tr><td><h2><xsl:value-of select="//tei:title"/></h2></td><td class="tdTeiLink">{teiLink}</td></tr>
                </table>    

                <p xml:space="preserve">By <i><xsl:value-of select="//tei:author"/> (<xsl:value-of select="//tei:date"/>)</i></p>
                
                <xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/text()">
                    <p xml:space="preserve">Informant ID: 
                    <i><xsl:value-of select="//tei:profileDesc/tei:particDesc/tei:person"/></i><xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/@sex">, Sex: <i><xsl:value-of select="//tei:profileDesc/tei:particDesc/tei:person/@sex"/></i></xsl:if><xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/@age">, Age: <i><xsl:value-of select="//tei:profileDesc/tei:particDesc/tei:person/@age"/></i></xsl:if>
                </p>
                </xsl:if>
                
                <table class="tbFeatures">
                    <xsl:for-each select="//tei:div[@type='featureGroup']">
                        <tr>
                            <td colspan="2" class="tdFeaturesHead"><xsl:apply-templates select="./tei:head"/></td>
                        </tr>
                        <xsl:for-each select="./tei:cit[@type='featureSample']"> 
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </xsl:for-each>
                </table>
            </div>         
        </div>
    </xsl:template>
</xsl:stylesheet>
