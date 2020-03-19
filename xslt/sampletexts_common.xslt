<xsl:stylesheet 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns="http://www.w3.org/1999/xhtml" 
xmlns:tei="http://www.tei-c.org/ns/1.0"
xmlns:acdh="http://acdh.oeaw.ac.at"
version="2.0">    
<xsl:output method="html"/>

<xsl:param name="highlight"></xsl:param>
<xsl:param name="highLightIdentifier" select="()"></xsl:param>
    
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
        <xsl:for-each select="./(tei:w | tei:c | tei:pc | tei:choice)">
            <xsl:variable name="position" select="position()"/>
            <xsl:choose>
                <xsl:when test="./name() = 'w'">
                    <xsl:sequence select="acdh:word-block(., 'sample', $position)" />
                </xsl:when>
                <xsl:when test="./name() = 'choice'">
                    <xsl:sequence select="acdh:choice-block(., 'sample')" />
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates select="." /></xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </span>
</xsl:template>

<xsl:template match="tei:quote[@xml:lang = 'ar']">
    <xsl:for-each select="./(tei:w | tei:c | tei:pc | tei:choice)">
        <xsl:variable name="position" select="position()"/>
        <xsl:choose>
            <xsl:when test="./name() = 'w'">
                <xsl:sequence select="acdh:word-block(., 'feature', $position)" />
            </xsl:when>
            <xsl:when test="./name() = 'choice'">
                <xsl:sequence select="acdh:choice-block(., 'feature')" />
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates select="." /></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>
    
<xsl:function name="acdh:matches-highlight">
    <xsl:param name="wordform"></xsl:param>
    <xsl:for-each select="tokenize(replace($highlight, '\*', '.*'), ',')">
        <xsl:sequence select="if (contains(. ,'.*')) then matches($wordform, .) else $wordform = ."/>
    </xsl:for-each>
</xsl:function>
    
<xsl:function name="acdh:highlight-identifier">
    <xsl:param name="el"></xsl:param>
    
</xsl:function>
    
<xsl:function name="acdh:word-span">
    <xsl:param name="w"></xsl:param>
    <xsl:variable name="wordform" select="acdh:get-wordform($w)"/>
    <xsl:variable name="matchesHighlights" select="acdh:matches-highlight($wordform)"/>
    <xsl:variable name="highLightIdentifier">
        <xsl:choose>
            <xsl:when test="not(empty($highLightIdentifier))"><xsl:value-of select="$highLightIdentifier"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="acdh:current-feature-ana($w)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="matchesHighlightId" select="not(empty($highLightIdentifier)) and not(empty(($w/@ana))) and (contains($w/@ana,$highLightIdentifier) or contains($w/parent::tei:phr/@ana, $highLightIdentifier))"/>
    
    <span class="w" data-html="true" data-placement="top">
        <xsl:if test="$matchesHighlights = true() or $matchesHighlightId = true()">
            <xsl:attribute name="style">
                color: red
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$w/tei:fs">
            <xsl:attribute name="class">
                <xsl:value-of select="$w/@class" />
                <xsl:value-of select="'sample-text-tooltip'" />
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='pos'])&gt;0">&lt;span class="spPos"&gt;POS:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='pos']"/>&lt;br/&gt;</xsl:if>
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='lemma'])&gt;0">&lt;span class="spLemma"&gt;Lemma:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='lemma']"/>&lt;br/&gt;</xsl:if>                            
                <xsl:if test="string-length($w/tei:fs/tei:f[@name='translation'])&gt;0">&lt;span class="spTrans"&gt;English:&lt;/span&gt;&#160;<xsl:value-of select="$w/tei:fs/tei:f[@name='translation']"/>&lt;br/&gt;</xsl:if>
                <xsl:if test="count($w//tei:f[@name='informant'])&gt;0">&lt;span class="spTrans"&gt;Alternative form informant:&lt;/span&gt;&#160;<xsl:value-of select="string-join($w/tei:f[@name='informant'], ', ')"/>&lt;br/&gt;</xsl:if>
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

