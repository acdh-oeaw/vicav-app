<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:tei="http://www.tei-c.org/ns/1.0"
xmlns:acdh="http://acdh.oeaw.ac.at"
version="2.0">
    <xsl:template match="tei:cit[@type='featureSample']">
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
    </xsl:template>

    <xsl:template match="tei:lbl"><xsl:apply-templates /></xsl:template>
    <xsl:template match="tei:fs"></xsl:template>
    <xsl:template match="tei:head"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:hi[@rend = 'red']"><span style="color:red"><xsl:apply-templates/></span></xsl:template>
    <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
</xsl:stylesheet>