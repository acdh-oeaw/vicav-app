<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">    
    <xsl:include href="sampletexts_common.xslt"/>

    <xsl:param name="assetsBaseURIpattern" />
    <xsl:param name="assetsBaseURIto" />

    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements=""/>
    
    <xsl:template match="tei:TEI">        
        <xsl:variable name="authors" select="descendant::tei:titleStmt/(tei:author|tei:respStmt[tei:resp = 'author']/tei:persName)" as="element()*"/>
        <xsl:variable name="majorRevisions" select="descendant::tei:revisionDesc/tei:change[@type='major']" as="element(tei:change)*"/>
        <xsl:variable name="lastRevision" select="$majorRevisions[@when = max($majorRevisions/@when/xs:dateTime(.))][last()]"/>
        
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

            <p><xsl:text xml:space="preserve">By </xsl:text><i>
                <xsl:for-each select="$authors">
                    <xsl:choose xml:space="default">
                        <xsl:when test="position() gt 1 and . is $authors[last()]" xml:space="preserve"> and </xsl:when>
                        <xsl:when test="position() gt 1  and not(. is $authors[last()])" xml:space="preserve">, </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select=". "/>
                </xsl:for-each>
                <xsl:if test="$lastRevision" xml:space="preserve"> (revision: <xsl:value-of 
            select="($lastRevision/format-dateTime(@when,'[Y0000]-[M00]-[D00]'), replace($lastRevision, 'T.*', ''))[1]" />)
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

            <xsl:if test="./tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/tei:media[@type='distributionFile']">
                <a class="play m-2 flex cursor-pointer">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4 self-center"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
                    <span>Play recording</span>
                </a>
                <a class="stop m-2 flex hidden cursor-pointer">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4 self-center"><rect x="14" y="4" width="4" height="16" rx="1"/><rect x="6" y="4" width="4" height="16" rx="1"/></svg>
                    <span>Stop recording</span>
                </a>
                <audio hidden="hidden">
                    <source>
                    <xsl:attribute name="src">
                        <xsl:value-of select="replace(
                            substring-after(
                                ./tei:teiHeader/tei:fileDesc/tei:sourceDesc/
                                tei:recordingStmt/tei:recording/tei:media
                                [@type='distributionFile'][1]/@url, ':'),
                            $assetsBaseURIpattern, 
                            $assetsBaseURIto)" />
                    </xsl:attribute>
                    </source>
                </audio>                
            </xsl:if>
            <xsl:apply-templates select="./tei:text/tei:body/tei:div[@type='sampleText']/tei:p/tei:s"/>
        </div> 
    </xsl:template>
</xsl:stylesheet>

