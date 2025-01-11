<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">    
    <xsl:include href="sampletexts_common.xslt"/>

    <xsl:param name="assetsBaseURIpattern" />
    <xsl:param name="assetsBaseURIto" />

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

            <p xml:space="preserve">By <i><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/><xsl:if test="./tei:teiHeader/tei:revisionDesc/tei:change"> (revision: <xsl:value-of select="(./tei:teiHeader/tei:revisionDesc/tei:change[1]/@n, replace(./tei:teiHeader/tei:revisionDesc/tei:change[1]/@when, 'T.*', ''))[1]" />)</xsl:if></i></p>
            <ul id="informants">
            <xsl:for-each select="./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person">
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

            <xsl:if test="./tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/tei:media[@type='distributionFile']">
                <a class="play mt-1"
						>
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
                        <span class="hidden">Play recording</span></a
					>
                <audio hidden="hidden">
                    <source>
                    <xsl:attribute name="src">
                        <xsl:value-of select="replace(
                        replace(tei:teiHeader//tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/
                        tei:media[@type='distributionFile'][1]/@url, 'assets:', ''), 
                        $assetsBaseURIpattern, 
                        $assetsBaseURIto)" />
                    </xsl:attribute>
                    </source>
                </audio>                
            </xsl:if>
            <xsl:apply-templates select="./tei:text/tei:body/tei:div[@type='sampleText']/tei:p/tei:s"/>
        </div> 
    </xsl:template>
    
    <sourceDesc>
               <recordingStmt sameAs="corpus:ouledslema6_m_40_st_recordingStmt">
                  <recording dur-iso="PT121.0S" type="audio">
                     <date when="2020-07-28"/>
                     <respStmt>
                        <resp>recording</resp>
                        <persName ref="corpus:RT"/>
                     </respStmt>
                     <media url="arche:OuledSlema6m40_ST_Samah.mp3" mimeType="audio/mp3" type="master" xml:id="ouledslema6_m_40_st-master">
                        <desc>The informant has agreed to the publication of the audio recording.</desc>
                     </media>
                     <media url="assets:OuledSlema6m40_ST_Samah.mp3" decls="corpus:ouledslema6_m_40_st-free" mimeType="audio/mp3" type="distributionFile" xml:id="ouledslema6_m_40_st-dist">
                        <desc>This is the compressed distribution copy of the recording for production use.</desc>
                     </media>
                  </recording>
               </recordingStmt>
            </sourceDesc>
    
</xsl:stylesheet>

