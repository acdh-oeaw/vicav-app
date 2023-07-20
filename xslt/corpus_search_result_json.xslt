<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

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
            <xsl:variable name="w" select="$hit/tei:u/tei:w[@xml:id = $token]"/>

            <xsl:if test="$w">
                <xsl:variable select="acdh:index-of-node($hit/tei:u/tei:w, $w)" name="word_pos"/>
                <xsl:message select="$w"/>
                <xsl:message select="$word_pos"/>
                <xsl:variable select="subsequence($hit/tei:u/tei:w, $word_pos+1, 5)" name="right"/>
                <xsl:variable select="subsequence($hit/tei:u/tei:w, $word_pos - 5, 5)" name="left"/>
                <div class="corpus-search-result">
                    <xsl:attribute name="id" select="concat('corpus-w-', $hit/token)"/>
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
                        <xsl:if test="not($w/@join = 'right')">
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
    </xsl:function>




    <xsl:template match="/">
        <json objects="json" arrays="hits">
            <xsl:apply-templates/></json>
    </xsl:template>

    <xsl:template match="hits">
        <query><xsl:value-of select="$query"/></query>
        <hits>


        <xsl:for-each select="./hit">
            <_ type="object">

                <xsl:apply-templates select="./@*"/>
                <content><xsl:apply-templates select="acdh:render-hit(.)" mode="serialize"/></content>
            </_>
        </xsl:for-each>
        </hits>
    </xsl:template>

    <xsl:template match="*" mode="serialize">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*" mode="serialize" />
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:text>&gt;</xsl:text>
                <xsl:apply-templates mode="serialize" />
                <xsl:text>&lt;/</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> /&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" mode="serialize">
        <xsl:text> </xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>="</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="text()" mode="serialize">
      <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:element name="{local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
</xsl:stylesheet>