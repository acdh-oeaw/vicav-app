<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml" 
   xmlns:tei="http://www.tei-c.org/ns/1.0" 
   version="2.0">
   
    <xsl:output method="xml" encoding="utf-8"/>
    <xsl:template match="/">
        
        <div>
            <!-- ********************************************* -->
            <!-- ***  **************************************** -->
            <!-- ********************************************* -->
           <xsl:for-each select="//tei:div[@type='feature']">
               <div>
                  <h3><xsl:value-of select="tei:head"/></h3>
                  <table>
                     <xsl:for-each select="tei:table/tei:row">
                        <tr>
                           <td class="tdFeatureLeft"><xsl:value-of select="tei:cell[@rend='tdLeft']"/> </td>
                           <td class="tdFeatureComm"><xsl:value-of select="tei:cell[@rend='tdComm']"/> </td>
                           <td class="tdFeatureRight"><xsl:value-of select="tei:cell[@rend='tdRight']"/> </td>                           
                        </tr>                        
                     </xsl:for-each>
                  </table>
               </div>   
            </xsl:for-each>
  
         </div>
      
    </xsl:template>
</xsl:stylesheet>