<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/"
    xmlns:zr="http://explain.z3950.org/dtd/2.0/"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:cr="http://aac.ac.at/content_repository"
    version="1.0"
    extension-element-prefixes="diag zr sru fcs exsl cr xd">
    <xd:doc scope="stylesheet">
        <xd:desc>Generic functions for SRU-result handling.
            <xd:p>History:
                <xd:ul>
                    <xd:li>2011-12-04: created by:"vr": based on cmd_functions.xsl but retrofitted back to 1.0</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="dict_file"/>
    </xd:doc>
    <xd:doc>
        <xd:desc>This also inludes params.xls</xd:desc>
    </xd:doc>
    <xsl:include href="html_snippets.xsl"/>

<!-- <xsl:param name="mode" select="'html'" /> -->
    <xd:doc>
        <xd:desc>Read the content of the dict.xml file into this variable
        <xd:p>If the file is not structured as expected an empty list is returned.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="dict">
        <xsl:variable name="dict_file_content">
            <xsl:copy-of select="document($dict_file)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exsl:node-set($dict_file_content)/dict/list[@xml:lang = $dict_lang]">
                <xsl:copy-of select="exsl:node-set($dict_file_content)/dict/list[@xml:lang = $dict_lang]"/>
<!-- switch.php is set up to throw an exception on any error or _warning_ so this kills the transform right now -->
<!--                <xsl:message>Reading <xsl:value-of select="$dict_lang"/> from dict_file <xsl:value-of select="$dict_file"/></xsl:message> -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Problem reading <xsl:value-of select="$dict_lang"/> from dict_file <xsl:value-of select="$dict_file"/>
                    <xsl:copy-of select="$dict_file_content"/>.. Please check!</xsl:message>
                 <list xmlns=""/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xd:doc>
        <xd:desc>Common starting point for all stylesheet
	        <xd:p>Cares for unified html-envelope
	        and passes back to the individual stylesheets for the content 
	        (via template: <xd:ref name="continue-root" type="template">continue-root</xd:ref>)
	        </xd:p>
            <xd:p>
	            Depending on <xd:ref name="format" type="parameter">$format</xd:ref> containing
	            that name generates the html framework using one of the following named templates
	            <xd:ul>
                    <xd:li>
                        <xd:ref name="html" type="template">html</xd:ref> for ??? </xd:li>
                    <xd:li>
                        <xd:ref name="htmljs" type="template">htmljs</xd:ref> for ??? </xd:li>
                    <xd:li>
                        <xd:ref name="htmlsimple" type="template">htmlsimple</xd:ref> for ??? </xd:li>
                </xd:ul>
	            If none of these are found only the contents generated by
	            <xd:ref name="continue-root" type="template">continue-root</xd:ref> are returned. 
	        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
<!--		<xsl:message>root_document-uri:<xsl:value-of select="$root_uri"/>
			</xsl:message>-->
