module namespace vicav = "http://acdh.oeaw.ac.at/vicav";

import module namespace cors = 'https://www.oeaw.ac.at/acdh/tools/vle/cors' at 'cors.xqm';
import module namespace api-problem = "https://tools.ietf.org/html/rfc7807" at "api-problem.xqm";

declare namespace bib = 'http://purl.org/net/biblio#';
declare namespace dc = 'http://purl.org/dc/elements/1.1/';
declare namespace tei = 'http://www.tei-c.org/ns/1.0';
declare namespace dcterms = "http://purl.org/dc/terms/";
declare namespace prof = "http://basex.org/modules/prof";
declare namespace response-codes = "https://tools.ietf.org/html/rfc7231#section-6";
declare namespace test = "http://exist-db.org/xquery/xqsuite";

import module namespace openapi="https://lab.sub.uni-goettingen.de/restxqopenapi" at "3rd-party/openapi4restxq/content/openapi.xqm";
import module namespace util = "https://www.oeaw.ac.at/acdh/tools/vle/util" at "3rd-party/vleserver_basex/vleserver/util.xqm";
import module namespace u = "http://basex.org/modules/util";

(:~
 : VICAV API
 :
 : An API for retrieving the various VICAV TEI documents rendered either as XHTML snippets or JSON
 :)
 
(:~
 : get the API description
 :
 : OpenAPI 3.0 JSON description of the API
 :)
declare
    %rest:path('/vicav/openapi.json')
    %rest:produces('application/json')
    %output:media-type('application/json')
function vicav:getOpenapiJSON() as item()+ {
    openapi:json(file:base-dir())
};

