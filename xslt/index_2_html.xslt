<xsl:stylesheet xml:space="preserve" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
   <!-- TODO change to unordered list and use jquery-ui autocomplete -->
   <xsl:output method="xml"/>

   <xsl:template match="/">
      <div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="w">
      <option>
         <xsl:attribute name="class">opWordList_<xsl:value-of select="@index"/></xsl:attribute>
         <xsl:apply-templates/>
      </option>
   </xsl:template>

   <xsl:template match="hi">
      [<xsl:value-of select="."/>]
   </xsl:template>
</xsl:stylesheet>