<!--			<xsl:message>format:<xsl:value-of select="$format"/>
			</xsl:message>-->
        <xsl:choose>
            <xsl:when test="contains($format, 'htmlbootstrap')">
                <xsl:call-template name="htmlbootstrap"/>
            </xsl:when>
            <xsl:when test="contains($format,'htmlpage')">
                <xsl:call-template name="html"/>
            </xsl:when>
            <xsl:when test="contains($format,'htmljspage')">
                <xsl:call-template name="htmljs"/>
            </xsl:when>
            <xsl:when test="contains($format,'htmlsimple')">
                <xsl:call-template name="htmlsimple"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="continue-root"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates the typical html framework and integrates the parts created by the specialised named templates</xd:desc>
    </xd:doc>
    <xsl:template name="htmlbootstrap">
        <html>
            <head>
                <xsl:call-template name="html-head-bootstrap"/>
                <xsl:call-template name="callback-header"/>
            </head>
            <body>
                <xsl:call-template name="page-header-bootstrap"/>
				<xsl:call-template name="page-content"/>
                <h1>
                    <xsl:value-of select="$title"/>
                </h1>
                <xsl:apply-templates select="//sru:diagnostics"/>          
            </body>
        </html>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates the typical html framework and integrates the parts created by the specialised named templates</xd:desc>
    </xd:doc>
    <xsl:template name="html">
        <html>
            <head>
                <xsl:call-template name="html-head"/>
                <xsl:call-template name="callback-header"/>
            </head>
            <body>
                <xsl:call-template name="page-header"/>
                <h1>
                    <xsl:value-of select="$title"/>
                </h1>
                <xsl:if test="not(sru:searchRetrieveResponse)">
                    <xsl:apply-templates select="//sru:diagnostics"/>
                </xsl:if>
                <xsl:call-template name="continue-root"/>
            </body>
        </html>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generates the typical html framework and integrates the more parts created by the specialised named templates</xd:desc>
    </xd:doc>
    <xsl:template name="htmljs">
        <html>
            <head>
                <xsl:call-template name="html-head"/>
                <xsl:call-template name="callback-header"/>
            </head>
            <body>
                <xsl:call-template name="page-header"/>
                <h1>
                    <xsl:value-of select="$title"/>
                </h1>
                <xsl:call-template name="query-input"/>
                <xsl:call-template name="query-list"/>
                <xsl:call-template name="detail-space"/>
                <xsl:call-template name="public-space"/>
                <xsl:call-template name="user-space"/>
				<xsl:call-template name="continue-root"/>
            </body>
        </html>
    </xsl:template>
    <xd:doc>
        <xd:desc>An html-envelope for a simple (noscript) view
            <xd:p>
                Uses $script_url/style/cmd-ui.css
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="htmlsimple">
        <html>
            <head>
                <title>
                    <xsl:value-of select="$title"/>
                </title>			
				<!-- <xsl:call-template name="callback-header"/> -->
            </head>
            <xsl:call-template name="page-header"/>
            <body>                
				<!-- <h1><xsl:value-of select="$title"/></h1> -->
                <xsl:apply-templates select="diagnostics"/>
                <xsl:call-template name="continue-root"/>
            </body>
        </html>
    </xsl:template>
    <xd:doc>
        <xd:desc>Do-nothing definition of callback-header. Overwrite this in specialised templates</xd:desc>
    </xd:doc>
    <xsl:template name="callback-header"/>
    <xd:doc>
        <xd:desc>Template used to display an error/diagnostic message returned by the upstream endpoint
        <xd:p>
            The error message can be found in diag:diagnostic so the template for this is directly related.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="diagnostics">
        <div class="error">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="diag:diagnostic">
        <p>
            <xsl:value-of select="diag:message"/>
            <xsl:if test="diag:details"> (<xsl:value-of select="diag:details"/>)</xsl:if>
            <xsl:call-template name="br"/>
            <xsl:value-of select="diag:uri"/>
        </p>
    </xsl:template>
    <xd:doc>
        <xd:desc>Fetches the context from the URL provided in $context_url
        <xd:p>
            $context_url is influenced by <xd:ref name="base_url" type="variable">$base_url</xd:ref>.
        </xd:p>
            <xd:p>
            Note: by default $base_url is set to an empty string so the URL is assumed to be wherever these
            style sheet is executed. This may lead to warnings by the XSLT processor.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="contexts-doc">
        <xsl:choose>
            <xsl:when test="$contexts_url = ''"/>
            <xsl:when test="$scripts_user">
                <xsl:variable name="contexts_auth_url" select="concat(substring-before($contexts_url, '//'), '//', $scripts_user, ':', $scripts_pw, '@', substring-after($contexts_url,'//'))"/>
                <xsl:copy-of select="document($contexts_auth_url)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="document($contexts_url)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>All contexts as XML</xd:desc>
    </xd:doc>
    <xsl:variable name="contexts">
        <xsl:call-template name="contexts-doc"/>
    </xsl:variable>
    
    <xd:doc>
        <xd:desc>Fetches the explaination for the current endpoint
            <xd:p>
                $indexes_url is influenced by <xd:ref name="base_url" type="variable">$base_url</xd:ref> and 
                <xd:ref name="base_url" type="variable">$x-context</xd:ref>.
            </xd:p>
            <xd:p>
                Note: by default $base_url is set to an empty string so the URL is assumed to be wherever these
                style sheet is executed. This may lead to warnings by the XSLT processor.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="indexes-doc">
        <xsl:choose>
            <xsl:when test="$indexes_url = ''"/>
            <xsl:when test="$scripts_user">
                <xsl:variable name="indexes_auth_url" select="concat(substring-before($indexes_url, '//'), '//', $scripts_user, ':', $scripts_pw, '@', substring-after($indexes_url,'//'))"/>
                <xsl:copy-of select="document($indexes_auth_url)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="document($indexes_url)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>All indexes as XML</xd:desc>
    </xd:doc>
    <xsl:variable name="indexes">
        <xsl:call-template name="indexes-doc"/>
    </xsl:variable>

    <xd:doc>
        <xd:desc>Generates an HTML select-option list of available contexts</xd:desc>
    </xd:doc>
    <xsl:template name="contexts-select">
        
