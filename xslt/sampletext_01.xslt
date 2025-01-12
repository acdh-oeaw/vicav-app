<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">    
    <xsl:include href="sampletexts_common.xslt"/>

    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>
    <xsl:template match="tei:TEI">        
        <div>
            <table class="tbHeader">
                <tr><td><h2><xsl:value-of select="./tei:text/tei:body/tei:head"/></h2></td>
                    <xsl:if test="$tei-link-marker='true'"><td class="tdTeiLink">{teiLink}</td></xsl:if>
                    <td class="tdPrintLink">
                        <a data-print="true" target="_blank" class="aTEIButton">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$print-url"/>
                            </xsl:attribute>
                            Print
                        </a>
                    </td>
                </tr>
            </table>

            <p xml:space="preserve">
            By <i><xsl:value-of select="string-join(//tei:titleStmt/(tei:author,tei:respStmt[tei:resp = 'author']/tei:persName), ',')"/>
            <xsl:if test="./tei:teiHeader/tei:revisionDesc/tei:change"> 
            (revision: <xsl:value-of 
            select="(./tei:teiHeader/tei:revisionDesc[1]/tei:change[1]/@n, replace(subsequence(./tei:teiHeader/tei:revisionDesc/tei:change/@when, 1, 1)[1], 'T.*', ''))[1]" />)
            </xsl:if></i></p>
            <ul id="informants">
            <xsl:for-each select="./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson/tei:person">
                <li xml:space="preserve">Informant ID: 
                    <i><xsl:value-of select="."/></i><xsl:if test="@sex">, Sex: <i><xsl:value-of select="@sex"/></i></xsl:if><xsl:if test="@age">, Age: <i><xsl:value-of select="@age"/></i></xsl:if>
                </li>
            </xsl:for-each>
            </ul>
            
            <xsl:if test="string-length(./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:p[1])&gt;0">
                <xsl:for-each select="./tei:TEIHeader/tei:profileDesc/tei:particDesc/tei:p">
                    <xsl:apply-templates/>
                </xsl:for-each>
                <hr/>
            </xsl:if>

            <xsl:apply-templates select="./tei:text/tei:body/tei:div[@type='sampleText']/tei:p/tei:s"/>
        </div> 
    </xsl:template>
    
    
</xsl:stylesheet>

