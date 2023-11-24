<xsl:stylesheet 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  version="2.0" >

  <xsl:output method="html" encoding="UTF-8"/>  
  <xsl:param name="tei-link-marker" select="'false'" as="xs:string"/>
  <!-- the path under which images are served frome the webapplication. The XQuery function that handles such requests is defined in http.xqm -->
  <xsl:param name="param-base-path">/vicav</xsl:param>
  <!-- we make sure that $images-base-path always has a trailing slash -->
  <xsl:include href="concat-path-inc.xslt"/>
  <xsl:variable name="images-base-path" select="tei:concat-path('images')"/>
  <xsl:variable name="docs-base-path" select="tei:concat-path('')"/>
  <xsl:include href="vicavIDToLabel.xslt"/>
  
  <xsl:variable name="openDictFuncToDictID" select='map{
    "func:openDict_Damascus()": "dc_apc_eng_publ",
    "func:openDict_Tunis()": "dc_tunico",
    "func:openDict_Cairo()": "dc_arz_eng_publ",
    "func:openDict_Baghdad()": "dc_acm_baghdad_eng_publ",
    "func:openDict_MSA()": "dc_ar_eng_publ"
  }'/>
    
  <xsl:function name="tei:getLinkAttributes" as="attribute()+">
    <xsl:param name="target" as="xs:string"/>
    <xsl:variable name="targetSplit" as="xs:string+">
      <xsl:choose>
        <xsl:when test="starts-with($target, 'func:openDict_')">
          <xsl:sequence select="('DictQuery', $openDictFuncToDictID($target), replace($target, 'func:openDict_([^(]+)\(.*', '$1 Dictionary Query'))"/>
        </xsl:when>
        <xsl:when test="starts-with($target, 'text:')">
          <xsl:sequence select="('Text', replace($target,'^text:([^/]+)(/[^/,]+)?', '$1'), $captionFromMenuID(replace($target,'^text:([^/]+)(/[^/,]+)?', '$1')))"/>
          <!-- The part after the / is the label for the new window. We get those labels usint the lookup table.  -->
        </xsl:when>
        <xsl:when test="starts-with($target, 'corpusText:')">
          <xsl:sequence select="('corpusText', replace($target,'^corpusText:([^/]+)(/[^/,]+)?', '$1'), replace($target,'^corpusText:([^/]+)(/[^/,]+)?', '$1'))"/>
          <!-- The part after the / is the label for the new window. We get those labels usint the lookup table.  -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:analyze-string select="$target" regex="^([^:]+):([^/]+)/([^/,]+)[,/]?(([^/,]+)[,/]?)?(([^/,]+)[,/]?)?(([^/,]+)[,/]?)?(([^/,]+)[,/]?)?">
            <xsl:matching-substring>
              <xsl:sequence select="(regex-group(1), regex-group(2),regex-group(3),regex-group(5),regex-group(7),regex-group(9),regex-group(11))[. != '']"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:sequence select="('external-link')"/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="matches($targetSplit[1], 'https?')">
        <xsl:sequence>
          <xsl:attribute name="data-target-type"><xsl:value-of select="'external-link'"/></xsl:attribute>
       </xsl:sequence>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence>
          <xsl:attribute name="data-target-type"><xsl:value-of select="upper-case(substring($targetSplit[1], 1, 1))||substring($targetSplit[1], 2)"/></xsl:attribute>
          <xsl:if test="exists($targetSplit[2])">
            <xsl:attribute name="data-text-id"><xsl:value-of select="$targetSplit[2]"/></xsl:attribute>
          </xsl:if>          
          <xsl:if test="exists($targetSplit[3])">
            <xsl:attribute name="data-label"><xsl:value-of select="translate($targetSplit[3], '_', ' ')"/></xsl:attribute>
          </xsl:if>
          <xsl:for-each select="$targetSplit[position() > 3]"><xsl:attribute name="data-query-{position()}"><xsl:value-of select="."/></xsl:attribute></xsl:for-each>      
        </xsl:sequence>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:character-map name="a">
     <xsl:output-character character="&lt;" string="&lt;"/>
     <xsl:output-character character="&gt;" string="&gt;"/>
    <xsl:output-character character="&amp;" string="&amp;"/>
  </xsl:character-map>
  
  <xsl:template match="/">
    <div><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="tei:cell">
    <td>
      <xsl:choose>
        <xsl:when test="@rend='tdCommentSpan'">
          <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
          <xsl:attribute name="colspan">4</xsl:attribute>
        </xsl:when>
        <xsl:when test="@rend"><xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute></xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
 
  <xsl:template match="tei:div">
      <!-- Label of the panel is in n -->
      <xsl:if test="@n"><xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
      
      <xsl:choose>
          <xsl:when test="count(ancestor::tei:div) = 1"><div>
            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
            <xsl:attribute name="style">margin-left:20px</xsl:attribute>
            <xsl:apply-templates/></div></xsl:when>
          
          <xsl:when test="count(ancestor::tei:div) = 2"><div>
            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
            <xsl:attribute name="style">margin-left:30px</xsl:attribute>
            <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute><xsl:apply-templates/></div></xsl:when>
          
          <xsl:when test="count(ancestor::tei:div) = 3"><div>
            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
            <xsl:attribute name="style">margin-left:40px</xsl:attribute>
            <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute><xsl:apply-templates/></div></xsl:when>
          
          <xsl:when test="count(ancestor::tei:div) = 4"><div>
            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
            <xsl:attribute name="style">margin-left:50px</xsl:attribute>
            <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute><xsl:apply-templates/></div></xsl:when>
          
          <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
      </xsl:choose>
  </xsl:template>
    
  <xsl:template match="tei:div[@type='displayContainer']"><p id="displayContainer">-</p></xsl:template>   

  <xsl:template match="tei:graphic">
    <img src="{concat($images-base-path,@url)}">
      <xsl:if test="@style"><xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute></xsl:if>
      <xsl:if test="@rend='inParagraph'">
        <xsl:attribute name="class">imgIllustration</xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <xsl:template match="tei:head">
    <xsl:choose>
      <xsl:when test="count(ancestor::tei:div) = 1">
        <xsl:choose>
          <xsl:when test="$tei-link-marker = 'true'">
            <table class="tbHeader">
              <tr><td><h2>
                  <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
                  <xsl:apply-templates/></h2></td><td>{teiLink}</td></tr>
            </table>
          </xsl:when>
          <xsl:otherwise>
            <h2>
                  <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
                  <xsl:apply-templates/></h2>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 2">
        <h3>
            <xsl:apply-templates/></h3>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 3">
        <h4>
            <xsl:apply-templates/></h4>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 4">
        <h5><xsl:apply-templates/></h5>
      </xsl:when>
      <xsl:otherwise><h3><xsl:apply-templates/></h3></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:hi[@rendition = '#i']">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rendition = '#b']">
    <b><xsl:apply-templates/></b>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend = 'italic']">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="tei:lb"><br/></xsl:template>

  <xsl:template match="tei:list">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>

  <xsl:template match="tei:div[@type='dvContributor']/tei:p">
    <p>
      <xsl:apply-templates select="tei:graphic"/>
      <span>
        <xsl:choose>
          <xsl:when test="tei:graphic"><xsl:apply-templates select="tei:graphic/following-sibling::node()"/></xsl:when>
          <xsl:otherwise><xsl:apply-templates></xsl:apply-templates></xsl:otherwise>
        </xsl:choose>        
      </span>
    </p>
  </xsl:template>


  <xsl:template match="tei:div[@type='html-content']">
    <div class="html-content">
    <xsl:analyze-string select="." regex="&lt;div id=&quot;bwg_container1_0&quot;(.+)bwg_main_ready\(\);      \}}\);    &lt;/script&gt;">
      <xsl:matching-substring>
        <div class="gallery">
          <xsl:analyze-string select="." regex="href=&quot;(http.*?\.jpe?g).*?&quot;.*?src=&quot;(http.*?\.jpe?g).*?&quot;.*? alt=&quot;(.*?)&quot;">
          <xsl:matching-substring>
            <div class="gallery-item">
            <a href="{replace(regex-group(1), '^https?://.*/(.*?)\.(jpe?g)$', 'images/$1.jpg')}" title="{regex-group(3)}">
              <img src="{replace(regex-group(2), '^https?://.*/(.*?)\.(jpe?g)$', 'images/$1.jpg')}"/>
            </a>
            </div>
          </xsl:matching-substring>
        </xsl:analyze-string>
        </div>
       </xsl:matching-substring>
      <xsl:non-matching-substring>    
        <xsl:analyze-string select="." regex="&lt;a.*?href=&quot;(http.*?\.jpe?g).*?&quot;.*?class=&quot;(.*?)&quot;.*?src=&quot;(http.*?\.jpe?g).*?&quot;.*? alt=&quot;(.*?)&quot;.*?&lt;/a&gt;">
          <xsl:matching-substring>
            <div class="gallery {regex-group(2)}">
            <div class="gallery-item">
              <a href="{replace(regex-group(1), '^https?://.*/(.*?)\.(jpe?g)$', 'images/$1.jpg')}" title="{regex-group(4)}">
                <img src="{replace(regex-group(3), '^https?://.*/(.*?)\.(jpe?g)$', 'images/$1.jpg')}"/>
              </a>
              </div>
            </div>
            </xsl:matching-substring>
          <xsl:non-matching-substring>    
            <xsl:value-of disable-output-escaping="yes" select="replace(., '&amp;nbsp;', '&amp;#160;')"/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </div>
  </xsl:template>

  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="tei:ref[starts-with(@target,'http:') or starts-with(@target,'https:')]">
      <a target="_blank" class="aVicText">
          <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
          <xsl:sequence select='tei:getLinkAttributes(@target)'/>
          <xsl:apply-templates/>
      </a>
  </xsl:template>

   <xsl:template match="tei:ptr[@type='sound']">
   </xsl:template>

   <xsl:template match="tei:ref[
       starts-with(@target,'profile:') or
       starts-with(@target,'feature:') or
       starts-with(@target,'sound:') or
       starts-with(@target,'mapMarkers:') or
       starts-with(@target,'corpus:') or
       starts-with(@target,'bibl:') or
        starts-with(@target,'flashcards:') or
        starts-with(@target,'text:') or
        starts-with(@target,'sample:')]">
        <a class="aVicText">
            <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select='@target'/>", this)</xsl:attribute>
            <xsl:sequence select='tei:getLinkAttributes(@target)'/>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:rs[
        starts-with(@ref,'profile:') or
        starts-with(@ref,'feature:') or
        starts-with(@ref,'sound:') or
        starts-with(@ref,'func:') or
        starts-with(@ref,'mapMarkers:') or
        starts-with(@ref,'corpus:') or
        starts-with(@ref,'bibl:') or
        starts-with(@ref,'flashcards:') or
        starts-with(@ref,'text:') or
        starts-with(@ref,'sample:') or
        starts-with(@ref,'corpusText:')]">
        <a class="aVicText">
            <xsl:choose>
                <xsl:when test="contains(@ref,'showLingFeatures')">
                    <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select="translate(@ref, ' ', '&#x2005;')"/>", this)</xsl:attribute>
                    <xsl:attribute name="data-text-id"><xsl:value-of select="translate(@ref, ' ', '&#x2005;')"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select='@ref'/>", this)</xsl:attribute>
                    <xsl:sequence select='tei:getLinkAttributes(@ref)'/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <xsl:template match="tei:ref[starts-with(@target,'func:')]">
        <a class="aVicText" href="{concat('javascript', substring-after(@target, 'func'))}">
        <xsl:sequence select='tei:getLinkAttributes(@target)'/>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    <!-- 
    <xsl:template match="tei:rs[starts-with(@ref,'func:')]">
        <a class="aVicText" href="{concat('javascript', substring-after(@ref, 'func'))}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
     -->
    
    <xsl:template match="tei:ref">
        <a target="_blank" class="aVicText">
            <xsl:attribute name="href"><xsl:value-of select="$docs-base-path||@target"/></xsl:attribute>
            <xsl:sequence select='tei:getLinkAttributes(@target)'/>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:span">
       <span>
          <xsl:if test="@rend">
              <xsl:attribute name="style"><xsl:value-of select="@rend"/></xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
      </span>
  </xsl:template>

  <xsl:template match="tei:row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="tei:table[@type='soundTable']">
      <p class="{@type}">
          <xsl:for-each select="tei:row">
              <div class="dvAudio" onmouseover="makeAudioVisible(this)" onmouseout="makeAudioInVisible(this)">
                  <b><xsl:value-of select="tei:cell[2]"/>:&#160;</b>
                  <xsl:value-of select="tei:cell[3]"/>&#160;<i>(<xsl:value-of select="tei:cell[4]"/>)</i>
                  <audio controls="controls" preload="none" class="audio">
                      <source type="audio/mp4">
                          <xsl:attribute name="src">/static/<xsl:value-of select='tei:cell[5]/tei:ptr/@target'/></xsl:attribute>
                      </source>
                      <a><xsl:attribute name="href">/static/<xsl:value-of select="tei:cell[5]/tei:ptr/@target"/></xsl:attribute>
                          </a>
                  </audio>
              </div>
          </xsl:for-each>
      </p><br/><br/>
  </xsl:template>

  <xsl:template match="tei:table">
    <table>
      <xsl:choose>
        <xsl:when test="@rend"><xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute></xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
</xsl:stylesheet>