<!--            DEBUG: contexts_url:<xsl:copy-of select="resolve-uri($contexts_url)" />
        DEBUG: base_url:<xsl:value-of select="$base_url" />
        DEBUG: contexts:<xsl:copy-of select="$contexts" /> -->
        <select name="x-context">
            <xsl:if test="$contexts">
                <xsl:for-each select="(exsl:node-set($contexts))//sru:terms/sru:term">
                    <xsl:variable name="ancestors-prefix">
                        <xsl:for-each select="ancestor::sru:term">
                            <xsl:text>.</xsl:text>
                        </xsl:for-each>
                    </xsl:variable>
                    <option value="{sru:value}">
                        <xsl:if test="sru:value/text() = $x-context">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="concat($ancestors-prefix, sru:displayTerm)"/>
                    </option>
                </xsl:for-each>
            </xsl:if>
        </select>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Generates an HTML select-option list of available indexes</xd:desc>
    </xd:doc>
    <xsl:template name="indexes-select">
        
        <!--            DEBUG: contexts_url:<xsl:copy-of select="resolve-uri($contexts_url)" />
        DEBUG: base_url:<xsl:value-of select="$base_url" />
        DEBUG: contexts:<xsl:copy-of select="$contexts" /> -->
        <select name="indexes">
            <xsl:if test="$indexes">
                <xsl:for-each select="(exsl:node-set($indexes))//zr:indexInfo/zr:index">
                    <option value="{.//zr:name}">
                        <xsl:if test=".//zr:name/text() = $index">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select=".//zr:title"/>
                    </option>
                </xsl:for-each>
            </xsl:if>
        </select>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Shall be usable to form consistently all urls within xsl</xd:desc>
        <xd:param name="action">Same meaning as <xd:ref name="operation" type="parameter">$operation</xd:ref>.
            Defaults to <xd:ref name="operation" type="parameter">$operation</xd:ref>.</xd:param>
        <xd:param name="format">Same meaning as <xd:ref name="format" type="parameter">$format</xd:ref>.
            Defaults to <xd:ref name="format" type="parameter">$format</xd:ref>.</xd:param>
        <xd:param name="q">Same meaning as <xd:ref name="q" type="parameter">$q</xd:ref>.
            Defaults to <xd:ref name="q" type="parameter">$q</xd:ref>.</xd:param>
        <xd:param name="startRecord">Same meaning as <xd:ref name="startRecord" type="parameter">$startRecord</xd:ref>.
            Defaults to <xd:ref name="startRecord" type="parameter">$startRecord</xd:ref>.</xd:param>
        <xd:param name="maximumRecords">Same meaning as <xd:ref name="maximumRecords" type="parameter">$maximumRecords</xd:ref>.
            Defaults to <xd:ref name="maximumRecords" type="parameter">$maximumRecords</xd:ref>.</xd:param>
    </xd:doc>
    <xsl:template name="formURL">
        <xsl:param name="action" select="$operation"/>
        <xsl:param name="format" select="$format"/>
        <xsl:param name="sort" select="$sort"/>
        <xsl:param name="md-format" select="'CMDI'"/>
        <xsl:param name="queryType" select="$queryType"/>
        <xsl:param name="q" select="$q"/>
        <xsl:param name="startRecord" select="$startRecord"/>
        <xsl:param name="maximumRecords" select="$maximumRecords"/>
        <xsl:param name="dataview" select="normalize-space(//fcs:x-dataview)"/>
        <xsl:param name="responsePosition" select="$responsePosition"/>
        <xsl:param name="maximumTerms" select="$maximumTerms"/>
        <xsl:param name="x-filter" select="$x-filter"/>
        <xsl:param name="x-context" select="$x-context"/>
        <xsl:param name="contextset" select="''"/>
        <xsl:param name="scanClause" select="$scanClause"/>
        <xsl:param name="fcs_prefix" select="$fcs_prefix"/>
        <xsl:param name="base_url" select="$base_url_public"/>

        <xsl:variable name="param_q">
            <xsl:if test="$q != ''">
                <xsl:variable name="q_protected">
                    <xsl:call-template name="replace-string">
                        <xsl:with-param name="text" select="$q"/>
                        <xsl:with-param name="replace" select="'#'"/>
                        <xsl:with-param name="with" select="'%23'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($q_protected, ' ')">
                        <xsl:variable name="q_index" select="substring-before($q_protected, '%3D')"/>
                        <xsl:variable name="q_query" select="substring-after($q_protected, '%3D')"/>
                        <xsl:value-of select="concat('&amp;query=', $q_index, '%3D&quot;', $q_query, '&quot;')"/>                       
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('&amp;query=', $q_protected)"/>                       
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_format">
            <xsl:if test="$format != ''">
                <xsl:value-of select="concat('&amp;x-format=',$format)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_sort">
            <xsl:if test="$sort != ''">
                <xsl:value-of select="concat('&amp;sort=',$sort)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_x-context">
