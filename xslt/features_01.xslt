<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    version="2.0">
    <xsl:include href="features_common.xslt"/>

    <xsl:preserve-space elements="*"/>
    <xsl:template match="/tei:TEI">
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
            
            <div>
                <table class="tbHeader">
                    <tr><td><h2><xsl:value-of select="//tei:title"/></h2></td><td class="tdTeiLink">{teiLink}</td><td class="tdPrintLink">
                <a href="#" data-print="true" class="aTEIButton"><xsl:attribute name="data-featurelist"><xsl:value-of 
                    select="./@xml:id"/></xsl:attribute>Print</a></td></tr>
                </table>    

                <p xml:space="preserve">By <i><xsl:value-of select="//tei:author"/><xsl:if test=".//tei:revisionDesc/tei:change"> (revision: <xsl:value-of select="replace(.//tei:revisionDesc/tei:change[1]/@when, 'T.*', '')" />)</xsl:if></i></p>
                
                <xsl:if test="//tei:profileDesc/tei:particDesc/tei:person/text()"><p xml:space="preserve">Informant ID: <i><xsl:value-of 
                    select="//tei:profileDesc/tei:particDesc/tei:person"/></i><xsl:if 
                    test="//tei:profileDesc/tei:particDesc/tei:person/@sex">, Sex: <i><xsl:value-of 
                    select="//tei:profileDesc/tei:particDesc/tei:person/@sex"/></i></xsl:if><xsl:if 
                    test="//tei:profileDesc/tei:particDesc/tei:person/@age">, Age: <i><xsl:value-of 
                    select="//tei:profileDesc/tei:particDesc/tei:person/@age"/></i></xsl:if></p>
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
