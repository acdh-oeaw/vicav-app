<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:acdh="http://acdh.oeaw.ac.at"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei acdh"
    version="3.0">
    
    <xsl:variable name="dictById" select="map:merge(//tei:entry!map {data(./@xml:id): .})"/>
    
    <xsl:template match="tei:u">
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array"><xsl:apply-templates select="tei:w|tei:pc|tei:gap" mode="array"/></_0024_0024>
    </xsl:template>
    
    <xsl:template match="tei:w|tei:pc|tei:gap" mode="array">
        <_ type="object">
            <xsl:element name="{local-name()}">
                <xsl:attribute name="type">object</xsl:attribute>
                <xsl:apply-templates select="."/>
                <xsl:if test=".[@lemmaRef]">
                    <xsl:variable name="id" select="replace(data(@lemmaRef), 'dict:', '')"/>
                    <xsl:apply-templates select="$dictById($id)/tei:gramGrp/tei:gram"></xsl:apply-templates>
                </xsl:if>
            </xsl:element>
        </_>
    </xsl:template>
    
    <xsl:template match="tei:gram">
        <xsl:element name="{@type}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:w[count((text(),*)) > 1]">        
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array">
            <xsl:apply-templates select="." mode="sequence"/>
        </_0024_0024> 
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:apply-templates select="@*"/>
        <xsl:for-each-group select="*|text()[normalize-space(.) ne '']" group-adjacent="local-name()">
            <xsl:choose>
                <xsl:when test="current-group()/local-name() = ''">
                    <xsl:apply-templates select="current-group()" mode="#default"/> 
                </xsl:when>
                <xsl:when test="count(current-group()) > 1">
                    <xsl:element name="{local-name()||'s'}">
                        <xsl:attribute name="type">array</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="array"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="self::tei:dict|self::*:standOff"/> <!-- only for lookup -->
                <xsl:otherwise>
                    <xsl:element name="{local-name()}">
                        <xsl:attribute name="type">object</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="#default"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>  
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="*" mode="array">
        <_ type="object">
            <xsl:apply-templates select="@*"/>
            <xsl:for-each-group select="*|text()[normalize-space(.) ne '']" group-adjacent="local-name()">
                <xsl:choose>
                    <xsl:when test="current-group()/local-name() = ''">
                        <xsl:apply-templates select="current-group()" mode="#default"/> 
                    </xsl:when>
                    <xsl:when test="count(current-group()) > 1">
                        <xsl:element name="{local-name()||'s'}">
                            <xsl:attribute name="type">array</xsl:attribute>
                            <xsl:apply-templates select="current-group()" mode="array"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{local-name()}">                       
                            <xsl:attribute name="type">object</xsl:attribute>
                            <xsl:apply-templates select="current-group()" mode="#default"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>  
            </xsl:for-each-group>
        </_>
    </xsl:template>
    
    <xsl:template match="*" mode="sequence">
        <xsl:for-each-group select="*|text()[normalize-space(.) ne '']" group-adjacent="local-name()">
            <_ type="object">
                <xsl:choose>
                    <xsl:when test="current-group()/local-name() = ''">
                        <xsl:apply-templates select="current-group()" mode="#default"/> 
                    </xsl:when>
                    <xsl:when test="count(current-group()) > 1">
                        <xsl:element name="{local-name()||'s'}">
                            <xsl:attribute name="type">array</xsl:attribute>
                            <xsl:apply-templates select="current-group()" mode="array"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{local-name()}">                       
                            <xsl:attribute name="type">object</xsl:attribute>
                            <xsl:apply-templates select="current-group()" mode="#default"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </_>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="*[normalize-space(string-join(text())) ne '' and count(text()) > 1]">        
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array">
            <xsl:attribute name="type">array</xsl:attribute>
            <xsl:apply-templates select="." mode="sequence"/>
        </_0024_0024>        
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:element name="{'_0040'||local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="text()">
        <_0024><xsl:value-of select="."/></_0024>
    </xsl:template>
    
    <xsl:template match="text()" mode="array">
        <_><_0024><xsl:value-of select="."/></_0024></_>
    </xsl:template>
</xsl:stylesheet>