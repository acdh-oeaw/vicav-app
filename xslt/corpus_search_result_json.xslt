<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="query"></xsl:param>

    <xsl:include href="serialize-html.xslt"/>

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
            Error: duplicate token ID <xsl:value-of select="token"/>
        </xsl:if>
        <xsl:if test="count($w) = 1">
            <xsl:variable select="acdh:index-of-node($hit/tei:u/tei:w, $w)" name="word_pos"/>
            <xsl:variable select="subsequence($hit/tei:u/tei:w, $word_pos+1, 5)" name="right"/>
            <xsl:variable select="subsequence($hit/tei:u/tei:w, $word_pos - 5, 5)" name="left"/>
            <div class="corpus-search-result justify-content-between">
                <xsl:attribute name="id" select="concat('corpus-w-', $hit/token)"/>
                <span class="left flex-fill text-end">
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
                </span>
                <span class="keyword text-center" width="150px">
                    <span class="w bg-warning">
                        <xsl:value-of select="$w" />
                    </span>
                    <xsl:if test="not($w/@join = 'right')">
                        <span xml:space="preserve"> </span>
                    </xsl:if>
                    <xsl:if test="$w/@join = 'right' and $w/@rend='withDash'">
                        <span>-</span>
                    </xsl:if>
                </span>
                <span class="right flex-fill text-start">
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
                </span>
            </div>
        </xsl:if>
    </xsl:function>




    <xsl:template match="/">
        <json objects="json" arrays="hits docHits">
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
                <content><xsl:apply-templates select="acdh:render-hit(.)" mode="serialize"/></content>
            </_>
        </xsl:for-each>
        </hits>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
</xsl:stylesheet>