<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   version="2.0">
 
    <xsl:output method="html" encoding="UTF-8"/>
    <xsl:import href="profile_01.xslt"/>

    <xsl:template match="tei:ref[starts-with(@target,'http')]">
         <a data-target-type="External-link" target="_blank">
            <xsl:attribute name="href" select="@target" />
            <xsl:value-of select="."/>
        </a>
    </xsl:template>


    <xsl:template match="tei:head" mode="gallery">
        <gallery>
            <xsl:for-each select="./tei:figure">
                <a>
                    <xsl:attribute name="href" select="concat($images-base-path, ./tei:graphic[@type='thumbnail']/@url)"/>
                    <img>
                        <xsl:attribute name="src" select="concat($images-base-path, 'thumb/', ./tei:graphic[@type='thumbnail']/@url)"/>
                        <xsl:attribute name="alt" select="./tei:head"/>
                    </img>
                </a>
            </xsl:for-each>
        </gallery>
    </xsl:template>
            
            
    <xsl:template match="tei:figure[not(@rendition)]">
        <div class="figure">
            <div class="gallery-item">
                <xsl:variable name="thumbnailPath">
                    <xsl:choose>
                        <xsl:when test="tei:graphic[@type = 'thumbnail']/@url != tei:graphic[@type = 'fullscale']/@url">
                            <xsl:value-of select="concat($images-base-path, tei:graphic[@type = 'thumbnail']/@url)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($images-base-path, 'thumb/',  tei:graphic[@type = 'fullscale']/@url)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <a>
                    <xsl:attribute name="href" select="concat($images-base-path, ./tei:graphic[@type='fullscale']/@url)"/>
                    <xsl:attribute name="title" select="tei:head"/>
                    <img>
                        <xsl:attribute name="src" select="$thumbnailPath"/>
                    </img>
                </a>
                <div class="imgCaption"><xsl:value-of select="tei:head[@type='imgCaption']"/></div>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:figure[@rendition='#slideshow']">
        <gallery>
            <xsl:for-each select="./tei:figure">
                <xsl:variable name="thumbnailPath">
                    <xsl:choose>
                        <xsl:when test="tei:graphic[@type = 'thumbnail']/@url != tei:graphic[@type = 'fullscale']/@url">
                            <xsl:value-of select="concat($images-base-path, tei:graphic[@type = 'thumbnail']/@url)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($images-base-path, 'thumb/',  tei:graphic[@type = 'fullscale']/@url)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <a>
                    <xsl:attribute name="href" select="concat($images-base-path, ./tei:graphic[@type='fullscale']/@url)"/>
                    <img>
                        <xsl:attribute name="alt" select="tei:head"/>
                        <xsl:attribute name="src" select="$thumbnailPath"/>
                    </img>
                </a>
            </xsl:for-each>
        </gallery>
    </xsl:template>

    <xsl:template match="tei:figure[@rendition='#gallery']">
        <xsl:if test="tei:head">
            <div class="h3Profile"><xsl:value-of select="./tei:head"/></div>
        </xsl:if>
        <gallery>
            <xsl:for-each select="./tei:figure">
                <xsl:variable name="thumbnailPath">
                    <xsl:choose>
                        <xsl:when test="tei:graphic[@type = 'thumbnail']/@url != tei:graphic[@type = 'fullscale']/@url">
                            <xsl:value-of select="concat($images-base-path, tei:graphic[@type = 'thumbnail']/@url)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($images-base-path, 'thumb/',  tei:graphic[@type = 'fullscale']/@url)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <a>
                    <xsl:attribute name="href" select="concat($images-base-path, tei:graphic[@type='fullscale']/@url)"/>
                    <img>
                        <xsl:attribute name="src" select="$thumbnailPath"/>
                        <xsl:attribute name="alt" select="./tei:head"/>
                    </img>
                </a>
            </xsl:for-each>
        </gallery>
    </xsl:template>

</xsl:stylesheet>