<!--            if action=explain, handle-q param as x-context-->
            <xsl:choose>
                <xsl:when test="$action='explain' and $q != ''">
                    <xsl:value-of select="concat('&amp;x-context=',$q)"/>
                </xsl:when>
                <xsl:when test="$x-context = '' "/>
                <xsl:otherwise>
                    <xsl:value-of select="concat('&amp;x-context=',$x-context)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="param_startRecord">
            <xsl:if test="$startRecord != ''">
                <xsl:value-of select="concat('&amp;startRecord=',$startRecord)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_maximumRecords">
            <xsl:if test="$maximumRecords != ''">
                <xsl:value-of select="concat('&amp;maximumRecords=',$maximumRecords)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_maximumTerms">
            <xsl:if test="$maximumTerms != ''">
                <xsl:value-of select="concat('&amp;maximumTerms=',$maximumTerms)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_responsePosition">
            <xsl:if test="$responsePosition != ''">
                <xsl:value-of select="concat('&amp;responsePosition=',$responsePosition)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_scanClause">
            <xsl:if test="$scanClause != ''">
            <xsl:value-of select="concat('&amp;scanClause=',$contextset,$scanClause)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_x-dataview">
            <xsl:if test="$dataview != ''">
                <xsl:value-of select="concat('&amp;x-dataview=', $dataview)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="XDEBUG_SESSION_START">
            <xsl:if test="$XDEBUG_SESSION_START">
                <xsl:value-of select="concat('&amp;XDEBUG_SESSION_START=', $XDEBUG_SESSION_START)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_queryType">
            <xsl:if test="$queryType != ''">
                <xsl:value-of select="concat('&amp;queryType=', $queryType)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="param_XDEBUG_SESSION_START">
            <xsl:if test="$XDEBUG_SESSION_START != ''">
                <xsl:value-of select="concat('&amp;XDEBUG_SESSION_START=', $XDEBUG_SESSION_START)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$action='get-data'">
                <xsl:value-of select="concat($base_url_public, 'get/', $q, '/data', translate($param_format,'&amp;','?'), $XDEBUG_SESSION_START)"/>
            </xsl:when>
            <xsl:when test="$action='get-metadata'">
                <xsl:value-of select="concat($base_url_public, 'get/', $q, '/metadata/', $md-format, translate($param_format,'&amp;','?'), $XDEBUG_SESSION_START)"/>
            </xsl:when>
            <xsl:when test="$action='explain'">
                <xsl:value-of select="concat($base_url_public, $fcs_prefix, '?version=1.2&amp;operation=',$action, $param_x-context, $param_format, $param_x-dataview, $param_XDEBUG_SESSION_START)"/>
            </xsl:when>
            <xsl:when test="$action='scan'">
                <xsl:value-of select="concat($base_url_public, $fcs_prefix, '?version=1.2&amp;operation=',$action, $param_scanClause, $param_x-context, $param_format, $param_x-dataview, $param_sort, $param_maximumTerms, $param_responsePosition, $param_XDEBUG_SESSION_START)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($base_url_public, $fcs_prefix, '?version=1.2&amp;operation=',$action, $param_q, $param_x-context, $param_startRecord, $param_maximumRecords, $param_format, $param_x-dataview, $param_queryType, $param_XDEBUG_SESSION_START)"/>
            </xsl:otherwise>
        </xsl:choose>                
         
        <!--        <xsl:choose>
            <xsl:when test="$action=''">
                <xsl:value-of select="concat($base_dir, '?q=', $q, '&repository=', $repository)"/>
            </xsl:when>
            <xsl:when test="$q=''">
                <xsl:value-of select="concat($base_dir, '/',$action, '/', $format)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$action='record'">
                        <xsl:value-of select="concat($base_dir, '/',$action, '/', $format, '?query=', $q, $param_repository)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($base_dir, '?operation=',$action, $param_q, $param_repository, $param_startRecord, $param_maximumRecords, $param_format)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
