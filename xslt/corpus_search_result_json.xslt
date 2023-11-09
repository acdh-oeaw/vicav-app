<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="2.0">

    <xsl:output method="xml" indent="yes"/>
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
    <xsl:function name="acdh:render-hit">
        <xsl:param name="hit"/>

        <xsl:variable name="token" select="$hit/token/text()"/>
        <xsl:variable name="w" select="$hit/tei:u/tei:w[@xml:id = $token][1]"/>

        <xsl:if test="count($w) > 1">
            Error: duplicate token ID <xsl:value-of select="$hit/token"/>
        </xsl:if>
        <xsl:if test="count($w) = 1">
            <xsl:variable select="acdh:index-of-node($hit/tei:u/tei:w, $w)" name="word_pos"/>
            <xsl:variable select="subsequence($hit/tei:u/tei:w, $word_pos+1, 5)" name="right"/>
            <xsl:variable select="subsequence($hit/tei:u/tei:w, $word_pos - 5, 5)" name="left"/>
                <!-- <xsl:attribute name="id" select="concat('corpus-w-', $hit/token)"/> -->
                <left>
                    <xsl:variable name="html">
                    <xsl:for-each select="$left">
                        <span class="w">
                            <xsl:attribute name="id" select="@xml:id"/>
                            <xsl:value-of select="."/>
                        </span>
                        <xsl:if test="not(./@join = 'right')  or following-sibling::*[1]/name() = 'pc'">
                            <span xml:space="preserve"> </span>
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
                    <span class="w">
                        <xsl:value-of select="$w" />
                    </span>
                    <xsl:if test="not($w/@join = 'right')">
                        <span xml:space="preserve"> </span>
                    </xsl:if>
                    <xsl:if test="$w/@join = 'right' and $w/@rend='withDash'">
                        <span>-</span>
                    </xsl:if>
                    </xsl:variable>
                    <xsl:value-of select='serialize($html, map{"method":"html"})'/>
                </kwic>
                <right>
                    <xsl:variable name="html">
                    <xsl:for-each select="$right">
                        <span class="w">
                            <xsl:value-of select="."/>
                        </span>
                        <xsl:if test="not(./@join = 'right') or following-sibling::*[1]/name() = 'pc'">
                            <span xml:space="preserve"> </span>
                        </xsl:if>
                        <xsl:if test="./@join = 'right' and ./@rend='withDash'">
                            <span>-</span>
                        </xsl:if>
                    </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select='serialize($html, map{"method":"html"})'/>
                </right>
        </xsl:if>
    </xsl:function>




    <xsl:template match="/">
        <json objects="json content" arrays="hits docHits">
            <xsl:apply-templates/>
        </json>
    </xsl:template>

    <xsl:template match="hits">
        <xsl:variable select="." name="hits"/>
        <query><xsl:value-of select="$query"/></query>
        <hits>

        <xsl:for-each select="./hit">
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
        </xsl:for-each>
        </hits>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
</xsl:stylesheet>