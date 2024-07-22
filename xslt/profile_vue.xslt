<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   version="2.0">
 
    <xsl:output method="html" encoding="UTF-8"/>
    <xsl:import href="profile_01.xslt"/>

    <xsl:template match="tei:ref[starts-with(@target,'http')]">
         <a  data-target-type="External-link" target="_blank">
            <xsl:attribute name="href" select="@target" />
            <xsl:value-of select="."/>
        </a>
    </xsl:template>


    <xsl:template match="tei:head" mode="gallery">
        <gallery>
            <xsl:for-each select="./tei:figure">
                <a>
                    <xsl:attribute name="href" select="concat($images-base-path, ./tei:graphic/@url)"/>
                    <img>
                        <xsl:attribute name="src" select="concat($images-base-path, 'thumb/', ./tei:graphic/@url)"/>
                        <xsl:attribute name="alt" select="./tei:head"/>
                    </img>
                </a>
            </xsl:for-each>
        </gallery>
    </xsl:template>
                
    <xsl:template match="tei:p[@rendition='#slideshow']">       
        <gallery>
            <xsl:for-each select="./tei:figure">
                <a>
                    <xsl:attribute name="href" select="concat($images-base-path, ./tei:link/@target)"/>
                    <img>
                        <xsl:attribute name="alt" select="tei:head"/>
                        <xsl:attribute name="src" select="concat($images-base-path, 'thumb/', ./tei:link/@target)"/>
                    </img>
                </a>
            </xsl:for-each>
        </gallery>
    </xsl:template>

    <xsl:template match="//tei:div[@type='gallery']">
        <div class="h3Profile"><xsl:value-of select="./tei:head"/></div>
        <gallery>
            <xsl:for-each select="./tei:link">
            <a>
                <xsl:attribute name="href" select="concat($images-base-path, ./@target)"/>
                <img>
                    <xsl:attribute name="src" select="concat($images-base-path, 'thumb/',  ./@target)"/>
                    <xsl:attribute name="alt" select="./tei:head"/>
                </img>
            </a>
            </xsl:for-each>
        </gallery>
    </xsl:template>

</xsl:stylesheet>