-->
    </xsl:template>
    <xd:doc>
        <xd:desc>Add link to more information to a link using information from mappings and some XML attribute key</xd:desc>
        <xd:p>
            Note: The context element where on which this template is applied is assumed to have that key XML attribute. 
        </xd:p>
        <xd:param name="elem">???</xd:param>
    </xd:doc>
    <xsl:template name="elem-link">
        <xsl:param name="elem" select="exsl:node-set(.)"/>
        
        <!-- WATCHME: primitive matching on elem-name, let's see how far this gets us -->
<!--        <xsl:variable name="index" select="$context-mapping//index[path = name($elem)][@link]"/>-->
<!--   FIXME: temporarily deactivated due to problems with feeding context     -->
        <xsl:variable name="index" select="/non-existent"/>
        <xsl:if test="$index">
            <!-- we would need a dynamic evaluation to get the specific piece of data from the $elem 
                but let's try with some more trivial means -->
            <xsl:variable name="linking-value">
                <xsl:choose>
                    <xsl:when test="contains($index/@use,'@')">
                        <xsl:value-of select="$elem/@*[name()= substring-after($index/@use,'@')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$elem/text()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="concat($index/@link, $linking-value)"/>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Formats an XML fragment so it's readable as such (using mode format-xmlelem), some elements as list or a single element
            using <xd:ref name="format-value" type="template">format-value</xd:ref>
        </xd:desc>
        <xd:param name="elems">Some node() that should be formated.</xd:param>
    </xd:doc>
    <xsl:template name="format-field">
        <xsl:param name="elems"/>
        <xsl:choose>
            <xsl:when test="$elems/*">
                <xsl:apply-templates select="$elems" mode="format-xmlelem"/>
            </xsl:when>
            <xsl:when test="count($elems) &gt; 1">
                <ul>
                    <xsl:for-each select="$elems">
                        <li>
                            <xsl:call-template name="format-value"/>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="format-value">
                    <xsl:with-param name="value" select="$elems"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Format values eg. when formatting attributes like below
            <xd:p>
                This basic implementation just replaces http: containing URLs with a matching HTML a tag
                that opens the link in another window.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="format-value">
        <xsl:param name="value" select="."/>
		<!-- cnt_value:<xsl:value-of select="count($value)" />  -->
        <xsl:choose>
            <xsl:when test="starts-with($value[1], 'http:') or starts-with($value[1], 'https:')">
                <a target="_blank" class="external" href="{$value}">
                    <xsl:value-of select="$value"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Provides a generic html-view for xml-elements 
	    </xd:desc>
        <xd:param name="strict">xs:boolean: Stay in mode format-xmlelem mode (or try to go back to mode=record-data)</xd:param>
    </xd:doc>
    <xsl:template match="*" mode="format-xmlelem">
        <xsl:param name="strict"/>
