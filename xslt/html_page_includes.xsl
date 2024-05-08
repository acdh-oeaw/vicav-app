<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="xd exsl html"
    version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            Work around to get rid of tons of unnecessary xmlns:html tags.
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>Get the TEI front part in an FCS explain response</xd:desc>
    </xd:doc>
    <xsl:template name="getTEIFrontPart">
        <xsl:param name="front">
            <xsl:copy-of select="document(concat($base_url, '?version=1.2&amp;operation=explain&amp;x-context=',$x-context,'&amp;x-format=html&amp;x-realhostname=',$site_url))"/>
        </xsl:param> 
        <xsl:copy-of select="exsl:node-set($front)//html:div[@class='zr-description']"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Get the HTML formatted header</xd:desc>
    </xd:doc>
    <xsl:template name="getTEIHeader">
        <xsl:param name="teiHeader">
            <xsl:copy-of select="document(concat($base_url, '?version=1.2&amp;operation=searchRetrieve&amp;query=rfpid==1&amp;x-context=',$x-context,'&amp;x-format=html&amp;x-realhostname=',$site_url))"/>
        </xsl:param>
        <xsl:copy-of select="exsl:node-set($teiHeader)//html:div[@class='tei-teiHeader']"/>
    </xsl:template>
    
    <xsl:template name="getVICAVDictionariesAbout">
        <xsl:param name="teiDocument">
            <xsl:variable name="base_url" select="'https://minerva.arz.oeaw.ac.at/vicav2/corpus_shell/modules/fcs-aggregator/switch.php'"/>
            <xsl:copy-of select="document(concat($base_url, '?version=1.2&amp;operation=searchRetrieve&amp;query=metaText==Dictionaries&amp;x-context=vicav_meta&amp;x-format=html&amp;x-realhostname=',$site_url))"/>
        </xsl:param>
        <xsl:copy-of select="exsl:node-set($teiDocument)//html:div[@class='tei-body']"/>
    </xsl:template>
    
</xsl:stylesheet>