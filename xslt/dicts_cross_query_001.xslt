<xsl:stylesheet xml:space="preserve" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">
   <xsl:output method="html"/>
   <xsl:template match="/">
      <div>
         <xsl:variable name="recNum"><xsl:value-of select="count(//tei:entry)"/></xsl:variable>
         <div class="dvStats" id="dvStats"><xsl:value-of select="$recNum"/><xsl:text> </xsl:text>hits
         </div>

         <!-- ********************************************* -->
         <!-- ***  ENTRY ********************************** -->
         <!-- ********************************************* -->
         <table>
            <xsl:for-each select="//tei:entry">
               <xsl:sort select="./tei:form/tei:orth/@xml:lang"/>
               <xsl:sort select="./tei:form/tei:orth"/>
               <tr>
                   <xsl:choose>
                      <xsl:when test="./tei:form/tei:orth/@xml:lang='ar-aeb'"><td class="tdCrossResultsLocation tdCrossResultsLocation_tunis">Tunis</td></xsl:when>
                      <xsl:when test="./tei:form/tei:orth/@xml:lang='ar-acm-x-baghdad-vicav'"><td class="tdCrossResultsLocation tdCrossResultsLocation_baghdad">Baghdad</td></xsl:when>
                      <xsl:when test="./tei:form/tei:orth/@xml:lang='ar-arz-x-cairo-vicav'"><td class="tdCrossResultsLocation tdCrossResultsLocation_cairo">Cairo</td></xsl:when>
                      <xsl:when test="./tei:form/tei:orth/@xml:lang='ar-apc-x-damascus-vicav'"><td class="tdCrossResultsLocation tdCrossResultsLocation_damascus">Damascus</td></xsl:when>
                      <xsl:when test="./tei:form/tei:orth/@xml:lang='ar'"><td class="tdCrossResultsLocation tdCrossResultsLocation_msa">MSA</td></xsl:when>
                   </xsl:choose>

                  <td class="tdCrossResultsLemma">
                     <i><xsl:value-of select="./tei:form/tei:orth[1]"/></i>
                     <!-- ********************************************* -->
                     <!-- ****************  ROOT  ********************* -->
                     <!-- ********************************************* -->
                     <xsl:if test="string-length(./tei:gramGrp/tei:gram[@type='root'])&gt;0 and not(contains(./tei:gramGrp/tei:gram[@type='root'], ' '))">
                        <span class="spRoot">
                           <xsl:if test="not(tei:etym)">    [<xsl:value-of select="./tei:gramGrp/tei:gram[@type='root']"/>]</xsl:if>
                        </span>
                     </xsl:if>

                     <xsl:if test="tei:gramGrp/tei:gram[@type='pos']">
                        <span class="spGramGrp">
                           <xsl:text> </xsl:text>
                           (
                           <xsl:choose>
                              <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='passiveParticiple'">pass. part.</xsl:when>
                              <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='activeParticiple'">act. part.</xsl:when>
                              <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='collectiveNoun'">coll. noun</xsl:when>
                              <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='dualNoun'">dual</xsl:when>
                              <xsl:otherwise><xsl:value-of select="tei:gramGrp/tei:gram[@type='pos']"/></xsl:otherwise>
                           </xsl:choose>
                           <xsl:if test="tei:gramGrp/tei:gram[@type='gender']='feminine'">; fem.</xsl:if>
                           <xsl:if test="tei:gramGrp/tei:gram[@type='subc']">;  <xsl:value-of select="tei:gramGrp/tei:gram[@type='subc']"/></xsl:if>
                           )
                        </span>
                     </xsl:if>
                     <xsl:text>   </xsl:text><a><xsl:attribute name="href">javascript:getDBSnippet("dictID:<xsl:value-of select="@xml:id"/>,<xsl:value-of select="./tei:form/tei:orth/@xml:lang"/>")</xsl:attribute>
                        Details</a>
                  </td>
               </tr>
            </xsl:for-each>
         </table>
      </div>
   </xsl:template>
</xsl:stylesheet>
