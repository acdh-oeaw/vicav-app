<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <!-- the path under which images are served frome the webapplication. The XQuery function that handles such requests is defined in http.xqm -->
    <xsl:param name="param-base-path">/vicav</xsl:param>
    
    <!-- we make sure that $subdir always has a trailing slash -->
    <xsl:function name="tei:concat-path" as="xs:string">
      <xsl:param name="subdir" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$param-base-path = ''"><xsl:value-of select="''"/></xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$subdir = '' or substring(normalize-space($param-base-path),string-length(normalize-space($param-base-path)),1) = '/'">
                        <xsl:value-of select="concat($param-base-path,$subdir,'/')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($param-base-path,'/',$subdir,'/')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:function>
</xsl:stylesheet>