<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

   <xsl:output method="xml" encoding="utf-8"/>
   <xsl:preserve-space elements="*"/>
   <xsl:template match="/">
      <div>
         <div>            
            <table class="tbHeader">
               <tr><td><h2><xsl:value-of select="//tei:table[1]/tei:row[1]/tei:cell[2]"/></h2></td><td class="tdTeiLink">{teiLink}</td></tr>
            </table>            
            
            
            <p>By&#160;&#160;<i><xsl:value-of select="//tei:table[1]/tei:row[2]/tei:cell[2]"/>&#160;(<xsl:value-of select="//tei:table[1]/tei:row[3]/tei:cell[2]"/>)</i></p>
         </div>
         
         <div>
            
            <!-- ********************************************* -->
            <!-- *** EXPORT: HTML 2 DOC ********************** -->
            <!-- ********************************************* -->
            <!--  
            <table class="tbProfile">
               <xsl:for-each select="//tei:div[@type = 'feature']">
                  <tr>
                     <td><h3><xsl:value-of select="tei:head"/></h3></td>
                  </tr>
                  <xsl:for-each select="tei:table/tei:row">
                     <tr>
                        <td class="tdFeaturesLeft"><xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/></td>
                        <td class="tdFeaturesRight"><xsl:copy-of select="tei:cell[@rend = 'tdCom']"/></td>
                        <td class="tdFeaturesRight"><xsl:apply-templates select="tei:cell[@rend = 'tdRight']/tei:cit/tei:cit[@type = 'translation'][@xml:lang='en']"/></td>
                        <td class="tdFeaturesRight"><xsl:apply-templates select="tei:cell[@rend = 'tdRight']/tei:cit[@type = 'example']/tei:quote[1]"/></td>
                        <td class="tdFeaturesRight"><xsl:value-of select="tei:cell[@rend = 'tdRight']/tei:cit/@corresp"/></td>
                      </tr>
                   </xsl:for-each>
               </xsl:for-each>
            </table>
            -->
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
   
               <div>
                  <table class="tbFeatures">
                     <xsl:for-each select="//tei:table[2]/tei:row">
                        <xsl:choose>
                           <!-- ******************************************************* -->
                           <!-- HEADER LINE ******************************************* -->
                           <!-- ******************************************************* -->
                           <xsl:when test="(string-length(tei:cell[@rend = 'tdRight']) = 0) and (string-length(tei:cell[@rend = 'tdCentre']) = 0)">
                              <tr>
                                 <td colspan="2" class="tdFeaturesHead"><xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/></td>
                              </tr>
                           </xsl:when>
                           
                           <xsl:when test="string-length(tei:cell[@rend = 'tdCom']) &gt; 0">
                              <tr>
                                 <td class="tdFeaturesLeft" rowspan="3">
                                    <xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/>
                                 </td>
                                 <td class="tdFeaturesCom">
                                    <xsl:apply-templates select="tei:cell[@rend = 'tdCom']"/>
                                 </td>
                              </tr>
                              <tr>
                                 <td class="tdFeaturesRightSource">
                                    <xsl:apply-templates select="tei:cell[@rend = 'tdCentre']"/>
                                 </td>
                              </tr>
                              <tr>
                                 <td class="tdFeaturesRightTarget">
                                    <xsl:apply-templates select="tei:cell[@rend = 'tdRight']"/>
                                 </td>
                              </tr>
                           </xsl:when>
                           <xsl:otherwise>
                              <tr>
                                 <td class="tdFeaturesLeft" rowspan="2">
                                    <xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/>
                                 </td>
                                 <td class="tdFeaturesRightSource">
                                    <xsl:apply-templates select="tei:cell[@rend = 'tdCentre']"/>
                                 </td>
                              </tr>
                              <tr>
                                 <td class="tdFeaturesRightTarget">
                                    <xsl:apply-templates select="tei:cell[@rend = 'tdRight']"/>&#160;
                                 </td>
                              </tr>
                           </xsl:otherwise>
                        </xsl:choose>
   
                     </xsl:for-each>
                  </table>
               </div>         
         </div>
      </div>
   </xsl:template>
   
   <xsl:template match="tei:fs"></xsl:template>
   <xsl:template match="tei:head"><h2><xsl:apply-templates/></h2></xsl:template>
   <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
   <xsl:template match="tei:hi[@rend = 'bold']"><b><xsl:apply-templates/></b></xsl:template>
   <xsl:template match="tei:hi[@rend = 'red']"><span style="color:red"><xsl:apply-templates/></span></xsl:template>
   <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
   
   <!-- 
   <xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
   <xsl:template match="tei:row">
      <tr><xsl:apply-templates/></tr></xsl:template>
   <xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
   <xsl:template match="tei:w"><span><xsl:apply-templates/></span></xsl:template>
    -->
</xsl:stylesheet>
