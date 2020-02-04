<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:param name="highLightIdentifier"></xsl:param>
    <xsl:param name="explanation"></xsl:param>
    
    <!-- <xsl:output method="xml" encoding="utf-8"/> -->
    <xsl:output method="html" encoding="utf-8"/>
    <!-- <xsl:strip-space elements="tei:cell"/> -->
    <!-- VERSION 3.1.4 -->
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>
    <xsl:template match="/">
        <!-- 
        <html>
            <head>
                <META http-equiv="Content-Type" content="text/html; charset=utf-8"></META></head>
            <body> -->
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
            
            <div>
                <table class="tbHeader">
                    <tr><td>
                        <h2 xml:space="preserve">Compare samples: <i>
                            <xsl:value-of select="string-join(distinct-values(./items//item/@city), ', ')"/></i></h2></td>
                        <!-- TEI deaktivated for the time being, problem with mixed xml.space -->
                        <!-- 
                        <td class="tdTeiLink"><a class='aTEIButton'>
                            <xsl:attribute name="href">javascript:showLingFeatures("==teiFuncID==","==teiFuncLabel==", "tei")</xsl:attribute>
                            TEI</a></td>  -->
                    </tr>
                </table>    
                
                
                <xsl:variable name="root" select="."/>
                <xsl:for-each select="distinct-values(//items//tei:s/@n)">
                    <xsl:variable name="sentence" select="."/>
                    <h3><xsl:value-of select="$sentence"/></h3>
                    <table class="tbFeatures">
                        <xsl:for-each select="$root/items//item">
                            <xsl:sort select="@city"/>
                            <tr>
                                <td class="tdFeaturesHeadRight"><xsl:value-of select="@city"/>
                                <small>
                                <xsl:if test="./@informant != ''"> (<xsl:value-of select="./@informant"/><xsl:if test="./@sex != ''">/<xsl:value-of select="@sex"/></xsl:if><xsl:if test="@age != ''">/<xsl:value-of select="@age"/></xsl:if>)</xsl:if></small>
                            </td>
                                <td class="tdFeaturesRightTarget">
                                    <xsl:apply-templates select=".//tei:div[@type='sampleText']//tei:s[@n=$sentence]"/>
                                </td>
                            </tr>                       
                        </xsl:for-each>
                    </table>
                    <br/>
                </xsl:for-each>
                    
            </div>         
        </div>
        <!--             </body>        </html> -->
    </xsl:template>
    
    <xsl:template match="tei:fs"><xsl:value-of select="."/></xsl:template>
    <xsl:template match="tei:head"></xsl:template>
    <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
    <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
    <xsl:template match="tei:p"></xsl:template>

            
<xsl:template match="//tei:div[@type='sampleText']/tei:p/tei:s | //tei:div[@type='corpusText']/tei:u">
<span class="spSentence">
    <span class="sample-text-tooltip" data-html="true" data-toggle="tooltip" data-placement="top">
        <xsl:attribute name="title">                    
            <xsl:variable name="nn" select="@n"/>
            <xsl:value-of select="//tei:s[@type='translationSentence'][@n=$nn] | //tei:div[@type='dvTranslations']/tei:u[@n=$nn]"/>
        </xsl:attribute>
        <i class="fa fa-commenting-o" aria-hidden="true"></i>
    </span>
    <xsl:value-of select="' '" />
    <xsl:for-each select="tei:w | tei:c | tei:seg | tei:pc">
        <!-- <span >
            <xsl:attribute name="onmouseover">omi('')</xsl:attribute>
            <xsl:attribute name="onmouseout">omo()</xsl:attribute>
        
        </span>
         -->
        
        <span class="sample-text-tooltip" data-html="true" data-toggle="tooltip" data-placement="top">
            <xsl:attribute name="data-toggle">
                <xsl:choose>
                <xsl:when test="string-length(tei:fs/tei:f[@name='pos'])>0 or string-length(tei:fs/tei:f[@name='lemma'])>0 or string-length(tei:fs/tei:f[@name='translation'])>0 or string-length(./tei:fs/tei:f[@name='variant'])>0 or string-length(tei:fs/tei:f[@name='comment'])>0">tooltip</xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:if test="string-length(tei:fs/tei:f[@name='pos'])&gt;0">&lt;span class="spPos"&gt;POS:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='pos']"/>&lt;br/&gt;</xsl:if>
                <xsl:if test="string-length(tei:fs/tei:f[@name='lemma'])&gt;0">&lt;span class="spLemma"&gt;Lemma:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='lemma']"/>&lt;br/&gt;</xsl:if>                            
                <xsl:if test="string-length(tei:fs/tei:f[@name='translation'])&gt;0">&lt;span class="spTrans"&gt;English:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='translation']"/></xsl:if>
                <xsl:if test="string-length(tei:fs/tei:f[@name='variant'])&gt;0">&lt;span class="spTrans"&gt;Alternative form:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='variant']"/></xsl:if>                                                        
                <xsl:if test="string-length(tei:fs/tei:f[@name='comment'])&gt;0">&lt;span class="spTrans"&gt;Note:&lt;/span&gt;&#160;<xsl:value-of select="tei:fs/tei:f[@name='comment']"/></xsl:if>                                                        
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
</xsl:template>


</xsl:stylesheet>
