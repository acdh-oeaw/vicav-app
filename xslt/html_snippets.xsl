<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0" exclude-result-prefixes="xs sru fcs xd tei">
    <xsl:import href="params.xsl"/>
    <xsl:include href="html_page_includes.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>pieces of html wrapped in templates, to be reused by other stylesheets
            <xd:p>History:
            <xd:ul>
                <xd:li>2011-12-05: created by:"vr": copied from cr/html_snippets reworked back to xslt 1.0</xd:li>
            </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>Standard header for the html page
            <xd:p>
                <xd:ul>
                    <xd:li>Sets the charset to UTF-8</xd:li>
                    <xd:li>includes a customized stylesheet based on jQuery-ui 1.8.5</xd:li>
                    <xd:li>includes a CSS style sheet cmd-ui.css</xd:li>
                    <xd:li>includes a CSS style sheet cr.css</xd:li>
                    <xd:li>includes jQuery 1.6.2 (???!)</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
                TODO: what about htmljspage and jquery.treeview css/js? Enable it? Toss it?
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="html-head">
        <title>
            <xsl:value-of select="$title"/>
        </title><xsl:text>&#xA;</xsl:text>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><xsl:text>&#xA;</xsl:text>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/><xsl:text>&#xA;</xsl:text>
        <link href="{$scripts_url}style/jquery/clarindotblue/jquery-ui-1.8.5.custom.css" type="text/css" rel="stylesheet"/><xsl:text>&#xA;</xsl:text>
        <link href="{$scripts_url}style/corpusshell.css" type="text/css" rel="stylesheet"/><xsl:text>&#xA;</xsl:text>
        <link href="{$scripts_url}style/cr.css" type="text/css" rel="stylesheet"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery-1.11.2.min.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery.tablesorter.min.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript">
            var xcontext = "<xsl:value-of select="$x-context"/>";
            // set everything that should not have its default falue here before param.js is loaded.
            var switchURL = "<xsl:value-of select="$base_url_public"/>";
            var templateLocation = "<xsl:value-of select="$scripts_url"/>/js/";
            var xsltParameters = <xsl:value-of select="$parameters_as_json"/>;
        </script><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="scripts/js/params.js"/><xsl:text>&#xA;</xsl:text>
    </xsl:template>

    <xd:doc>
        <xd:desc>Standard header for the html page
            <xd:p>
                <xd:ul>
                    <xd:li>Sets the charset to UTF-8</xd:li>
                    <xd:li>includes a customized stylesheet based on jQuery-ui 1.8.5</xd:li>
                    <xd:li>includes a CSS style sheet cmd-ui.css</xd:li>
                    <xd:li>includes a CSS style sheet cr.css</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
                TODO: what about htmljspage and jquery.treeview css/js? Enable it? Toss it?
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="html-head-bootstrap"><xsl:text>&#xA;</xsl:text>
        <title>
            <xsl:value-of select="$title"/>
        </title><xsl:text>&#xA;</xsl:text>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><xsl:text>&#xA;</xsl:text>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/><xsl:text>&#xA;</xsl:text>
        <link href="{$scripts_url}style/jquery/clarindotblue/jquery-ui-1.8.5.custom.css" type="text/css" rel="stylesheet"/><xsl:text>&#xA;</xsl:text>
        <link rel="stylesheet" href="{$scripts_url}style/bootstrap-3.3.6/css/bootstrap.min.css"/><xsl:text>&#xA;</xsl:text>
        <link rel="stylesheet" href="{$scripts_url}style/bootstrap-3.3.6/css/bootstrap-theme.min.css"/><xsl:text>&#xA;</xsl:text>
        <link rel="stylesheet" href="{$scripts_url}style/awesome-bootstrap-checkbox.css"/><xsl:text>&#xA;</xsl:text>
        <link rel="stylesheet" href="{$scripts_url}style/virtual-keyboard.css"/><xsl:text>&#xA;</xsl:text>
        <link rel="stylesheet" href="{$scripts_url}style/dictionaries.css"/><xsl:text>&#xA;</xsl:text>
        <link href="{$scripts_url}style/corpusshell.css" type="text/css" rel="stylesheet"/><xsl:text>&#xA;</xsl:text>
        <link href="{$scripts_url}style/cr.css" type="text/css" rel="stylesheet"/><xsl:text>&#xA;</xsl:text>
		<link rel="stylesheet" href="{$scripts_url}style/font-awesome-4.6.1/css/font-awesome.min.css"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery-1.11.2.min.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery.tablesorter.min.js"></script><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/URI.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery.history.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery.selection.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/jquery/jquery-ui.min.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/bootstrap-3.3.6/js/bootstrap.min.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript">
            var xcontext = "<xsl:value-of select="$x-context"/>";
            // set everything that should not have its default falue here before param.js is loaded.
            var switchURL = "<xsl:value-of select="$base_url_public"/>";
            var templateLocation = "<xsl:value-of select="$scripts_url"/>/js/";
            var xsltParameters = <xsl:value-of select="$parameters_as_json"/>;
        </script><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/params.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/virtual-keyboard.js"/><xsl:text>&#xA;</xsl:text>
        <script type="text/javascript" src="{$scripts_url}js/dictionaries.js"/><xsl:text>&#xA;</xsl:text>
        <style>
		
		</style>
        <!--        <xsl:if test="contains($format,'htmljspage')">
            <link href="{$base_dir}/style/jquery/jquery-treeview/jquery.treeview.css" rel="stylesheet"/>        
            </xsl:if>-->
    </xsl:template>
    <xd:doc>
        <xd:desc>A header visible for the user
            <xd:p>
                Shows the site's name, a logo and and the contents of top-menu.
            </xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template name="page-header">
        <xsl:variable name="logo_link">
            <xsl:choose>
                <xsl:when test="not($site_url='')">
                    <xsl:value-of select="$site_url"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$base_url_public"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div class="cmds-ui-block" id="header">
            <div id="logo">
                <a href="{$logo_link}">
                    <img src="{$site_logo}" alt="{$site_name}"/>
                </a>
                <div id="site-name">
                    <xsl:value-of select="$site_name"/>
                </div>
            </div>
            <xsl:call-template name="top-menu"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>A header visible for the user
            <xd:p>
                Shows the site's name, a logo and and the contents of top-menu.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="page-header-bootstrap">
        <xsl:variable name="logo_link">
            <xsl:choose>
                <xsl:when test="not($site_url='')">
                    <xsl:value-of select="$site_url"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$base_url"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
          <div class="jumbotron">
            <xsl:if test="not($site_logo='')">
            <div id="logo">
                <a href="{$logo_link}">
                    <img src="{$site_logo}" alt="{$site_name}"/>
                </a>
            </div>
			</xsl:if>
			
			  <div id="site-name">
                 <xsl:call-template name="sitename"/>   
                </div>
             
            </div>
			<xsl:call-template name="top-menu-bootstrap"/>
    </xsl:template>
	<xsl:template name="sitename">
	<h2><xsl:value-of select="$site_name"/></h2>
	</xsl:template>

    <xd:doc>
        <xd:desc>Shows a link that leads to the xml representation of this page</xd:desc>
    </xd:doc>
    <xsl:template name="top-menu-bootstrap">
          <nav class="navbar navbar-inverse">
         <div class="container-fluid"> <div class="navbar-header">
               <button id="navtoggle" type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse" aria-expanded="false">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
               </button>
               <a class="navbar-brand" href="#"></a>
            </div>
