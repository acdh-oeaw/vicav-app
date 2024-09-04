<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:include href="features_common.xslt"/>
    <!-- VERSION 3.1.4 -->
    <xsl:preserve-space elements="*"/>

    <xsl:template match="/items">
        <div><xsl:value-of select="./@count"/>
        <xsl:for-each select="./feature">
            <xsl:variable name="ana" select="./@feature"/>
            <h3><xsl:value-of select="./@label" /></h3>
            <xsl:for-each select="./region">
                <div>
                    <h4><xsl:value-of select="./@name"/></h4>
                    <xsl:for-each select="./settlement">
                        <div>
                        <xsl:variable select="./@name" name="city" />
                        <h5><xsl:value-of select="$city" /></h5>
                            <p xml:space="preserve"><xsl:value-of select="./@count"/> feature sentences found.</p>

                            <table class="tbFeatures">
                                <xsl:for-each select="./item">
                                    <xsl:variable select="." name="item"/>
                                    <xsl:if test="./tei:note">
                                        <tr>
                                            <td class="tdFeaturesHeadRight" rowspan="3">
                                                <xsl:value-of select="$city"/>
                                                <small xml:space="preserve"><xsl:if test="$item/@informant != ''"> (<xsl:value-of 
                                                        select="$item/@informant"/><xsl:if test="$item/@sex != ''">/<xsl:value-of 
                                                        select="$item/@sex"/></xsl:if><xsl:if test="$item/@age != ''">/<xsl:value-of 
                                                        select="$item/@age"/></xsl:if>)</xsl:if></small>
                                            </td>
                                            <td class="tdFeaturesCom">
                                                <xsl:apply-templates select="./tei:note"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    
                                    <tr>
                                        <xsl:if test="not(./tei:note)">
                                            <td class="tdFeaturesHeadRight" rowspan="2">
                                                <xsl:value-of select="$city"/>
                                                <small xml:space="preserve"><xsl:if test="$item/@informant != ''"> (<xsl:value-of 
                                                        select="$item/@informant"/><xsl:if test="$item/@sex != ''">/<xsl:value-of 
                                                        select="$item/@sex"/></xsl:if><xsl:if test="$item/@age != ''">/<xsl:value-of 
                                                        select="$item/@age"/></xsl:if>)</xsl:if></small>
                                            </td>                                    
                                        </xsl:if>
                                        <td class="tdFeaturesRightSource">
                                            <xsl:value-of select="$item/tei:cit/tei:cit[@type='translation']/tei:quote[@xml:lang = 'en']"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="tdFeaturesRightTarget">
                                            <xsl:sequence select="acdh:feature-sentence($item/tei:cit/tei:quote[@xml:lang = ['aeb', 'ar']], acdh:current-feature-ana(., $ana))" /><xsl:text> </xsl:text>
                                        </td>                                                
                                    </tr>              
                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:for-each>
        </xsl:for-each>                  
        </div>
    </xsl:template>
 
 </xsl:stylesheet>