<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

   <xsl:output method="xml" encoding="utf-8"/>
   <xsl:preserve-space elements="*"/>
   <xsl:template match="/">
      <div>
         <xsl:apply-templates select="//tei:div[@type='intro']"/>   
      </div>
      
      <div>
         <!-- ********************************************* -->
         <!-- ***  **************************************** -->
         <!-- ********************************************* -->
         <xsl:for-each select="//tei:div[@type = 'feature']">
            <div>
               <h3>
                  <xsl:value-of select="tei:head"/>
               </h3>
               <table class="tbProfile">
                  <xsl:for-each select="tei:table/tei:row">

                     <xsl:choose>
                        <xsl:when test="string-length(tei:cell[@rend = 'tdCom']) &gt; 0">
                           <tr>
                              <td class="tdFeaturesLeft" rowspan="3">
                                 <xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/>
                              </td>
                              <td class="tdFeaturesRight">
                                 <xsl:apply-templates select="tei:cell[@rend = 'tdCom']"/>
                              </td>
                           </tr>
                           <tr>
                              <td class="tdFeaturesRight">
                                 <xsl:apply-templates select="tei:cell[@rend = 'tdRight']/tei:cit/tei:cit[@type = 'translation'][@xml:lang='en']"/>
                              </td>
                           </tr>
                           <tr>
                              <td class="tdFeaturesRight">
                                 <xsl:apply-templates select="tei:cell[@rend = 'tdRight']/tei:cit[@type = 'example']/tei:quote[1]"/>
                              </td>
                           </tr>
                        </xsl:when>
                        <xsl:otherwise>
                           <tr>
                              <td class="tdFeaturesLeft" rowspan="2">
                                 <xsl:copy-of select="tei:cell[@rend = 'tdLeft']"/>
                              </td>
                              <td class="tdFeaturesRight">
                                 <xsl:apply-templates select="tei:cell[@rend = 'tdRight']/tei:cit/tei:cit[@type = 'translation'][@xml:lang='en']"/>
                              </td>
                           </tr>
                           <tr>
                              <td class="tdFeaturesRight">
                                 <xsl:apply-templates select="tei:cell[@rend = 'tdRight']/tei:cit[@type = 'example']/tei:quote[1]"/>
                              </td>
                           </tr>
                        </xsl:otherwise>
                     </xsl:choose>

                  </xsl:for-each>
               </table>
            </div>
         </xsl:for-each>

      </div>
   </xsl:template>
   
   <xsl:template match="tei:fs"></xsl:template>
   <xsl:template match="tei:head"><h2><xsl:apply-templates/></h2></xsl:template>
   <xsl:template match="tei:hi[@rend = 'italic']"><i><xsl:apply-templates/></i></xsl:template>
   <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
   
   <!-- 
   <xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
   <xsl:template match="tei:row">
      <tr><xsl:apply-templates/></tr></xsl:template>
   <xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
   <xsl:template match="tei:w"><span><xsl:apply-templates/></span></xsl:template>
    -->
</xsl:stylesheet>
