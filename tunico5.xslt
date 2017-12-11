<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

    <xsl:output method="html"/>
    <xsl:template match="/">
        
        <div>
           <div class="dvStats">
              <xsl:variable name="recNum"><xsl:value-of select="count(//tei:entry)"/></xsl:variable>
              <xsl:value-of select="$recNum"/><xsl:text> </xsl:text> 
              <xsl:choose>
                 <xsl:when test="$recNum=0">records. Try to add .* to your query.</xsl:when>
                 <xsl:when test="$recNum=1">record</xsl:when>
                 <xsl:otherwise>records</xsl:otherwise>
              </xsl:choose>
           </div>
            
            <!-- ********************************************* -->
            <!-- ***  ENTRY ********************************** -->
            <!-- ********************************************* -->
            <xsl:for-each select="//tei:entry">
               <xsl:sort select="./tei:form/tei:orth"/>
               <div class="dvRoundLemmaBox_ltr">
                  <xsl:value-of select="tei:form[@type='lemma']/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav'] | tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav'] | tei:form[@type='abbrev']/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']"/>
                  <xsl:if test="tei:gramGrp/tei:gram[@type='pos']">
                      <span class="spGramGrp">
                          <xsl:text> </xsl:text>
                          (<xsl:value-of select="tei:gramGrp/tei:gram[@type='pos']"/>)
                       </span>                                                                 
                  </xsl:if>
               </div>               
               
               <table class="tbEntry">
                  <xsl:for-each select="tei:form[@type='lemma'] | tei:form[@type='multiWordUnit'] ">
                        
                     <xsl:if test="tei:bibl">
                        <tr width="200px">
                           <td class="tdHead">Refs.</td>
                           <td>
                              <span class="spBibl" alt="References">
                                 <xsl:for-each select="tei:bibl">
                                    <xsl:if test="position()&gt;1">;<xsl:text> </xsl:text></xsl:if>
                                    <xsl:value-of select="."/>
                                 </xsl:for-each>
                              </span>
                           </td>   
                        </tr>
                     </xsl:if>
                     
                     <!-- ********************************************* -->
                     <!-- ***  VARIANTS OF LEMMA  ********************* -->
                     <!-- ********************************************* -->
                     <xsl:for-each select="tei:form[@type='variant']">
                        <tr>
                           <td class="tdHead">Var.</td>
                           <td>
                              <xsl:if test="tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']">                                     
                                 <xsl:value-of select="tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']"/>                                         
                                 <xsl:if test="tei:usg"><span class="spGramGrp"><xsl:text> </xsl:text>(<xsl:value-of select="tei:usg"/>)</span></xsl:if>
                                       
                              </xsl:if>

                              <xsl:if test="tei:bibl">
                                 <span class="spBibl">
                                    (<xsl:for-each select="tei:bibl"><xsl:if test="position()&gt;1">;<xsl:text> </xsl:text></xsl:if>
                                     <xsl:value-of select="."/>
                                     </xsl:for-each>)
                                  </span>
                              </xsl:if>
                           </td>
                         </tr>
                      </xsl:for-each>

                  </xsl:for-each>

                  <!-- ********************************************* -->
                  <!-- ***  ETYMOLOGY ****************************** -->
                  <!-- ********************************************* -->
                  <xsl:if test="string-length(tei:etym)&gt;0">
                     <tr>
                        <td class="tdHead">Etym.</td>
                        <td>
                           <span class="spEtym">
                              <xsl:for-each select="tei:etym">
                                 <xsl:text>&lt; </xsl:text>
                                 
                                 <xsl:if test="tei:mentioned">
                                    <xsl:value-of select="tei:mentioned"/>
                                 </xsl:if>
                                 
                                 <xsl:if test="tei:lang">
                                     (<xsl:value-of select="tei:lang"/>)
                                 </xsl:if>
                              </xsl:for-each>
                           </span>
                        </td>                           
                     </tr>                     
                  </xsl:if>
                  <!-- ********************************************* -->
                  <!-- ***  INFLECTED FORMS (Pls, etc.) ************ -->
                  <!-- ********************************************* -->
                  <xsl:if test="string-length(tei:form[@type='inflected'])&gt;0">
                     <tr>
                        <td class="tdHead">Inflected</td>
                        <td>
                           <xsl:for-each select="tei:form[@type='inflected']">
                               <xsl:if test="string-length(tei:orth[@xml:lang='ar-aeb-x-tunis-vicav'])&gt;0">
                                  <xsl:if test="position()&gt;1">,<xsl:text> </xsl:text></xsl:if>
                                  <xsl:value-of select="tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']"/>

                               <!-- ********************************************* -->
                               <!-- ***  ANA attributes   *********************** -->
                               <!-- ********************************************* -->
                               <xsl:if test="@ana">
                                  <span class="spGramGrp"><xsl:text> </xsl:text>                         
                                     <xsl:choose>
                                        <xsl:when test="@ana='#ap_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#ap_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#n_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#n_dual'">[dual]</xsl:when>
                                        <xsl:when test="@ana='#adj_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#n_f'">[feminine]</xsl:when>
                                        <xsl:when test="@ana='#n_unit'">[unit noun]</xsl:when>
                                        <xsl:when test="@ana='#n_unit_pl'">[unit noun plural]</xsl:when>
                                        
                                        <xsl:when test="@ana='#adj_pl'">[plural]</xsl:when>
                                        <xsl:when test="@ana='#p_f'">[feminine]</xsl:when>
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
                          <td class="tdSenseHead">Defs.</td>
                          <td class="tdSense">
                             <div class="dvDef">
                                <xsl:for-each select="tei:def[@xml:lang='en'] | tei:def[@lang='en']">
                                   <xsl:if test="string-length(.)&gt;1">                                    
                                      <span class="spTransEn">
                                         <xsl:if test="position()&gt;1">,<xsl:text> </xsl:text></xsl:if>
                                         <xsl:value-of select="."/>
                                      </span>
                                   </xsl:if>
                                </xsl:for-each>   
                                
                                <div class="dvLangSep">
                                   <xsl:for-each select="tei:def[@xml:lang='fr'] | tei:def[@lang='fr']">
                                      <xsl:if test="string-length(.)&gt;1">                                    
                                         <span class="spTransFr">
                                            <xsl:if test="position()&gt;1">,<xsl:text> </xsl:text></xsl:if>
                                            <xsl:value-of select="."/>
                                         </span>
                                      </xsl:if>
                                   </xsl:for-each>   
                                </div>
                                
                                
                                <div class="dvLangSep">
                                      <xsl:for-each select="tei:def[@xml:lang='de'] | tei:def[@lang='de']">
                                       <xsl:if test="string-length(.)&gt;1">                                    
                                          <span class="spTransDe">
                                            <xsl:if test="position()&gt;1">,<xsl:text> </xsl:text></xsl:if>
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
                        <td class="tdSenseHead">Sense
                           <xsl:if test="count(tei:sense)&gt;1"><xsl:text> </xsl:text>
                              <xsl:value-of select="position()"/>
                           </xsl:if>
                        </td>
                        <td class="tdSense">
                           <!-- ********************************************* -->
                           <!-- ** ARGUMENTS ******************************** -->
                           <!-- ********************************************* -->
                           <xsl:if test="tei:gramGrp/tei:gram[@type='arguments']">
                              <div class="dvDef">
                                 <xsl:value-of select="parent::tei:form[@type='lemma']/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav'] | parent::tei:form[@type='multiWordUnit']/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav'] | parent::tei:form[@type='abbrev']/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']"/>
                                 <span class="dvArguments"><xsl:value-of select="tei:gramGrp/tei:gram[@type='arguments']"/></span>
                              </div>   
                           </xsl:if>


                           <div class="dvDef">
                              <xsl:for-each select="tei:cit[@type='translation'][@xml:lang='en']">
                                 <xsl:if test="string-length(.)&gt;1">                                    
                                    <span class="spTransEn">
                                       <xsl:if test="position()&gt;1">,<xsl:text> </xsl:text></xsl:if>
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
                                             <xsl:if test="position()&gt;1"><xsl:text>, </xsl:text></xsl:if>
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
                                             <xsl:if test="position()&gt;1">,<xsl:text> </xsl:text></xsl:if>
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
                                 <xsl:if test="tei:quote[@xml:lang='ar-aeb-x-tunis-vicav']">
                                    <xsl:value-of select="tei:quote[@xml:lang='ar-aeb-x-tunis-vicav']"/>
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
                           
                           <xsl:for-each select="tei:cit[@type='multiWordUnit'][@xml:lang='ar-aeb-x-tunis-vicav']">
                              <div class="dvMWUExamples">
                                 <table>
                                    <tr>
                                       <xsl:if test="tei:quote[@xml:lang='ar-aeb-x-tunis-vicav']">
                                         <td class="tdNoBorder">
                                            <xsl:value-of select="tei:quote[@xml:lang='ar-aeb-x-tunis-vicav']"/>
                                         </td>
                                      </xsl:if>
                                      <td class="tdNoBorder">
                                         <xsl:for-each select="tei:cit[@type='translation']">
                                            <div class="dvDef">
                                              <span class="spTrans">
                                                 <xsl:value-of select="tei:quote[@xml:lang='ar-aeb-x-tunis-vicav']"/>
                                                 <xsl:if test="tei:usg"><xsl:text> </xsl:text>
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
                                        <xsl:if test="tei:form/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']">
                                           <td class="tdNoBorder">
                                              <xsl:value-of select="tei:form/tei:orth[@xml:lang='ar-aeb-x-tunis-vicav']"/>
                                           </td>
                                        </xsl:if>

                                        <td class="tdNoBorder">
                                           <xsl:for-each select="tei:sense">
                                                <div class="dvDef">
                                                   <span class="spTrans">
                                                      <xsl:value-of select="tei:cit/tei:quote[@xml:lang='ar-aeb-x-tunis-vicav']"/>

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
               
               <!-- 
                 <tr>
                 <td class="tdSenseHead">Editors</td>
                 <td>
                    <span class="spEditors" alt="Editors">
                       <xsl:for-each select="//ed">
                          <xsl:sort select="."/>
                          <xsl:if test="position()&gt;1">,<xsl:text>&#x2006;</xsl:text></xsl:if>
                          <xsl:choose>
                             <xsl:when test=".='Anton'">A.&#xA0;Anton</xsl:when>
                             <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                         </xsl:choose>
                       </xsl:for-each>
                    </span>
                 </td>
               </tr>
                -->
            </table>
            </xsl:for-each>
         </div>
      
    </xsl:template>
</xsl:stylesheet>