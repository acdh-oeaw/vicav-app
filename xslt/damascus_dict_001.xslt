<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

    <xsl:output method="html"/>
    <xsl:template match="/">
        
        <div>
           <div class="dvStats" id="dvStats">
              <xsl:variable name="recNum"><xsl:value-of select="count(//tei:entry)"/></xsl:variable>              
              <xsl:value-of select="$recNum"/>&#160;hits 
           </div>
            
            <!-- ********************************************* -->
            <!-- ***  ENTRY ********************************** -->
            <!-- ********************************************* -->
            <xsl:for-each select="//tei:entry">
               <xsl:sort select="./tei:form/tei:orth"/>
               <div class="dvRoundLemmaBox_ltr">
                  <xsl:value-of select="tei:form[@type='lemma']/tei:orth[@xml:lang='ar-apc-x-damascus-vicav'] | tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='ar-apc-x-damascus-vicav'] | tei:form[@type='abbrev']/tei:orth[@xml:lang='ar-apc-x-damascus-vicav']"/>
                  <xsl:if test="tei:gramGrp/tei:gram[@type='pos']">
                      <span class="spGramGrp">
                          <xsl:text>&#x2004;</xsl:text>
                          (
                          <xsl:choose>
                             <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='passiveParticiple'">pass. part.</xsl:when>
                             <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='activeParticiple'">act. part.</xsl:when>
                             <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='collectiveNoun'">coll. noun</xsl:when>
                             <xsl:when test="tei:gramGrp/tei:gram[@type='pos']='dualNoun'">dual</xsl:when>
                             <xsl:otherwise><xsl:value-of select="tei:gramGrp/tei:gram[@type='pos']"/></xsl:otherwise>
                          </xsl:choose>  
                         <xsl:if test="tei:gramGrp/tei:gram[@type='gender']='feminine'">; fem.</xsl:if>                         
                         <xsl:if test="tei:gramGrp/tei:gram[@type='subc']">;&#160;&#160;<xsl:value-of select="tei:gramGrp/tei:gram[@type='subc']"/></xsl:if>                         
                         )
                       </span>                                                                 
                  </xsl:if>
                  
                  <!-- ********************************************* -->
                  <!-- ****************  ROOT  ********************* -->
                  <!-- ********************************************* -->
                  <xsl:if test="string-length(./tei:gramGrp/tei:gram[@type='root'])&gt;0 and not(contains(./tei:gramGrp/tei:gram[@type='root'], ' '))">
                     <span class="spRoot">
                        <xsl:if test="not(tei:etym)">&#160;&#160;&#160;&#160;[<xsl:value-of select="./tei:gramGrp/tei:gram[@type='root']"/>]</xsl:if>
                     </span>                         
                  </xsl:if>
               </div>               
               
               <table class="tbEntry">
                  <xsl:for-each select="tei:form[@type='lemma'] | tei:form[@type='multiWordUnit'] ">                                             
                     <!-- ********************************************* -->
                     <!-- ***  VARIANTS OF LEMMA  ********************* -->
                     <!-- ********************************************* -->
                     <xsl:if test="./tei:form[@type='variant']">
                        <tr>
                           <td class="tdHead">Var.</td>
                           <td class="tdKWICMain">
                              <xsl:for-each select="./tei:form[@type='variant']">
                                 <xsl:if test="position()&gt;1">,&#xA0;</xsl:if>
                                 <xsl:if test="tei:orth[@xml:lang='ar-apc-x-damascus-vicav']">                                     
                                    <xsl:value-of select="tei:orth[@xml:lang='ar-apc-x-damascus-vicav']"/>                                         
                                    <xsl:if test="tei:usg"><span class="spGramGrp"><xsl:text>&#xA0;</xsl:text>(<xsl:value-of select="tei:usg"/>)</span></xsl:if>
                                          
                                 </xsl:if>
      
                                 <xsl:if test="tei:bibl">
                                    <span class="spBibl">
                                       &#160;(<xsl:for-each select="tei:bibl"><xsl:if test="position()&gt;1">;<xsl:text>&#xA0;</xsl:text></xsl:if>
                                        <xsl:value-of select="."/>
                                        </xsl:for-each>)
                                     </span>
                                 </xsl:if>
                              </xsl:for-each>
                           </td>
                         </tr>
                     </xsl:if>

                  </xsl:for-each>

                  <!-- ********************************************* -->
                  <!-- ***  ETYMOLOGY ****************************** -->
                  <!-- ********************************************* -->
                  <xsl:if test="string-length(tei:etym)&gt;0">
                     <tr>
                        <td class="tdHead">Etym.</td>
                        <td class="tdKWICMain">
                           <span class="spEtym">
                              <xsl:for-each select="tei:etym">
                                 <xsl:text>&lt;&#160;</xsl:text>
                                 
                                 <xsl:if test="tei:mentioned">
                                    <xsl:value-of select="tei:mentioned"/>
                                 </xsl:if>
                                 
                                 <xsl:if test="tei:lang">
                                    &#160;(<xsl:value-of select="tei:lang"/>)
                                 </xsl:if>
                              </xsl:for-each>
                           </span>
                        </td>                           
                     </tr>                     
                  </xsl:if>

                  <!-- ********************************************* -->
                  <!-- ***  INFLECTED FORMS (Pls, etc.) ************ -->
                  <!-- ********************************************* -->
                  <xsl:if test="string-length(tei:form[@type='inflected']/tei:orth/text())&gt;0">
                     <tr>
                        <td class="tdHead">Inflected</td>
                        <td class="tdKWICMain">
                           <xsl:for-each select="tei:form[@type='inflected']">
                               <xsl:if test="string-length(tei:orth[@xml:lang='ar-apc-x-damascus-vicav'])&gt;0">
                                  <xsl:if test="position()&gt;1">,<xsl:text>&#x2006;</xsl:text></xsl:if>
                                  <xsl:value-of select="tei:orth[@xml:lang='ar-apc-x-damascus-vicav']"/>

                               <!-- ********************************************* -->
                               <!-- ***  ANA attributes   *********************** -->
                               <!-- ********************************************* -->
                               <xsl:if test="@ana">
                                  <span class="spGramGrp"><xsl:text>&#xA0;</xsl:text>                         
                                     <xsl:choose>
                                        <xsl:when test="@ana='#ap_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#ap_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#n_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#n_dual'">[dual]</xsl:when>
                                        <xsl:when test="@ana='#adj_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#n_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#n_unit'">[unit noun]</xsl:when>
                                        <xsl:when test="@ana='#n_unit_pl'">[unit noun plural]</xsl:when>
                                        <xsl:when test="@ana='#n_constructState'">[construct state]</xsl:when>
                                        
                                        
                                        <xsl:when test="@ana='#adj_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#p_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#passiveParticiple'">[pas. part.]</xsl:when>
                                        <xsl:when test="@ana='#activeParticiple'">[act. part.]</xsl:when>
                                        <xsl:when test="@ana='#pp_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#p_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#pp_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#adj_elative'">[elative]</xsl:when>
                                        <xsl:when test="@ana='#v_pres_sg_p3'">[3.sg.pres.]</xsl:when>                                        
                                        
                                        <xsl:otherwise>[<xsl:value-of select="@ana"/>]</xsl:otherwise>
                                     </xsl:choose>
                                   </span>
                               </xsl:if>

                                   <!-- ********************************************* -->
                                   <!-- ***  USG of infl.  ************************** -->
                                   <!-- ********************************************* -->
                                   <xsl:if test="tei:usg">
                                         (<xsl:value-of select="tei:usg"/>)
                                   </xsl:if>
                               </xsl:if>
                           </xsl:for-each>
                        </td>
                     </tr>
                  </xsl:if>
                             
                  <!-- ********************************************* -->
                  <!-- ** SENSES *********************************** -->
                  <!-- ********************************************* -->
                  <xsl:for-each select="tei:sense">
                     <xsl:if test="./tei:def">
                       <tr>
                          <td class="tdHead">Defs.</td>
                          <td class="tdSense">
                             <div class="dvDef">
                                <xsl:for-each select="tei:def[@xml:lang='en'] | tei:def[@lang='en']">
                                   <xsl:if test="string-length(.)&gt;1">                                    
                                      <span class="spTransEn">
                                         <xsl:if test="position()&gt;1">,<xsl:text>&#xA0;</xsl:text></xsl:if>
                                         <xsl:value-of select="."/>
                                      </span>
                                   </xsl:if>
                                </xsl:for-each>   
                                
                                <div class="dvLangSep">
                                   <xsl:for-each select="tei:def[@xml:lang='fr'] | tei:def[@lang='fr']">
                                      <xsl:if test="string-length(.)&gt;1">                                    
                                         <span class="spTransFr">
                                            <xsl:if test="position()&gt;1">,<xsl:text>&#xA0;</xsl:text></xsl:if>
                                            <xsl:value-of select="."/>
                                         </span>
                                      </xsl:if>
                                   </xsl:for-each>   
                                </div>
                                
                                
                                <div class="dvLangSep">
                                      <xsl:for-each select="tei:def[@xml:lang='de'] | tei:def[@lang='de']">
                                       <xsl:if test="string-length(.)&gt;1">                                    
                                          <span class="spTransDe">
                                            <xsl:if test="position()&gt;1">,<xsl:text>&#xA0;</xsl:text></xsl:if>
                                            <xsl:value-of select="."/>
                                         </span>
                                      </xsl:if>
                                   </xsl:for-each>   
                                 </div>
                              </div>     
                          </td>
                       </tr> 
                     </xsl:if>
                     
                     <tr>
                        <td class="tdHead">Sense
                           <xsl:if test="count(tei:sense)&gt;1"><xsl:text>&#xA0;</xsl:text>
                              <xsl:value-of select="position()"/>
                           </xsl:if>
                        </td>
                        <td class="tdSense">
                           <!-- ********************************************* -->
                           <!-- ** ARGUMENTS ******************************** -->
                           <!-- ********************************************* -->
                           <xsl:if test="tei:gramGrp/tei:gram[@type='arguments']">
                              <div class="dvDef">
                                 <xsl:value-of select="parent::tei:form[@type='lemma']/tei:orth[@xml:lang='ar-apc-x-damascus-vicav'] | parent::tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='ar-apc-x-damascus-vicav'] | parent::tei:form[@type='abbrev']/tei:orth[@xml:lang='ar-apc-x-damascus-vicav']"/>
                                 <span class="dvArguments"><xsl:value-of select="tei:gramGrp/tei:gram[@type='arguments']"/></span>
                              </div>   
                           </xsl:if>


                           <div class="dvDef">
                              <xsl:for-each select="tei:cit[@type='translation'][@xml:lang='en']">
                                 <xsl:if test="string-length(.)&gt;1">                                    
                                    <span class="spTransEn">
                                       <xsl:if test="position()&gt;1">,<xsl:text>&#xA0;</xsl:text></xsl:if>
                                       <xsl:value-of select="tei:quote"/>
                                       <xsl:if test="tei:usg"> 
                                          (<xsl:value-of select="tei:usg"/>)
                                       </xsl:if>
                                    </span>
                                 </xsl:if>
                              </xsl:for-each>
                              <!-- ********************************************* -->
                              <!-- ** USG ************************************** -->
                              <!-- ********************************************* -->
                              <xsl:if test="tei:usg[@xml:lang='en']">
                                 <span class="dvUsg">(<xsl:value-of select="tei:usg[@xml:lang='en']"/>)</span>   
                              </xsl:if>
                              
                              <xsl:if test="count(tei:cit[@type='translation'][@xml:lang='de'])&gt;0">
                                 <div class="dvLangSep">
                                    <xsl:for-each select="tei:cit[@type='translation'][@xml:lang='de']">
                                       <xsl:if test="string-length(.)&gt;1">                                       
                                          <span class="spTransDe">
                                             <xsl:if test="position()&gt;1"><xsl:text>,&#x2006;</xsl:text></xsl:if>
                                             <xsl:value-of select="tei:quote"/>
                                             <xsl:if test="tei:usg"> 
                                                (<xsl:value-of select="tei:usg"/>)
                                             </xsl:if>
                                          </span>
                                       </xsl:if>
                                    </xsl:for-each>
                                    <xsl:if test="tei:usg[@xml:lang='de']">
                                       <span class="dvUsg">(<xsl:value-of select="tei:usg[@xml:lang='de']"/>)</span>   
                                    </xsl:if>
                                 </div>  
                              </xsl:if>
                              
                              <xsl:if test="count(tei:cit[@type='translation'][@xml:lang='fr'])&gt;0">
                                 <div class="dvLangSep">
                                    <xsl:for-each select="tei:cit[@type='translation'][@xml:lang='fr']">
                                       <xsl:if test="string-length(.)&gt;1">                                       
                                          <span class="spTransFr">
                                             <xsl:if test="position()&gt;1">,<xsl:text>&#xA0;</xsl:text></xsl:if>
                                             <xsl:value-of select="tei:quote"/>
                                             <xsl:if test="tei:usg"> 
                                                (<xsl:value-of select="tei:usg"/>)
                                             </xsl:if>
                                          </span>
                                       </xsl:if>
                                    </xsl:for-each>
                                    <xsl:if test="tei:usg[@xml:lang='fr']">
                                       <span class="dvUsg">(<xsl:value-of select="tei:usg[@xml:lang='fr']"/>)</span>   
                                    </xsl:if>
                                 </div>   
                              </xsl:if>
                              
                           </div>
                           
                           <xsl:for-each select="tei:cit[@type='example']">
                              <div class="dvExamples">
                                 <xsl:if test="tei:quote[@xml:lang='ar-apc-x-damascus-vicav']">
                                    <xsl:value-of select="tei:quote[@xml:lang='ar-apc-x-damascus-vicav']"/>
                                 </xsl:if>
                                 <xsl:for-each select="tei:cit[@type='translation'][@xml:lang='en']">                                    
                                    <span class="spTransEn"><xsl:text> </xsl:text>
                                       <xsl:value-of select="tei:quote"/>                                            
                                    </span>                                                                        
                                 </xsl:for-each>
                                 <xsl:for-each select="tei:cit[@type='translation'][@xml:lang='de']">                                    
                                    <span class="spTransDe"><xsl:text> </xsl:text>
                                       <xsl:value-of select="tei:quote"/>                                            
                                    </span>                                                                        
                                 </xsl:for-each>
                              </div>
                           </xsl:for-each>
                           
                           <xsl:for-each select="tei:cit[@type='multiWordUnit'][@xml:lang='ar-apc-x-damascus-vicav']">
                              <div class="dvMWUExamples">
                                 <table>
                                    <tr>
                                       <xsl:if test="tei:quote[@xml:lang='ar-apc-x-damascus-vicav']">
                                         <td class="tdNoBorder">
                                            <xsl:value-of select="tei:quote[@xml:lang='ar-apc-x-damascus-vicav']"/>
                                         </td>
                                      </xsl:if>
                                      <td class="tdNoBorder">
                                         <xsl:for-each select="tei:cit[@type='translation']">
                                            <div class="dvDef">
                                              <span class="spTrans">
                                                 <xsl:value-of select="tei:quote[@xml:lang='ar-apc-x-damascus-vicav']"/>
                                                 <xsl:if test="tei:usg"><xsl:text>&#xA0;</xsl:text>
                                                   (<xsl:value-of select="tei:usg"/>)
                                                 </xsl:if>
                                              </span>
                                            </div>
                                         </xsl:for-each>
                                      </td>
                                   </tr>
                                </table>
                             </div>
                           </xsl:for-each>
                           
                           <xsl:for-each select="tei:entry[@type='example']">
                              <div class="dvMWUExamples">
                                 <table>
                                     <tr>
                                        <xsl:if test="tei:form/tei:orth[@xml:lang='ar-apc-x-damascus-vicav']">
                                           <td class="tdNoBorder">
                                              <xsl:value-of select="tei:form/tei:orth[@xml:lang='ar-apc-x-damascus-vicav']"/>
                                           </td>
                                        </xsl:if>

                                        <td class="tdNoBorder">
                                           <xsl:for-each select="tei:sense">
                                                <div class="dvDef">
                                                   <span class="spTrans">
                                                      <xsl:value-of select="tei:cit/tei:quote[@xml:lang='ar-apc-x-damascus-vicav']"/>

                                                      <xsl:if test="tei:usg"> 
                                                         (<xsl:value-of select="tei:usg"/>)
                                                      </xsl:if>
                                                   </span>
                                                </div>
                                             </xsl:for-each>
                                        </td>
                                     </tr>
                                 </table>
                              </div>
                           </xsl:for-each>

                        </td>
                     </tr>
                                      
               </xsl:for-each>
               
                  <!-- ********************************************* -->
                  <!-- ***** BIBL ********************************** -->
                  <!-- ********************************************* -->
                  <xsl:if test="tei:form[@type='lemma']/tei:bibl | tei:form[@type='multiWordUnit']/tei:bibl">
                     <tr width="200px">
                        <td class="tdHead">Refs.</td>
                        <td class="tdKWICMain">
                           <span class="spBibl" alt="References">
                              <xsl:for-each select="tei:form[@type='lemma']/tei:bibl | tei:form[@type='multiWordUnit']/tei:bibl">
                                 <xsl:if test="position()&gt;1">;<xsl:text>&#x2006;</xsl:text></xsl:if>
                                 <xsl:value-of select="."/>
                              </xsl:for-each>
                           </span>
                        </td>   
                     </tr>
                  </xsl:if>
                  
               <!-- ********************************************* -->
               <!-- ** EDITORS ********************************** -->
               <!-- ********************************************* -->
               <tr>
                 <td class="tdHead">Editors</td>
                  <td class="tdKWICMain">
                    <span class="spEditors" alt="Editors">
                       <xsl:for-each select="//ed">
                          <xsl:sort select="."/>
                          <xsl:if test="position()&gt;1">,<xsl:text>&#x2006;</xsl:text></xsl:if>
                          <xsl:choose>
                             <xsl:when test=".='stephan'">S.&#xA0;Procházka</xsl:when>
                             <xsl:when test=".='inesd'">I.&#xA0;Dallaji</xsl:when>
                             <xsl:when test=".='inesg'">I.&#xA0;Gabsi</xsl:when>
                             <xsl:when test=".='gisela'">G.&#xA0;Kitzler</xsl:when>
                             <xsl:when test=".='ines2'">I.&#xA0;Ben Brahim</xsl:when>
                             <xsl:when test=".='omar1'">O.&#xA0;Siam</xsl:when>
                             <xsl:when test=".='bettina'">B.&#xA0;Leitner</xsl:when>
                             <xsl:when test=".='charly'">K.&#xA0;Moerth</xsl:when>
                             <xsl:when test=".='veronika'">V.&#xA0;Ritt-Benmimoun</xsl:when>
                             <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                         </xsl:choose>
                       </xsl:for-each>
                    </span>
                 </td>
               </tr>
                  
            </table>
            </xsl:for-each>
         </div>
      
    </xsl:template>
</xsl:stylesheet>
