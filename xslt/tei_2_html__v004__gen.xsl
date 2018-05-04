<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0" exclude-result-prefixes="xsl tei">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
<!--    <xsl:strip-space elements="tei:body tei:TEI tei:teiHeader tei:text tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:availability tei:div tei:div1 tei:div2 tei:div3 tei:div4 tei:div5"/>-->
    <xsl:variable name="title">
        <xsl:value-of select="//tei:titleStmt/tei:title"/>
    </xsl:variable>
  
    <xsl:template match="/">
        <html>
            <xsl:comment>This is a generated page, do not edit!</xsl:comment>
            <!-- <xsl:comment>Generated: <xsl:value-of select="current-dateTime()"/></xsl:comment> -->
            
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
                <style type="text/css">
                    .spRed { color: red; }                    
                    .spEquals {color: black; }
                    .spAttrName { color: purple; }
                    .spQuotes { color: green; }
                    .spValues { color: blue; }
                </style>
                
            </head>
            <body>
                <!-- <xsl:call-template name="continue-root"/> -->
                <pre class="preBox">
                    <xsl:apply-templates select="node()"/>
                </pre>
                
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="*">
        <span>
            <xsl:if test="preceding-sibling::node()[1]/self::*">
                <xsl:text>

 </xsl:text>
            </xsl:if>
            <span class="spRed">
                <xsl:value-of select="concat('&lt;',local-name())"/>
            </span>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="node()">
                    <span class="spRed">
                        <xsl:text>&gt;</xsl:text>
                    </span>
                    <xsl:apply-templates/>
                    <span class="spRed">
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="local-name()"/>
                        <xsl:text>&gt;</xsl:text>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="spRed">
                        <xsl:text>/&gt;</xsl:text>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    <xsl:template match="@*">
        <span>
            <span class="spAttrName">
                <xsl:text> </xsl:text>&#160;    
               <xsl:value-of select="local-name()"/>
            </span>
            <span class="spEquals">=</span>
            <span class="spQuotes">"</span>
            <span class="spValues">
                <xsl:value-of select="."/>
            </span>
            <span class="spQuotes">"</span>
        </span>
    </xsl:template>
    <xsl:template match="@xml:*">
        <span>
            <xsl:text> </xsl:text>
            <span class="spAttrName">&#160;
                <xsl:value-of select="concat('xml:',local-name())"/>
            </span>
            <span class="spEquals">=</span>
            <span class="spQuotes">"</span>
            <span class="spValues">
                <xsl:value-of select="."/>
            </span>
            <span class="spQuotes">"</span>
        </span>
    </xsl:template>
    
    <!-- <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>
     -->
</xsl:stylesheet>