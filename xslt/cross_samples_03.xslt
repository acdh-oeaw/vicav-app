<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"

version="3.1">
    <xsl:include href="sampletexts_common.xslt"/>
    <!-- VERSION 3.1.4 -->
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>

    <xsl:param name="page"></xsl:param>
    <xsl:param name="filter-features"></xsl:param>
    <!-- <xsl:param name="features"></xsl:param> -->


    <xsl:template match="tei:s">
        <span class="spSentence">
            <xsl:attribute name="xml:space">preserve</xsl:attribute>      
            <span class="sample-text-tooltip" data-html="true" data-toggle="tooltip" data-placement="top">
                <xsl:attribute name="title">                    
                    <xsl:variable name="nn" select="@n"/>
                    <xsl:value-of select="../tei:s[@type='translationSentence']"/>
                </xsl:attribute>
                <xsl:attribute name="data-tooltip">                    
                    <xsl:variable name="nn" select="@n"/>
                    <xsl:value-of select="../tei:s[@type='translationSentence']"/>
                </xsl:attribute>
                <i class="fa fa-comment" aria-hidden="true">
                    <span/>
                </i>
            </span>
            <xsl:value-of select="' '" />
            <xsl:for-each select="./(tei:w | tei:c | tei:pc | tei:choice)">
                <xsl:variable name="position" select="position()"/>
                <xsl:choose>
                    <xsl:when test="./name() = 'w'">
                        <xsl:sequence select="acdh:word-block(., 'sample', $position, '')" />
                    </xsl:when>
                    <xsl:when test="./name() = 'choice'">
                        <xsl:sequence select="acdh:choice-block(., 'sample', '')" />
                    </xsl:when>
                    <xsl:otherwise><xsl:apply-templates select="." /></xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </span>
    </xsl:template>

    <xsl:template match="/items">
        <!-- <xsl:variable name="prev_sentence">
            <xsl:if test="count($filter-features) = 1 and number($filter-features[1]) > 1">
                <xsl:value-of select="number($filter-features[1]) - 1"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="next_sentence">
            <xsl:if test="count($filter-features) = 1 and number($filter-features[1]) &lt; max($features)">
                <xsl:value-of select="number($filter-features[1]) + 1"/>
            </xsl:if>
        </xsl:variable> -->

        <xsl:variable name="root" select="."/>
        
        <div>
            <div class="explore-samples">
                <table class="tbHeader">
                    <tr><td>
                        <h2 xml:space="preserve" class="pb-2 m-0">Compare samples</h2></td>
                            <td class="tdPrintLink">
                            <a data-print="true" target="_blank" class="aTEIButton">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$print-url"/>
                                </xsl:attribute>
                                Print
                            </a>
                        </td>                    </tr>
                </table>
                <xsl:if test="count($root/features/region) &gt; 1">
                <div class="explore-samples-summary">
                    <h4>Summary</h4>
                    <table>
                    <xsl:for-each select="$root/feature">
                        <tr>
                            <th colspan="2">
                                <xsl:value-of select="./@name"/>
                            </th>
                        </tr>
                        <xsl:for-each select="./region">
                    
                        <tr>
                            <th>
                                <xsl:value-of select="./@name"/>
                            </th>
                            <td>
                                <xsl:value-of select="./@count"/>
                            </td>
                        </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                    </table>
                </div>
                </xsl:if>
                
                <xsl:variable name="pager">
                    <xsl:if test="@pages &gt; 1">
                        <div class="sentences-nav flex justify-between">
                            <xsl:if test="(count(./feature) > 1) and ($page > 1)">
                                <a href="#" data-target-type="ExploreSamples" data-target-window="self" 
                                data-page="{$page -1}" class="prev-link"><i class="fa fa-chevron-left"><span/></i> Previous</a>
                            </xsl:if>
                            <form>
                                <input name="features" data-target-type="ExploreSamples" data-target-window="self">
                                    <xsl:attribute name="value"><xsl:value-of select="$page"/></xsl:attribute>
                                </input> / <xsl:value-of select="@pages"/>
                            </form>
                            <xsl:if test="(@pages &gt; 1) and ($page &lt; @pages)">
                                <a href="#" data-target-type="ExploreSamples" data-target-window="self" data-page="{$page + 1}" class="next-link">Next <i class="fa fa-chevron-right"><span/></i></a>
                            </xsl:if>
                        </div>
                    </xsl:if>
                </xsl:variable>
                <xsl:sequence select="$pager">

                <xsl:for-each select="./feature">
                    <h3 class="mt-0" xml:space="preserve">Sentence <xsl:value-of select="@name"/></h3>

                    <xsl:for-each select="./region">
                        <h4><xsl:value-of select="@name"/></h4>
                        
                        <p xml:space="preserve"><xsl:value-of select="@count"/> sentences found.</p>

                        <table class="tbFeatures">
                            <xsl:for-each select="./settlement">
                                <xsl:sort select="@name"/>
                                <xsl:for-each select="./item">
                                    <tr>
                                        <td class="tdFeaturesHeadRight"><xsl:value-of select="../@name"/>
                                        <small xml:space="preserve"><xsl:if test="./@informant != ''"> (<xsl:value-of select="./@informant"/><xsl:if test="./@sex != ''">/<xsl:value-of select="@sex"/></xsl:if><xsl:if test="@age != ''">/<xsl:value-of select="@age"/></xsl:if>)<xsl:if test=".//tei:revisionDesc/tei:change"><br/></xsl:if></xsl:if><xsl:value-of select="replace(.//tei:revisionDesc/tei:change[1]/@when, 'T.*', '')" /></small>
                                        </td>
                                        <td class="tdFeaturesRightTarget">
                                            <a class="show-sentence" title="Show full sample text" href="#"
                                            data-target-type="SampleText">
                                                <xsl:attribute name="data-text-id">
                                                    <xsl:value-of select="@xml:id" />
                                                </xsl:attribute>
                                                <xsl:attribute name="data-sampletext">
                                                    <xsl:value-of select="@xml:id" />
                                                </xsl:attribute>
                                                <i class="fa fa-eye" aria-hidden="true"><span/></i>
                                            </a>

                                            <xsl:apply-templates select="tei:s[not(@type='translationSentence')]" /><xsl:text> </xsl:text>
                                        </td>
                                    </tr>   
                                </xsl:for-each>
                            </xsl:for-each>
                        </table>
                    </xsl:for-each>
                </xsl:for-each> 
                            
                <xsl:sequence select="$pager">     
            </div>         
        </div>
    </xsl:template>
    
    <!-- <xsl:template match="tei:fs"><xsl:value-of select="."/></xsl:template>
    <xsl:template match="tei:head"></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:p"></xsl:template> -->
</xsl:stylesheet>
