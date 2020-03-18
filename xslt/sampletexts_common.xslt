<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:tei="http://www.tei-c.org/ns/1.0"
xmlns:acdh="http://acdh.oeaw.ac.at"
version="2.0">    
<xsl:output method="html"/>

<xsl:param name="highlight"></xsl:param>

<xsl:template match="//tei:div[@type='sampleText']/tei:p/tei:s | //tei:div[@type='corpusText']/tei:u">
    <span class="spSentence">
        <span class="sample-text-tooltip" data-html="true" data-toggle="tooltip" data-placement="top">
            <xsl:attribute name="title">                    
                <xsl:variable name="nn" select="@n"/>
                <xsl:value-of select="(//tei:s[@type='translationSentence'][@n=$nn] | //tei:div[@type='dvTranslations']/tei:u[@n=$nn])[1]"/>
            </xsl:attribute>
            <i class="fa fa-commenting-o" aria-hidden="true"></i>
        </span>
        <xsl:value-of select="' '" />
        <xsl:for-each select="tei:w | tei:c | tei:seg | tei:pc">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </span>
</xsl:template>

<xsl:template match="tei:quote[@xml:lang = 'ar']">
        <xsl:for-each select="tei:w | tei:c | tei:seg | tei:pc">
            <xsl:apply-templates select="." mode="feature"/>
        </xsl:for-each>
</xsl:template>
    
    
<xsl:function name="acdh:word-span">
    <xsl:param name="w"></xsl:param>
    <xsl:param name="highlight"></xsl:param>
    <xsl:variable name="wordform" select="acdh:get-wordform($w)"/>
    
    <span class="w" data-html="true" data-placement="top">
        <xsl:variable name="matchesHighlights">
            <xsl:for-each select="tokenize(replace($highlight, '\*', '.*'), ',')">
                <xsl:sequence select="if (contains($w ,'.*')) then matches($wordform, $w) else $wordform = $w"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$matchesHighlights != '' and $matchesHighlights = true()">
            <xsl:attribute name="style">
                color: red
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$w/tei:fs">
            <xsl:attribute name="class">
                <xsl:value-of select="$w/@class" />
                <xsl:value-of select="'sample-text-tooltip'" />
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='variant']/text())&gt;0">
                    <xsl:value-of select="' sample-text-variant'"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='pos'])&gt;0">&lt;span class="spPos"&gt;POS:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='pos']"/>&lt;br/&gt;</xsl:if>
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='lemma'])&gt;0">&lt;span class="spLemma"&gt;Lemma:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='lemma']"/>&lt;br/&gt;</xsl:if>                            
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='translation'])&gt;0">&lt;span class="spTrans"&gt;English:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='translation']"/>&lt;br/&gt;</xsl:if>
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='variant'])&gt;0">&lt;span class="spTrans"&gt;Alternative form:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='variant']"/>&lt;br/&gt;</xsl:if>  
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='informant'])&gt;0">&lt;span class="spTrans"&gt;Alternative form informant:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='informant']"/>&lt;br/&gt;</xsl:if>
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='comment'])&gt;0">&lt;span class="spTrans"&gt;Note:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='comment']"/>&lt;br/&gt;</xsl:if>                                                        
            </xsl:attribute>
            
            <xsl:choose>
                <xsl:when test="string-length($w/tei:fs/tei:f[@name='pos'])>0 or string-length($w/tei:fs/tei:f[@name='lemma'])>0 or string-length($w/tei:fs/tei:f[@name='translation'])>0 or string-length($w/tei:fs/tei:f[@name='variant'])>0 or string-length($w/tei:fs/tei:f[@name='comment'])>0">
                    <xsl:attribute name="data-toggle">tooltip</xsl:attribute></xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:value-of select="$wordform"/>
    </span>    
</xsl:function>
    
<xsl:function name="acdh:get-wordform">
    <xsl:param name="w"></xsl:param>
    
    <xsl:choose>
        <xsl:when test="$w/tei:fs">
            <xsl:value-of select="replace($w/tei:fs/tei:f[@name='wordform'], '[\s&#160;]+$', '')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="replace($w, '[\s&#160;]+$', '')"/>
        </xsl:otherwise>
    </xsl:choose>
    
</xsl:function>
    
<xsl:template match="tei:w" mode="feature">
    <xsl:variable name="wordform" select="acdh:get-wordform(.)"/>
    <xsl:sequence select="acdh:word-span(., $highlight)"></xsl:sequence>
    <xsl:if test="not(matches($wordform, '^[„-]$')) and
        not(following-sibling::*[1]/name() = 'pc') and
        not(matches(following-sibling::tei:w[1]/tei:fs/tei:f[@name='wordform'], '^\W+$'))">
        <xsl:value-of select="' '" />
    </xsl:if>
</xsl:template>
    
<xsl:template match="tei:w" mode="sample">
    <xsl:variable name="wordform" select="acdh:get-wordform(.)"/>
    
    <a class="word-search">
        <xsl:attribute name="href">
            <xsl:value-of select="'compare-samples.html?word='"/>
            <xsl:value-of select="$wordform" />
<!--            <xsl:value-of select="'&amp;location='"/>
            <xsl:value-of select="string-join(distinct-values(//tei:body/tei:head/tei:name/text()), ',')"/>-->
        </xsl:attribute>
        <xsl:sequence select="acdh:word-span(., $highlight)"></xsl:sequence>
    </a>

    <xsl:if test="not(matches($wordform, '^[„-]$')) and
        not(following-sibling::*[1]/name() = 'pc') and
        not(matches(following-sibling::tei:w[1]/tei:fs/tei:f[@name='wordform'], '^\W+$'))">
        <xsl:value-of select="' '" />
    </xsl:if>
</xsl:template>

<xsl:template match="tei:c">
    <xsl:value-of select="."/>
</xsl:template>
        
<xsl:template match="tei:pc" mode="feature">
    <span class="pc">
        <xsl:if test="./@join = 'right'"><xsl:value-of select="' '" /></xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="./@join = 'left'"><xsl:value-of select="' '" /></xsl:if>
    </span>
</xsl:template>
    
<xsl:template match="tei:pc">
    <span class="pc">
        <xsl:if test="./@join = 'right'"><xsl:value-of select="' '" /></xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="./@join = 'left'"><xsl:value-of select="' '" /></xsl:if>
    </span>
</xsl:template>
</xsl:stylesheet>