<xsl:function name="acdh:choice-block">
    <xsl:param name="choice"></xsl:param>
    <xsl:param name="mode"></xsl:param>
    <xsl:variable name="variants" select="$choice/tei:seg[position() >= 2]"/>
    <xsl:variable name="variant_count" select="count($variants)"></xsl:variable>
    <xsl:variable name="variants-value">
        <xsl:for-each select="$variants">
            <xsl:variable name="variant_pos" select="position()"></xsl:variable>
            <xsl:for-each select="./*">
                <xsl:choose>
                    <xsl:when test="name() = 'phr'">
                        <xsl:for-each select="./*">
                            <xsl:if test="./name() = 'w'">
                                <xsl:value-of select=".//tei:f[@name='wordform']"/>
                                <xsl:if test="not(empty(following-sibling::*)) and following-sibling::*[1][name() != 'pc']"><xsl:value-of select="' '"/></xsl:if>
                            </xsl:if>
                            <xsl:if test="./name() = 'pc'"><xsl:value-of select="."/></xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$variant_pos &lt; $variant_count"><xsl:value-of select="', '"/></xsl:if>
                    </xsl:when>
                    <xsl:when test="name() = 'w'">
                        <xsl:value-of select=".//tei:f[@name='wordform']"/>                        
                        <xsl:if test="$variant_pos &lt; $variant_count"><xsl:value-of select="', '"/></xsl:if>
                    </xsl:when>
                    <xsl:when test="name() = 'pc'"><xsl:value-of select="."/></xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable> 
    
    <span class="phr sample-text-tooltip sample-text-variant" data-toggle="tooltip" data-html="true" data-placement="top" href="#">
    <xsl:attribute name="title">
        <xsl:if test="$variants">&lt;span class="spTrans"&gt;Alternative form:&lt;/span&gt;&#160;<xsl:value-of select="$variants-value"/>&lt;br/&gt;</xsl:if>  
        <xsl:if test="count($variants//tei:f[@name='informant'])&gt;0">&lt;span class="spTrans"&gt;Alternative form informant:&lt;/span&gt;&#160;<xsl:value-of select="string-join($variants/tei:f[@name='informant'], ', ')"/></xsl:if>
    </xsl:attribute>
    <xsl:for-each select="$choice/tei:seg[1]/*">
        <xsl:choose>
            <xsl:when test="./name() = 'w'">
                <xsl:variable select="position()" name="position"/>
                <xsl:sequence select="acdh:word-block(., $mode, $position)"></xsl:sequence>
            </xsl:when>
            <xsl:when test="./name() = 'phr'">
                <xsl:for-each select="./*">
                    <xsl:choose>
                        <xsl:when test="name() = 'w'">
                            <xsl:variable select="position()" name="position"/>
                            
                            <xsl:sequence select="acdh:word-block(., $mode, $position)"></xsl:sequence>
                        </xsl:when>
                        <xsl:otherwise><xsl:apply-templates select="." /></xsl:otherwise>                        
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates select="." /></xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    </span>
    <xsl:if test="
        not($choice/following-sibling::*[1]/name() = 'pc') and
        not(matches($choice/following-sibling::tei:w[1]/tei:fs/tei:f[@name='wordform'], '^\W+$'))">
        <xsl:value-of select="' '"/>
    </xsl:if>
</xsl:function>
    
<xsl:function name="acdh:current-feature-ana">
    <xsl:param name="w"></xsl:param>        
    <xsl:choose>
        <xsl:when test="$w/ancestor::tei:cit[@type='featureSample']/@ana != ''">
            <xsl:value-of select="$w/ancestor::tei:cit[@type='featureSample']/@ana"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="calculated-semlib" select="lower-case(replace(replace($w/ancestor::tei:cit[@type='featureSample']/tei:lbl, '\s+', '_'), '[^\w_]', ''))"/>
            <xsl:value-of select="concat('semlib:', $calculated-semlib)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>    
    
<xsl:template match="tei:w" mode="sample">
    <xsl:variable name="wordform" select="acdh:get-wordform(.)"/>
    <xsl:variable name="add-space" select="not(matches($wordform, '^[„-]$')) and
        not(following-sibling::*[1]/name() = 'pc') and
        not(matches(following-sibling::tei:w[1]/tei:fs/tei:f[@name='wordform'], '^\W+$')) "/>
        <xsl:sequence select="acdh:word-block(., 'sample', $add-space)"></xsl:sequence>        
</xsl:template>
    
<xsl:function name="acdh:word-block">
    <xsl:param name="w"></xsl:param>
    <xsl:param name="type"></xsl:param>
    <xsl:param name="position"></xsl:param>
    <xsl:variable name="wordform" select="acdh:get-wordform($w)"/>
    <xsl:variable name="add-space" select="not(matches($wordform, '^[„-]$')) and
        not($w/following-sibling::*[1]/name() = 'pc') and
        not(matches($w/following-sibling::tei:w[1]/tei:fs/tei:f[@name='wordform'], '^\W+$')) and
        (not($w/ancestor::tei:choice) or $position != count($w/parent::*/*))"/>
    
    <xsl:choose>
        <xsl:when test="$type='feature'">
            <xsl:sequence select="acdh:word-span($w)"></xsl:sequence>            
        </xsl:when>
        <xsl:otherwise>
            <a class="word-search">
                <xsl:attribute name="href">
                    <xsl:value-of select="'compare-samples.html?word='"/>
                    <xsl:value-of select="$wordform" />
                </xsl:attribute>
                <xsl:sequence select="acdh:word-span($w)"></xsl:sequence>
            </a>       
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$add-space">
        <xsl:value-of select="' '" />
    </xsl:if>
</xsl:function>

<xsl:template match="tei:c">
    <xsl:value-of select="."/>
</xsl:template>
        
<xsl:template match="tei:pc">
    <span class="pc">
        <xsl:if test="./@join = 'right'"><xsl:value-of select="' '" /></xsl:if>
        <xsl:value-of select="."/>
        <xsl:if test="./@join = 'left'"><xsl:value-of select="' '" /></xsl:if>
    </span>
</xsl:template>
    
</xsl:stylesheet>