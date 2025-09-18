<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:output indent="yes"/>
    <xsl:param name="query"></xsl:param>

    <xsl:function name="acdh:index-of-node">
        <xsl:param name="nodes"></xsl:param>
        <xsl:param name="search"></xsl:param>
        <xsl:for-each select="$nodes">
            <xsl:variable name="pos" select="position()"/>
            <xsl:if test=". is $search">
                <xsl:value-of select="$pos"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <!-- TODO: Add links to document? -->
    
    <xsl:template match="/tei:hits">
        <div class="corpus-search-results">
        <h2 xml:space="preserve">Search results for <xsl:value-of select="$query"/></h2>

            <xsl:for-each select="./tei:div">
            <xsl:variable name="token" select="(@hits, token/text())"/>
            <xsl:variable name="w" select="./tei:u/tei:w[@xml:id = $token]"/>
            
            <xsl:if test="count($w) > 1">
                <xsl:value-of select="token"/>
            </xsl:if>
            <xsl:if test="count($w) = 1">

                <xsl:variable select="acdh:index-of-node(./tei:u/(tei:w|tei:pc), $w)" name="word_pos"/>
                <xsl:variable select="subsequence(./tei:u/(tei:w|tei:pc), $word_pos+1, 5)" name="right"/>
                <xsl:variable select="subsequence(./tei:u/(tei:w|tei:pc), $word_pos - 5, 5)" name="left"/>
                <div class="corpus-search-result">
                    <xsl:attribute name="id" select="concat('corpus-w-', ./token)"/>
                    <div class="left">
                        <xsl:for-each select="$left">
                            <span class="{local-name(.)}">
                                <xsl:attribute name="id" select="@xml:id"/>
                                <xsl:value-of select="."/>
                            </span>
                            <xsl:if test="not(./@join = 'right') and not(following-sibling::*[1]/self::tei:pc)">
                                <span xml:space="preserve"> </span>
                            </xsl:if>                        
                        </xsl:for-each> 
                    </div>
                    <div class="keyword">
                        <span class="{local-name($w)}">
                            <xsl:value-of select="$w" />
                        </span>
                        <xsl:if test="not($w/@join = 'right') and not(following-sibling::*[1]/self::tei:pc)">
                            <span xml:space="preserve"> </span>
                        </xsl:if> 
                    </div>
                    <div class="right">
                        <xsl:for-each select="$right">
                            <span class="{local-name(.)}">
                                <xsl:value-of select="."/>
                            </span>
                            <xsl:if test="not(./@join = 'right') and not(following-sibling::*[1]/self::tei:pc)">
                                <span xml:space="preserve"> </span>
                            </xsl:if> 
                        </xsl:for-each> 
                    </div>
                </div>
            </xsl:if>      
        </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>