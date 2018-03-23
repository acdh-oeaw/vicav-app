<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml" 
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:z="http://www.zotero.org/namespaces/export#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:bib="http://purl.org/net/biblio#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:vcard="http://nwalsh.com/rdf/vCard#" 
   version="2.0">
   
    <xsl:output method="html"/>
    <xsl:template match="/">
        
        <div>
           <div class="dvStats">
              <xsl:variable name="num" select="//@num"/>
              <xsl:choose>
                 <xsl:when test="$num=0">0 records. Try to add .* to your query.</xsl:when>
                 <xsl:when test="$num=1">1 record&#160;</xsl:when>
                 <xsl:otherwise><xsl:value-of select="$num"/>&#160;records&#160;</xsl:otherwise>
              </xsl:choose>
           </div>
            
            <!-- ********************************************* -->
            <!-- ***  ENTRY ********************************** -->
            <!-- ********************************************* -->
           <xsl:for-each select="results/bib:Article | results/bib:Book | results/bib:BookSection">
               <div>
                  
                  <!-- TYPE -->
                  <xsl:choose>
                     <xsl:when test="name()='bib:Article'"><xsl:attribute name="class">dvBibArticle</xsl:attribute></xsl:when>
                     <xsl:when test="name()='bib:Book'"><xsl:attribute name="class">dvBibBook</xsl:attribute></xsl:when>
                     <xsl:when test="name()='bib:BookSection'"><xsl:attribute name="class">dvBibBookSection</xsl:attribute></xsl:when>
                  </xsl:choose>
                  
                  <!-- NUMBER -->
                  <!-- 
                  <xsl:choose>
                     <xsl:when test="name()='bib:Article'"><xsl:attribute name="class">dvBibArticle</xsl:attribute><xsl:value-of select="position()"/>&#160;(article):&#160;</xsl:when>
                     <xsl:when test="name()='bib:Book'"><xsl:attribute name="class">dvBibBook</xsl:attribute><xsl:value-of select="position()"/>&#160;(book):&#160;</xsl:when>
                     <xsl:when test="name()='bib:BookSection'"><xsl:attribute name="class">dvBibBookSection</xsl:attribute><xsl:value-of select="position()"/>&#160;(book section):&#160;</xsl:when>
                  </xsl:choose>
                  -->
                  
                  <!-- ID -->
                  <!-- 
                  <xsl:variable name="sid" select="substring-before(substring-after(dcterms:abstract, '('), ')')"/>                  
                  &#160;[<xsl:value-of select="$sid"/>]&#160;
                   -->

                  <!-- ID -->
                  <!-- 
                  [<xsl:value-of select="@rdf:about"/>],&#160;
                  -->
                  
                  <!-- AUTHORS -->
                  <i class="fa fa-user" aria-hidden="true"></i>
                  <xsl:if test="bib:authors/.//foaf:Person">
                     <b>
                     <xsl:for-each select="bib:authors/.//foaf:Person">
                        <xsl:if test="position()&gt;1">;&#160;</xsl:if>
                        <xsl:choose>
                           <xsl:when test="string-length(foaf:givenname)&gt;0"><xsl:value-of select="foaf:surname"/>,&#160;<xsl:value-of select="foaf:givenname"/></xsl:when>
                           <xsl:otherwise><xsl:value-of select="foaf:surname"/></xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>
                     </b><br/>
                  </xsl:if>
                                                                      
                  <div class="dvBiblBlock">                                                    
                     <!-- TITLE -->
                     <i class="fa fa-book" aria-hidden="true"></i>
                     <xsl:value-of select="dc:title"/>.&#160;

                     <xsl:if test="dcterms:isPartOf/bib:Journal">
                        In:&#160;<i><xsl:value-of select="dcterms:isPartOf/bib:Journal/dc:title"/>
                           <xsl:if test="string-length(dcterms:isPartOf/bib:Journal/prism:volume)&gt;0">&#160;<xsl:value-of select="dcterms:isPartOf/bib:Journal/prism:volume"/></xsl:if>
                           <xsl:if test="string-length(bib:pages)&gt;0">:&#160;<xsl:value-of select="bib:pages"/></xsl:if>
                           .&#160;
                        </i>   
                     </xsl:if>

                     <!-- DATE -->
                     <xsl:if test="string-length(dc:date)&gt;0"><xsl:text> </xsl:text>&#160;<xsl:value-of select="dc:date"/>.&#160;</xsl:if>                 
                  </div>
                  
               </div>   
            </xsl:for-each>
  
         </div>
      
    </xsl:template>
</xsl:stylesheet>