<!--        <xsl:message>strict:<xsl:value-of select="$strict"/></xsl:message>        -->
        <xsl:if test=".//text() or @*">
            <xsl:variable name="has_text">
                <xsl:choose>
                    <xsl:when test="normalize-space(text()[1])='Unspecified'">unspecified</xsl:when>
                    <xsl:when test="not(normalize-space(.//text())='')">text</xsl:when>
                    <xsl:otherwise>empty</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="has_children">
                <xsl:choose>
                    <xsl:when test="*">has-children</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="label-class">
                <xsl:choose>
                    <xsl:when test="*">block label</xsl:when>
                    <xsl:otherwise>inline label</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <span class="cmds-xmlelem wrapper">
                <div class="cmds-xmlelem {$has_children} value-{$has_text}">
                    <span class="{$label-class}">
                        <xsl:value-of select="local-name()"/>
                    </span>
                    <xsl:if test="@*">
                        <span class="attributes">
                            <xsl:apply-templates select="@*" mode="format-attr"/>
                        </span>
                    </xsl:if>
                    <span class="value">
                        <xsl:call-template name="format-value">
                            <xsl:with-param name="value" select="text()[.!='']"/>
                        </xsl:call-template>
                    </span>
                    <xsl:choose>
                        <xsl:when test="$strict">
                            <xsl:apply-templates select="*" mode="format-xmlelem">
                                <xsl:with-param name="strict" select="$strict"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="*" mode="format-xmlelem"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </span>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Returns attribute names and their values as pairs of HTML span tags</xd:desc>
    </xd:doc>
    <xsl:template match="@*" mode="format-attr">
        <span class="inline label">
            <xsl:value-of select="name()"/>
        </span>
        <span class="value">
            <xsl:call-template name="format-value"/>
        </span>
    </xsl:template>
    <xd:doc>
        <xd:desc>???</xd:desc>
    </xd:doc>
    <xsl:template name="xml-context">
        <xsl:param name="child"/>
        <xsl:variable name="collect">
            <xsl:for-each select="$child/ancestor::CMD_Component|$child/ancestor::Term">
                <xsl:value-of select="@name"/>.</xsl:for-each>
            <xsl:value-of select="$child/@name"/>
        </xsl:variable>
        <xsl:value-of select="$collect"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Look up the key or the current context in the dict.xml file that can be supplied
        <xd:p>
            Used e.g. for translation.
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="dict">
        <xsl:param name="key"/>
        <xsl:param name="fallback" select="$key"/>
        <xsl:choose>
            <xsl:when test="exsl:node-set($dict)/list/item[@key=$key]">
                <xsl:value-of select="exsl:node-set($dict)/list/item[@key=$key]"/>
            </xsl:when>
            <xsl:when test="exsl:node-set($dict)/list/item[.=$key]">
                <xsl:value-of select="exsl:node-set($dict)/list/item[.=$key]/@key"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fallback"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Generate links for the scan operation results
        </xd:desc>
    </xd:doc>
    <xsl:template name="generateLinkInScanResults">
        <xsl:param name="format" select="$format"/>
        <xsl:param name="index" select="''"/>
        <!--                        special handling for special index -->
        <xsl:choose>
            <xsl:when test="$scanClause = 'fcs.resource'">
                <!--                    <xsl:value-of select="utils:formURL('explain', $format, sru:value)"/>-->
                <xsl:call-template name="formURL">
                    <xsl:with-param name="action">explain</xsl:with-param>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="q" select="sru:value"/>
                </xsl:call-template>
            </xsl:when>
            <!-- TODO: special handling for cmd.collection? -->
            <!--<xsl:when test="$index = 'cmd.collection'">
                    <xsl:value-of select="utils:formURL('explain', $format, sru:value)"/>
                </xsl:when>-->
            <xsl:otherwise>
                <!--                    <xsl:value-of select="utils:formURL('searchRetrieve', $format, concat($index, '%3D%22', sru:value, '%22'))"/>-->
                <xsl:call-template name="formURL">
                    <xsl:with-param name="action">searchRetrieve</xsl:with-param>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="q" select="concat($index, '%3D', sru:value)"/>