<!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse">
                <xsl:call-template name="menu-content"/>
            </div>
         </div>
      </nav> <!--
            <xsl:variable name="link_toggle_js">
                <xsl:call-template name="formURL">
                    <xsl:with-param name="format">
                        <xsl:choose>
                            <xsl:when test="contains($format,'htmljspage')">htmlpage</xsl:when>
                            <xsl:otherwise>htmljspage</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>-->
        <xsl:call-template name="xml-links"/>
            <!--<xsl:choose>
                <xsl:when test="contains($format,'htmljspage')">
                    <a href="{$link_toggle_js}"> none js </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$link_toggle_js}"> js </a>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$user = ''">
                    <a href="workspace.jsp">    login</a>
                </xsl:when>
                <xsl:otherwise>
                        User: <b>
                        <xsl:value-of select="$user"/>
                    </b>
                    <a href="logout.jsp">    logout</a>
                </xsl:otherwise>
            </xsl:choose>
            <a target="_blank" href="static/info"> docs</a> -->
        <div id="notify" class="cmds-elem-plus note">
            <div id="notifylist" class="note"/>
        </div>

    </xsl:template>
    
    <xsl:template name="xml-links">
        <xsl:param name="additional-css-classes" select="''"/>
        <xsl:variable name="link_xml">
            <xsl:call-template name="formURL">
                <xsl:with-param name="format" select="'xml'"/>
                <xsl:with-param name="dataview" select="$x-dataview"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="link_tei">
            <xsl:call-template name="formURL">
                <xsl:with-param name="format" select="'xmltei'"/>
                <xsl:with-param name="dataview" select="$x-dataview"/>
            </xsl:call-template>               
        </xsl:variable>
        <a class="link-fcs-xml {$additional-css-classes}" href="{$link_xml}">fcs/xml</a>
        <xsl:choose>
            <xsl:when test="//tei:TEI">
                <xsl:text> </xsl:text><a class="link-tei {$additional-css-classes}" href="{$link_tei}">TEI</a>
            </xsl:when>
            <xsl:when test="//tei:teiHeader|//tei:front|//tei:entry">
                <xsl:text> </xsl:text><a class="link-tei {$additional-css-classes}" href="{$link_tei}">TEI</a>
            </xsl:when>
        </xsl:choose>        
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Shows a link that leads to the xml representation of this page</xd:desc>
    </xd:doc>
    <xsl:template name="top-menu">
        <!--
            <xsl:variable name="link_toggle_js">
                <xsl:call-template name="formURL">
                    <xsl:with-param name="format">
                        <xsl:choose>
                            <xsl:when test="contains($format,'htmljspage')">htmlpage</xsl:when>
                            <xsl:otherwise>htmljspage</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>-->
            <xsl:call-template name="xml-links"/>
            <!--<xsl:choose>
                <xsl:when test="contains($format,'htmljspage')">
                    <a href="{$link_toggle_js}"> none js </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{$link_toggle_js}"> js </a>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$user = ''">
                    <a href="workspace.jsp">    login</a>
                </xsl:when>
                <xsl:otherwise>
                        User: <b>
                        <xsl:value-of select="$user"/>
                    </b>
                    <a href="logout.jsp">    logout</a>
                </xsl:otherwise>
            </xsl:choose>
            <a target="_blank" href="static/info"> docs</a> -->
        <div id="notify" class="cmds-elem-plus note">
            <div id="notifylist" class="note"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Menu content-container</xd:desc>
    </xd:doc>
    <xsl:template name="menu-content">        
        <ul class="nav navbar-nav">
            <li id="li-search"><a>Search</a></li>
            <li id="li-language"><a>Help</a></li>
            <li id="li-impressum"><a>Impressum</a></li>
            <li id="li-settings"><a>Settings</a></li>
        </ul>
    </xsl:template>

    <xd:doc>
        <xd:desc>Main content-container 
            <xd:p>
                Shows search-ui and other content.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="page-content">
    <input type="checkbox" value="unused" checked="checked" style="display: none;" id="exampleToggle"/>
    <div id="main">
        <xsl:call-template name="front"/>
        <xsl:call-template name="continue-root"/>
        <xsl:call-template name="help"/>
        <xsl:call-template name="impressum"/>
        <xsl:call-template name="settings"/>
    </div>     
    </xsl:template>

    <xd:doc>
        <xd:desc>Provides query controls
        <xd:p>Note: This is included in the operation specific parts of the style sheet and htmljs pages.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="query-input">
    
    <!-- QUERYSEARCH - BLOCK -->
        <div class="cmds-ui-block init-show" id="querysearch">
            <div class="header ui-widget-header ui-state-default ui-corner-top">
                Search
            </div>
            <div class="content" id="query-input">
                <!-- fill form@action with <xsl:call-template name="formURL"/> will not work, 
                        because the parameter have to be encoded as input-elements  not in the form-url  
                    -->
                <!--<form id="searchretrieve" action="{$base_url}" method="get">-->
                <form id="searchretrieve" action="{$base_url_public}" method="get">
                    <input type="hidden" name="x-format" value="{$format}"/>
                    <input type="hidden" name="operation" value="{$operation}"/>
                    <input type="hidden" name="version" value="1.2"/> 
                    <input type="hidden" name="x-dataview" value="{//fcs:x-dataview}"/>
                    <input type="hidden" name="maximumRecords" value="{$maximumRecords}"/>
                    <xsl:if test="$queryType != ''">
                        <input type="hidden" name="queryType" value="{$queryType}"/> 
                    </xsl:if>
                    <!--<table class="cmds-ui-elem-stretch">
                        <tr>
                            <td colspan="2">
                    -->
                    <fieldset class="contexts form-group">
                        <label>Context</label>
                        <xsl:call-template name="contexts-select"/>
                    </fieldset>
                    <xsl:call-template name="br"/>
                    <fieldset class="query form-group">
                    <xsl:call-template name="queryTextUI"/>
