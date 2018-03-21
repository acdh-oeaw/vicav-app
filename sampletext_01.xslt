<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml" 
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   version="2.0">
   
    <xsl:output method="html"/>
    <xsl:template match="/">
                       
        <div class="h2Profile"><xsl:value-of select="//tei:head"/></div>
        
        <xsl:for-each select="//tei:s">
            <xsl:for-each select="tei:w | tei:c">
                <!-- <span >
                    <xsl:attribute name="onmouseover">omi('')</xsl:attribute>
                    <xsl:attribute name="onmouseout">omo()</xsl:attribute>
                    
                </span>
                 -->
                
                <span class="sample-text-tooltip" data-toggle="tooltip" data-placement="top" title="">
                    <xsl:attribute name="title">
                        <span>
                            POS: <xsl:value-of select="tei:fs/tei:f[@name='pos']"/><br/>
                            Lemma: <xsl:value-of select="tei:fs/tei:f[@name='lemma']"/><br/>
                            English: <xsl:value-of select="tei:fs/tei:f[@name='translation']"/></span>
                    </xsl:attribute>
                    <xsl:if test="name()='w'"><xsl:value-of select="tei:fs/tei:f[@name='wordform']"/></xsl:if>
                </span>
                <xsl:if test="name()='c'"><xsl:value-of select="."/></xsl:if>               
            </xsl:for-each>
            <br/>
        </xsl:for-each>
        
    </xsl:template>
    
    
</xsl:stylesheet>

