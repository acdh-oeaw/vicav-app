<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

  <xsl:output method="html"/>
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
      <xsl:when test="count(ancestor::tei:div) = 1"><div style="margin-left:20px"><xsl:apply-templates/></div></xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 2"><div style="margin-left:30px"><xsl:apply-templates/></div></xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 3"><div style="margin-left:40px"><xsl:apply-templates/></div></xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 4"><div style="margin-left:50px"><xsl:apply-templates/></div></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:graphic">
    <img>
      <xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
    </img>
  </xsl:template>
  
  <xsl:template match="tei:head">
    <xsl:choose>
      <xsl:when test="count(ancestor::tei:div) = 1">
        <table class="tbHeader">
          <tr><td><h2><xsl:apply-templates/></h2></td><td>{teiLink}</td></tr>
        </table>            
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 2">
        <h3><xsl:apply-templates/></h3>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 3">
        <h4><xsl:apply-templates/></h4>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 4">
        <h5><xsl:apply-templates/></h5>
      </xsl:when>
      <xsl:otherwise><h3><xsl:apply-templates/></h3></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:hi[@rend = 'italic']">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:item">
    <li><xsl:apply-templates/></li>
  </xsl:template>
  
  <xsl:template match="tei:list">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>

  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>        
  </xsl:template>

  <xsl:template match="tei:ref">
    <xsl:choose>
        <xsl:when test="@type='flachCards'">
            <a class="aVicText">          
                <xsl:attribute name="onclick">flashcard:</xsl:attribute>
                <xsl:apply-templates/>
            </a>                    
        </xsl:when>
        <xsl:when test="contains(@target, 'reg:') or contains(@target, 'biblid:')">
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

  <xsl:template match="tei:row">
    <tr>
      <xsl:apply-templates/>
    </tr>
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
