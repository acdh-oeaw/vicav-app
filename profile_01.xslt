<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml" 
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   version="2.0">
   
    <xsl:output method="html"/>
    <xsl:template match="/">
        
        <div class="h2Profile"><xsl:value-of select="//tei:name[@xml:lang='eng']"/></div>
        
        <div class="imgProfile">
            <img class="imgProfile">
            <xsl:attribute name="src">images/<xsl:value-of select="//tei:head/tei:ref[1]/@target"/></xsl:attribute>
                <div class="imgCaption"><xsl:value-of select="//tei:head/tei:ref[1]"/></div>
            </img>
        </div>    
            
        <table class="table table-striped">
            <tr>
                <td class="tdHead">Official name</td>
                <td class="tdProfile"><xsl:value-of select="//tei:name[@xml:lang='ara-x-DMG']"/></td>
                <td class="tdArabicText"><xsl:value-of select="//tei:name[@xml:lang='ara']"/></td>
            </tr>
            <xsl:if test="//tei:name[@type='latLoc']">
                <tr>
                    <td class="tdHead">Local name</td>
                    <td class="tdProfile"><xsl:value-of select="//tei:name[@type='latLoc']"/></td>
                    <td class="tdArabicText"><xsl:value-of select="//tei:name[@type='araLoc']"/></td>
                </tr>
            </xsl:if>
        </table>
        <div>Contributed by&#160;<i><xsl:value-of select="//tei:author"/></i> </div>
        <div>Geo location:&#160;<i><xsl:value-of select="//tei:div[@type='positioning']/tei:p/tei:geo"/></i> </div>
        
        <xsl:apply-templates select="//tei:div"/>        
        
        <br/>
        <br/>
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="@type='typology'">
                <div class="h3Profile">Typology</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='lingFeatures'">
                <div class="h3Profile">Linguistic Features</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='general'">
                <div class="h3Profile">General</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='researchHistory'">
                <div class="h3Profile">Research History</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='sampleText'">
                <div class="h3Profile">Sample Text</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='bibliography'">
                <div class="h3Profile">Bibliography</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='textBooks'">
                <div class="h3Profile">Text Books</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='dictionaries'">
                <div class="h3Profile">Dictionaries</div>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@type='audioData'">
                <div class="h3Profile">Audio Data</div>
                <xsl:apply-templates/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:teiHeader"></xsl:template>

    <xsl:template match="tei:p"><div class="pNorm"><xsl:apply-templates/></div></xsl:template>
        
    <xsl:template match="tei:ptr">
        <a class="visibleLink">
            <xsl:attribute name="href">#</xsl:attribute>
            <xsl:attribute name="onClick">refEvent("<xsl:value-of select="@target"/>")</xsl:attribute>
            -->
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <a class="visibleLink">
            <xsl:attribute name="href">#</xsl:attribute>
            <xsl:attribute name="onClick">refEvent("<xsl:value-of select="@target"/>")</xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
</xsl:stylesheet>