<!--                                <div id="searchclauselist" class="queryinput inactive"/>-->
                       <!--     </td>
                            <td>
                       -->
                    <input class="btn btn-default" type="submit" value="submit" id="submit-query"/>
                    <div class="loader"><img src="{$scripts_url}/style/img/ajax-loader.gif"/></div>
                    </fieldset>
                    
                    <!--<xsl:call-template name="br"/>-->
                                <!--<span id="switch-input" class="cmd"/>
                                <label>Complex query</label>-->
                          <!--  </td>
                        </tr>
                        <tr>
                            <td valign="top">                                    
                                        
							<!-\-  selected collections  -\->
							<!-\- <label>Collections</label><xsl:call-template name="br"/>-\->
                                <div id="collections-widget" class="c-widget"/>
                            </td>
                            <td valign="top">
                                <xsl:call-template name="result-paging"/>
                            </td>
                            <td/>
                        </tr>
                    </table>-->
                </form>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template name="queryTextUI">
        <input type="text" id="input-simplequery" name="query" value="{$q}" class="queryinput active" data-context="{$x-context}"/>
    </xsl:template>
    
    <xsl:template name="additional-search-ui-controls"/>
    
    <xd:doc>
        <xd:desc>Provides information to the user about the position in a search response that spans multiple pages</xd:desc>
    </xd:doc>
    <xsl:template name="result-paging">
        <span class="label">from:</span>
        <span>
            <input type="text" name="startRecord" class="value start_record paging-input">
                <xsl:attribute name="value">
                    <xsl:value-of select="$startRecord"/>
                </xsl:attribute>
            </input>
        </span>
        <span class="label">max:</span>
        <span>
            <input type="text" name="maximumRecords" class="value maximum_records paging-input">
                <xsl:attribute name="value">
                    <xsl:choose>
                        <xsl:when test="number($numberOfRecords) &gt; 0 and number($numberOfRecords) &lt; number($maximumRecords)">
                            <xsl:value-of select="$numberOfRecords"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$maximumRecords"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </input>
        </span>
        <input type="submit" value="" class="cmd cmd_reload"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Provides controls for going forward and back in searches that span multiple pages</xd:desc>
    </xd:doc>
    <xsl:template name="prev-next">
        <xsl:variable name="prev_startRecord">
            <xsl:choose>
                <xsl:when test="number($startRecord) - number($maximumRecords) &gt; 0">
                    <xsl:value-of select="format-number(number($startRecord) - number($maximumRecords),'#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="next_startRecord">
            <xsl:choose>
                <xsl:when test="number($startRecord) + number($maximumRecords) &gt; number($numberOfRecords)">
                    <xsl:value-of select="$startRecord"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-number(number($startRecord) + number($maximumRecords),'#')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="link_prev">
            <xsl:call-template name="formURL">
                <xsl:with-param name="startRecord" select="$prev_startRecord"/>
                <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="prev-enabled" select="not($startRecord = '1')"/>
        <xsl:variable name="link_next">
            <xsl:call-template name="formURL">
                <xsl:with-param name="startRecord" select="$next_startRecord"/>
                <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="next-enabled" select="number($startRecord) + number($maximumRecords) &lt; number($numberOfRecords)"/>
        <xsl:if test="$numberOfRecords &gt; 0">
            <span class="result-navigation prev-next">
                <xsl:if test="$prev-enabled">
                    <a class="internal prev" href="{$link_prev}">
                        <span class="cmd_prev"/>
                    </a>
                </xsl:if>
                <span class="result-pager value hilight">
                    <xsl:value-of select="$startRecord"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="(number($startRecord) + number(sru:extraResponseData/fcs:returnedRecords) - 1)"/>
                </span>
                <xsl:if test="$next-enabled">
                    <a class="internal next" href="{$link_next}">
                        <span class="cmd_next"/>
                    </a>
                </xsl:if>
            </span>
        </xsl:if>
    </xsl:template>

    <xsl:template name="number-of-records">
        <p class="xsl-number-of-records">Showing <span class="fcs-returnedRecords"><xsl:value-of select="(sru:extraResponseData/fcs:returnedRecords)+number($startRecord)-1"/></span> out of <span class="fcs-numberOfRecords"><xsl:value-of select="number($numberOfRecords)"/></span> hits</p>
    </xsl:template>

    <xd:doc>
        <xd:desc>Provides a querylistblock HTML div element which is manipulated by JavaScript</xd:desc>
    </xd:doc>
    <xsl:template name="query-list">
