<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:include href="sampletexts_common.xslt"/>
    <xsl:include href="features_common.xslt"/>
    <!-- VERSION 3.1.4 -->
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>

    <xsl:param name="filter-words"></xsl:param>
    <xsl:param name="filter-features" select="''"></xsl:param>

    <xsl:template match="/">
        <xsl:variable name="all-features" select="distinct-values(/items//*[./name() = 'w' or @type= 'featureSample']/@ana)" />
        <xsl:variable name="selected-features" select="tokenize($filter-features, ',')" />

        <xsl:variable name="features-shown" select="if ($filter-features = '') then $all-features else $selected-features"/>
        <xsl:variable name="root" select="."/>
        
        <xsl:variable name="results" >
            <xsl:for-each select="$features-shown">
                <xsl:variable name="ana" select="."/>
                <xsl:sequence select="$root/items/item//tei:cit[@type='featureSample' and (.//tei:w[contains-token(@ana,$ana)][1] or .//tei:phr[contains-token(@ana,$ana)][1])]"></xsl:sequence>
            </xsl:for-each>
        </xsl:variable>
        
        
        <xsl:variable name="filtered-by-word">
            <xsl:choose>
                <xsl:when test="$filter-words != ''">
                    <xsl:for-each select="tokenize($filter-words, ',')">
                        <xsl:variable name="word" select="."/>
                        <xsl:for-each 
                            select=".">
                            <xsl:sequence select="$results/tei:cit[.//tei:w[matches(., concat('(\W|^)', replace($word, '\*', '.*'), '(\W|$)' ))]]" />
                        </xsl:for-each>
                     </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$results"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <div>
            <div>
                <table class="tbHeader">
                    <tr><td>
                        <h2 xml:space="preserve">Compare features</h2></td>
                    </tr>
                    <tr><td><i>
                            <xsl:value-of select="string-join(distinct-values(./items//item/@city), ', ')"/></i>
                    </td></tr>
                </table>    

                <p xml:space="preserve"><xsl:value-of select="count($filtered-by-word/tei:cit)"/> feature sentences found.</p>

                <xsl:for-each select="$features-shown">
                    <xsl:variable name="ana" select="."/>
                    <xsl:if test="count($results) > 0">
                        <xsl:if test="count($filtered-by-word/tei:cit[.//tei:w[contains-token(@ana,$ana)][1] or .//tei:phr[contains-token(@ana,$ana)][1]]) > 0">
                            <xsl:if test="count($selected-features) > 1 or $filter-features = ''">
                                <h3><xsl:value-of select="$results/tei:cit[@ana = $ana][1]//tei:lbl"/></h3>
                            </xsl:if>

                            <xsl:for-each-group select="$root/items//item" group-by="(.//tei:region[1], 'unknown')[1]">
                                <xsl:if test="count(current-group()//tei:cit[@type='featureSample' and (.//tei:w[contains-token(@ana,$ana)][1] or .//tei:phr[contains-token(@ana,$ana)][1]) and index-of($filtered-by-word/tei:cit, .) > 0]) > 0">
                                    <h4><xsl:value-of select="current-grouping-key()"/></h4>
                                    
                                    <table class="tbFeatures">
                                        <xsl:for-each select="current-group()">
                                            <xsl:sort select="@city"/>
                                            <xsl:variable name="item" select="."/>
                                            <xsl:variable name="city-results" select=".//tei:cit[@type='featureSample' and (.//tei:w[contains-token(@ana,$ana)][1] or .//tei:phr[contains-token(@ana,$ana)][1]) and index-of($filtered-by-word/tei:cit, .) > 0]"/>
                                            <xsl:if test="count($city-results) > 0">
                                            
                                            <xsl:for-each select="$city-results">
                                                <xsl:if test="./tei:note">
                                                    <tr>
                                                        <td class="tdFeaturesHeadRight" rowspan="3">
                                                            <xsl:value-of select="$item/@city"/>
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
                                                            <xsl:value-of select="$item/@city"/>
                                                            <small xml:space="preserve"><xsl:if test="$item/@informant != ''"> (<xsl:value-of 
                                                                   select="$item/@informant"/><xsl:if test="$item/@sex != ''">/<xsl:value-of 
                                                                   select="$item/@sex"/></xsl:if><xsl:if test="$item/@age != ''">/<xsl:value-of 
                                                                   select="$item/@age"/></xsl:if>)</xsl:if></small>
                                                        </td>                                    
                                                    </xsl:if>
                                                    <td class="tdFeaturesRightSource">
                                                        <xsl:apply-templates select=".//tei:quote[@xml:lang = 'en']"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="tdFeaturesRightTarget">
                                                        <xsl:sequence select="acdh:feature-sentence(./tei:quote, acdh:current-feature-ana(., $ana))" /><xsl:text> </xsl:text>
                                                    </td>                                                
                                                </tr>
                                            </xsl:for-each>
                                            </xsl:if>                    
                                        </xsl:for-each>
                                    </table>
                                </xsl:if>
                            </xsl:for-each-group>
                        </xsl:if>
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
