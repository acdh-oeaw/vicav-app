<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:include href="features_common.xslt"/>

    <xsl:preserve-space elements="*"/>
    <xsl:variable name="authors" select="descendant::tei:titleStmt/(tei:author|tei:respStmt[tei:resp = 'author']/tei:persName)" as="element()*"/>
        <xsl:variable name="majorRevisions" select="descendant::tei:revisionDesc/tei:change[@type='major']" as="element(tei:change)*"/>
        <xsl:variable name="lastRevision" select="$majorRevisions[@when = max($majorRevisions/@when/xs:dateTime(.))][last()]"/>
    <xsl:template match="/tei:TEI">
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
            
            <div>
              <xsl:choose>
                <xsl:when test="$tei-link-marker = 'true'">
                <table class="tbHeader">
                    <tr>
                        <td><h2><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@level='a']"/></h2></td>
                        <td class="tdTeiLink">{teiLink}</td>
                        <td class="tdPrintLink">
                            <a data-print="true" target="_blank" class="aTEIButton">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$print-url"/>
                                </xsl:attribute>
                                Print
                            </a>
                        </td>
                    </tr>
                </table>
                </xsl:when>
                <xsl:otherwise>
                  <table class="tbHeader">
                    <tr>
                        <td>
                            <h2><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h2>
                        </td>
                        <td class="tdPrintLink">
                            <a data-print="true" target="_blank" class="aTEIButton">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$print-url"/>
                                </xsl:attribute>
                                Print
                            </a>
                        </td>
                    </tr>
                  </table>
                </xsl:otherwise>
              </xsl:choose>
                <p><xsl:text xml:space="preserve">By </xsl:text><i>
                <xsl:for-each select="$authors">
                    <xsl:choose xml:space="default">
                        <xsl:when test="position() gt 1 and . is $authors[last()]" xml:space="preserve"> and </xsl:when>
                        <xsl:when test="position() gt 1  and not(. is $authors[last()])" xml:space="preserve">, </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select=". "/>
                </xsl:for-each>
                <xsl:if test="$lastRevision" xml:space="preserve"> (revision: <xsl:value-of 
            select="($lastRevision/format-dateTime(@when,'[Y0000]-[M00]-[D00]'), replace($lastRevision, 'T.*', ''))[1]" />)
            </xsl:if></i></p>
                
                <ul id="informants"><xsl:for-each select="./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson/tei:person"><li xml:space="preserve">Informant ID: <i><xsl:value-of 
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
