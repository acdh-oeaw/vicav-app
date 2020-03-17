<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    version="2.0">
    <xsl:param name="highLightIdentifier"></xsl:param>
    <xsl:include href="sampletexts_common.xslt"/>

    <xsl:preserve-space elements="*"/>
    <xsl:output method="html" encoding="utf-8"/>
    <xsl:template match="/">
        
        <!-- 
        <html>
            <head>
                <META http-equiv="Content-Type" content="text/html; charset=utf-8"></META></head>
            <body> -->
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
            
            <div>
                <table class="tbHeader">
                    <tr><td><h2><xsl:value-of select="//tei:title"/></h2></td><td class="tdTeiLink">{teiLink}</td></tr>
                </table>    

                <p xml:space="preserve">By <i><xsl:value-of select="//tei:author"/> (<xsl:value-of select="//tei:date"/>)</i></p>
                
                <table class="tbFeatures">
                    <xsl:for-each select="//tei:div[@type='featureGroup']">
                        <tr>
                            <td colspan="2" class="tdFeaturesHead"><xsl:apply-templates select="./tei:head"/></td>
                        </tr>
                        <xsl:for-each select="./tei:cit[@type='featureSample']"> 
                            <xsl:if test="./tei:note">
                                <tr>
                                    <td class="tdFeaturesLeft" rowspan="3">
                                        <xsl:apply-templates select="tei:lbl"/>
                                    </td>
                                    <td class="tdFeaturesCom">
                                        <xsl:apply-templates select="./tei:note"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            
                            <tr>
                                <xsl:if test="not(./tei:note)">
                                    <td class="tdFeaturesLeft" rowspan="2">
                                        <xsl:apply-templates select="tei:lbl"/>
                                    </td>                                    
                                </xsl:if>
                                <td class="tdFeaturesRightSource">
                                    <xsl:apply-templates select=".//tei:quote[@xml:lang = 'en']"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="tdFeaturesRightTarget">
                                    <xsl:apply-templates select=".//tei:quote[@xml:lang = 'ar']"/><xsl:text> </xsl:text>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                </table>
            </div>         
        </div>
        <!--             </body>        </html> -->
    </xsl:template>
    
    <xsl:function name="acdh:current-feature-ana">
        <xsl:param name="w"></xsl:param>        
        <xsl:choose>
            <xsl:when test="$w/ancestor::tei:cit[@type='featureSample']/@ana != ''">
                <xsl:value-of select="$w/ancestor::tei:cit[@type='featureSample']/@ana"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="calculated-semlib" select="lower-case(replace(replace($w/ancestor::tei:cit[@type='featureSample']/tei:lbl, '\s+', '_'), '[^\w_]', ''))"/>
                <xsl:value-of select="concat('semlib:', $calculated-semlib)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="tei:lbl"><xsl:apply-templates /></xsl:template>
    <xsl:template match="tei:fs"></xsl:template>
    <xsl:template match="tei:head"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:hi[@rend = 'red']"><span style="color:red"><xsl:apply-templates/></span></xsl:template>
    <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
    
    <!-- 
   <xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
   <xsl:template match="tei:row">
      <tr><xsl:apply-templates/></tr></xsl:template>
   <xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
   <xsl:template match="tei:w"><span><xsl:apply-templates/></span></xsl:template>
    -->
</xsl:stylesheet>
