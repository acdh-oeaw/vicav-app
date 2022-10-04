<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:include href="sampletexts_common.xslt"/>
    <!-- VERSION 3.1.4 -->
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>

    <xsl:param name="filter-words"></xsl:param>
    <xsl:param name="filter-features"></xsl:param>


    <xsl:template match="/items">
    <xsl:value-of select="filter-features"/>
        <xsl:variable name="all-sentences" select="distinct-values(//tei:s/@n)" />
        <xsl:variable name="selected-sentences" select="tokenize($filter-features, ',')" />
        <xsl:variable name="prev_sentence">
            <xsl:if test="count($selected-sentences) = 1 and number($selected-sentences[1]) > 1">
                <xsl:value-of select="number($selected-sentences[1]) - 1"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="next_sentence">
            <xsl:if test="count($selected-sentences) = 1 and number($selected-sentences[1]) &lt; max($all-sentences)">
                <xsl:value-of select="number($selected-sentences[1]) + 1"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="sentences-shown" select="if ($filter-features = 'any' or $filter-features = '') then $all-sentences else $selected-sentences"/>
        <xsl:variable name="root" select="."/>
        
        <xsl:variable name="filtered-by-word">
            <xsl:choose>
                <xsl:when test="$filter-words != ''">
                    <xsl:for-each select="tokenize($filter-words, ',')">
                        <xsl:variable name="word" select="."/>
                        <xsl:for-each 
                            select="$root/item//tei:s[not(@type = 'translationSentence') and .//tei:w[matches(., concat('(\W|^)', replace($word, '\*', '.*'), '(\W|$)' ))]]">
                            <xsl:sequence select="."/>
                        </xsl:for-each>
                     </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$root/item//tei:s[not(@type = 'translationSentence')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div>
            <div class="explore-samples">
                <table class="tbHeader">
                    <tr><td>
                        <h2 xml:space="preserve">Compare samples</h2></td>
                        <td class="tdPrintLink"><a href="#" data-print="true" class="aTEIButton">Print</a></td>
                    </tr>
                </table>
                <div class="explore-samples-summary">
                    <h4>Summary</h4>
                    <table>
                    <xsl:for-each-group select="$root/item" group-by="(.//tei:region[1], 'unknown')[1]">
                        <xsl:variable name="count" select="count(current-group()//tei:s[index-of($filtered-by-word/tei:s, .)> 0])"/>
                        <tr>
                            <th>
                                <xsl:value-of select="current-grouping-key()"/>
                            </th>
                            <td>
                                <xsl:value-of select="$count"/>
                            </td>
                        </tr>
                    </xsl:for-each-group>
                    </table>
                </div>
                
                <xsl:if test="$filter-features">
                    <div class="sentences-nav">
                        <xsl:if test="not($prev_sentence = '')">
                            <a href="#" data-feature="{$prev_sentence}" class="prev-link"><i class="fa fa-chevron-left"><span/></i> Previous</a>
                        </xsl:if>
                        <xsl:if test="not($next_sentence = '')">
                            <a href="#" data-feature="{$next_sentence}" class="next-link">Next <i class="fa fa-chevron-right"><span/></i></a>
                        </xsl:if>
                        <input name="sentences">
                            <xsl:attribute name="value"><xsl:value-of select="string-join($selected-sentences, ',')"/></xsl:attribute>
                        </input> / <xsl:value-of select="max($all-sentences)"/>
                    </div>
                </xsl:if>

                <xsl:for-each select="$sentences-shown">
                    <xsl:variable name="sentence" select="."/>
                    <xsl:if test="count($root/item//tei:s[@n=$sentence and index-of($filtered-by-word/tei:s, .) > 0]) > 0">
                        <xsl:if test="count($selected-sentences) > 1 or not($filter-features)">
                            <h3><xsl:value-of select="$sentence"/></h3>
                        </xsl:if>

                        <xsl:for-each-group select="$root/item" group-by="(.//tei:region[1], 'unknown')[1]">
                            <xsl:variable name="count" select="count(current-group()//tei:s[@n=$sentence and index-of($filtered-by-word/tei:s, .)> 0])"/>
                            <xsl:if test="$count > 0">
                                <h4><xsl:value-of select="current-grouping-key()"/></h4>
                                
                                <p xml:space="preserve"><xsl:value-of select="$count"/> sentences found.</p>

                                <table class="tbFeatures">
                                    <xsl:for-each select="current-group()">
                                        <xsl:sort select="@city"/>
                                        <xsl:if test="count(.//tei:s[@n=$sentence and index-of($filtered-by-word/tei:s, .) > 0]) > 0">
                                        <tr>
                                            <td class="tdFeaturesHeadRight"><xsl:value-of select="@city"/>
                                            <small xml:space="preserve"><xsl:if test="./@informant != ''"> (<xsl:value-of select="./@informant"/><xsl:if test="./@sex != ''">/<xsl:value-of select="@sex"/></xsl:if><xsl:if test="@age != ''">/<xsl:value-of select="@age"/></xsl:if>)<xsl:if test=".//tei:revisionDesc/tei:change"><br/></xsl:if></xsl:if><xsl:value-of select="replace(.//tei:revisionDesc/tei:change[1]/@when, 'T.*', '')" /></small>
                                        </td>
                                            <td class="tdFeaturesRightTarget">
                                                <a class="show-sentence" title="Show full sample text" href="#">
                                                    <xsl:attribute name="data-sampletext">
                                                        <xsl:value-of select="./descendant::tei:TEI/@xml:id" />
                                                    </xsl:attribute>
                                                    <i class="fa fa-eye" aria-hidden="true"><span/></i>
                                                </a>

                                                <xsl:apply-templates select=".//tei:div[@type='sampleText']//tei:s[@n=$sentence]"/>
                                            </td>
                                        </tr>   
                                        </xsl:if>                    
                                    </xsl:for-each>
                                </table>
                            </xsl:if>
                        </xsl:for-each-group>
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
