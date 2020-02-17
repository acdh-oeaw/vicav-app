<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:include href="sampletexts_common.xslt"/>
    <xsl:output method="html" encoding="utf-8"/>
    <!-- VERSION 3.1.4 -->
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>

    <xsl:param name="filter-word"></xsl:param>

    <xsl:template match="/">
        <div>
            <div>
                <table class="tbHeader">
                    <tr><td>
                        <h2 xml:space="preserve">Compare samples: <i>
                            <xsl:value-of select="string-join(distinct-values(./items//item/@city), ', ')"/></i></h2></td>
                    </tr>
                </table>    
                                
                <xsl:variable name="root" select="."/>
                
                <xsl:variable name="sentences-containing">
                    <xsl:for-each select="tokenize($filter-word, ',')">
                        <xsl:variable name="word" select="."/>
                        <xsl:for-each select="$root/items//item//tei:s[.//tei:w[contains-token(., $word)]]">
                            <xsl:sequence select="."/>
                        </xsl:for-each>
                     </xsl:for-each>
                 </xsl:variable>

                 <xsl:value-of select="count($sentences-containing/*)"/>

                <xsl:for-each select="distinct-values(/items//tei:s/@n)">
                    <xsl:variable name="sentence" select="."/>
                    <xsl:if test="count($root/items//item//tei:s[@n=$sentence and index-of($sentences-containing/tei:s, .) > 0]) > 0">
                    <h3><xsl:value-of select="$sentence"/></h3>
                    <table class="tbFeatures">
                        <xsl:for-each select="$root/items//item">
                            <xsl:sort select="@city"/>
                            <xsl:if test="count(.//tei:s[@n=$sentence and index-of($sentences-containing/tei:s, .) > 0]) > 0">
                            <tr>
                                <td class="tdFeaturesHeadRight"><xsl:value-of select="@city"/>
                                <small>
                                <xsl:if test="./@informant != ''"> (<xsl:value-of select="./@informant"/><xsl:if test="./@sex != ''">/<xsl:value-of select="@sex"/></xsl:if><xsl:if test="@age != ''">/<xsl:value-of select="@age"/></xsl:if>)</xsl:if></small>
                            </td>
                                <td class="tdFeaturesRightTarget">
                                    <xsl:for-each select=".//tei:div[@type='sampleText']//tei:s[@n=$sentence]">
                                        <xsl:value-of select="index-of($sentences-containing, .)" />
                                    </xsl:for-each>
                                    <xsl:apply-templates select=".//tei:div[@type='sampleText']//tei:s[@n=$sentence]"/>
                                </td>
                            </tr>                       
                        </xsl:if>
                        </xsl:for-each>
                    </table>
                </xsl:if>
                </xsl:for-each>                  
            </div>         
        </div>
    </xsl:template>
    
    <xsl:template match="tei:fs"><xsl:value-of select="."/></xsl:template>
    <xsl:template match="tei:head"></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:p"></xsl:template>
</xsl:stylesheet>
