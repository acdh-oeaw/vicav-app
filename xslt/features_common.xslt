<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:tei="http://www.tei-c.org/ns/1.0"
xmlns:acdh="http://acdh.oeaw.ac.at"
exclude-result-prefixes="#all"
version="2.0">
    <xsl:include href="sampletexts_common.xslt"/>
    
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
                <xsl:sequence select="acdh:feature-sentence(.//tei:quote[@xml:lang=('ar', 'aeb')], acdh:current-feature-ana(., ()))"/><xsl:text> </xsl:text>
            </td>
        </tr>
    </xsl:template>

    <xsl:function name="acdh:current-feature-ana">
        <xsl:param name="feature"></xsl:param>      
        <xsl:param name="ana"></xsl:param>
        <xsl:variable name="hasHighlight" select="not(empty($highlight)) and not($highlight = '')"/>

        <xsl:if test="$hasHighlight"><xsl:value-of select="$highlight"/></xsl:if>

        <xsl:if test="not($hasHighlight) and not(empty($ana))">
            <xsl:value-of select="$ana"/>
        </xsl:if>

        <xsl:if test="not($hasHighlight) and empty($ana) and not($feature/@ana = '')"><xsl:value-of select="$feature/@ana"/></xsl:if>

        <xsl:if test="not($hasHighlight) and empty($ana) and $feature/@ana = ''">
            <xsl:variable name="calculated-semlib" select="lower-case(replace(replace($feature/tei:lbl, '\s+', '_'), '[^\w_]', ''))"/>
            <xsl:value-of select="concat('semlib:', $calculated-semlib)"/>
        </xsl:if>
    </xsl:function>    

    <xsl:template match="tei:lbl"><xsl:apply-templates /></xsl:template>
    <xsl:template match="tei:fs"></xsl:template>
    <xsl:template match="tei:head"><xsl:apply-templates/></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:hi[@rend = 'red']"><span style="color:red"><xsl:apply-templates/></span></xsl:template>
    <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
</xsl:stylesheet>