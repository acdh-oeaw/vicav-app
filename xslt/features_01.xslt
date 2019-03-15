<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:param name="highLightIdentifier"></xsl:param>
    
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>
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
                    <xsl:for-each select="//tei:row">
                        <xsl:choose>
                            <xsl:when test="(string-length(tei:cell[@rend = 'tdRight']) = 0) and (string-length(tei:cell[@rend = 'tdCentre']) = 0)">
                                <tr>
                                    <td colspan="2" class="tdFeaturesHead"><xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/></td>
                                </tr>
                            </xsl:when>
                            
                            <xsl:when test="string-length(tei:cell[@rend = 'tdCom']) &gt; 0">
                                <tr>
                                    <td class="tdFeaturesLeft" rowspan="3">
                                        <xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/>
                                    </td>
                                    <td class="tdFeaturesCom">
                                        <xsl:apply-templates select="tei:cell[@rend = 'tdCom']"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdFeaturesRightSource">
                                        <xsl:apply-templates select="tei:cell[@rend = 'tdCentre']"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdFeaturesRightTarget">
                                        <xsl:apply-templates select="tei:cell[@rend = 'tdRight']"/>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                                <tr>
                                    <td class="tdFeaturesLeft" rowspan="2">
                                        <xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/>
                                    </td>
                                    <td class="tdFeaturesRightSource">
                                        <xsl:apply-templates select="tei:cell[@rend = 'tdCentre']"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="tdFeaturesRightTarget">
                                        <xsl:apply-templates select="tei:cell[@rend = 'tdRight']"/><xsl:text> </xsl:text>
                                    </td>
                                </tr>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:for-each>
                </table>
            </div>         
        </div>
        <!--             </body>        </html> -->
    </xsl:template>
    
    <xsl:template match="tei:fs"></xsl:template>
    <xsl:template match="tei:head"><h2><xsl:apply-templates/></h2></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:hi[@rend = 'red']"><span style="color:red"><xsl:apply-templates/></span></xsl:template>
    <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
    <xsl:template match="tei:seg"><span xml:space="preserve"><xsl:value-of select="."/></span></xsl:template>
    <xsl:template match="tei:w">
        <span><xsl:if test="contains(@ana,concat('#',$highLightIdentifier))"><xsl:attribute name="style">color:red;</xsl:attribute></xsl:if>
            <xsl:apply-templates/></span></xsl:template>
    
    <!-- 
   <xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
   <xsl:template match="tei:row">
      <tr><xsl:apply-templates/></tr></xsl:template>
   <xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
   <xsl:template match="tei:w"><span><xsl:apply-templates/></span></xsl:template>
    -->
</xsl:stylesheet>