<!--                    according to the specs an exact search for a search term looks like this but cr-xq doesn't support this yet-->
<!--                    <xsl:with-param name="q" select="concat($index, '%3D%3D%22', sru:value, '%22')"></xsl:with-param>-->
                    <xsl:with-param name="dataview">kwic,title</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>Forces generation of one (!) emtpty &lt;br/&gt; tag
            <xd:p>br tags tend not to be collapse which is interpreted as two brs by browsers.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="br">
        <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
    </xsl:template>
    <xd:doc>
        <xd:desc>string-join replacement</xd:desc>
    </xd:doc>
    <xsl:template name="string-join">
        <xsl:param name="nodes-to-join"/>
        <xsl:param name="join-with" select="','"/>
        <xsl:choose>
            <xsl:when test="not($nodes-to-join) or count($nodes-to-join) = 0">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:when test="count($nodes-to-join) = 1">
                <xsl:value-of select="$nodes-to-join"/>
            </xsl:when>
            <xsl:when test="count($nodes-to-join) = 2">
                <xsl:value-of select="concat($nodes-to-join[1], $join-with, $nodes-to-join[2])"/>
            </xsl:when>
            <xsl:when test="count($nodes-to-join) = 3">
                <xsl:value-of select="concat($nodes-to-join[1], $join-with, $nodes-to-join[2], $join-with, $nodes-to-join[3])"/>
            </xsl:when>
            <xsl:when test="count($nodes-to-join) = 4">
                <xsl:value-of select="concat($nodes-to-join[1], $join-with, $nodes-to-join[2], $join-with, $nodes-to-join[3], $join-with, $nodes-to-join[4])"/>
            </xsl:when>
            <xsl:when test="count($nodes-to-join) = 5">
                <xsl:value-of select="concat($nodes-to-join[1], $join-with, $nodes-to-join[2], $join-with, $nodes-to-join[3], $join-with, $nodes-to-join[4], $join-with, $nodes-to-join[5])"/>
            </xsl:when>
            <xsl:when test="count($nodes-to-join) = 6">
                <xsl:value-of select="concat($nodes-to-join[1], $join-with, $nodes-to-join[2], $join-with, $nodes-to-join[3], $join-with, $nodes-to-join[4], $join-with, $nodes-to-join[5], $join-with, $nodes-to-join[6])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="rest">
                    <xsl:call-template name="string-join">
                        <xsl:with-param name="nodes-to-join" select="$nodes-to-join[position() &gt;= 8]"/>
                        <xsl:with-param name="join-with" select="$join-with"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($nodes-to-join[1], $join-with, $nodes-to-join[2], $join-with, $nodes-to-join[3], $join-with, $nodes-to-join[4], $join-with, $nodes-to-join[5], $join-with, $nodes-to-join[6], $join-with, $rest)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>tokenize function replacement
            <xd:p>Note: result needs exsl:node-set!</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="tokenize">
        <xsl:param name="text"/>
        <xsl:param name="delimiter"/>
        <xsl:if test="string-length($text)>0">
            <lang><xsl:value-of select="substring-before(concat($text, $delimiter), $delimiter)"/></lang>            
            <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="substring-after($text, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>String replacement for XSL 1.0
            <xd:p>Found on stackoverflow: http://stackoverflow.com/questions/7520762/xslt-1-0-string-replace-function</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="replace-string">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="with"/>
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$with"/>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text"
                        select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="with" select="$with"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="linebreak-80">
        <xsl:call-template name="_linebreak-80">
            <xsl:with-param name="text" select="."/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="_linebreak-80">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="$text = ''"/>
            <xsl:otherwise>
                <xsl:value-of select="substring($text, 1, 80)"/>
                <xsl:call-template name="_linebreak_next_space">
                    <xsl:with-param name="text" select="substring($text, 81)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="_linebreak_next_space">
        <xsl:param name="text"/>
        <xsl:value-of select="substring-before($text, ' ')"/><xsl:text>
</xsl:text><xsl:call-template name="_linebreak-80">
    <xsl:with-param name="text" select="substring-after($text, ' ')"/>
</xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>