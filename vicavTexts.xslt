<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0">

  <xsl:output method="html"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:cell">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="tei:div">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:head">
    <xsl:choose>
      <xsl:when test="count(ancestor::tei:div) = 1">
        <h2>1: <xsl:apply-templates/></h2>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 2">
        <h3>2: <xsl:apply-templates/></h3>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 3">
        <h4>3: <xsl:apply-templates/></h4>
      </xsl:when>
      <xsl:when test="count(ancestor::tei:div) = 4">
        <h5>4: <xsl:apply-templates/></h5>
      </xsl:when>
      <xsl:otherwise>
        <h3>
          <xsl:apply-templates/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:hi[@rend = 'italic']">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>

  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:ref">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:value-of select="@target"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="tei:row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="tei:table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
</xsl:stylesheet>
