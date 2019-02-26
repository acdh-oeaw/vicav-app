<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    
   xmlns:tei="http://www.tei-c.org/ns/1.0" 
   version="2.0">
   
    <xsl:output method="xml"/>
    <xsl:template match="/">
        
        <div>
           <div class="dvStats">
              Query:  <span class="spQueryText">{query}</span>
           </div>
           <div class="dvStats">
              <xsl:variable name="num" select="//@num"/>
              <xsl:choose>
                 <xsl:when test="$num=0">0 records. Try to add .* to your query.</xsl:when>
                 <xsl:when test="$num=1">1 record </xsl:when>
                 <xsl:otherwise><xsl:value-of select="$num"/> records </xsl:otherwise>
              </xsl:choose>
           </div>
            
            <!-- ********************************************* -->
            <!-- ***  ENTRY ********************************** -->
            <!-- ********************************************* -->
           <xsl:for-each select="results/tei:biblStruct">
               <!-- <xsl:if test="node()/tei:author[1]/tei:surname[1]"> -->
                 <div>
                  
                  <!-- TYPE -->
                  <xsl:choose>
                      <xsl:when test="@type='journalArticle'"><xsl:attribute name="class">dvBibArticle</xsl:attribute></xsl:when>
                      <xsl:when test="@type='encyclopediaArticle'"><xsl:attribute name="class">dvBibArticle</xsl:attribute></xsl:when>                      
                      <xsl:when test="@type='book'"><xsl:attribute name="class">dvBibBook</xsl:attribute></xsl:when>
                      <xsl:when test="@type='bookSection'"><xsl:attribute name="class">dvBibBookSection</xsl:attribute></xsl:when>
                      <xsl:when test="@type='thesis'"><xsl:attribute name="class">dvThesis</xsl:attribute></xsl:when>
                  </xsl:choose>
                                   
                  <!-- AUTHORS -->
                  <div class="dvAuthor">
                     <b>
                        <!-- Number 
                        <xsl:value-of select="position()"/><xsl:text>:&#160;</xsl:text>
                         -->
                         
                        <xsl:for-each select="node()/tei:author">
                           <xsl:if test="position()&gt;1">;&#160;</xsl:if>
                           <xsl:choose>
                               <xsl:when test="string-length(tei:name)&gt;0"><xsl:value-of select="tei:name"/></xsl:when>
                               <xsl:when test="string-length(tei:forename)&gt;0"><xsl:value-of select="tei:surname"/>,&#160;<xsl:value-of select="tei:forename"/></xsl:when>
                               <xsl:otherwise><xsl:value-of select="tei:surname"/></xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                         
                        <xsl:if test="not(node()/tei:author)">
                            <xsl:choose>
                                <xsl:when test="node()/tei:editor">
                                    <xsl:for-each select="node()/tei:editor">
                                        <xsl:if test="position()&gt;1">;&#160;</xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="string-length(tei:name)&gt;0"><xsl:value-of select="tei:name"/>&#160;(ed.)</xsl:when>
                                            <xsl:when test="string-length(tei:forename)&gt;0"><xsl:value-of select="tei:surname"/>,&#160;<xsl:value-of select="tei:forename"/>&#160;(ed.)</xsl:when>
                                            <xsl:otherwise><xsl:value-of select="tei:surname"/>&#160;(ed.)</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>(No author in record)</xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:if>
                        
                        <!-- Type
                        <xsl:text>&#160;&#160;&#160;&#160;(</xsl:text><xsl:value-of select="@type"/><xsl:text>)</xsl:text>
                        -->
                      </b>
                   </div>
                                                                      
                  <div class="dvBiblBlock">                                                    
                     <!-- TITLE -->
                     <!-- <i class="fa fa-book" aria-hidden="true"></i>
                     <i class="fa fa-file-text" aria-hidden="true"></i> -->
                     
                     <xsl:choose>
                         <xsl:when test="@type='thesis'"><img class="imgBiblItem" src="images/book_001.jpg"/></xsl:when>
                         <xsl:when test="@type='book'"><img class="imgBiblItem" src="images/book_001.jpg"/></xsl:when>
                         <xsl:when test="@type='bookSection'"><img class="imgBiblItem" src="images/booksection_001.jpg"/></xsl:when>
                         <xsl:when test="@type='journalArticle'"><img class="imgBiblItem" src="images/article_001.jpg"/></xsl:when>
                         <xsl:when test="@type='encyclopediaArticle'"><img class="imgBiblItem" src="images/article_001.jpg"/></xsl:when>
                     </xsl:choose>

                     <!-- Thesis -->
                      <xsl:if test="@type='thesis'">
                          <xsl:value-of select="tei:monogr/tei:title"/>
                     </xsl:if>
                          
                      
                      <!-- journalArticle -->
                      <xsl:if  test="@type='journalArticle' or @type='encyclopediaArticle' ">
                          <xsl:value-of select="tei:analytic/tei:title"/>.&#160;In:&#160;
                           <i>
                              <xsl:value-of select="tei:monogr[1]/tei:title[1]"/>
                              <xsl:if test="string-length(tei:monogr/tei:imprint/tei:biblScope[@unit='volume'])&gt;0">&#160;
                                <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/>
                              </xsl:if>
                              <xsl:if test="string-length(tei:monogr/tei:imprint/tei:biblScope[@unit='page'])&gt;0">:&#160;
                                <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
                              </xsl:if>
                               
                               
                               <!-- editor(s) -->
                               <xsl:if test="tei:monogr/tei:editor">&#160;(
                                   <xsl:if test="count(tei:monogr/tei:editor)=1">ed.&#160;</xsl:if>
                                   <xsl:if test="count(tei:monogr/tei:editor)&gt;1">eds.&#160;</xsl:if>
                                   
                                   <xsl:for-each select="tei:monogr/tei:editor">
                                       <xsl:if test="position()&gt;1">;&#160;</xsl:if>
                                       <xsl:value-of select="tei:forename"/>&#160;<xsl:value-of select="tei:surname"/>
                                   </xsl:for-each>)
                              </xsl:if> 
                           </i>   
                     </xsl:if>
                      
                      <!-- bookSection -->
                      <xsl:if  test="@type='bookSection'">
                          <xsl:value-of select="tei:analytic/tei:title"/>.&#160;In:&#160;
                          <i>
                              <xsl:value-of select="tei:monogr[1]/tei:title[1]"/>
                              <xsl:if test="string-length(tei:monogr/tei:imprint/tei:biblScope[@unit='volume'])&gt;0">&#160;
                                  <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/></xsl:if>
                              <xsl:if test="string-length(tei:monogr/tei:imprint/tei:biblScope[@unit='page'])&gt;0">:&#160;
                                  <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/></xsl:if>
                              <!-- editor(s) -->

                              <xsl:if test="tei:monogr/tei:editor">&#160;(
                                  <xsl:if test="count(tei:monogr/tei:editor)=1">ed.&#160;</xsl:if>
                                  <xsl:if test="count(tei:monogr/tei:editor)&gt;1">eds.&#160;</xsl:if>
                                  
                                  <xsl:for-each select="tei:monogr/tei:editor">
                                      <xsl:if test="position()&gt;1">;&#160;</xsl:if>
                                      <xsl:value-of select="tei:forename"/>&#160;<xsl:value-of select="tei:surname"/>
                                  </xsl:for-each>)
                              </xsl:if> 
                          </i>   
                      </xsl:if>
                      
                      <!-- book -->
                      <xsl:if  test="@type='book' or @type='thesis'">
                          <xsl:value-of select="tei:monogr[1]/tei:title[1]"/>
                      </xsl:if>
                      
                      
                      <!-- ORT, Verlag -->
                      <xsl:if test="string-length(tei:monogr[1]/tei:imprint[1]/tei:pubPlace[1])&gt;0">
                          .&#160;<xsl:value-of select="tei:monogr[1]/tei:imprint[1]/tei:pubPlace[1]"/>
                      </xsl:if>
                         
                      <xsl:if test="string-length(tei:monogr[1]/tei:imprint[1]/tei:publisher[1])&gt;0">
                          .&#160;<xsl:value-of select="tei:monogr[1]/tei:imprint[1]/tei:publisher[1]"/>
                      </xsl:if>                           
                     
                     <!-- DATE -->
                     <xsl:if test="string-length(tei:monogr[1]/tei:imprint[1]/tei:date[1])&gt;0">
                         .&#160;<xsl:value-of select="tei:monogr[1]/tei:imprint[1]/tei:date[1]"/>
                     </xsl:if>
                      
                     <xsl:text>.</xsl:text>

                     <!-- ZOTERO ID 
                     <xsl:if test="@corresp">
                         &#160;&#160;&#160;<i style="font-size:small">(zotero id: <xsl:value-of select="@corresp"/>)</i> 
                     </xsl:if>                      
                     --> 
                  </div>
                  
               </div>
               <!-- </xsl:if> -->
            </xsl:for-each>
  
         </div>
      
    </xsl:template>
</xsl:stylesheet>