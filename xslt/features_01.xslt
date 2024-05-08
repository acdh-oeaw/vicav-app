<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="features_common.xslt"/>

    <xsl:preserve-space elements="*"/>
    <xsl:template match="/tei:TEI">
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
            
            <div>
              <xsl:choose>
                <xsl:when test="$tei-link-marker = 'true'">
                <table class="tbHeader">
                    <tr><td><h2><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h2></td><td class="tdTeiLink">{teiLink}</td><td class="tdPrintLink">
                <a href="#" data-print="true" class="aTEIButton"><xsl:attribute name="data-featurelist"><xsl:value-of 
                    select="./@xml:id"/></xsl:attribute>Print</a></td></tr>
                </table>
                </xsl:when>
                <xsl:otherwise>
                  <h2><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h2>
                </xsl:otherwise>
              </xsl:choose>

                <p xml:space="preserve">By <i><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/><xsl:if test="./tei:teiHeader/tei:revisionDesc/tei:change"> (revision: <xsl:value-of select="replace(./tei:teiHeader/tei:revisionDesc/tei:change[1]/@when, 'T.*', '')" />)</xsl:if></i></p>
                
                <ul id="informants"><xsl:for-each select="./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person"><li xml:space="preserve">Informant ID: <i><xsl:value-of 
                    select="."/></i><xsl:if
                    test="@sex">, Sex: <i><xsl:value-of
                    select="@sex"/></i></xsl:if><xsl:if
                    test="@age">, Age: <i><xsl:value-of
                    select="@age"/></i></xsl:if></li>
                    </xsl:for-each></ul>
                
                <table class="tbFeatures">
                    <xsl:for-each select="(./tei:text/tei:body/tei:div/tei:div[@type='featureGroup'], ./tei:text/tei:body/tei:div[@type='featureGroup'])">
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