<!-- QUERYLIST BLOCK -->
        <div id="querylistblock" class="cmds-ui-block">
            <div class="header ui-widget-header ui-state-default ui-corner-top">
                <span>QUERYLIST</span>
            </div>
            <div class="content" id="querylist"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Provides a detailblock HTML div element which is manipulated by JavaScript</xd:desc>
    </xd:doc>
    <xsl:template name="detail-space">
        <div id="detailblock" class="cmds-ui-block">
            <div class="header ui-widget-header ui-state-default ui-corner-top">
                <span>DETAIL</span>
            </div>
            <div class="content" id="details"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Provides a public-space HTML div element which is manipulated by JavaScript</xd:desc>
    </xd:doc>
    <xsl:template name="public-space">
        <div id="public-space" class="cmds-ui-block">
            <div class="header">
                <span>Public Space</span>
            </div>
            <div id="serverqs" class="content"/>
        </div>
    </xsl:template>
    <xd:doc>
        <xd:desc>Provides HTML elements for a Personal Workspace which is manipulated by JavaScript</xd:desc>
    </xd:doc>
    <xsl:template name="user-space">
        <div class="cmds-ui-block init-show" id="user-space">
            <div class="header">
                <span>Personal Workspace</span>
            </div>
            <div id="userqs" class="content">
                <div id="userquerysets">
                    <label>Querysets</label>
                    <select id="qts_select"/>
				<!--  <button id="qts_add" class="cmd cmd_add" >Add</button> -->
                    <span id="qts_add" class="cmd cmd_add"/>
                    <span id="qts_delete" class="cmd cmd_del"/>
                </div>
                <label>name</label>
                <input type="text" id="qts_input"/>
                <span id="qts_save" class="cmd cmd_save"/>
                <div id="userqueries"/>
            </div>
            <div id="userbs" class="content">
                <div id="bookmarksets">
                    <label>Bookmarksets</label>
                    <select id="bts_select"/>
                    <span id="bts_add" class="cmd cmd_add"/>
                    <span id="bts_delete" class="cmd cmd_del"/>
                    <span id="bts_publish" class="cmd cmd_publish"/>
                </div>
                <label>name</label>
                <input type="text" id="bts_input"/>
                <span id="bts_save" class="cmd cmd_save"/>
                <div id="bookmarks"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="help">
        <div class="container" id="help">
        Help
        </div>
    </xsl:template>
    <xsl:template name="impressum">
        <div class="container" id="impressum">
            <xsl:call-template name="getTEIHeader"/>
        </div>
    </xsl:template>
    <xsl:template name="settings">
        <div class="container" id="settings">
            <xsl:call-template name="additional-search-ui-controls"/>
        </div>
    </xsl:template>
    <xsl:template name="front">
       <div class="container" id="front">
           <xsl:call-template name="getTEIFrontPart"/>           
        </div>
     </xsl:template>
</xsl:stylesheet>