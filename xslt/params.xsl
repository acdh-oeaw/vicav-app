<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sru="http://www.loc.gov/zing/srw/"
    xmlns:zr="http://explain.z3950.org/dtd/2.0/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fcs="http://clarin.eu/fcs/1.0"
    xmlns:exsl="http://exslt.org/common"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xsl sru zr xs fcs exsl xd" version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>Central definition of all parameters the style sheets take
            <xd:p>
                The following are needed in commons_v1.xsl (formURL) and in html_snippets.xsl, therefore they need to be defined here
                (but only as default, so we could move them, because actually they pertain only to result2view.xsl:
                <xd:ul>
                    <xd:li>
                        <xd:ref name="operation" type="parameter">operation</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="format" type="parameter">format</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="sort" type="parameter">sort</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="q" type="parameter">q</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="x-context" type="parameter">x-context</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="cr_project" type="parameter">cr_project</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="startRecord" type="parameter">startRecord</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="maximumRecords" type="parameter">maximumRecords</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="numberOfRecords" type="parameter">numberOfRecords</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="numberOfMatches" type="parameter">numberOfMatches</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="mode" type="parameter">mode</xd:ref>
                    </xd:li>
                    <xd:li>
                        <xd:ref name="fcs_prefix" type="parameter">fcs_prefix</xd:ref>
                    </xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>???</xd:desc>
    </xd:doc>
    <xsl:param name="user" select="''"/>
    <xd:doc>
        <xd:desc>
            <xd:p>
                Defaults to an empty xs:string.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="title" select="''"/>
    <xd:doc>
        <xd:desc>A URL that is used by this style sheet to build links and fetch additional data
            <xd:p>
                Corresponds to //sru:baseUrl. If this is an empty string links used in this style sheet point back
                to the URL that executed the style sheet. If this is not an SRU aware endpoint strange warnings and
                behaviors can be expected.
            </xd:p>
            <xd:p>
                Examples:
                <xd:ul>
                    <xd:li>
                        <xd:a href="https://minervar.arz.oeaw.ac.at/switch">https://minervar.arz.oeaw.ac.at/switch</xd:a>
                    </xd:li>
                    <xd:li>
                        <xd:a href="http://clarin.aac.ac.at/cr/lrp/fcs">http://clarin.aac.ac.at/cr/lrp/fcs</xd:a>
                    </xd:li>
                    <xd:li>http://localhost/corpus_shell/modules/fcs-aggregator/switch.php</xd:li>
                    <xd:li>The URL has to be reachable by the XSLT processor so sth. like this is possible: http://localhost:8686/exist/rest/db/cr/cr.xql</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
                Defaults to an empty xs:string.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="base_url" select="''"/>
    <xd:doc>
        <xd:desc>A user name that may be needed to access resources used by these xsl transforms</xd:desc>
    </xd:doc>
    <xsl:param name="scripts_user" select="''"/>
    <xd:doc>
        <xd:desc>A password associated with scripts_user</xd:desc>
    </xd:doc>
    <xsl:param name="scripts_pw" select="''"/>
    <xd:doc>
        <xd:desc>A URL that is used by this style sheet to construct URLs to the cr-xq root for public exposal
            <xd:p>Since base_url might also be something like './', we need a explicit public url when constructing links to the application.</xd:p>
            <xd:p>
                Defaults to <xd:ref type="parameter" name="base_url">$base_url</xd:ref>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="base_url_public" select="$base_url"/>
    <xd:doc>
        <xd:desc>part of the URL for fcs-endpoint (minus <xd:ref name="base_url" type="parameter">$base_url</xd:ref>)
            <xd:p>
                Defaults to an empty xs:string.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="fcs_prefix" select="''"/>
    <xd:doc>
        <xd:desc>to be put as link on the logo in simple html pages </xd:desc>
    </xd:doc>
    <xsl:param name="site_url" select="'https://cs.acdh-dev.oeaw.ac.at/'"/>
    
    <xd:doc>
        <xd:desc>A URL for locating JavaScript scripts and CSS style sheets
        <xd:p>
            Note: If this parameter is supplied it has to end in a path separator (/)!
        </xd:p>
            <xd:p>
            Note: These paths are meant for the user's browser so localhost is usually not an option!
        </xd:p>
            <xd:p>
            If this is an empty string the location of the files are interpreted relativ to the URL that
            executed the style sheet respectively the document generated by the style sheet.
        </xd:p>
            <xd:p>
            Usually passed by the script 
            <xd:a href="../phpdocs/config/_utils-php---config.php.html#global$scriptsUrl">switch.php</xd:a>.
        </xd:p>
            <xd:p>
            Examples:
            <xd:ul>
                    <xd:li>../../</xd:li>
                    <xd:li>https://minervar.arz.oeaw.ac.at/cs2/corpus_shell/scripts/</xd:li>
                    <xd:li>Only for testing purpose on your development machine: http://localhost/corpus_shell/</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
            Defaults to an empty string
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="scripts_url" select="''"/>
    <xd:doc>
        <xd:desc>A URL-prefix for the rest-endpoint
            <xd:p>
                Defaults to /exist/restxq/cr-xq/
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="rest_prefix">/exist/restxq/cr-xq</xsl:param>
    <xd:doc>
        <xd:desc>A URL where a logo for the site can be found
            <xd:p>
                Defaults to <xd:ref name="scripts_url" type="parameter">$scripts_url</xd:ref> . 'style/logo_c_s.png'
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="site_logo" select="concat($scripts_url, 'style/logo_c_s.png')"/>
    <xd:doc>
        <xd:desc>Name of the site
            <xd:p>
                Defaults to 'Repository'
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="site_name">Repository</xsl:param>
    
    
    <!-- following are needed in in commons_v1.xsl (formURL) and in html_snippets.xsl, therefore they need to be defined here
        (but only as default, so we could move them, because actually they pertain only to result2view.xsl -->
    <xd:doc>
        <xd:desc>Operation for which this template should do the transformation 
            <xd:p>One of
                <xd:ul>
                    <xd:li>explain</xd:li>
                    <xd:li>scan</xd:li>
                    <xd:li>searchRetrieve</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
                Defaults to nothing.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="operation"/>
    <xd:doc>
        <xd:desc>Requested order of the results
            <xd:p>One of text or size.</xd:p>
            <xd:p>No default value, as this would override index-defined default ordering.</xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>Requested format of the result
            <xd:p>One of htmlpage, htmljspage or htmlsimple or something completely different.
                Most importantly this chooses between four different frameworks for the page with more or less
                building blocks. Unrecognizeable strings generate only the least possible amount of HTML.</xd:p>
            <xd:p>Possible intended future use: Mix and match parts needed by the application:</xd:p>
            <xd:p>One a combination of
                <xd:ul>
                    <xd:li>"html" to actually generate an HTML framework as opposed to an AJAX HTML fragment + one of
                        <xd:ul>
                            <xd:li>"page"</xd:li>
                            <xd:li>"js" generate an HTML page that utilises JavaScript</xd:li>
                            <xd:li>"simple" generate a simple HTML page</xd:li>
                        </xd:ul>
                    </xd:li>
                    <xd:li>"list" represent the SRU items as a list</xd:li>
                    <xd:li>"detail" add detail information</xd:li>
                </xd:ul>
            </xd:p>
            <xd:p>
                Examples would be: htmlsimpledetail or htmljslist
            </xd:p>
            <xd:p>
                Defaults to 'htmlpagelist'.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="format" select="'htmlpagetable'"/>
    <xd:doc>
        <xd:desc>The query sent by the client
            <xd:p>
                Defaults to /sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:query
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="q" select="/sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:query"/>
    <xd:doc>
        <xd:desc>The query sent by the client
            <xd:p>
                Defaults to empty.
                Possible values:
                <xd:ul>
                    <xd:li>native</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="queryType"/>
    <xd:doc>
        <xd:desc>The x-context (x-cmd-context) the client specified
            <xd:p>
                Defaults to //fcs:x-context 
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="x-context" select="/sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/fcs:x-context|
                                        /sru:explainResponse/sru:record/sru:recordData/zr:explain/zr:serverInfo/zr:database"/>
    <xd:doc>
        <xd:desc>The x-dataiew the client specified
            <xd:p>
                Defaults to a comma separated list of all dataviews the returned xml contains.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="x-dataview">
        <xsl:call-template name="string-join">
            <xsl:with-param name="nodes-to-join" select="//fcs:DataView[not(ancestor::fcs:DataView)]/@type"/>
            <xsl:with-param name="join-with" select="','"/>
        </xsl:call-template>
    </xsl:param>
    <xd:doc>
    <xd:desc>cr_xq specific parameter: The id of the cr_xq project the user is operating in.
            <xd:p>
                Defaults to <xd:ref name="x-context" type="parameter">$x-context</xd:ref>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="cr_project" select="''"/>
    <xd:doc>
        <xd:desc>The start record the client requested or the one the upstream endpoint chose
            <xd:p>
                Defaults to /sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:startRecord
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="startRecord" select="/sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:startRecord"/>
    <xd:doc>
        <xd:desc>The maximum number of records the client requested or the one the upstream endpoint chose
            <xd:p>
                Defaults to /sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:maximumRecords
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="maximumRecords" select="/sru:searchRetrieveResponse/sru:echoedSearchRetrieveRequest/sru:maximumRecords"/>
    <xd:doc>
        <xd:desc>The maximum number of terms in scan the client requested or the one the upstream endpoint chose
            <xd:p>
                Defaults to /sru:scanResponse/sru:echoedScanRequest/sru:maximumTerms
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="maximumTerms" select="/sru:scanResponse/sru:echoedScanRequest/sru:maximumTerms"/>    
    <xd:doc>
        <xd:desc>The position within the list of terms returned where the client would like the start term to occur.
            <xd:p>
                Defaults to /sru:searchRetrieveResponse/sru:numberOfRecords
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="responsePosition" select="/sru:scanResponse/sru:echoedScanRequest/sru:responsePosition"/>
    <xd:doc>
        <xd:desc>The actual number of records in the response
            <xd:p>
                Defaults to /sru:searchRetrieveResponse/sru:numberOfRecords
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="numberOfRecords" select="/sru:searchRetrieveResponse/sru:numberOfRecords"/>
    <xd:doc>
        <xd:desc>How the result terms of a scan should be sorted
            <xd:p>
                Defaults to 'x', default sorting.
                Possible values:
                <xd:ul>
                    <xd:li>s=size</xd:li>
                    <xd:li>n=name</xd:li>
                    <xd:li>t=time</xd:li>
                    <xd:li>x=default</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="sort" select="'x'"/>
    <xd:doc>
        <xd:desc>The number of matches records in the response
            <xd:p>
                Defaults to /sru:searchRetrieveResponse/sru:extraResponseData/fcs:numberOfMatches
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="numberOfMatches" select="/sru:searchRetrieveResponse/sru:extraResponseData/fcs:numberOfMatches"/>
    <xd:doc>
        <xd:desc>???
            <xd:p>
                Defaults to 'html'
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="mode" select="'html'"/>
    <xd:doc>
        <xd:desc>The scanClause specified by the client
            <xd:p>
                Defaults to /sru:scanResponse/sru:echoedScanRequest/sru:scanClause.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="scanClause" select="/sru:scanResponse/sru:echoedScanRequest/sru:scanClause"/>
    
    <xd:doc>
        <xd:desc>The index is defined as the part of the scanClause or query before the operator (e. g. '=')
            <xd:p>
                This is one possibility according to the
                <xd:a href="http://www.loc.gov/standards/sru/specs/scan.html">SRU documentation</xd:a>.
                The documentation states that scanClause can be "expressed as a complete index, relation, term clause in CQL". 
            </xd:p>
            <xd:p>
                Note: for the special scan clause fcs.resource this is an empty string.
                See <xd:a href="http://www.w3.org/TR/xpath/#function-substring-before">.XPath language definition</xd:a>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="index">
        <xsl:choose>
            <xsl:when test="substring-before($scanClause,'=')">
                <xsl:value-of select="substring-before($scanClause,'=')"/>
            </xsl:when>
            <xsl:when test="substring-before($scanClause,'&lt;')">
                <xsl:value-of select="substring-before($scanClause,'=')"/>
            </xsl:when>
            <xsl:when test="substring-before($scanClause,'>')">
                <xsl:value-of select="substring-before($scanClause,'=')"/>
            </xsl:when>
            <xsl:when test="substring-before($scanClause,' ')">
                <xsl:value-of select="substring-before($scanClause,'=')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$scanClause"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    
    <xd:doc>
        <xd:desc>The operator is defined as the part of the scanClause or query
            <xd:p>Note: has to be passed in, cannot be computed xsl 1.0</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="operator" select="''"/>
    
    <xd:doc>
        <xd:desc>The searchString is defined as the part of the scanClause or query
            <xd:p>Note: has to be passed in, cannot be computed xsl 1.0</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="searchString" select="''"/>               
    
    <xd:doc>
        <xd:desc>The filter is defined as the part of the scanClause after the '='
            <xd:p>
                This is one possibility according to the
                <xd:a href="http://www.loc.gov/standards/sru/specs/scan.html">SRU documentation</xd:a>.
                The documentation states that scanClause can be "expressed as a complete index, relation, term clause in CQL". 
            </xd:p>
            <xd:p>
                Note: for the special scan clause fcs.resource this is an empty string.
                See <xd:a href="http://www.w3.org/TR/xpath/#function-substring-after">.XPath language definition</xd:a>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="filter" select="substring-after($scanClause,'=')"/>
    
    <xd:doc>
        <xd:desc>Standard callback from / template
            <xd:p>
                <xd:ul>
                    <xd:li>If a htmlpage is requested generates input elements for the user to do another scan.</xd:li>
                    <xd:li>Wraps the HTML representation of the result terms in an HTML div element.</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc>The fcs:x-filter for filtering scan (scanClause is for entry point into the index)
            <xd:p>
                Defaults to an empty xs:string.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="x-filter" select="''"/>
    
    <xd:doc>
        <xd:desc>A URL that returns any contexts an endpoint provides
            <xd:p>
                Defaults to $base_url + ?operation=scan&amp;scanClause=fcs.resource&amp;sort=text&amp;version=1.2&amp;x-format=xml.
            </xd:p>
            <xd:p>
                Note: If $base_url is the empty string (the default) then this calls back to whatever URL this style sheet is
                executed from. Of course this doesn't work on a local hard drive so there may be warnings when processing the
                style sheet.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="contexts_url" select="concat($base_url,'?version=1.2&amp;operation=scan&amp;scanClause=fcs.resource&amp;sort=text&amp;x-format=xml')"/>
    <xd:doc>
        <xd:desc>A URL that returns the explain operation for the current x-context
            <xd:p>
                Defaults to $base_url + '?version=1.2&amp;operation=explain&amp;x-context=' + $x-context + '&amp;x-format=xml'.
            </xd:p>
            <xd:p>
                Note: If $base_url is the empty string (the default) then this calls back to whatever URL this style sheet is
                executed from. Of course this doesn't work on a local hard drive so there may be warnings when processing the
                style sheet.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="indexes_url" select="concat($base_url,'?version=1.2&amp;operation=explain&amp;x-context=', $x-context, '&amp;x-format=xml')"/>
    <xd:doc>
        <xd:desc>A URL to a file where additional parameters can be specified</xd:desc>
    </xd:doc>
    <xsl:param name="mappings-file" select="''"/>
    
    <xd:doc>
        <xd:desc>A comma separated list of languages the user knows.</xd:desc>
    </xd:doc>
    <xsl:param name="user_langs" select="'en'"/>
    
    <xsl:variable name="userLangs">
        <xsl:call-template name="tokenize">
            <xsl:with-param name="text" select="$user_langs"/>
            <xsl:with-param name="delimiter" select="','"/>
        </xsl:call-template>
    </xsl:variable>
    
    <xd:doc>
        <xd:desc>XDebug passthrough</xd:desc>
        <xd:p>The XDebug PHP server debugging tool activates itsself depending on this special parameter.</xd:p>
        <xd:p>So as a service pass this parameter on by appending it to all generated links as is if it is present.</xd:p>
    </xd:doc>
    <xsl:param name="XDEBUG_SESSION_START" select="''"/>
    
    <xd:doc>
        <xd:desc>A file containing translation strings
        <xd:p>
            Example:
            <xd:pre>
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;dict>
    &lt;list xml:lang="en_US">
        &lt;item key="positioning">Positioning&lt;/item>
    &lt;/list>
    &lt;list xml:lang="de_DE">
        &lt;item key="typology">Typologie&lt;/item>
    &lt;/list>
&lt;/dict>               
            </xd:pre>
        </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:param name="dict_file" select="'dict.xml'"/>
    
    <xd:doc>
        <xd:desc>The language used for looking up translateable strings</xd:desc>
    </xd:doc>
    <xsl:param name="dict_lang" select="'en_US'"/>
    
    <xd:doc>
        <xd:desc>The location of the fcs endpoint relative to the base-url (used in the <xd:ref name="formURL" type="template">formURL</xd:ref> template to build links.</xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>URL parameter that contained the context for the operation</xd:desc>
    </xd:doc>
    <xsl:variable name="context-param" select="'x-context'"/>
    <xd:doc>
        <xd:desc>A map with additional settings</xd:desc>
    </xd:doc>
    <xsl:variable name="mappings" select="exsl:node-set(document($mappings-file)/map)"/>
    <xd:doc>
        <xd:desc>The settings for <xd:ref name="x-context" type="parameter">$x-context</xd:ref> contained in 
        <xd:ref name="mappings" type="variable">mappings</xd:ref>
        </xd:desc>
        <xd:p>
            The XML atrribute key is taken from the XSL context where this variable is evaluated so the context
            should be an XML element that has a key attribute.
        </xd:p>
    </xd:doc>
    <xsl:variable name="context-mapping" select="$mappings//map[@key][xs:string(@key) = $x-context]"/>
    <xd:doc>
        <xd:desc>The settings for default contained in <xd:ref name="mappings" type="variable">mappings</xd:ref>
            <xd:p>
                The XML atrribute key is taken from the XSL context where this variable is evaluated so the context
                should be an XML element that has a key attribute.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="default-mapping" select="$mappings//map[@key][xs:string(@key) = 'default']"/>
    <xd:doc>
        <xd:desc>A parameter that can contains all the parameters passed to the XSL processor as JSON
            <xd:p>
                Defaults to the empty object {}.
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:variable name="parameters_as_json" select="'{}'"/>
    
</xsl:stylesheet>
