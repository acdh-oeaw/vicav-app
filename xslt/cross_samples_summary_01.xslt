<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:include href="features_common.xslt"/>
    <!-- VERSION 3.1.4 -->
    <xsl:preserve-space elements="*"/>

    <xsl:param name="filter-words"></xsl:param>
    <xsl:param name="filter-features"></xsl:param>
    <xsl:param name="filter-translations"></xsl:param>
    <xsl:param name="filter-comments"></xsl:param>


    <xsl:template match="/items">

        <xsl:variable name="query">
            <xsl:value-of select="concat('age=', encode-for-uri(./@age), '&amp;sex=', encode-for-uri(./@sex), '&amp;word=', ./@word, '&amp;translation=', ./@translation, '&amp;comment=', ./@comment)"/>
        </xsl:variable>

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
            <div>
                <div>
                    <div class="explore-samples-summary">
                    <h5>Query</h5>

                    <div>
                        <xsl:if test="not(@features = '')">
                            <xsl:value-of select="concat('Sentences: ', @features, ' ')"/>
                        </xsl:if>
                        <xsl:if test="not(@word = '')">
                            <xsl:value-of select="concat('Word: ', @word, ' ')"/>
                        </xsl:if>
                        <xsl:if test="not(@age = '')">
                            <xsl:value-of select="concat('Age: ', @age, ' ')"/>
                        </xsl:if>
                        <xsl:if test="not(@sex = '')">
                            <xsl:value-of select="concat('Sex: ', @sex, ' ')"/>
                        </xsl:if>
                        <xsl:if test="not(@comment = '')">
                            <xsl:value-of select="concat('Comment: ', @comment, ' ')"/>
                        </xsl:if>
                        <xsl:if test="not(@translation = '')">
                            <xsl:value-of select="concat('Translation: ', @translation, ' ')"/>
                        </xsl:if>
                    </div>
                </div>
                    <h4>Summary</h4>

                    <table>
                    <xsl:for-each-group select="$root/item" group-by="(.//tei:region[1], 'unknown')[1]">
                        <xsl:variable name="count" select="count(current-group()//tei:s[index-of($filtered-by-word/tei:s, .)> 0])"/>
                        <xsl:variable select="current-grouping-key()" name="region"/>
                        <xsl:variable name="feature-query">
                            <xsl:if test="not($root/@features = '')">
                                &amp;features=
                                <xsl:value-of select="$root/@features"/>
                            </xsl:if>
                        </xsl:variable>
                        <tr>
                            <xsl:if test="$root/@features = ''">
                                <xsl:attribute name="class" select="'explore-samples-summary'"/>
                            </xsl:if>
                            <th>
                                <xsl:value-of select="current-grouping-key()"/>
                            </th>
                            <td>
                                    <a href="#">
                                    <xsl:attribute name="data-type">sample</xsl:attribute>
                                    <xsl:attribute name="data-query" select="concat($query,'&amp;location=region:', $region, $feature-query)"/>
                                    <xsl:value-of select="$count"/>
                                    <xsl:value-of select="' sentences'"/>
                                </a>
                                <xsl:if test="$filter-features = ''">
                                <table style="display:none">

                                    <xsl:for-each-group select="current-group()//tei:s" group-by="./@n">
                                        <xsl:variable name="count2" select="count(current-group()//tei:s[index-of($filtered-by-word/tei:s, .)> 0])"/>
                                        <xsl:if test="$count2 > 0">
                                        <tr>
                                            <xsl:if test="$root/$features = ''">
                                                <xsl:attribute name="class" select="explore-samples-summary"/>
                                            </xsl:if>
                                            <th>
                                                <xsl:value-of select="current-grouping-key()"/>
                                            </th>
                                            <td>

                                                <a href="#">
                                                <xsl:attribute name="data-type">sample</xsl:attribute>
                                                <xsl:attribute name="data-query" select="concat($query,'&amp;location=region:', $region, '&amp;features=', current-grouping-key())"/>
                                                <xsl:value-of select="$count2"/>
                                                <xsl:value-of select="' sentences'"/>
                                                </a>
                                            </td>
                                        </tr>
                                        </xsl:if>
                                    </xsl:for-each-group>

                                </table>
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:for-each-group>
                    </table>
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>