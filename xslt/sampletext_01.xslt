<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">    
    <xsl:output method="html"/>
    <xsl:template match="/">        
        <div>                       
            <!-- <div class="h2Profile"> -->
            <table class="tbHeader">
                <tr><td><h2><xsl:value-of select="//tei:head"/></h2></td><td class="tdTeiLink">{teiLink}</td></tr>
            </table>            
            
            <!-- </div> -->
            
            <p>By&#160;<i><xsl:value-of select="//tei:author"/>
                <xsl:if test="//tei:publicationStmt/tei:date">&#160;(<xsl:value-of select="//tei:publicationStmt/tei:date"/>)</xsl:if>
            </i></p>
            
            <xsl:if test="string-length(//tei:teiHeader/tei:profileDesc/tei:particDesc/tei:p[1])&gt;0">
                <xsl:for-each select="//tei:teiHeader/tei:profileDesc/tei:particDesc/tei:p">
                    <xsl:apply-templates/>
                </xsl:for-each>
                <hr/>
            </xsl:if>
            
            <xsl:for-each select="//tei:div[@type='sampleText']/tei:p/tei:s | //tei:div[@type='corpusText']/tei:u">
                <span class="spSentence">
                    <span class="sample-text-tooltip" data-html="true" data-toggle="tooltip" data-placement="top">
                        
                        <xsl:attribute name="title">                    
                            <xsl:variable name="nn" select="@n"/>
                            <xsl:value-of select="//tei:s[@type='translationSentence'][@n=$nn] | //tei:div[@type='dvTranslations']/tei:u[@n=$nn]"/>
                        </xsl:attribute>
                        <i class="fa fa-commenting-o" aria-hidden="true"></i>
                    </span>
                    
                    <xsl:for-each select="tei:w | tei:c | tei:seg | tei:pc">
                        <!-- <span >
                            <xsl:attribute name="onmouseover">omi('')</xsl:attribute>
                            <xsl:attribute name="onmouseout">omo()</xsl:attribute>
                        
                        </span>
                         -->
                        
                        <span class="sample-text-tooltip" data-html="true" data-toggle="tooltip" data-placement="top">
                            <xsl:attribute name="title">
                                <xsl:if test="string-length(tei:fs/tei:f[@name='pos'])&gt;0">&lt;span class="spPos"&gt;POS:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='pos']"/>&lt;br/&gt;</xsl:if>
                                <xsl:if test="string-length(tei:fs/tei:f[@name='lemma'])&gt;0">&lt;span class="spLemma"&gt;Lemma:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='lemma']"/>&lt;br/&gt;</xsl:if>                            
                                <xsl:if test="string-length(tei:fs/tei:f[@name='translation'])&gt;0">&lt;span class="spTrans"&gt;English:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='translation']"/></xsl:if>
                                <xsl:if test="string-length(tei:fs/tei:f[@name='variant'])&gt;0">&lt;span class="spTrans"&gt;Alternative form:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='variant']"/></xsl:if>                                                        
                            </xsl:attribute>
                            <xsl:if test="name()='w'">
                                <xsl:variable name="wordform" select="tei:fs/tei:f[@name='wordform']"/>
                                <xsl:message select="$wordform"></xsl:message>
                                <xsl:choose>
                                    <xsl:when test="not(matches($wordform, '^[„-]$')) and
                                        not(following-sibling::*[1]/name() = 'pc') and
                                        not(matches(following-sibling::tei:w[1]/tei:fs/tei:f[@name='wordform'], '^\W+$'))">
                                        <xsl:value-of select="replace($wordform, '[\s&#160;]+$', '')"/>
                                        <xsl:value-of select="' '" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="replace($wordform, '[\s&#160;]+$', '')"/>
                                    </xsl:otherwise>
                                </xsl:choose> 
                            </xsl:if>
                        </span>
                        
                        <xsl:if test="name()='c'">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        
                        <xsl:if test="name()='seg'">
                            <xsl:value-of select="."/>
                        </xsl:if>               

                        <xsl:if test="name()='pc'">
                            <xsl:if test="./@join = 'right'"><xsl:value-of select="' '" /></xsl:if>
                            <xsl:value-of select="."/>
                            <xsl:if test="./@join = 'left'"><xsl:value-of select="' '" /></xsl:if>
                        </xsl:if>               


                    </xsl:for-each>
                </span>
            </xsl:for-each>
        </div> 
    </xsl:template>
    
    
    
    
</xsl:stylesheet>

