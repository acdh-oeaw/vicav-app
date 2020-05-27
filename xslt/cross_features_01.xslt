<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:param name="explanation"></xsl:param>
    <xsl:include href="sampletexts_common.xslt"/>
    <xsl:include href="features_common.xslt"/>
    
    <!-- VERSION 3.1.4 -->
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>
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
                    <tr><td>
                        <h2 xml:space="preserve">Features: <i>
                            <xsl:value-of select="$explanation"/></i></h2></td>
                        <!-- TEI deaktivated for the time being, problem with mixed xml.space -->
                        <!-- 
                        <td class="tdTeiLink"><a class='aTEIButton'>
                            <xsl:attribute name="href">javascript:showLingFeatures("==teiFuncID==","==teiFuncLabel==", "tei")</xsl:attribute>
                            TEI</a></td>  -->
                    </tr>
                </table>    
                
                
                <table class="tbFeatures">
                    <xsl:for-each select="//item">
                        <xsl:sort select="@city"/>
                        <xsl:value-of select="@city"/>
                        <tr>
                            <td class="tdFeaturesHeadRight"><xsl:value-of select="@city"/></td>
                            <td class="tdFeaturesRightTarget">
                                <xsl:apply-templates select=".//[@type='featureSample']/tei:quote"/>
                                <i class="iFeaturesTrans" xml:space="preserve"><xsl:text> </xsl:text>(<xsl:value-of select=".//tei:quote[@xml:lang = 'en']"/>)</i>
                            </td>
                        </tr>                       
                    </xsl:for-each>
                </table>
            </div>         
        </div>
        <!--             </body>        </html> -->
    </xsl:template>
    
    <xsl:template match="tei:head"></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:p"></xsl:template>
    <xsl:template match="tei:phr">
        <span>
            <xsl:if test="contains(@ana,$highLightIdentifier)">
                <xsl:attribute name="style">color:red;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/></span></xsl:template>
    <xsl:template match="tei:seg">
        <span><xsl:value-of select="."/></span>
    </xsl:template>
    
    <xsl:template match="tei:w"><span><xsl:if test="contains(@ana,$highLightIdentifier)">
                <xsl:attribute name="style">color:red;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/></span>
        <xsl:if test="not(./@join = 'right')  and not(following-sibling::*[1]/name() = 'pc')">
            <span xml:space="preserve"> </span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:pc">
        <span><xsl:apply-templates/></span>
        <xsl:if test="not(./@join = 'right')">
            <span xml:space="preserve"> </span></xsl:if></xsl:template>
    <!-- 
   <xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
   <xsl:template match="tei:row">
      <tr><xsl:apply-templates/></tr></xsl:template>
   <xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
   <xsl:template match="tei:w"><span><xsl:apply-templates/></span></xsl:template>
    -->
</xsl:stylesheet>
