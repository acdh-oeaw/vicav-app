<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei acdh"
    version="2.0">
    <xsl:import href="utterances-to-json.xsl"/>

    <xsl:output method="xml" indent="no"/>
    <xsl:param name="query"></xsl:param>
    <xsl:param name="exit-on-node-index-not-found">no</xsl:param>

    <xsl:function name="acdh:index-of-node" as="xs:int">
        <xsl:param name="nodes"></xsl:param>
        <xsl:param name="search"></xsl:param>
        <xsl:variable name="ret" as="xs:int?">
        <xsl:for-each select="$nodes">
            <xsl:variable name="pos" select="position()"/>
            <xsl:if test=". is $search">
                <xsl:value-of select="$pos"/>
            </xsl:if>
        </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$ret"><xsl:value-of select="$ret"/></xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="{$exit-on-node-index-not-found}">Could not find index of node with xml:id <xsl:value-of select="$search/@xml:id"/></xsl:message>
                0
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="acdh:render-hit">
        <xsl:param name="hit"/>

        <xsl:variable name="token" select="$hit/token/text()"/>
        <xsl:variable name="w" select="$hit//tei:w[@xml:id = $token]"/>

        <xsl:variable select="acdh:index-of-node($hit/tei:u/(tei:w|tei:pc), $w[1])" name="word_pos_start"/>
        <xsl:variable select="acdh:index-of-node($hit/tei:u/(tei:w|tei:pc), $w[last()])" name="word_pos_end"/>
        <xsl:variable select="subsequence($hit/tei:u/(tei:w|tei:pc), $word_pos_end+1, 5)" name="right"/>
        <xsl:variable select="subsequence($hit/tei:u/(tei:w|tei:pc), $word_pos_start - 5, 5)" name="left"/>
        <!-- <xsl:attribute name="id" select="concat('corpus-w-', $hit/token)"/> -->
        <left>
            <xsl:variable name="html">
                <xsl:for-each select="$left">
                    <span class="{local-name(.)}">
                        <xsl:attribute name="id" select="@xml:id"/>
                        <xsl:value-of select="."/>
                    </span>
                    <xsl:if test="not(./@join = 'right') and not(following-sibling::*[1]/self::tei:pc)">
                        <span xml:space="preserve">&#xa0;</span>
                    </xsl:if>
                    <xsl:if test="./@join = 'right' and ./@rend='withDash'">
                        <span>-</span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select='serialize($html, map{"method":"html"})'/>
        </left>
        <kwic>
            <xsl:variable name="html">
                <xsl:for-each select="$w">
                    <span class="{local-name(.)}">
                        <xsl:attribute name="id" select="@xml:id"/>
                        <xsl:value-of select="."/>
                    </span>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select='serialize($html, map{"method":"html"})'/>
        </kwic>
        <right>
            <xsl:variable name="html">
                <xsl:for-each select="$right">
                    <xsl:if test="preceding-sibling::*[1][./@join = 'right' and ./@rend='withDash']">
                        <span>-</span>
                    </xsl:if>
                    <xsl:if test="not(./@join = 'left') and not(preceding-sibling::*[1][./@join = 'right' or ./@rend='withDash'])">
                        <span xml:space="preserve">&#xa0;</span>
                    </xsl:if>
                    <span class="{local-name(.)}">
                        <xsl:value-of select="."/>
                    </span>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select='serialize($html, map{"method":"html"})'/>
        </right>
    </xsl:function>

    <xsl:template match="/">
        <json objects="json hits">
            <xsl:apply-templates mode="docwrap"/>
        </json>
    </xsl:template>

    <xsl:template match="*:hits" mode="docwrap">
        <query><xsl:value-of select="$query"/></query>
        <hits>
          <xsl:apply-templates select="." mode="#default"/>
        </hits>
    </xsl:template>
    
    <xsl:template match="hit">
        <xsl:variable select=".." name="hits"/>
        <xsl:variable select="." name="hit"/>
        <_ type="object">
            <xsl:apply-templates select="./@*"/>
            <docHits>
                <xsl:for-each select="$hits/hit[./@doc = $hit/@doc]/token">
                    <_ type="string"><xsl:value-of select="."/></_>
                </xsl:for-each>
            </docHits>
            <content><xsl:sequence select="acdh:render-hit(.)"/></content>
        </_>        
    </xsl:template>

    <xsl:template match="@hits">
        <hits type="array">
            <xsl:for-each select="tokenize(.)">
                <_><xsl:value-of select="."/></_>
            </xsl:for-each>
        </hits>
    </xsl:template>
</xsl:stylesheet>