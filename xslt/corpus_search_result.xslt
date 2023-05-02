<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    
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
    
    
    <xsl:template match="/hits">
        <div class="corpus-search-results">
        <h2 xml:space="preserve">Search results for <xsl:value-of select="$query"/></h2>

        <xsl:for-each select="./hit">
            <xsl:variable name="token" select="token/text()"/>
            <xsl:variable name="w" select="./tei:u/tei:w[@xml:id = $token]"/>
            
            <xsl:if test="$w">
                <xsl:variable select="acdh:index-of-node(./tei:u/tei:w, $w)" name="word_pos"/>
                <xsl:message select="$w"/>
                <xsl:message select="$word_pos"/>
                <xsl:variable select="subsequence(./tei:u/tei:w, $word_pos+1, 5)" name="right"/>
                <xsl:variable select="subsequence(./tei:u/tei:w, $word_pos - 5, 5)" name="left"/>
                <div class="corpus-search-result">
                    <xsl:attribute name="id" select="concat('corpus-w-', ./token)"/>
                    <div class="left">
                        <xsl:for-each select="$left">
                            <span class="w">
                                <xsl:attribute name="id" select="@xml:id"/>
                                <xsl:value-of select="."/>
                            </span>
                            <xsl:if test="not(./@join = 'right')  or following-sibling::*[1]/name() = 'pc'">
                                <span xml:space="preserve"> </span>
                            </xsl:if>                        
                        </xsl:for-each> 
                    </div>
                    <div class="keyword">
                        <span class="w">
                            <xsl:value-of select="$w" />
                        </span>
                        <xsl:if test="not($w/@join = 'right') or following-sibling::*[1]/name() = 'pc'">
                            <span xml:space="preserve"> </span>
                        </xsl:if> 
                    </div>
                    <div class="right">
                        <xsl:for-each select="$right">
                            <span class="w">
                                <xsl:value-of select="."/>
                            </span>
                            <xsl:if test="not(./@join = 'right') or following-sibling::*[1]/name() = 'pc'">
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