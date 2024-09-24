<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:include href="features_common.xslt"/>
    <!-- VERSION 3.1.4 -->
    <xsl:preserve-space elements="*"/>


    <xsl:param name="page" select="1"></xsl:param>
    <xsl:param name="filter-features"></xsl:param>

    <xsl:template match="/items">
        <table class="tbHeader">
            <tr><td>
                <h2 xml:space="preserve" class="pb-2 m-0">Compare linguistic features</h2></td>
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
        
        <div><span xml:space="preserve"><xsl:value-of select="./@count"/> sentences found.</span>

        <xsl:variable name="pager">
        <xsl:if test="not(./@pages = 1)">
            <div class="sentences-nav flex justify-between">
                <xsl:if test="@pages &gt; 1 and $page &gt; 1">
                    <a href="#" data-target-type="ExploreSamples" data-target-window="self" data-page="{$page - 1}" class="prev-link"><i class="fa fa-chevron-left"><span/></i> Previous</a>
                </xsl:if>
                <form>
                    <input name="features" data-target-type="ExploreSamples" data-target-window="self">
                        <xsl:attribute name="value"><xsl:value-of select="$page"/></xsl:attribute>
                    </input> / <xsl:value-of select="@pages"/>
                </form>
                <xsl:if test="(@pages &gt; 1) and not($page = count(./features))">
                    <a href="#" data-target-type="ExploreSamples" data-target-window="self" data-page="{$page + 1}" class="next-link">Next <i class="fa fa-chevron-right"><span/></i></a>
                </xsl:if>
            </div>
        </xsl:if>
        </xsl:variable>

        <xsl:sequence select="$pager" />

        <xsl:for-each select="./feature">
            <xsl:variable name="ana" select="./@feature"/>
            <h3><xsl:value-of select="./@label" /></h3>
            <xsl:for-each select="./region">
                <div>
                    <h4 class="my-0 text-lg"><xsl:value-of select="./@name"/></h4>
                    <xsl:for-each select="./settlement">
                        <div>
                        <xsl:variable select="./@name" name="city" />
                        <h5 class="my-2 font-bold"><xsl:value-of select="$city" /></h5>
                            <table class="tbFeatures my-0">
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
                                            <xsl:sequence select="acdh:feature-sentence($item/tei:cit/tei:quote[@xml:lang = ['aeb', 'ar']], acdh:current-feature-ana($item, $ana))" /><xsl:text> </xsl:text>
                                        </td>                                                
                                    </tr>              
                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:for-each>
        </xsl:for-each>      
        <xsl:sequence select="$pager"/>            
        </div>
    </xsl:template>
 
 </xsl:stylesheet>
