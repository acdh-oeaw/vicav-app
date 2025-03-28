<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 28, 2025</xd:p>
            <xd:p><xd:b>Author:</xd:b> simar</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <json type="object">
            <xsl:apply-templates/>
        </json>
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
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
                <xsl:when test="self::*:dict|self::*:standOff"/> <!-- only for lookup -->
                <xsl:otherwise>
                    <xsl:element name="{local-name()}">
                        <xsl:attribute name="type">object</xsl:attribute>
                        <xsl:apply-templates select="current-group()" mode="#default"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>  
        </xsl:for-each-group>
    </xsl:template>

    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>   
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
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>   
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
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>   
    <xsl:template match="*[normalize-space(string-join(text())) ne '' and count(text()) > 1]">        
        <xsl:apply-templates select="@*"/>
        <_0024_0024 type="array">
            <xsl:attribute name="type">array</xsl:attribute>
            <xsl:apply-templates select="." mode="sequence"/>
        </_0024_0024>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>   
    <xsl:template match="@*">
        <xsl:element name="{'_0040'||local-name()}"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>   
    <xsl:template match="text()">
        <_0024><xsl:value-of select="normalize-space(.)"/></_0024>
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template match="text()" mode="array">
        <_><_0024><xsl:value-of select="normalize-space(.)"/></_0024></_>
    </xsl:template>
</xsl:stylesheet>