declare function vicav:expandExamplePointers($in as item(), $dict as document-node()*) {
    typeswitch ($in)
        case text()
            return
                $in
        case attribute()
            return
                $in
        case document-node()
            return
                document {
                    vicav:expandExamplePointers($in/*, $dict)
                }
        case element(tei:ptr)
            return
                $dict//tei:cit[@xml:id = $in/@target]
        case element(tei:ref)
            return
                $dict//tei:cit[@xml:id = replace($in/@target, '#', '')]
        case element()
            return
                (: element { QName( namespace-uri($in), local-name($in) ) } { for $node in $in/node() return wde:expandExamplePointers($node, $dict) } :)
                element {QName(namespace-uri($in), local-name($in))} {
                    for $i in ($in/@*, $in/node())
                    return
                        vicav:expandExamplePointers($i, $dict)
                }
        default
            return
                $in
};

declare function vicav:distinct-nodes($nodes as node()*) as node()* {
    for $seq in (1 to count($nodes))
    return
        $nodes[$seq][not(vicav:is-node-in-sequence(., $nodes[position() < $seq]))]
};

declare function vicav:is-node-in-sequence
($node as node()?,
$seq as node()*) as xs:boolean {
    
    some $nodeInSeq in $seq
        satisfies $nodeInSeq is $node
};

declare function vicav:get_project_name() as xs:string {
    let $project := doc('vicav_projects/projects.xml')/projects/project[matches(try{request:hostname()} catch basex:http {()}, @regex)]/text()
    return if (empty($project) or $project = '') then doc('vicav_projects/projects.xml')/projects/project[1]/text() else $project
};

declare function vicav:get_project_db() as xs:string {
    let $project := vicav:get_project_name()

    let $out := if (empty($project) or $project = '' or $project = 'vicav') then 
        '' 
        else 
            "/" || $project
    return $out
};

declare
%rest:path("/vicav/project")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:project_config() {
  let $hash := if (exists(try{collection('prerendered_json')} catch err:FODC0002 {()}))
               then xs:string(collection('prerendered_json')//json/ETag/text())
               else ()
    , $hashBrowser := request:header('If-None-Match', '')
  return if ($hash and ($hash = $hashBrowser)) then api-problem:return_problem(prof:current-ns(),
    <problem xmlns="urn:ietf:rfc:7807">
      <type>https://tools.ietf.org/html/rfc7231#section-6</type>
      <title>{$api-problem:codes_to_message(304)}</title>
      <status>304</status>
    </problem>,
  map:merge((cors:header(()), vicav:return_content_header(), map{
      'X-UA-Compatible': 'IE=11'
    , 'Cache-Control': 'public, max-age=2, must-revalidate'
    , 'ETag': $hash
    })))
  else api-problem:or_result (prof:current-ns(),
    vicav:_project_config#0, [], map:merge((cors:header(()), vicav:return_content_header(),
    if ($hash) then map{
      'X-UA-Compatible': 'IE=11'
    , 'Cache-Control': 'public, max-age=2, must-revalidate'
    , 'ETag': $hash
    } else ()))
  )
};

declare function vicav:return_content_header() {
  let $first-accept-header := replace(try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }, '^([^,]+).*', '$1')
  return switch ($first-accept-header)
  case '' return map{}
  default return map{'Content-Type': $first-accept-header||';charset=UTF-8'}
};

declare
function vicav:_project_config() {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $publicURI := try { replace(util:get-base-uri-public(), '/project', '') } catch basex:http { '' }
    let $path := 'vicav_projects/' || vicav:get_project_name() || '.xml'
    let $config := if (doc-available($path)) then doc($path)/projectConfig else <projectConfig><menu></menu></projectConfig>
    return if (matches($accept-header, '[+/]json'))
    then
      let $jsonAsXML := 
        if (exists(try{collection('prerendered_json')} catch err:FODC0002 {()}))
        then collection('prerendered_json')//json
         update {insert node <cached type="boolean">true</cached> as first into ./projectConfig,
       .//text()[contains(., '{{host_name}}')]!(replace value of node . with replace(., '{{host_name}}/{{path}}', $publicURI, 'q'))}
        else vicav:project_config_json_as_xml($publicURI) update {insert node <cached type="boolean">false</cached> as first into ./json/projectConfig}
      return serialize($jsonAsXML, map {"method": "json", "indent": "no"})
    else let $renderedMenu := xslt:transform($config/menu, 'xslt/menu.xslt')
      return <project><config>{$config}</config><renderedMenu>{$renderedMenu}</renderedMenu></project>
};

declare function vicav:project_config_json_as_xml($publicURI as xs:string) {
    let $path := 'vicav_projects/' || vicav:get_project_name() || '.xml',
        $config := if (doc-available($path)) then doc($path)/projectConfig else <projectConfig><menu></menu></projectConfig>,
        $jsonAsXML := xslt:transform($config, 'xslt/menu-json.xslt', map{'baseURIPublic': $publicURI}),
        $jsonAsXML := $jsonAsXML update {
          .//*[starts-with(local-name(), "insert_")]!(replace node . with vicav:get_insert_data(local-name()))
        },
        $hash := xs:string(xs:hexBinary(hash:md5($jsonAsXML))),
        $res := $jsonAsXML/json update {
          insert node <ETag>{$hash}</ETag> into .
        }
    return $res
};

declare function vicav:get_insert_data($type as xs:string) {
  switch ($type)
    case "insert_featurelist" return <_ type="object">{vicav:get_featurelist()}</_>
    case "insert_variety_data" return <_ type="object">{vicav:get_variety_data()}</_>
    case "insert_taxonomy" return <_ type="object">{vicav:get_taxonomy()}</_>
    case "insert_list_of_corpus_characters" return vicav:get_list_of_corpus_characters()
    default return <_ type="object">{json:parse(vicav:_get_tei_doc_list(replace($type, '^insert_', '')))/json/*}</_>
};

declare function vicav:get_list_of_corpus_characters() as element(specialCharacters) {
  <specialCharacters>{
    for $c in sort(distinct-values(collection('vicav_corpus')//text()[normalize-space() ne '']!u:chars(normalize-unicode(.,'NFC')))[not(matches(., '[-/()\[\]0-9a-zA-z<>,.;:+*?!~%=#"&apos;]|\s'))]) return
    <_ type="object"><value>{$c}</value></_>
  }</specialCharacters> 
};

declare function vicav:get_variety_data() {
  collection("wibarab_varieties")//json/*
};

declare function vicav:get_featurelist() {
  let $docs := collection('wibarab_features')//tei:TEI
  let $result :=
  map:merge((
    for $doc in $docs
    let $filename := fn:tokenize(base-uri($doc), '/')[last()]
    where starts-with($filename, 'feature')
    return
        map {
           string($doc/@xml:id): 
                map {
                    "title": string($doc//tei:title),
                    "values": map:merge((
                        let $items := $doc//tei:list[@type = "featureValues"]/tei:item
                        for $item in $items
                        return map {string($item/@xml:id): string($item/tei:label)}))
                    }
                }
          ))
        
   return json:parse(serialize($result, map {"method": "json", "indent": "no"}), map {"format": "direct"})/json/*
};

declare function vicav:get_taxonomy() {
  let $docs := collection('wibarab_features')//tei:TEI
  let $dmp := $docs[fn:tokenize(base-uri(.), '/')[last()] = 'wibarab_dmp.xml']
  let $mainCategories := $dmp//tei:taxonomy/tei:category
  let $result :=
     map:merge((
      for $category in $mainCategories
      let $id := string($category/@xml:id)
      let $title := string($category/tei:catDesc)
      let $subcategories := $category/tei:category
      return
        if (empty($subcategories)) then
          map:entry($id, map { "title": $title })
        else
          map:entry($id, map { 
            "title": $title, 
            "subcategories": map:merge(
              for $sub in $subcategories
              return map:entry(string($sub/@xml:id), string($sub/tei:catDesc))
            )
          })
    ))

  return json:parse(serialize($result, map {"method": "json", "indent": "no"}), map {"format": "direct"})/json/*
};

declare
%updating
%rest:path("/vicav/project")
%rest:PUT
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:prerender_project_config() {
  let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' },
      $publicURI := '{{host_name}}/{{path}}',
      $prerenderedFileName := $publicURI||'/prerendered_json.xml',
      $jsonAsXml := api-problem:or_result (prof:current-ns(),
    vicav:project_config_json_as_xml#1, [$publicURI], map:merge((cors:header(()), vicav:return_content_header()))
  ),
      $res := if (matches($accept-header, '[+/]json')) 
        then ($jsonAsXml[1],$jsonAsXml[2]) 
        else ($jsonAsXml[1],serialize($jsonAsXml[2], map {'method': 'xml'}))
  return (
    if (db:exists('prerendered_json')) then db:replace('prerendered_json', $prerenderedFileName, $jsonAsXml[2])
    else db:create('prerendered_json', $jsonAsXml[2], $prerenderedFileName),
    update:output($res)
  )
};

declare
%rest:path("/vicav/biblio")
%rest:query-param("query", "{$query}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:GET

function vicav:query_biblio($query as xs:string*, $xsltfn as xs:string) {
    let $queries := tokenize($query, ',')
    let $qs :=
    for $query in $queries
    return
        if (contains($query, 'geo:')) then
            '[dc:subject[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
        else
            if (contains($query, 'reg:')) then
                '[dc:subject[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
            else
                if (contains($query, 'vt:')) then
                    '[dc:subject[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
                else
                    '[.//node()[text() contains text "' || $query || '" using wildcards]]'
    
    let $ns := "declare namespace bib = 'http://purl.org/net/biblio#'; " ||
    "declare namespace rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'; " ||
    "declare namespace foaf= 'http://xmlns.com/foaf/0.1/'; " ||
    "declare namespace dc = 'http://purl.org/dc/elements/1.1/';"
    let $q := 'let $arts := collection("/vicav_biblio")//node()[(name()="bib:Article") or 
    (name()="bib:Book") or (name()="bib:BookSection") or (name()="bib:Thesis")]' ||
    string-join($qs) ||
    'for $art in $arts ' ||
    'let $author := $art/bib:authors[1]/rdf:Seq[1]/rdf:li[1]/foaf:Person[1]/foaf:surname[1] ' ||
    'order by $author return $art'
    let $query := $ns || $q
    let $results := xquery:eval($query)
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $num := count($results)
    let $results := <results num="{$num}">{$results}</results>
    let $sHTML := xslt:transform-text($results, $style)
    return
        (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
        $sHTML)
};

declare
%rest:path("/vicav/biblio_tei")
%rest:query-param("query", "{$query}")
%rest:query-param("xslt", "{$xsltfn}")
%test:arg("query", "Skoura")
%rest:produces("application/xml")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
%rest:GET
function vicav:query_biblio_tei($query as xs:string*, $xsltfn as xs:string?) {
  let $generateQuery := not(empty($xsltfn))
  let $xsltfn := if (empty($xsltfn)) then "biblio_tei_01.xslt" else $xsltfn
  return api-problem:or_result (prof:current-ns(),
    vicav:_query_biblio_tei#3, [$query, $xsltfn, $generateQuery], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_query_biblio_tei($query as xs:string*, $xsltfn as xs:string, $generateQuery as xs:boolean) {
    let $queries := tokenize($query, '\+')
    let $qs :=
    for $query in $queries     
    return                
        if (contains($query, 'date:')) then
           '[.//tei:date[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (contains($query, 'title:')) then
           '[.//tei:title[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (contains($query, 'pubPlace:')) then
           '[.//tei:pubPlace[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (contains($query, 'author:')) then
           '[.//tei:author/tei:surname[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (contains($query, 'geo:') or contains($query, 'reg:') or contains($query, 'diaGroup:')) then
           '[.//tei:note[@type="tag"]/tei:name[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (contains($query, 'vt:')) then
           '[.//tei:note[@type="tag"][text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (contains($query, 'prj:')) then
           '[.//tei:note[@type="tag"][text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
        else if (starts-with($query, 'zotid:')) then
           '[@corresp = "http://zotero.org/groups/2165756/items/' || substring-after($query, ':') ||'"]'
        else
           '[.//node()[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'  
    
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'let $arts := ' ||
    'collection("/vicav_biblio'  || vicav:get_project_db() || '")//tei:biblStruct' ||
    string-join($qs) ||
    'for $art in $arts ' ||
    'let $author := ' ||
    '  if ($art/tei:analytic) ' ||
    '     then ($art/tei:analytic[1]/tei:author[1]/tei:surname[1] | 
                $art/tei:analytic[1]/tei:author[1]/tei:name[1] | 
                $art/tei:analytic[1]/tei:editor[1]/tei:surname[1] | 
                $art/tei:analytic[1]/tei:editor[1]/tei:name[1]) ' ||
    '     else ($art/tei:monogr[1]/tei:author[1]/tei:surname[1] | 
                $art/tei:monogr[1]/tei:author[1]/tei:name[1] | 
                $art/tei:monogr[1]/tei:editor[1]/tei:surname[1] | 
                $art/tei:monogr[1]/tei:editor[1]/tei:name[1]) ' ||
    'let $date := $art/tei:monogr[1]/tei:imprint[1]/tei:date[1] ' ||
    'order by $author[1],$date[1] return $art'
    let $query2 := $ns || $q
    let $results := xquery:eval($query2)
    
    let $num := count($results)
    
    let $results := <results
        num="{$num}">{$results}</results>
    let $sHTML := vicav:transform($results, $xsltfn, (), map{
      'generateQuery': xs:string($generateQuery)
    })
    return
      $sHTML
        
};

declare
%rest:path("/vicav/biblio_id")
%rest:query-param("query", "{$query}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:GET

function vicav:query_biblio_id($query as xs:string*, $xsltfn as xs:string) {
    let $ids := tokenize($query, ' ')
    let $bibls :=
    for $id in $ids
    return
        collection("/vicav_biblio" || vicav:get_project_db())//tei:biblStruct[@corresp = 'http://zotero.org/groups/2165756/items/' || $id]
    
    let $results :=
    for $bibl in $bibls
    let $author :=
    if ($bibl/tei:analytic)
    then
        ($bibl/tei:analytic[1]/tei:author[1]/tei:surname[1] | $bibl/tei:analytic[1]/tei:author[1]/tei:name[1] | $bibl/tei:analytic[1]/tei:editor[1]/tei:surname[1] | $bibl/tei:analytic[1]/tei:editor[1]/tei:name[1])
    else
        ($bibl/tei:monogr[1]/tei:author[1]/tei:surname[1] | $bibl/tei:monogr[1]/tei:author[1]/tei:name[1] | $bibl/tei:monogr[1]/tei:editor[1]/tei:surname[1] | $bibl/tei:monogr[1]/tei:editor[1]/tei:name[1])
    
    let $date := $bibl/tei:monogr[1]/tei:imprint[1]/tei:date[1]
    order by $author[1],$author[2],$date
    return
        $bibl
    
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $num := count($results)
    let $results := <results
        num="{$num}">{$results}</results>
    let $sHTML := xslt:transform-text($results, $style)
    return
        $sHTML
};

declare function vicav:transform($doc as element(), $xsltfn as xs:string, $print as xs:string?, $options as map(*)?) {
    let $stylePath := file:resolve-path('xslt/', file:base-dir())
    let $style := doc(file:resolve-path('xslt/' || $xsltfn, file:base-dir()))

    let $xslt := if (empty($print)) then $style else xslt:transform-text(
        doc(file:resolve-path('xslt/printable.xslt', file:base-dir()))
        , doc(file:resolve-path('xslt/printable_path.xslt', file:base-dir())), map {'xslt': file:path-to-uri(file:resolve-path('xslt/' || $xsltfn, file:base-dir()))})

    let $sHTML := xslt:transform-text($doc, $xslt, $options)
    return
        $sHTML
};

declare
%rest:path("/vicav/profile")
%rest:GET
%rest:query-param("id", "{$id}")
%test:arg("id", "profile_amman_01")
%rest:query-param("coll", "{$coll}", "/vicav_profiles")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("print", "{$print}")
%rest:produces("application/xml")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_profile($coll as xs:string, $id as xs:string*, $xsltfn as xs:string*, $print as xs:string*) {
  let $generateTeiMarker := exists($xsltfn)
  let $xsltfn := if (exists($xsltfn)) then $xsltfn else "profile_vue.xslt"
  return api-problem:or_result (prof:current-ns(),
    vicav:_get_document_transformed#6, [$coll, $id, $xsltfn, $print, $generateTeiMarker, '/profile'], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare
%rest:path("/vicav/ling_feature")
%rest:GET
%rest:query-param("id", "{$id}")
%rest:query-param("print", "{$print}")
%test:arg("id", "ling_features_baghdad")
function vicav:get_ling_feature($id as xs:string?, $print as xs:string*) {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_document_transformed#6, ['vicav_lingfeatures', $id, 'features_01.xslt', $print, false(), '/ling_feature'], map:merge((cors:header(()), vicav:return_content_header())))
};

declare function vicav:_get_document_transformed($coll as xs:string, $id as xs:string*,
  $xsltfn as xs:string*, $print as xs:string*, $generateTeiMarker as xs:boolean,
  $endpoint as xs:string) {
  let $doc := collection($coll || vicav:get_project_db())/descendant::tei:TEI[@xml:id=$id],
      $doc-exists := if (exists($doc)) then true()
	                 else error(xs:QName('response-codes:_404'), 
                                $api-problem:codes_to_message(404), 'A document with xml:id '||$id|| ' does not exist in '|| $coll || vicav:get_project_db() || '.')
  return vicav:transform($doc,
     $xsltfn, $print, map{
          'param-base-path': replace(util:get-base-uri-public(), $endpoint, ''),
          'tei-link-marker': xs:string($generateTeiMarker),
          "print-url": concat(
             request:uri(), "?", request:query(), "&amp;print=true" 
          )
        }
     )
};

declare
%rest:path("/vicav/sample")
%rest:query-param("coll", "{$coll}")
%rest:query-param("id", "{$id}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("print", "{$print}")

%rest:GET

function vicav:get_sample($coll as xs:string*, $id as xs:string*, $xsltfn as xs:string*, $print as xs:string*) {
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $xsltfn := if (exists($xsltfn)) then $xsltfn else "sampletext_01.xslt"

    let $q := 'collection("/vicav_samples' || vicav:get_project_db() || '")/descendant::tei:TEI[@xml:id="' || $id || '"]'
    let $query := $ns || $q
    let $results := xquery:eval($query)
    return 
        (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
        vicav:transform($results, $xsltfn, $print, map{
            "print-url": concat(
                request:uri(), "?", request:query(), "&amp;print=true" 
            )
        }))
};


declare
%rest:path("/vicav/features")
%rest:query-param("ana", "{$ana}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("expl", "{$expl}")

%rest:GET

function vicav:get_lingfeatures($ana as xs:string*, $expl as xs:string*, $xsltfn as xs:string) {
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("/vicav_lingfeatures'  || vicav:get_project_db() ||'")//tei:cit[@type="featureSample" and (.//tei:w[contains-token(@ana,"' || $ana || '")][1] or .//tei:phr[contains-token(@ana,"' || $ana || '")][1])]'
    let $query := $ns || $q    
    let $results := xquery:eval($query)
    
    let $ress := 
      for $item in $results
        let $city := $item/../../tei:head/tei:name[@type='city']
        let $country := $item/../../tei:body/tei:head/tei:name[@type='country']
        return
           <item city="{$city}">{$item}</item>
    let $ress1 := <items>{$ress}</items>

    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $sHTML := xslt:transform-text($ress1, $style, map {"highLightIdentifier":$ana,"explanation":$expl})
    
    return 
        (:<div type="lingFeatures">{$sHTML}</div>:)
        (: <r>{$query}</r> :)
        (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
        $sHTML)
};

declare function vicav:query_clause($name as xs:string, $args as xs:string+) as xs:string {
    let $filtered := for $a in $args
                        return if ($a) then $a 
                    else 
                        ()
    let $left := if (count($filtered) > 1) then '(' else ''
    let $right := if (count($filtered) > 1) then ')' else ''

    let $out := $left || string-join($filtered, ' ' || $name || ' ') || $right
    return $out
};  

declare function vicav:or($args as xs:string+) as xs:string {
    let $out := vicav:query_clause('or', $args)
    return $out
};  


declare function vicav:and($args as xs:string+) as xs:string {
    let $out := vicav:query_clause('and', $args)
    return $out
};  


declare function vicav:explore-query(
    $collection as xs:string,
    $location as xs:string*, 
    $word as xs:string*,
    $person as xs:string*, 
    $age as xs:string*, 
    $sex as xs:string*
) as xs:string {
    let $ps := for $p in tokenize($person, ',')
            return "'" || $p || "'" 

    let $person_q := if (not(empty($ps))) then
        '(./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person/text() = ['|| string-join($ps, ',') ||'])'
        else ''

    let $words_q := for $w in tokenize($word, ',')
            let $match_str := if (contains($w, '*')) then
                '[matches(.,"(^|\W)' || replace($w, '\*', '.*') || '($|\W)")][1]'
                else 
                '[contains-token(.,"' || $w || '")][1]'
            return 
                vicav:or(('./tei:text/tei:body/tei:div//tei:w' || $match_str, './tei:text/tei:body/tei:div//tei:w/tei:fs/tei:f' || $match_str, './tei:text/tei:body/tei:div//tei:phr' || $match_str))

    let $word_q := if (empty($words_q)) then '' else vicav:or($words_q)

    let $age_bounds := if ($age) then
            for $a in tokenize($age, ',')
            order by number($a)
            return $a
        else ()

    let $age_q := if (not(empty($age_bounds)) and ($age_bounds[2] != "100" or $age_bounds[1] != "0")) then
        vicav:and((
            '(number(./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age) > ' || min($age_bounds) || ')',
            ' (number(./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age) < ' || max($age_bounds) || ')'
        ))
        else ''

    let $sex_qqs := if (not(empty($sex))) then
        for $s in tokenize($sex, ',')
            return '"' || lower-case($s) || '"'
        else ()

    let $sex_q := if (not(empty($sex_qqs))) then
        ' (./tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person/@sex = [' || string-join($sex_qqs, ',') || '])'
        else ''

    let $loc_qs := tokenize($location, ',')

    let $location_q := if(not(empty($loc_qs))) then 
        let $loc_queries := for $loc_q in $loc_qs
            let $l := if (contains($loc_q, ':'))
                then (tokenize($loc_q, ':')[1], tokenize($loc_q, ':')[2])
                else ('settlement', $loc_q)

            return switch ($l[1])
                case 'region'
                    return './tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:region/text() = "' || $l[2] || '"'
                case 'country'
                    return './tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:country/text() = "' || $l[2] || '"'
                default
                    return vicav:or((
                        './tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name/text() = "' || $l[2] || '"',
                        './tei:text/tei:body/tei:head/tei:name/text() = "' || $l[2] || '"'
                    ))

        return vicav:or($loc_queries)

    else
        ""

    let $loc_word_age_sex_q := if ($location_q != '' or $word_q != '' or $age_q != '' or $sex_q != '') then vicav:and(($location_q, $word_q, $age_q, $sex_q)) else ''

    let $full_tei_query := if ($person_q != '' and $location_q != '') then vicav:or(($person_q, $loc_word_age_sex_q)) else
        vicav:and(($person_q, $loc_word_age_sex_q))

    let $full_tei_query := if (not($full_tei_query = '')) then
        '[' || $full_tei_query || ']'
        else
        $full_tei_query

    let $query := 'declare namespace tei = "http://www.tei-c.org/ns/1.0"; collection("' || $collection ||'")/descendant::tei:TEI'
        || $full_tei_query

    return $query
};

declare function vicav:explore-data(
    $collection as xs:string,
    $location as xs:string*, 
    $word as xs:string*,
    $person as xs:string*, 
    $age as xs:string*, 
    $sex as xs:string*
) as element() {
    let $query := vicav:explore-query($collection, $location, $word, $person, $age, $sex)
    let $results := xquery:eval($query)

    let $ress :=
      for $item in $results
        let $city := $item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name[@xml:lang="en"]/text()
        let $informant := $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text()
        let $age := $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age
        let $sex := $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@sex

        return
           <item city="{$city}" informant="{$informant}" age="{$age}" sex="{$sex}">{$item}</item>
    let $ress1 := <items>{$ress}</items>
    return $ress1
};


declare
%rest:path("/vicav/explore_samples")
%rest:query-param("type", "{$type}")
%rest:query-param("location", "{$location}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("word", "{$word}")
%rest:query-param("comment", "{$comment}")
%rest:query-param("features", "{$features}")
%rest:query-param("translation", "{$translation}")
%rest:query-param("highlight", "{$highlight}")
%rest:query-param("person", "{$person}")
%rest:query-param("age", "{$age}")
%rest:query-param("sex", "{$sex}")
%rest:query-param("print", "{$print}")
%rest:GET

function vicav:explore_samples(
    $type as xs:string*, 
    $location as xs:string*, 
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*, 
    $comment as xs:string*,
    $person as xs:string*, 
    $age as xs:string*, 
    $sex as xs:string*, 
    $highlight as xs:string*, 
    $xsltfn as xs:string,    
    $print as xs:string*
    ) {

    let $resourcetype := if (empty($type) or $type = '') then 
            "samples"
        else 
            $type

    let $filter_features := if ((empty($word) or $word = '') and (empty($features) or $features = '')) then 
            if ($resourcetype = 'samples') then "1" else ''
        else 
            if (empty($word) or $word = '') then 
                if ($resourcetype = 'samples') then replace($features, '[^\d,]+', '') else replace($features, '[^\w:,_]+', '')
            else ""

    let $trans_filter := if (empty($translation)) then '' else $translation
    let $comment_filter := if (empty($comment)) then '' else  lower-case($comment)

    (:let $ress := vicav:explore-query(
        'vicav_' || $resourcetype || vicav:get_project_db(),
        $location, 
        $word,
        $person, 
        $age, 
        $sex
    ):)

    let $items := vicav:explore-data(
        'vicav_' || $resourcetype || vicav:get_project_db(),
        $location, 
        $word,
        $person, 
        $age, 
        $sex
    )/item

    let $ress1 := <items
        location="{$location}"
        word="{$word}"
        person="{$person}"
        features="{$features}"
        age="{$age}"
        sex="{$sex}"
        translation="{$translation}"
        comment="{$comment}">{$items}</items>

    let $sHTML := if ((empty($location) or $location = '') and (empty($person) or $person = '')) then
        vicav:transform($ress1, "cross_" || $resourcetype || "_summary_01.xslt", $print, map {
            "highlight":string($word),
            "filter-words": string($word),
            "filter-features":$filter_features,
            "filter-translations": $trans_filter,
            "filter-comments": $comment_filter
        })
    else
        vicav:transform($ress1, $xsltfn, $print, map {
            "highlight":string($word),
            "filter-words": string($word),
            "filter-features":$filter_features,
            "filter-translations": $trans_filter,
            "filter-comments": $comment_filter,
            "print-url": concat(
                request:uri(), "?", request:query(), "&amp;print=true" 
            )
        })

    return
        (:<div type="lingFeatures">{$sHTML}</div>:)
        (:$ress1:)
        (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
        $sHTML)
};

declare function vicav:compare-features-query(
    $collection as xs:string,
    $ids as xs:string*, 
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*,
    $comment as xs:string*
) as xs:string {
    let $ids_q := for $id in tokenize($ids, ",") return '"'|| $id || '"'
    let $id_q := if (empty($ids_q)) then "" else 
        "[@xml:id = [" || string-join($ids_q, ',') || "]]"

    let $words_q := for $w in tokenize($word, ',')
            let $match_str := if (contains($w, '*')) then
                '[matches(.,"(^|\W)' || replace($w, '\*', '.*') || '($|\W)")][1]'
                else 
                '[contains-token(.,"' || $w || '")][1]'
            return 
                vicav:or(('./tei:quote/tei:w' || $match_str, 
                './tei:quote/tei:w/tei:fs/tei:f' || $match_str, 
                './tei:quote/tei:phr/tei:w/tei:fs/tei:f' || $match_str))
    let $features_q := for $f in tokenize($features, ",") return '"'|| $f || '"'
    let $ana_q := if (empty($features_q)) then '' else '@ana = ['|| string-join($features_q, ",") ||']'

    let $feature_q := if (empty($features_q)) then '' else vicav:or(
        ('./' || $ana_q ,
        './tei:quote/tei:w[' || $ana_q || '][1]',
        './tei:quote/tei:choice[' || $ana_q || '][1]',
        './tei:quote/tei:w/tei:fs/tei:f[' || $ana_q || '][1]', 
        './tei:quote/tei:phr/tei:w/tei:fs/tei:f[' || $ana_q || '][1]'
        )
    )

    let $transls_q := for $t in tokenize($translation, ',')
            let $match_str := 'contains(.,"' || $t || '")'
            return 
                vicav:or(('./tei:cit/tei:quote[' || $match_str || '][1]', 
                './tei:quote/tei:w/tei:fs/tei:f[@type="translation" and ' || $match_str || '][1]'
                ))
    let $transl_q := if (empty($transls_q)) then '' else vicav:or($transls_q)

    let $comments_q := for $c in tokenize($comment, ',')
     return vicav:or(
        ('./tei:quote/tei:w/tei:fs/tei:f[@name="comment" and ' ||
     'contains(translate(.,"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "' 
     || $c || '")][1]',
     './tei:quote/tei:phr/tei:w/tei:fs/tei:f[@name="comment" and ' ||
     'contains(translate(.,"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "' 
     || $c || '")][1]' 
     ))
                
    let $comment_q := if (empty($comments_q)) then '' else vicav:or($comments_q)
    let $word_q := if (empty($words_q)) then '' else vicav:or($words_q)
     (: return $feature_q :)
    
    let $full_tei_query := vicav:and((vicav:and(($word_q, $transl_q, $comment_q,
    $feature_q))))

    let $full_tei_query := if (not($full_tei_query = '')) then
        '[' || $full_tei_query || ']'
        else
        $full_tei_query

    let $query := 'declare namespace tei = "http://www.tei-c.org/ns/1.0"; collection("' || 
        $collection ||'")/descendant::tei:TEI' || $id_q || '/tei:text/tei:body/tei:div/tei:div/tei:cit[@type="featureSample"]'
        || $full_tei_query

    return $query
};

declare function vicav:compare-data(
    $resourcetype as xs:string, 
    $ids as xs:string,
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*, 
    $comment as xs:string*
    ) {

    let $features_filter := if ((empty($word) or $word = '') and (empty($features) or $features = '')) then 
            ''
        else 
            if ($resourcetype = 'samples') then replace($features, '[^\d,]+', '') else replace($features, '[^\w:,_]+', '')
            
    let $comment_filter := if (empty($comment)) then '' else  lower-case($comment) 
    let $trans_filter := if (empty($translation)) then '' else $translation
    let $query := if ($resourcetype = "samples") then
    vicav:compare-samples-query(
        'vicav_' || $resourcetype || vicav:get_project_db(),
        $ids,
        $word,
        $features_filter,
        $trans_filter,
        $comment_filter
    )
    else vicav:compare-features-query(
        'vicav_' || $resourcetype || vicav:get_project_db(),
        $ids,
        $word,
        $features_filter,
        $trans_filter,
        $comment_filter
    )
    return xquery:eval($query)
};

declare function vicav:compare-samples-query(
    $collection as xs:string,
    $ids as xs:string*, 
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*,
    $comment as xs:string*
) as xs:string {
    let $ids_q := for $id in tokenize($ids, ",") return '"'|| $id || '"'
    let $id_q :=  if (empty($ids_q)) then "" else 
        "[@xml:id = [" || string-join($ids_q, ',') || "]]"

    let $words_q := for $w in tokenize($word, ',')
        let $match_str := if (contains($w, '*')) then
            '[matches(.,"(^|\W)' || replace($w, '\*', '.*') || '($|\W)")][1]'
            else 
            '[contains-token(.,"' || $w || '")][1]'
        return 
            vicav:or(('./tei:w' || $match_str, 
            './tei:w/tei:fs/tei:f' || $match_str, 
            './tei:phr/tei:w/tei:fs/tei:f' || $match_str))
    let $features_q := for $f in tokenize($features, ",") return '"'|| $f || '"'
    let $feature_q := if (empty($features_q)) then '' 
        else './@n = ['|| string-join($features_q, ",") ||']'

    let $transls_q := for $t in tokenize($translation, ',')
        let $match_str := 'contains(.,"' || $t || '")'
        return vicav:or((
            '../../tei:div[@type="translationSentence"]/tei:s[' || $match_str || '][1]', 
            './tei:w/tei:fs/tei:f[@type="translation" and ' || $match_str || '][1]'
        ))
    let $transl_q := if (empty($transls_q)) then '' else vicav:or($transls_q)

    let $comments_q := for $c in tokenize($comment, ',')
     return vicav:or(
        ('./tei:w/tei:fs/tei:f[@name="comment" and ' ||
     'contains(translate(.,"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "' 
     || $c || '")][1]',
     './tei:phr/tei:w/tei:fs/tei:f[@name="comment" and ' ||
     'contains(translate(.,"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "' 
     || $c || '")][1]' 
     ))
                
    let $comment_q := if (empty($comments_q)) then '' else vicav:or($comments_q)
    let $word_q := if (empty($words_q)) then '' else vicav:or($words_q)
    
    let $full_tei_query := vicav:and(($word_q, $transl_q, $comment_q,
        $feature_q))

    let $full_tei_query := if (not($full_tei_query = '')) then
        '[' || $full_tei_query || ']'
        else
        $full_tei_query

    let $query := 'declare namespace tei = "http://www.tei-c.org/ns/1.0"; collection("' || 
        $collection ||
        '")/descendant::tei:teiCorpus/tei:TEI' || $id_q ||
        '/tei:text/tei:body/tei:div[@type="sampleText"]/tei:p/tei:s'
        || $full_tei_query

    return $query
};


declare
%rest:path("/vicav/compare_markers")
%rest:query-param("type", "{$type}")
%rest:query-param("ids", "{$ids}")
%rest:query-param("word", "{$word}")
%rest:query-param("comment", "{$comment}")
%rest:query-param("features", "{$features}")
%rest:query-param("translation", "{$translation}")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_compare_markers(
   $type as xs:string, 
    $ids as xs:string,
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*, 
    $comment as xs:string* 
) {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_compare_markers#6, [
    $type, 
    $ids,
    $word,
    $features,
    $translation, 
    $comment], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_compare_markers(
    $type as xs:string, 
    $ids as xs:string,
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*, 
    $comment as xs:string*
) {  
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $entries := vicav:compare-data(
        $type, 
        $ids,
        $word,
        $features,
        $translation, 
        $comment)

    let $ids := distinct-values(vicav:get-root($entries)/@xml:id)
    
    let $dataType := if ($type = 'lingfeatures') then "Feature" else "SampleText" 

    let $out :=
        for $item in $entries
        group by $locName := vicav:get-root($item)/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement[1]/tei:name[@xml:lang="en"]/text()
        let $loc := replace(vicav:get-root($item[1])/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text(), '(\d+(\.|,)\s*\d+,\s*\d+(\.|,)\s*\d+).*', '$1')
        return
        
            <r
                type='geo'>
                <loc>{$loc}</loc>
                (: <loc type="decimal">{$item//tei:geo[@decls="decimal"]/text()}</loc> :)
                <locName>{$locName}</locName>
                <alt>{$locName}</alt>
                <freq>{count($entries[vicav:get-root(.)/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement[1]/tei:name[@xml:lang="en"]/text() = $locName])}</freq>
                <params>
                    <dataType>{$dataType}</dataType>
                    <ids>{string-join(distinct-values(vicav:get-root($item)/@xml:id), ",")}</ids>
                    <features>{$features}</features>
                    <translation>{$translation}</translation>
                    <comment>{$comment}</comment>
                    <word>{$word}</word>
                </params>
            </r>
    
    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>,
        'xslt/bibl-markers-json.xslt',
        map{"target-type": "ExploreSamples"})
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else <rs>{$out}</rs>
};

declare
%rest:path("/vicav/compare")
%rest:query-param("type", "{$type}")
%rest:query-param("ids", "{$ids}")
%rest:query-param("word", "{$word}")
%rest:query-param("comment", "{$comment}")
%rest:query-param("features", "{$features}")
%rest:query-param("translation", "{$translation}")
%rest:query-param("highlight", "{$highlight}")
%rest:query-param("page", "{$page}")
%rest:query-param("print", "{$print}")
%rest:GET
function vicav:compare(
    $type as xs:string, 
    $ids as xs:string,
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*, 
    $comment as xs:string*,
    $highlight as xs:string*, 
    $page as xs:string*,   
    $print as xs:string*
    ) {
api-problem:or_result (prof:current-ns(),
    vicav:_get_compare#9, [
        $type, 
        $ids,
        $word,
        $features,
        $translation, 
        $comment,
        $highlight, 
        $page,   
        $print
    ], map:merge((cors:header(()), vicav:return_content_header()))
)  
};

declare function vicav:_get_compare(
    $type as xs:string, 
    $ids as xs:string,
    $word as xs:string*,
    $features as xs:string*,
    $translation as xs:string*, 
    $comment as xs:string*,
    $highlight as xs:string*, 
    $page as xs:string*,   
    $print as xs:string*
)  {
    let $resourcetype := if (empty($type) or $type = '') then 
        "samples"
    else 
        $type
    
    let $pagevalue := number(if (empty($page) or $page = '') then "1" else $page)

    let $filter-features := if (empty($features) or $features = '') then "" else tokenize($features, ",")

    let $data := vicav:compare-data($resourcetype, $ids, $word, $features, $translation, $comment)
    
    let $sorted := for $entry in $data
                    order by ($entry/@ana, $entry/@n)[1]
                    return $entry
    let $paged := subsequence($sorted, ($pagevalue - 1) * 100 + 1, $pagevalue * 100)

    let $ress := 
        for $item in $paged
        group by $feature := ($item/@ana, $item/@n)
        return
        <feature name="{$feature}" label="{$item[1]/tei:lbl}" count="{count($item)}">
            {for $item-in-feature in $item 
            group by $region := vicav:get-root($item-in-feature)/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:region
            return <region name="{$region}" count="{count($item)}">{
                for $item-in-region in $item-in-feature
                group by $settlement := vicav:get-root($item-in-region)/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name[@xml:lang="en"]
                return <settlement name="{$settlement}">{
                    for $i in $item-in-region
                    return 
                        <item xml:id="{vicav:get-root($i)/@xml:id}" 
                        informant="{vicav:get-root($i)/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]}" 
                        age="{vicav:get-root($i)/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age}" 
                        sex="{vicav:get-root($i)/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@sex}" 
                        >{$i}{
                            if ($resourcetype = "samples") then
                            $i/../../../tei:div[@type="dvTranslations"]/tei:p/tei:s[@n = $i/@n] 
                            else ()
                        }</item>
                }</settlement>
            }
            </region>
            }
        </feature>

    (: let $features := distinct-values(($data/@ana, $data/@n)) :)

    let $ress1 := <items count="{count($data)}" pages="{(count($data) idiv 100) + 1}">{$ress}</items>
    (: return $ress1  :)

    return vicav:transform($ress1, "cross_" || $resourcetype || "_03.xslt", $print, map {
        (: "features": $features or , :)
        "page": $pagevalue,
        "filter-features": $filter-features,
        "highlight":string($word),
        "print-url": concat(
            request:uri(), "?", request:query(), "&amp;print=true" 
        )
    })
};


declare
function vicav:get-root($item) {
    $item/../../../../..
};


(:~
 : get a description text
 :
 : Retrieve a description TEI text found in the DB.
 : 
 : @param $id ID of a description TEI text found in the DB.
 :           May start with li_
 : @param $xsltfn XSL used to rencer the TEI (defaults to vicavTexts.xslt)
 :
 : @return A rendered HTML of the description TEI text.
 :)
declare
%rest:path("/vicav/text")
%rest:query-param("id", "{$id}")
%test:arg("id", "li_vicavMission")
%rest:query-param("xslt", "{$xsltfn}")
%rest:GET
%rest:produces("application/xml")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_text($id as xs:string, $xsltfn as xs:string?) {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_text#2, [$id, $xsltfn], map:merge((cors:header(()), vicav:return_content_header()))
  )  
};

declare function vicav:_get_text($id as xs:string, $xsltfn as xs:string?) {
    let $id := replace($id, '^li_', '')
    let $generateTeiMarker := exists($xsltfn)
    let $xsltfn := if (exists($xsltfn)) then $xsltfn else "vicavTexts.xslt" 
    let $results := collection("/vicav_texts")//tei:div[@xml:id=$id] 
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $sHTML := xslt:transform-text($results, $style, map{
      'param-base-path': replace(util:get-base-uri-public(), '/text', ''),
      'tei-link-marker': xs:string($generateTeiMarker)})
    return $sHTML        
};

declare
%rest:path("/vicav/dict_index")
%rest:query-param("dict", "{$dict}")
%rest:query-param("ind", "{$ind}")
%rest:query-param("str", "{$str}")

%rest:GET

function vicav:query-index___($dict as xs:string, $ind as xs:string, $str as xs:string) {
    let $rs := 
    (: it seems there is a bug right now in 9.7.2 that prevents us from using this here. Check later if it still exists. :)
    (: (# db:enforceindex #) { :)
    switch ($ind)
        case "any"
            return
                collection($dict)//index/w[text() contains text { $str } using wildcards]
        default return
            if ($str = '*')
            then
                collection($dict)//index[@id = $ind]/w
            else
                collection($dict)//index[@id = $ind]/w[text() contains text { $str } using wildcards]
    (: } :)

let $rs2 := <res>{
        for $r in $rs
           let $replString := concat("[",$str,"]")
           let $a := replace($r/text(), $str, $replString)
           let score $score := $r/text() contains text { $str } using wildcards
           order by $score descending
           (: return :) 
            (: <w index="{$r/../@id}">{$a}</w> :)              

        return
            <w index="{$r/../@id}">{ft:mark($r[text() contains text { $str } using wildcards], 'hi')/node()}</w>
    }</res>

let $style := doc('xslt/index_2_html.xslt')
let $ress := <results>{subsequence($rs2, 1, 500)}</results>
let $sReturn := xslt:transform($ress, $style)
return
    (web:response-header(map {'method': 'xml'}, map:merge((cors:header(()), vicav:return_content_header()))),
    $sReturn)
    (: $rs :)
};

declare function vicav:createMatchString($in as xs:string) {
    let $s := replace($in, '"', '')
    let $s1 :=
    if (contains($s, '*') or contains($s, '.') or contains($s, '^') or contains($s, '$') or contains($s, '+'))
    then
        'matches(., "' || $s || '")'
    else
        '.="' || $s || '"'
    return
        $s1
};

declare
%rest:path("/vicav/dicts_api")
%rest:query-param("query", "{$query}")
%rest:query-param("dicts", "{$dicts}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("print", "{$print}")
%rest:GET

function vicav:dicts_query($dicts as xs:string, $query as xs:string*, $xsltfn as xs:string, $print as xs:string?) {
    let $nsTei := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $queries := tokenize($query, ',')
    let $qs :=
    for $query in $queries
    let $terms := tokenize(normalize-space($query), '=')
    return
        switch (normalize-space($terms[1]))
            case 'any'
                return '[.//node()[' || vicav:createMatchString($terms[2]) || ']]'
            case 'lem'
                return '[tei:form[@type="lemma"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'lemma'
                return '[tei:form[@type="lemma"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'infl'
                return '[tei:form[@type="inflected"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'inflType'
                return '[tei:form[@type="inflected"][@ana="#' || $terms[2] || '"]]'
            case 'en'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="en"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'de'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="de"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'fr'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="fr"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'es'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="es"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'etymLang'
                return '[tei:etym/tei:lang[' || vicav:createMatchString($terms[2]) || ']]'
            case 'etym' 
                return '[tei:etym/tei:mentioned[' || vicav:createMatchString($terms[2]) || ']]'
            case 'root'
                return '[tei:gramGrp/tei:gram[@type="root"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'stem'
                return '[tei:gramGrp/tei:gram[@type="subc"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'subc'
                return '[tei:gramGrp/tei:gram[@type="subc"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'pos' 
                return '[tei:gramGrp/tei:gram[@type="pos"][' || vicav:createMatchString($terms[2]) || ']]'
            default return
                ()

let $dictsTemp := tokenize($dicts, ',')

let $qq :=
   for $seq in (1 to count($dictsTemp))
     return 
       if ($seq = 1) 
         then
           'collection("' || $dictsTemp[$seq] || '")//tei:entry' || string-join($qs)
         else 
           ',collection("' || $dictsTemp[$seq] || '")//tei:entry' || string-join($qs)
         
       
let $sQuery := $nsTei || string-join($qq)
let $results := xquery:eval($sQuery)

let $ress := <results xmlns="http://www.tei-c.org/ns/1.0">{$results}</results>
let $sReturn := vicav:transform($ress, $xsltfn, $print, map{
  "query": $query,
  "dicts": $dicts
})
return
  (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
  $sReturn)
  (: $query :)
};

declare
%rest:path("/vicav/dict_api")
%rest:query-param("query", "{$query}")
%rest:query-param("dict", "{$dict}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("print", "{$print}")
%rest:GET

function vicav:dict_query($dict as xs:string, $query as xs:string*, $xsltfn as xs:string, $print as xs:string?) {
    (: let $user := substring-before($autho, ':')
  let $pw := substring-after($autho, ':') :)
    
    let $nsTei := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $queries := tokenize($query, ',' )
    let $qs :=
    for $query in $queries
    let $terms := tokenize(normalize-space($query), '=')
    return
        switch (normalize-space($terms[1]))
            case 'any'
                return '[.//node()[' || vicav:createMatchString($terms[2]) || ']]'
            case 'id'
                return '[@xml:id="' || $terms[2] || '"]'
            case 'lem'
                return '[tei:form[@type="lemma"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'lemma'
                return '[tei:form[@type="lemma"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'infl'
                return '[tei:form[@type="inflected"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'inflType'
                return 
                (
                  let $s1 := replace($terms[2], '~~eq~~', '=')
                  let $s2 := replace($s1, '~~pl~~', '+')
                  let $queryPart := tokenize($s2, '\+')
                  return 
                    if ($queryPart[2]) 
                      then (
                        let $min := substring-after($queryPart[2], '=')
                          return '[count(tei:form[@type="inflected"][@ana="#' || $queryPart[1] || '"])>' || $min ||']'
                          (: return $min || ' - ' || $queryPart[2] :)
                      ) else 
                        '[tei:form[@type="inflected"][@ana="#' || $terms[2] || '"]]'                      
                    
                       
                )
            case 'en'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="en"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'de'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="de"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'etym' 
                return '[tei:etym/tei:mentioned[' || vicav:createMatchString($terms[2]) || ']]'
            case 'fr'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="fr"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'es'
                return '[tei:sense/tei:cit[@type="translation"][@xml:lang="es"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'etymLang'
                return '[tei:etym/tei:lang[' || vicav:createMatchString($terms[2]) || ']]'
            case 'pos' 
                return '[tei:gramGrp/tei:gram[@type="pos"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'root'
                return '[tei:gramGrp/tei:gram[@type="root"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'stem'
                return '[tei:gramGrp/tei:gram[@type="subc"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'subc'
                return '[tei:gramGrp/tei:gram[@type="subc"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'q'                 
                return (
                  let $s1 := replace($terms[2], '~~eq~~', '=')
                  let $s2 := replace($s1, '~~ha~~', '#')
                  let $s3 := replace($s2, '~~qu~~', '"')
                  return '[' || $s3 || ']'
                )
            default return
                ()

let $qq := 'collection("' || $dict || '")//tei:entry' || string-join($qs)
let $qs := $nsTei || $qq
let $results := xquery:eval($qs)
(: return <answer>{count($res)}||{$res}</answer> :)

(: let $results := xquery:eval($query):)

(:
let $eds := distinct-values($results//tei:fs/tei:f[@name = 'who']/tei:symbol/@value)
let $editors :=
for $ed in $eds
return
    <ed>{$ed}</ed>
:)

(: q=count(.//node()[@ana~~eq~~'~~ha~~n_pl'])>4 :)


let $ress1 :=
   for $entry in $results
      let $eds := distinct-values($entry//tei:fs/tei:f[@name = 'who']/tei:symbol/@value)
      let $editors :=
      for $ed in $eds
      return
        <span xmlns="http://www.tei-c.org/ns/1.0" type="editor">{$ed}</span>
        return <div xmlns="http://www.tei-c.org/ns/1.0" type="entry">{$entry}{$editors}</div>
        
let $exptrs := $ress1//tei:*[name() = ['ptr', 'ref'] and @type = 'example']
let $entries :=
for $r in $ress1
return
    ($r/ancestor::tei:entry, $r/ancestor::tei:cit[@type = 'example'], $r)[1]

let $res := vicav:distinct-nodes($entries)
let $res2 := for $e in $res
return
    vicav:expandExamplePointers($e, collection($dict))

let $ress := <results  xmlns="http://www.tei-c.org/ns/1.0">{$res2}</results>
let $sReturn := vicav:transform($ress, $xsltfn, $print, map{
  "query": $query,
  "dict": $dict
})

return
    (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
    $sReturn)
    (: $res :)
    (: <r>{$qs}</r> :)
    (: if (wde:check-user_($dict, $user, $pw)) :)
    (: then $sReturn :)
    (: else <error type="user authentication" name="{$user}" pw="{$pw}"/> :)
};

declare
%rest:path("/vicav/bibl_markers")
%rest:query-param("query", "{$query}")
%rest:query-param("scope", "{$scope}")
%rest:GET

function vicav:get_bibl_markers($query as xs:string, $scope as xs:string) {
    let $queries := tokenize($query, ',')
    let $qs :=
    for $query in $queries
    return
        if (contains($query, 'geo:')) then
            '[dc:subject[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
        else
            if (contains($query, 'reg:')) then
                '[dc:subject[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
            else
                if (contains($query, 'vt:')) then
                    '[dc:subject[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
                else
                    '[node()[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
    
    let $ns := "declare namespace bib = 'http://purl.org/net/biblio#'; " ||
    "declare namespace rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'; " ||
    "declare namespace foaf= 'http://xmlns.com/foaf/0.1/'; " ||
    "declare namespace dc = 'http://purl.org/dc/elements/1.1/';"
    let $q := 'let $arts := collection("/vicav_biblio' || vicav:get_project_db() || '")//node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection") or (name()="bib:Thesis")]' ||
    string-join($qs) ||
    'for $art in $arts ' ||
    'let $author := $art/bib:authors[1]/rdf:Seq[1]/rdf:li[1]/foaf:Person[1]/foaf:surname[1] ' ||
    'order by $author return $art'
    let $query := $ns || $q
    let $tempresults := xquery:eval($query)
    (: return count($tempresults) :)
    
    let $out :=
    for $subj at $icnt in $tempresults
    return
        let $geos :=
        switch ($scope)
            case 'geo_reg'
                return
                    $subj/dc:subject[contains(., 'reg:') or contains(., 'geo:')]
            case 'geo'
                return
                    $subj/dc:subject[contains(., 'geo:')]
            case 'reg'
                return
                    $subj/dc:subject[contains(., 'reg:')]
            default return
                ()
    
    for $geo in $geos
    return
        let $abstract := $subj/dcterms:abstract[contains(., '(biblid:')][1]
        let $after := fn:substring-after($abstract, '(biblid:')
        let $id := fn:substring-before($after, ')')
        
        return
            if (string-length($geo) > 0)
            then
                (
                let $type := fn:substring-before($geo, ':')
                let $altItem := replace($geo, 'geo:|reg:', '')
                let $locname := fn:substring-before($altItem, '[')
                let $locname := fn:normalize-space($locname)
                let $locname := fn:replace($locname, '''', '&#180;')
                let $sa := fn:substring-after($altItem, '[')
                let $geodata := fn:substring-before($sa, ']')
                
                return
                    if (string-length($locname) = 0) then
                        (
                        <item><type>{$type}</type><geo></geo><loc>{$altItem}</loc><id>{$id}</id></item>
                        )
                    else
                        (
                        <item><type>{$type}</type><geo>{$geodata}</geo><loc>{$locname}</loc><id>{$id}</id></item>
                        )
                
                )
            else
                ()

let $out1 := <r>{$out}</r>
let $out :=
for $item at $icnt in $out1/item
let $loc := $item/loc/string(),
    $geo := $item/geo

for $id in $item/id
group by $loc

let $s := for $i in $item/id
return
    $i/text() || ","

return
    if (string-length($geo[1]/text()) > 0) then
        (
        (: if the <geo> element is empty, no output should be generated:)
        
        if ($item/type = 'geo') then
            (
            <r
                type='geo'><loc>{$geo[1]/text()}</loc><alt>{$loc}</alt><freq>{count($id)}</freq></r>
            )
        else
            (
            <r
                type='reg'><loc>{$geo[1]/text()}</loc><alt>{$loc}</alt><freq>{count($id)}</freq></r>
            )
        )
    else
        ()
        
        (: return file:write("c:\dicttemp\geo_bibl_001.txt", $out) :)
return
   (web:response-header(map {'method': 'xml'}, map:merge((cors:header(()), vicav:return_content_header()))),
    <rs
        type="{count($out)}">{$out}</rs>)

};

(:~
 : gets a geo marker information.
 :
 : Retrieve geo data information from the bibliography for displaying coordinates on a map.
 : 
 : @param $query A BaseX Full-Text search query in in vicav-biblio tei:biblstruct with wildcards enabled.
 :           See: https://docs.basex.org/wiki/Full-Text#Match_Options
 :           using wildcards using diacritics sensitive
 :           Uses prefixes to limit the full text search to certein elements.
 :           * date: -> tei:date
 :           * title: -> tei:title
 :           * pubPlace: -> tei:pubPlace
 :           * author: -> tei:author/tei:surname
 :           * geo:, geo_reg:, reg:, diaGroup: -> tei:note[@type="tag"]/tei:name
 :           * vt:, prj: -> tei:note[@type="tag"]
 :           
 :           Without a prefix any text in vicav-biblio tei:biblstruct is searched.
 :           
 :           More than one query is possible by separating with ' '/+.
 : @param $scope Filters based on a set of tei:name/@types being present in a tei:note[tei:geo]           
 :           * geo
 :           * diaGroup
 :           * reg
 :           * geo_reg: any of the above
 :
 : @return a list of geo markers
 :)

declare
%rest:path("/vicav/bibl_markers_tei")
%rest:query-param("query", "{$query}")
%rest:query-param("scope", "{$scope}", "geo", "reg", "diaGroup")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_bibl_markers_tei($query as xs:string, $scope as xs:string+) {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_bibl_markers_tei#2, [$query, $scope], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_bibl_markers_tei($query as xs:string, $scope as xs:string+) {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $current-query := $query
    let $queries := tokenize($query, '\+')
    let $qs :=
        for $query in $queries
        return
           if (contains($query, 'date:')) then
              '[.//tei:date[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else if (contains($query, 'title:')) then
              '[.//tei:title[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else if (contains($query, 'pubPlace:')) then
              '[.//tei:pubPlace[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else if (contains($query, 'author:')) then
              '[.//[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else if (contains($query, 'geo:') or contains($query, 'geo_reg:') or contains($query, 'reg:') or contains($query, 'diaGroup:')) then
              '[.//tei:note[@type="tag"]/tei:name[text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else if (contains($query, 'vt:')) then
              '[.//tei:note[@type="tag"][text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else if (contains($query, 'prj:')) then
              '[.//tei:note[@type="tag"][text() contains text "' || substring-after($query, ':') || '" using wildcards using diacritics sensitive]]'
           else
              '[.//node()[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'          
                           
        
            (:return '[tei:note/tei:note[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]':)
            (: return '[tei:note/tei:note[tei:name contains text "' || $query || '" using wildcards using diacritics sensitive]]' :)
            (: return '[.//node()[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]' :)
  
    let $q := 'let $arts := collection("/vicav_biblio' || vicav:get_project_db() ||'")//tei:biblStruct' || string-join($qs) || 
              'for $art in $arts ' ||
              'let $author := ' ||
              '   if ($art/tei:analytic) ' ||
              '      then ($art/tei:analytic[1]/tei:author[1]/tei:surname[1] | $art/tei:analytic[1]/tei:author[1]/tei:name[1] | ' ||
              '            $art/tei:analytic[1]/tei:editor[1]/tei:surname[1] | $art/tei:analytic[1]/tei:editorr[1]/tei:name[1]) ' ||
              '      else ($art/tei:monogr[1]/tei:author[1]/tei:surname[1] | $art/tei:monogr[1]/tei:author[1]/tei:name[1] | ' ||
              '            $art/tei:monogr[1]/tei:editor[1]/tei:surname[1] | $art/tei:monogr[1]/tei:editor[1]/tei:name[1]) ' ||
              'let $date := $art/tei:monogr[1]/tei:imprint[1]/tei:date[1] ' ||
              'order by $author[1],$date[1] return $art'

    let $ns := 'declare namespace tei = "http://www.tei-c.org/ns/1.0";'
    let $query := $ns || $q
    let $tempresults := xquery:eval($query)

    let $out :=
        for $subj in $tempresults
        return
            let $geos :=
                $scope!(switch (.)
                    case 'geo_reg'
                        return $subj/tei:note/tei:note[(tei:name/@type = 'reg') or (tei:name/@type = 'geo') or (tei:name/@type = 'diaGroup')][tei:geo]
                    case 'geo'
                        return $subj/tei:note/tei:note[tei:name/@type = 'geo'][tei:geo]
                    case 'diaGroup'
                        return $subj/tei:note/tei:note[tei:name/@type = 'diaGroup'][tei:geo]
                    case 'reg'
                        return $subj/tei:note/tei:note[tei:name/@type = 'reg'][tei:geo]
            default return ())
    
    for $geo in $geos
    return
        let $id := $subj/@corresp
        
        return
            if (string-length($geo/tei:name) > 0)
            then
                (
               (: let $type := fn:substring-before($geo, ':')
                let $altItem := replace($geo, 'geo:|reg:', '')
                let $locname := fn:substring-before($altItem, '[')
                let $locname := fn:normalize-space($locname)
                let $locname := fn:replace($locname, '''', '&#180;')
                let $sa := fn:substring-after($altItem, '[')
                let $geodata := fn:substring-before($sa, ']')
                :)
                let $type := $geo/tei:name/@type
                let $altItem := $geo/tei:name/text()
                let $locname := $geo/tei:name/text()
                let $geodata := $geo/tei:geo/text()
                
                return
(:                    if (string-length($locname) = 0) then
                        (
                        <item>{$type}<geo></geo><loc>{$altItem}</loc><id>{$id}</id></item>
                        )
                    else
                        ( :)
                        <item>{$type}<geo>{$geodata}</geo><loc>{$locname}</loc><id>{$id}</id></item>
                       (: )                :)
                )
            else ()

    let $out1 := <r>{$out}</r>
    let $out2 :=
    for $item at $icnt in $out1/item
    let $loc := $item/loc/string(),
    $geo := $item/geo

    for $id in $item/id
    group by $loc

    let $s := for $i in $item/id
    return $i/text() || ","

    return
    (:if (string-length($geo[1]/loc) > 0) then:)
        <r>{$item[1]/@type}{$geo[1]}<alt>{$loc}</alt><freq>{count($id)}</freq></r>
       
       (:
        (if ($item/type = 'geo') then
            (
            <r
                type='geo'><loc>{$geo[1]}</loc><alt>{$loc}</alt><freq>{count($id)}</freq></r>
            )
        else
            (
            <r
                type='reg'><loc>{$geo[1]}</loc><alt>{$loc}</alt><freq>{count($id)}</freq></r>
            )
        )
        :)
    (:else  ():)
        
    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out2}</_>, 'xslt/bibl-markers-json.xslt', map{
      "target-type": "BiblioEntries",
      "current-query": $current-query
    })
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else <rs type="{count($out2)}">{$out2}</rs>
        (: <res>{$out}</res> :)
        (: <res>{$query}</res> :)
        (: <_>{$tempresults}</_> :)
};

declare
%rest:path("/vicav/profile_markers")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_profile_markers() {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_document_transformed_markers#0, [], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_document_transformed_markers() {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $entries := collection('vicav_profiles' || vicav:get_project_db())/descendant::tei:TEI
    let $out :=
    for $item in $entries
    return
        if ($item/tei:text[1]/tei:body[1]/tei:div[1]/tei:head[1]/tei:name[1]/@type) then (
          <r type='{$item/tei:text[1]/tei:body[1]/tei:div[1]/tei:head[1]/tei:name[1]/@type}'>{$item/@xml:id}
              <loc>{$item/tei:text/tei:body/tei:div/tei:div/tei:p/tei:geo[1]/text()}</loc>
              <loc type="decimal">{$item//tei:geo[@decls="decimal"]/text()}</loc>
              <alt>{$item//tei:text[1]/tei:body[1]/tei:div[1]/tei:head[1]/tei:name[1]/text()}</alt>
              <freq>1</freq>
          </r>
        ) else
        (
          <r type='geo'>{$item/@xml:id}
              <loc>{$item/tei:text/tei:body/tei:div/tei:div/tei:p/tei:geo[1]/text()}</loc>
              <loc type="decimal">{$item//tei:geo[@decls="decimal"]/text()}</loc>
              <alt>{$item//tei:text[1]/tei:body[1]/tei:div[1]/tei:head[1]/tei:name[1]/text()}</alt>
              <freq>1</freq>
          </r>
        )
    
    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>, 'xslt/bibl-markers-json.xslt', map{
      "target-type": "Profile"
    })
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else <rs>{$out}</rs>
};

declare
%rest:path("/vicav/data_locations")
%rest:GET
%rest:query-param("type", "{$type}")
function vicav:data_locations($type as xs:string*) {
    let $type := if ($type = () or $type = '') then 'samples' else $type

    let $entries := collection('vicav_' || $type || vicav:get_project_db())/descendant::tei:TEI/(./tei:text/tei:body/tei:head/tei:name[1], ./tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement[1]/tei:name[@xml:lang="en"], ./tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:region[1], ./tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:country[1])

    let $labels :=
    for $item in $entries
        order by $item/text()

        let $label := if ($item/name() = 'region') then
            'region:' || $item/text()
        else if ($item/name() = 'country') then
            'country:' || $item/text() 
        else 
            $item/text()
        return $label
    
    let $out:= for $label in distinct-values($labels)
        return <location>
            <label>{$label}</label>
        </location>
       
    return 
    (web:response-header(map {'method': 'xml'}, map:merge((cors:header(()), vicav:return_content_header()))),
    <results>{$out}</results>)
};

declare
%rest:path("/vicav/sample_markers")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_sample_markers() {api-problem:or_result (prof:current-ns(),
    vicav:_get_sample_markers#0, [], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_sample_markers() {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $entries := collection("/vicav_samples" || vicav:get_project_db())/descendant::tei:TEI
    let $out :=
    for $item in $entries
        order by $item/@xml:id
        let $loc := if ($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text()) then 
                        replace($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text(), '(\d+(\.|,)\s*\d+,\s*\d+(\.|,)\s*\d+).*', '$1')
                    else $item/tei:text/tei:body/tei:div[@type="positioning"]//tei:geo/text()
        let $alt := if ($item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person)
        then $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text() || '/' ||
         $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@sex || '/' ||
         $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age
        else  $item/tei:text/tei:body/tei:head/tei:name[1]

        let $locName := if ($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement) then
            $item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement[1]/tei:name[@xml:lang="en"]/text()
        else
            $item/tei:text/tei:body/tei:head/tei:name[1]

        return
            if (string-length($loc[1])>0) then
            <r
                type='geo'>{$item/@xml:id}
                <loc>{$loc[1]}</loc>
                <locName>{$locName}</locName>
                <alt>{$alt[1]}</alt>
                <freq>1</freq>
            </r>
            else ()
    
    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>,
        'xslt/bibl-markers-json.xslt',
        map{"target-type": "SampleText"})
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else <rs>{$out}</rs>
};

declare
%rest:path("/vicav/feature_labels")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_feature_labels() {
    api-problem:or_result (prof:current-ns(),
    vicav:_get_feature_labels#0, [], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare
function vicav:_get_feature_labels() {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
   
    let $features := collection('vicav_lingfeatures' || vicav:get_project_db())/descendant::tei:TEI//tei:cit[@type="featureSample"]
    let $out := for $ana in distinct-values($features/@ana)
        return <feature ana="{$ana}">{$features[./@ana = $ana][1]/tei:lbl/text()}</feature>


    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>,
        'xslt/feature_labels-json.xslt')
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else
        <features>{$out}</features>
};


declare
%rest:path("/vicav/data_persons")
%rest:GET
%rest:query-param("type", "{$type}")

function vicav:get_sample_persons($type as xs:string*) {
    let $type := if ($type = () or $type = '') then 'samples' else $type

    let $persons := collection('vicav_' || $type || vicav:get_project_db())/descendant::tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person
    let $out :=
    for $person in $persons
        order by $person/text()
        return 
        <person age="{$person/@age}" sex="{$person/@sex}">
            {$person/text()}
        </person>
    
    return
        (web:response-header(map {'method': 'xml'}, map:merge((cors:header(()), vicav:return_content_header()))),
        <persons>{$out}</persons>)
};

declare function vicav:tr($string as xs:string) {
    let $tr := translate($string, 
        "ᵃᵉⁱᵒᵘᵊʰʷʸˢᶴQāēīōūḅṭḍṣẓḏšžṛḥṃǧġʕʔ",
        "aeiouehwyssqaeioubtdszdszrhmgg??"
    )
    return replace(
        replace($tr, "ǟ", "a"), "ḏ̣", "d")
};

declare
%rest:path("/vicav/data_words")
%rest:query-param("type", "{$type}")
%rest:query-param("query", "{$query}")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_data_words($type as xs:string*, $query as xs:string*) {
    api-problem:or_result (prof:current-ns(),
    vicav:_get_data_words#2, [$type, $query], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_data_words($type as xs:string*, $query as xs:string*) {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $collections := if (empty($type) or $type = '') then 
        <i><coll>samples</coll><coll>corpus</coll><coll>lingfeatures</coll></i> else <i><coll>{$type}</coll></i>
    
     let $words := for $collName in $collections[1]/coll/text()
        let $collection := collection("vicav_" || $collName || vicav:get_project_db())
        let $base := if ($collName = "samples") then 
            $collection/tei:teiCorpus/tei:TEI/tei:text/tei:body/tei:div[@type="sampleText"]/tei:p/tei:s
            else if ($collName = "lingfeatures") then
            $collection/tei:TEI/tei:text/tei:body/tei:div/tei:div[@type="featureGroup"]/tei:cit[@type="featureSample"]/tei:quote
            else $collection/tei:TEI/tei:text/tei:body/tei:div/tei:annotationBlock/tei:u/tei:w
        
        return if ($collName = ["samples", "lingfeatures"]) then
            (
                $base/tei:choice/tei:w/tei:fs/tei:f[if (empty($query)) then @name="wordform" else @name = "wordform" and contains(vicav:tr(./text()), vicav:tr($query))]/text(),
                $base/tei:choice/tei:phr/tei:w/tei:fs/tei:f[if (empty($query)) then @name="wordform" else @name = "wordform" and contains(vicav:tr(./text()), vicav:tr($query))]/text(),                
                $base/tei:w/tei:fs/tei:f[if (empty($query)) then @name="wordform" else @name = "wordform" and contains(vicav:tr(./text()), vicav:tr($query))]/text(),
                $base/tei:phr/tei:w/tei:fs/tei:f[if (empty($query)) then @name="wordform" else @name = "wordform" and contains(vicav:tr(./text()), vicav:tr($query))]/text()
            )
            else 
                $base[if (empty($query)) then true() else contains(vicav:tr(.), vicav:tr($query))]

    let $persons := for $w in $words
        return replace(normalize-space($w), '[\s&#160;]', '')

    let $out :=
    for $person in distinct-values($persons)
        order by $person
        return 
        <word>
            {$person}
        </word>
    
    return
    if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>,
        'xslt/data_words-json.xslt')
        return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else 
        <words>{$out}</words> 
};


declare
%rest:path("/vicav/feature_markers")
%rest:GET
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')   
%rest:produces('application/problem+xml')
function vicav:get_feature_markers() {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_feature_markers#0, [], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_feature_markers() {  
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $entries := collection('vicav_lingfeatures' || vicav:get_project_db())/descendant::tei:TEI
    let $out :=
        for $item in $entries
            order by $item/@xml:id
            let $loc := if ($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text()) then 
                            replace($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text(), '(\d+(\.|,)\s*\d+,\s*\d+(\.|,)\s*\d+).*', '$1')
                        else $item/tei:text/tei:body/tei:div[@type="positioning"]//tei:geo/text()
            let $alt := if ($item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person)
                then $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text() || '/' ||
                 $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@sex || '/' ||
                 $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age
                else  $item/tei:text/tei:body/tei:head/tei:name[1]

            let $locName := if ($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement) then
                    $item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement[1]/tei:name[@xml:lang="en"]/text()
                else
                    $item/tei:text/tei:body/tei:head/tei:name[1]

            return
                if ($item/@xml:id and $loc) then
                <r
                    type='geo'>{$item/@xml:id}
                    <loc>{$loc}</loc>
                    <loc type="decimal">{$item//tei:geo[@decls="decimal"]/text()}</loc>
                    <locName>{$locName}</locName>
                    <alt>{$alt}</alt>
                    <freq>1</freq>
                </r>
                else ''
    
    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>,
        'xslt/bibl-markers-json.xslt',
        map{"target-type": "Feature"})
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else <rs>{$out}</rs>
};



declare
%rest:path("/vicav/data_markers")
%rest:GET
function vicav:get_all_data_markers() {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_all_data_markers#0, [], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_all_data_markers() {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $entries := for $c in ('vicav_profiles', 'vicav_samples', 'vicav_lingfeatures')
        return collection($c)/descendant::tei:TEI

    let $out :=
        for $item in $entries
            order by $item/@xml:id
            let $locName := $item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name[@xml:lang="en"]/text()
            let $loc := if ($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text()) then
                            replace($item/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:location/tei:geo/text(), '(\d+(\.|,)\s*\d+,\s*\d+(\.|,)\s*\d+).*', '$1')
                        else $item/tei:text/tei:body/tei:div[@type="positioning"]//tei:geo/text()
            let $alt := if ($item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person) then $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text() || '/' || $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@sex || '/' || $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/@age else $locName

            return
                if ($item/@xml:id and $loc) then
                <r
                    type='geo'>{$item/@xml:id}
                    <loc>{$loc}</loc>
                    <loc type="decimal">{$item//tei:geo[@decls="decimal"]/text()}</loc>
                    <locName>{$locName}</locName>
                    <taxonomy>{$item/tei:teiHeader/tei:profileDesc/tei:taxonomy/tei:category/tei:catDesc/text()}</taxonomy>
                    <alt>{$alt}</alt>
                    <freq>1</freq>
                </r>
                else ''

    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>, 'xslt/bibl-markers-json.xslt')
    return serialize($renderedJson, map {"method": "json", "indent": "no"})
    else <rs>{$out}</rs>
};


declare function vicav:data_list_region($type as xs:string, $region as xs:string, $items as element()*) {
    <div class="region"><h3>{$region}</h3>{
        for $city in distinct-values($items/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name[@xml:lang="en"])
            order by $city
            let $city-items := $items[./tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name[@xml:lang="en"] = $city]
            return
                <div class="settlement"><h5>{$city} ({count($city-items)})</h5>
                {if ($type = 'all') then
                    for $cat in distinct-values($city-items/tei:teiHeader/tei:profileDesc/tei:taxonomy/tei:category/tei:catDesc/text())
                        let $cat-items := $city-items[./tei:teiHeader/tei:profileDesc/tei:taxonomy/tei:category/tei:catDesc/text() = $cat]
                        let $typestring := switch($cat)
                                    case 'linguistic feature list' return
                                        'data-featurelist'
                                    case 'profile' return
                                        'data-profile'
                                    default return
                                        'data-sampletext'
                        return (element h6 {
                            concat($cat, ': ', count($cat-items))
                        },
                        for $item in $cat-items
                                order by $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text()
                                return element p {
                                    element a {
                                        attribute href { '#' },
                                        attribute {$typestring} {$item/@xml:id},
                                        text {$item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text()},
                                        text { string-join((' (Revision: ', replace($item/tei:teiHeader/tei:revisionDesc/tei:change[1]/@when, 'T.*', ''), ')')) }
                                    }, element br {}
                                }

                        )

                (: Handle single type data list :)
                else for $item in $city-items
                                order by $item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text()
                                let $typestring := switch($type)
                                    case 'lingfeatures' return
                                        'data-featurelist'
                                    case 'profiles' return
                                        'data-profile'
                                    default return
                                        'data-sampletext'
                                return element p {
                                    element a {
                                        attribute href { '#' },
                                        attribute {$typestring} {$item/@xml:id},
                                        text {$item/tei:teiHeader/tei:profileDesc/tei:particDesc/tei:person[1]/text()},
                                        text { string-join((' (Revision: ', replace($item/tei:teiHeader/tei:revisionDesc/tei:change[1]/@when, 'T.*', ''), ')')) }
                                    }, element br {}
                                }

            }</div>
        }</div>
};

declare
%rest:path("/vicav/data_list")
%rest:query-param("type", "{$type}")
%rest:GET
function vicav:get_data_list($type as xs:string*) {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_data_list#1, [$type], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_data_list($type as xs:string*) {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $type := if (empty($type) or $type = '') then 'all' else $type
    let $items := if ($type = 'all') then
        for $c in ('vicav_profiles', 'vicav_samples', 'vicav_lingfeatures') return collection($c)/descendant::tei:TEI
    else
        collection('vicav_' || $type || vicav:get_project_db())/descendant::tei:TEI

    let $countries := distinct-values($items/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:country)

    let $out := <div>Total: {count($items)}<br/>{if (count($countries) > 1) then
        for $country in $countries
        order by $country
        let $regions := distinct-values($items/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place[./tei:country[./text() = $country]]/tei:region)
        return <div class="country"><h1>{$country}</h1>{
            for $region in $regions
            order by $region
            return vicav:data_list_region($type, $region, $items[./tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place[./tei:region[./text() = $region]]])
        }</div>
    else
        let $regions := distinct-values($items/tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place/tei:region)
        for $region in $regions
        order by $region
             return vicav:data_list_region($type, $region, $items[./tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:place[./tei:region[./text() = $region]]])}</div>

    return if (matches($accept-header, '[+/]json'))
    then let $renderedJson := xslt:transform(<_>{$out}</_>, 'xslt/identity.xslt')
    return serialize($renderedJson, map {"method": "xml"})
    else $out
};

declare
%rest:path("/vicav/tei_doc_list")
%rest:query-param("type", "{$type}")
%rest:produces('application/json')
%rest:GET
function vicav:get_tei_doc_list($type as xs:string*) {
  api-problem:or_result (prof:current-ns(),
    vicav:_get_tei_doc_list#1, [$type], map:merge((cors:header(()), map{'Content-Type': 'application/json;charset=UTF-8'}))
  )
};

declare function vicav:_get_tei_doc_list($type as xs:string*) {
  let $noType := if (not(exists($type))) then
        error(xs:QName('response-codes:_422'), 
         $api-problem:codes_to_message(422),
         'You need to specify a type') else (),
      $corpus := try { collection($type)//tei:teiCorpus } catch err:FODC0002 {
        error(xs:QName('response-codes:_404'), 
         $api-problem:codes_to_message(404),
         'There are no TEI documents of type '||$type)},
      $corpus := if (not(exists($corpus)) and exists(collection($type)//tei:TEI))
        then <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">{collection($type)//tei:TEI!. update {delete node (./tei:text,./tei:standOff)}}</teiCorpus>
        else $corpus,
      $corpus := if (exists($corpus/@xml:id)) then $corpus else $corpus update { insert node attribute {"id"} {$type} as first into . }, 
      $notFound := if (not(exists($corpus))) then
        error(xs:QName('response-codes:_404'), 
         $api-problem:codes_to_message(404),
         'There are no TEI documents of type '||$type) else (),
      $corpusIDs := $corpus//tei:idno[ends-with(@type, 'CorpusID')]/text()!xs:string(.),
      $IDtypes :=  distinct-values($corpus//tei:idno/@type),
      $IDsContainingData := collection($type)//tei:TEI[.//tei:w]//tei:idno[@type = $IDtypes][. = $corpusIDs]!xs:string(.),
      $corpus := $corpus update { .//tei:TEI[.//tei:idno[@type = $IDtypes][. = $IDsContainingData]]!(insert node attribute {"hasTEIw"} {"true"} as first into .) }
  return serialize(xslt:transform($corpus, 'xslt/teiCorpusTeiHeader-json.xslt'), map {'method': 'json'})
};

(:****************************************************************************:)
(:** MANAGEMENT FUNCS ********************************************************:)
(:****************************************************************************:)
declare
%rest:path("/vicav/show_docs")
%rest:query-param("db", "{$db}")
%rest:GET

function vicav:vicav_show_docs($db as xs:string*) {
  let $docs := db:list($db)
  let $out :=
  for $item in $docs 
    return <div>{$item}</div>
  
  return
        (web:response-header(map {'method': 'basex'}, map:merge((cors:header(()), vicav:return_content_header()))),
        <p>{$out}</p>)
};

declare
%rest:path("/vicav/profiles")
%rest:GET

function vicav:get_profiles_overview() {
    (:let $entries := collection('vicav_profiles' || vicav:get_project_db())//tei:TEI:)
    let $entries := collection('vicav_profiles')//tei:TEI
    let $items :=
      for $item at $icnt in $entries
      return <item n="{$icnt}">{$item/@xml:id}<country>{$item//tei:country/text()}</country><author>{$item/.//tei:author/text()}</author><name>{$item/.//tei:head[1]/tei:name[1]/text()}</name></item>
      
    let $stylePath := file:base-dir() || 'xslt/profiles_overview.xslt'
    let $style := doc($stylePath)
    let $num := count($items)
    let $res1 := <results num="{$num}">{$items}</results>
    let $tei := xslt:transform-text($res1, $style)
    
    let $stylePath2 := file:base-dir() || 'xslt/vicavTexts.xslt'
    let $style1 := doc($stylePath2)    
    (: let $res4 := '<?xml version="1.0"?>' || $res2 :)
    (: let $res3 := serialize($res2):)
    (: let $res3 := parse-xml($res2) :)
    
    (: let $out := xslt:transform($tei, $style1) :)
        return 
        (web:response-header(map {'method': 'xml'}, map:merge((cors:header(()), vicav:return_content_header()))),
        $tei)
};
  
(:~
 : Performs a corpus search in NoSKE.
 : 
 : @param $query Query to perform against NoSKE.
 : @param $print Whether return the printable page with full HTML headers.
 :
 : @return A rendered HTML snippet with the search results.
 :)
declare
%rest:path("/vicav/corpus")
%rest:GET
%rest:query-param("query", "{$query}")
%rest:query-param("print", "{$print}")
%rest:query-param("xslt", "{$xslt}", "corpus_search_result.xslt")
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')
%rest:produces('application/problem+xml')
function vicav:search_corpus($query as xs:string, $print as xs:string?, $xslt as xs:string?) {
  api-problem:or_result (prof:current-ns(),
    vicav:_search_corpus#3, [$query, $print, $xslt], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_search_corpus($query as xs:string, $print as xs:string?, $xslt as xs:string?) {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    
    let $query-parts := if (starts-with($query, "[")) then
        $query
    else
        let $query-words := tokenize($query, '\s')
        return string-join(($query-words!('[word="' || encode-for-uri(.)
            || '"]')))

    let $path := 'vicav_projects/' || vicav:get_project_name() || '.xml'
    let $config := if (doc-available($path)) then doc($path)/projectConfig else <projectConfig><menu></menu></projectConfig>

    let $noske_host := $config//noskeHost,
        $request := $noske_host || '/bonito/run.cgi/first?corpname=' || vicav:get_project_name()
        || '&amp;queryselector=cqlrow&amp;cql='||$query-parts||'&amp;default_attr=word&amp;attrs=wid&amp;kwicleftctx=0&amp;kwicrightctx=0&amp;refs=u.id,doc.id&amp;pagesize=100000'
      , $_ := admin:write-log($request, 'INFO')
        

    let $result := if ($noske_host) then
        http:send-request(<http:request method='get'/>,
        $request)
        else false()
      (: , $_ := admin:write-log(serialize($result[2], map{'method': 'json'}), 'INFO') :)

(:let consecutiveIDs
        json.Lines.map((line) => {
          const key = line.Refs.map((ref) => {return ref.split('=')[1]}).join();
          consecutiveIDs = consecutiveIDs || []
          docsUandIDs[key] = docsUandIDs[key] || [];
          docsUHits[key] = docsUHits[key] || [];
          if (!line.Kwic[0]) {line.Kwic = line.Left}
          if (!line.Kwic[0]) {line.Kwic = line.Right}
          const ids = line.Kwic[0].str.split(" ").filter(str => str != "")
          const found = docsUandIDs[key].findIndex((id) => id === ids[0])
          if (line.Kwic[0]) {
            if (ids[0] === '' || found === -1) {
              consecutiveIDs = consecutiveIDs.concat(ids)
              docsUHits[key].push(Array.from(consecutiveIDs))
              docsUandIDs[key] = docsUandIDs[key].concat(consecutiveIDs)
              console.log('uhits', JSON.stringify(docsUHits), 'uandids', JSON.stringify(docsUandIDs))
              consecutiveIDs = []
            } else {
              const newIds = ids.filter(id => docsUandIDs[key].indexOf(id) === -1)
              if (newIds.length > 1) {
                consecutiveIDs = consecutiveIDs.concat(newIds)
              }
            }
          }:)


    let $consecutiveIds := []
    (:let $docUandIds := map:merge():)
    let $hits := <hits>{if (not($result)) then '' else for $line in $result/json/Lines/_
        let $uId := tokenize($line/Refs/_[1], '=')[2]
        let $docId := tokenize($line/Refs/_[2], '=')[2]
        (:$docUandIds := if not((map:contains($docUandIds, $key))) then map:put($docUandIds, $key, []) else $docUandIds:)
        let $tokenId := if (count($line/Kwic/_) > 0) then
                        tokenize(normalize-space($line/Kwic/_[1]/str/text()), '\s')
                     else if (count($line/Left/_) > 0) then
                        $line/Left/_[1]/text()
                     else if (count($line/Right/_) > 0) then
                        $line/Right/_[1]/text() else ""
        let $u := collection('vicav_corpus')
          /descendant::tei:TEI[./tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[ends-with(@type, "CorpusID")]/text() = $docId]         
        /tei:text/tei:body/tei:div/tei:annotationBlock/tei:u[@xml:id = $uId]
        return <hit u="{$uId}" doc="{$docId}">{$u}{$tokenId!<token>{.}</token>}</hit>}</hits>
      (: , $_ := admin:write-log(serialize($hits), 'INFO') :)
      (: , $_ := file:write(file:resolve-path('hits.xml', file:base-dir()), $hits, map { "method": "xml"}) :)

    return if (matches($accept-header, '[+/]json'))
        then
            let $transformedOutput := xslt:transform($hits, 'xslt/corpus_search_result_json.xslt', map{ 'query': $query})
            return serialize($transformedOutput, map {"method": "json", "indent": "no"})
        else
            let $out := vicav:transform($hits, $xslt, $print, map{ 'query': $query })
            return $out



};

declare function vicav:_corpus_text(
        $docId as xs:string,
        $page as xs:integer?,
        $size as xs:integer?,
        $hits as xs:string?,
        $print as xs:string?
    ) {
    let $accept-header := try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }
    let $p := if (empty($page)) then 1 else $page
    let $s := if (empty($size)) then 10 else $size

    let $hits_str := if (not(empty($hits))) then $hits else ""

    let $teiDoc := collection('vicav_corpus')
        //tei:TEI[./tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[ends-with(@type, 'CorpusID')]/text() = $docId],
        $notFound := if (not(exists($teiDoc))) then
        error(xs:QName('response-codes:_404'), 
         $api-problem:codes_to_message(404),
         'Text with id '||$docId||' does not exist') else (),
        $utterances := subsequence($teiDoc
        /tei:text/tei:body/tei:div/tei:annotationBlock/tei:u, ($p - 1)*$s+1, $s),
        $notFound := if (not(exists($utterances))) then
        error(xs:QName('response-codes:_404'), 
         $api-problem:codes_to_message(404),
         'Text with id '||$docId||' does not have page '||$p) else (),
        $doc := <doc id="${$docId}">{$utterances}</doc>,
      (: , $_ := file:write(file:resolve-path('doc.xml', file:base-dir()), $doc, map { "method": "xml"}) :)      
        $referenced_ids := $doc//@ana[starts-with(., '#')]!substring(., 2),
        $annot := db:attribute('vicav_corpus', $referenced_ids)/.. 
        (: there is a lot of scaffolding here, filter it :)
        update {
          delete node .//*[@fVal=""],
          delete node .//*[matches(@fVal, '\{.+\}')],
          delete node .//*[./*:string[not(text())]],
          delete node .//*[./*:string[matches(text(), '\{.+\}')]]
        },
        $pds := for $pd in collection('vicav_corpus')//tei:prefixDef
                group by $ident := $pd/@ident
                return $pd[1],
        $doc := <doc id="${$docId}">
          {$utterances}
          <standOff>
            {$annot}
          </standOff>
          <listPrefixDef>
            {$pds}
          </listPrefixDef>
        </doc>

    return if (matches($accept-header, '[+/]json'))
        then 
            let $out := xslt:transform($doc, 'xslt/corpus_utterances_json.xslt', map{
                "hits_str": $hits_str
            })
            return serialize($out, map {"method": "json", "indent": "no"})
        else
            let $out := vicav:transform($doc, 'corpus_utterances.xslt', $print, map{ "hits_str": $hits_str })
            return $out
};

(:~
 : Retrieve pageble set of utterances from a corpus text.
 :
 : @param $docId Text Identidfier.
 : @param $page Page number (defaults to 1)
 : @param $size Page size (defaults to 10)
 : @param $print Whether to return a printable page with full HTML headers.
 :
 : @return A rendered HTML snippet of the utterances.
 :)
declare
%rest:path("/vicav/corpus_text")
%rest:GET
%rest:query-param("id", "{$docId}")
%rest:query-param("page", "{$page}")
%rest:query-param("size", "{$size}")
%rest:query-param("hits", "{$hits}")
%rest:query-param("print", "{$print}")
%rest:produces("application/xml")
%rest:produces("application/json")
%rest:produces('application/problem+json')
%rest:produces('application/problem+xml')
function vicav:corpus_text($docId as xs:string, $page as xs:integer?, $size as xs:integer?, $hits as xs:string?, $print as xs:string?) {
  api-problem:or_result (prof:current-ns(),
    vicav:_corpus_text#5, [$docId, $page, $size, $hits, $print], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare variable $vicav:dict-alias-to-dict := map {
  "ar_de__v001": "dc_ar_en_publ",
  "aeb_eng_001__v001": "dc_tunico",
  "apc_eng_002": "dc_apc_eng_publ"
};

declare
%rest:path("/vicav/dict_csv")
%rest:GET
%rest:produces("text/csv")
%rest:query-param("unit","{$unit}")
%rest:query-param("x-format","{$format}")
%rest:query-param("x-context", "{$dict-alias}")
function vicav:get_dict_csv($unit as xs:string, $format as xs:string, $dict-alias as xs:string) {
  let $dict := $vicav:dict-alias-to-dict($dict-alias),
      $notFound := if (not(exists($dict))) then
      error(xs:QName('response-codes:_404'), 
       $api-problem:codes_to_message(404),
       'There is no dict for x-context '||$dict-alias) else () 
  return api-problem:or_result (prof:current-ns(),
    vicav:_get_dict_csv#3, [$unit, $format, $dict], map:merge((cors:header(()), map{
      'Content-Type': 'text/csv;charset=UTF-8',
      'Content-Disposition': 'attachment; filename="vocabulary_L'||$unit||'.csv"'
    }))
  )
};

declare function vicav:_get_dict_csv($unit as xs:string, $format as xs:string, $dict as xs:string) {
  let $data := <sru:records xmlns:sru="http://www.loc.gov/zing/srw/">{collection($dict)//(tei:cit[@type="example"]|tei:entry)[tei:fs/tei:f/tei:symbol/@value="released"][.//tei:bibl[@type=("damascCourse","tunisCourse","course") and .= $unit]]}</sru:records>,
      $notFound := if (not(exists($data))) then
        error(xs:QName('response-codes:_404'), 
         $api-problem:codes_to_message(404),
         'There are no TEI entries for dict/x-context '||$dict) else (),
      $wrongFormat := if ($format = ("csv-anki", "csv-fcdeluxe")) then () else
        error(xs:QName('response-codes:_422'), 
         $api-problem:codes_to_message(422),
         'Valid formats are csv-anki and csv-fcdeluxe')
  return xslt:transform-text($data, 'xslt/csv-table-export.xsl', map {"format": $format, "unit": $unit})
};

declare
%rest:path("/vicav/dict_markers")
%rest:GET
%rest:produces("application/json")
%rest:produces('application/problem+json')
function vicav:get_dict_markers() {api-problem:or_result (prof:current-ns(),
    vicav:_get_dict_markers#0, [], map:merge((cors:header(()), vicav:return_content_header()))
  )
};

declare function vicav:_get_dict_markers() {
  serialize([
    map {
    "type": "Feature",
    "geometry": map {
      "type": "Point",
      "coordinates": [
        31.233333333333334,
        30.05
      ]
    },
    "properties": map{
      "type": "reg",
      "name": "Cairo",
      "hitCount": 1
    }},
    map {
    "type": "Feature",
    "geometry": map {
      "type": "Point",
      "coordinates": [
        36.28333333333333,
        33.5
      ]
    },
    "properties": map{
      "type": "reg",
      "name": "Damascus",
      "hitCount": 1
    }},
    map {
    "type": "Feature",
    "geometry": map {
      "type": "Point",
      "coordinates": [
        10.15,
        36.81666666666667
      ]
    },
    "properties": map{
      "type": "reg",
      "name": "Tunis",
      "hitCount": 1
    }},
    map {
    "type": "Feature",
    "geometry": map {
      "type": "Point",
      "coordinates":[
        44.4,
        33.333333333333336
      ] 
    },
    "properties": map{
      "type": "reg",
      "name": "Baghdad",
      "hitCount": 1
    }}
  ], map{"method": "json", "indent": "no"})
};