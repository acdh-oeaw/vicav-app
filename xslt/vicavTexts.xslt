<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

    <xsl:output method="html" encoding="UTF-8"/>
  <!-- the path under which images are served frome the webapplication. The XQuery function that handles such requests is defined in http.xqm -->
  <xsl:param name="param-images-base-path">images</xsl:param>
  <!-- we make sure that $images-base-path always has a trailing slash -->
    <xsl:variable name="images-base-path">
        <xsl:choose>
            <xsl:when test="$param-images-base-path = ''"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="substring(normalize-space($param-images-base-path),string-length(normalize-space($param-images-base-path)),1) = '/'">
                        <xsl:value-of select="$param-images-base-path"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($param-images-base-path,'/')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
  
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

  <xsl:template match="tei:graphic">
    <img src="{concat($images-base-path,@url)}">
      <xsl:if test="@rend='inParagraph'">
        <xsl:attribute name="class">imgIllustration</xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>

  <xsl:template match="tei:head">
    <xsl:choose>
      <xsl:when test="count(ancestor::tei:div) = 1">
        <table class="tbHeader">
          <tr><td><h2>
              <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
              <xsl:apply-templates/></h2></td><td>{teiLink}</td></tr>
        </table>
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

  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="tei:ref[starts-with(@target,'http:') or starts-with(@target,'https:')]">
      <a target="_blank" class="aVicText">
          <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
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
            <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select="@target"/>", this)</xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:rs[
        starts-with(@ref,'profile:') or
        starts-with(@ref,'feature:') or
        starts-with(@ref,'sound:') or
        starts-with(@ref,'mapMarkers:') or
        starts-with(@ref,'corpus:') or
        starts-with(@ref,'bibl:') or
        starts-with(@ref,'flashcards:') or
        starts-with(@ref,'text:') or
        starts-with(@ref,'sample:')]">
        <a class="aVicText">
            <xsl:attribute name="href">javascript:getDBSnippet("<xsl:value-of select="@ref"/>", this)</xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[starts-with(@target,'func:')]">
       <a class="aVicText" href="{concat('javascript', substring-after(@target, 'func'))}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>


    <xsl:template match="tei:ref">
        <a target="_blank" class="aVicText">
            <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
<!--
  <xsl:template match="tei:ref">
    <xsl:choose>
        <xsl:when test="@type='flachCards'">
            <a class="aVicText">
                <xsl:attribute name="onclick">flashcard:</xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:when>
        <xsl:when test="contains(@target, '(reg:)or(geo:)') or contains(@target, 'biblid:')">
        <a class="aVicText">
          <xsl:attribute name="onclick">refEvent("<xsl:value-of select="@target"/>")</xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@type='dictQuery'">
        <a class="aVicText">
          <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@type='jsLink' or contains(@target, 'javascript:')">
        <a class="aVicText">
          <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@xml:id">
        <a class="aVicText">
          <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a target="_blank" class="aVicText">
          <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 -->

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
      <p>
          <xsl:for-each select="tei:row">
              <div class="dvAudio" onmouseover="makeAudioVisible(this)" onmouseout="makeAudioInVisible(this)">
                  <b><xsl:value-of select="tei:cell[2]"/>:&#160;</b>
                  <xsl:value-of select="tei:cell[3]"/>&#160;<i>(<xsl:value-of select="tei:cell[4]"/>)</i>
                  <audio controls="controls" preload="none" class="audio">
                      <source type="audio/mp4">
                          <xsl:attribute name="src">sound/<xsl:value-of select='tei:cell[5]/tei:ptr/@target'/></xsl:attribute>
                      </source>
                      <a><xsl:attribute name="href">sound/<xsl:value-of select="tei:cell[5]/tei:ptr/@target"/></xsl:attribute>
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
