module namespace vicav = "http://acdh.oeaw.ac.at/vicav";
declare namespace bib = 'http://purl.org/net/biblio#';
declare namespace dc = 'http://purl.org/dc/elements/1.1/';
declare namespace tei = 'http://www.tei-c.org/ns/1.0';
declare namespace dcterms="http://purl.org/dc/terms/";

declare function vicav:expandExamplePointers($in as item(), $dict as document-node()*) {
    typeswitch ($in)
        case text() return $in
        case attribute() return $in
        case document-node() return document {
            vicav:expandExamplePointers($in/*, $dict)
        }
        case element(tei:ptr) return $dict//tei:cit[@xml:id = $in/@target]
        case element() return 
            (: element { QName( namespace-uri($in), local-name($in) ) } { for $node in $in/node() return wde:expandExamplePointers($node, $dict) } :)
            element { QName( namespace-uri($in), local-name($in) ) } { 
              for $i in ($in/@*, $in/node()) 
              return vicav:expandExamplePointers($i, $dict) 
            }
        default return $in
};
      
declare function vicav:distinct-nodes( $nodes as node()* )  as node()* {
    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(vicav:is-node-in-sequence(.,$nodes[position() < $seq]))]
};
  
declare function vicav:is-node-in-sequence
 ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies $nodeInSeq is $node
};
 
declare 
    %rest:path("vicav/biblio")
    %rest:query-param("query", "{$query}")
    %rest:query-param("xslt", "{$xsltfn}")
   
    %rest:GET 
    
function vicav:query_biblio($query as xs:string*, $xsltfn as xs:string) {  
  let $queries := tokenize($query, ',')
  let $qs := 
    for $query in $queries
    return
     if (contains($query, 'geo:')) then '[dc:subject[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]' else
     if (contains($query, 'reg:')) then '[dc:subject[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]' else
     if (contains($query, 'vt:')) then '[dc:subject[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]' else 
     '[node()[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]'
  
  let $ns := "declare namespace bib = 'http://purl.org/net/biblio#'; "||
             "declare namespace rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'; "||
             "declare namespace foaf= 'http://xmlns.com/foaf/0.1/'; "||  
             "declare namespace dc = 'http://purl.org/dc/elements/1.1/';"
  let $q := 'let $arts := collection("vicav_biblio")//node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection") or (name()="bib:Thesis")]' ||       
                string-join($qs) ||
                'for $art in $arts ' ||
                'let $author := $art/bib:authors[1]/rdf:Seq[1]/rdf:li[1]/foaf:Person[1]/foaf:surname[1] ' ||
                'order by $author return $art'
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
  let $style := doc($stylePath)
  let $num := count($results)
  let $results := <results num="{$num}">{$results}</results>
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

declare 
    %rest:path("vicav/profile")
    %rest:query-param("coll", "{$coll}")
    %rest:query-param("id", "{$id}")
    %rest:query-param("xslt", "{$xsltfn}")
   
    %rest:GET 
    
function vicav:get_profile($coll as xs:string, $id as xs:string*, $xsltfn as xs:string) {
    
  let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
  let $q := 'collection("' || $coll || '")//tei:TEI[@xml:id="' || $id || '"]'
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
  let $style := doc($stylePath)
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

declare 
    %rest:path("vicav/sample")
    %rest:query-param("coll", "{$coll}")
    %rest:query-param("id", "{$id}")
    %rest:query-param("xslt", "{$xsltfn}")
    
    %rest:GET         
    
function vicav:get_sample($coll as xs:string*, $id as xs:string*, $xsltfn as xs:string) {
    
  let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
  let $q := 'collection("' || $coll || '")//tei:TEI[@xml:id="' || $id || '"]'
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
  let $style := doc($stylePath)
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

declare 
    %rest:path("vicav/text")
    %rest:query-param("id", "{$id}")
    %rest:query-param("xslt", "{$xsltfn}")
   
    %rest:GET 
    
function vicav:get_text($id as xs:string*, $xsltfn as xs:string) {
  let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
  let $q := 'collection("vicav_texts")//tei:div[@xml:id="' || $id || '"]'
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
  let $style := doc($stylePath)
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

declare 
    %rest:path("vicav/dict_index")
    %rest:query-param("dict", "{$dict}")    
    %rest:query-param("ind", "{$ind}")    
    %rest:query-param("str", "{$str}")    
    
    %rest:GET 
    %output:method("html")
     
    
function vicav:query-index___($dict as xs:string, $ind as xs:string, $str as xs:string) {  
let $rs := 
 switch($ind)
   case "any" return collection($dict)//index/w[starts-with(.,$str)]
   default return 
            if ($str='*')
               then collection($dict)//index[@id=$ind]/w
               else collection($dict)//index[@id=$ind]/w[starts-with(.,$str)]

let $rs2 := <res>{
    for $r in $rs
    return <w index="{$r/../@id}">{$r/text()}</w>
  }</res>

  let $style := doc('xslt/index_2_html.xslt')
  let $ress := <results>{$rs2}</results>
  let $sReturn := xslt:transform($ress, $style)
  return
    $sReturn
};

declare function vicav:createMatchString($in as xs:string) {
  let $s := replace($in, '"', '')
  let $s1 := 
    if (contains($s, '*') or contains($s, '.') or contains($s, '^') or contains($s, '$') or contains($s, '+')  )
    then 'matches(., "' || $s ||'")'
    else '.="' || $s || '"'    
    
  return $s1
};

declare 
    %rest:path("vicav/dict_api")
    %rest:query-param("query", "{$query}")    
    %rest:query-param("dict", "{$dict}")    
    %rest:query-param("xslt", "{$xsltfn}")    
    %rest:GET 

function vicav:dict_query($dict as xs:string, $query as xs:string*, $xsltfn as xs:string) {  
  (: let $user := substring-before($autho, ':')
  let $pw := substring-after($autho, ':') :)
   
  let $nsTei := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
  let $queries := tokenize($query, ',')
  let $qs := 
     for $query in $queries
        let $terms := tokenize(normalize-space($query), '=')
        return
          switch(normalize-space($terms[1]))
          case 'any' return      '[.//node()[' || vicav:createMatchString($terms[2]) || ']]'
          case 'lem' return      '[tei:form[@type="lemma"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
          case 'infl' return     '[tei:form[@type="inflected"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
          case 'en' return       '[tei:sense/tei:cit[@type="translation"][@xml:lang="en"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
          case 'de' return       '[tei:sense/tei:cit[@type="translation"][@xml:lang="de"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
          case 'fr' return       '[tei:sense/tei:cit[@type="translation"][@xml:lang="fr"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
          case 'etymLang' return '[tei:etym/tei:lang[' || vicav:createMatchString($terms[2]) || ']]'
          case 'etymSrc' return  '[tei:etym/tei:mentioned['|| vicav:createMatchString($terms[2]) || ']]'
          case 'root' return     '[tei:gramGrp/tei:gram[@type="root"][' || vicav:createMatchString($terms[2]) || ']]'
          case 'subc' return     '[tei:gramGrp/tei:gram[@type="subc"][' || vicav:createMatchString($terms[2]) || ']]'
          case 'pos' return      '[tei:gramGrp/tei:gram[@type="pos"][' || vicav:createMatchString($terms[2]) || ']]'          
          default return ()
    
  let $qq := 'collection("' || $dict || '")//tei:entry'||string-join($qs)
  let $results := xquery:eval($nsTei||$qq)
  (: return <answer>{count($res)}||{$res}</answer> :)
  
  (: let $results := xquery:eval($query):)
  let $eds := distinct-values($results//tei:fs/tei:f[@name='who']/tei:symbol/@value) 
  let $editors := 
    for $ed in $eds
      return <ed>{$ed}</ed>
    
  let $exptrs := $results//tei:ptr[@type = 'example']
  let $entries := 
    for $r in $results
      return ($r/ancestor::tei:entry, $r/ancestor::tei:cit[@type='example'], $r)[1]

  let $res := vicav:distinct-nodes($entries)
  let $res2 := for $e in $res return vicav:expandExamplePointers($e, collection($dict))
   
  let $style := doc("xslt/"||$xsltfn)
  let $ress := <results xmlns="http://www.tei-c.org/ns/1.0">{$res2}||<eds>{$editors}</eds></results>
  let $sReturn := xslt:transform-text($ress, $style)

  return     
     $sReturn 
    (: if (wde:check-user_($dict, $user, $pw)) :)
      (: then $sReturn :)
      (: else <error type="user authentication" name="{$user}" pw="{$pw}"/> :)       
  

};

declare
  %rest:path("vicav/bibl_markers")
  %rest:query-param("query", "{$query}")    
  %rest:query-param("scope", "{$scope}")    
  %rest:GET
  %output:method("xml")
  
function vicav:get_bibl_markers($query as xs:string, $scope as xs:string) {

let $queries := tokenize($query, ',')
let $qs := 
  for $query in $queries
    return
     if (contains($query, 'geo:')) then '[dc:subject[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]' else
     if (contains($query, 'reg:')) then '[dc:subject[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]' else
     if (contains($query, 'vt:')) then '[dc:subject[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]' else 
     '[node()[text() contains text "' || $query ||'" using wildcards using diacritics sensitive]]'

let $ns := "declare namespace bib = 'http://purl.org/net/biblio#'; "||
           "declare namespace rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'; "||
           "declare namespace foaf= 'http://xmlns.com/foaf/0.1/'; "||  
           "declare namespace dc = 'http://purl.org/dc/elements/1.1/';"
let $q := 'let $arts := collection("vicav_biblio")//node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection") or (name()="bib:Thesis")]' ||       
          string-join($qs) ||
          'for $art in $arts ' ||
          'let $author := $art/bib:authors[1]/rdf:Seq[1]/rdf:li[1]/foaf:Person[1]/foaf:surname[1] ' ||
          'order by $author return $art'
let $query := $ns||$q
let $tempresults := xquery:eval($query)   
(: return count($tempresults) :)
                  
let $out := 
  for $subj at $icnt in $tempresults
  return 
    let $geos := 
    switch($scope)
      case 'geo_reg' return $subj/dc:subject[contains(., 'reg:') or contains(., 'geo:')]
      case 'geo' return $subj/dc:subject[contains(., 'geo:')]
      case 'reg' return $subj/dc:subject[contains(., 'reg:')]
      default return ()
    
    for $geo in $geos
    return
      let $abstract := $subj/dcterms:abstract[contains(., '(biblid:')][1]
      let $after := fn:substring-after($abstract,'(biblid:')
      let $id := fn:substring-before($after, ')')
    
      return 
        if (string-length($geo) > 0) 
          then (            
            let $type := fn:substring-before($geo,':')
            let $altItem := replace($geo, 'geo:|reg:', '')           
            let $locname := fn:substring-before($altItem,'[')
            let $locname :=  fn:normalize-space($locname)
            let $locname := fn:replace($locname, '''', '&#180;')
            let $sa := fn:substring-after($altItem,'[')
            let $geodata := fn:substring-before($sa,']')                    
          
            return 
              if (string-length($locname) = 0) then (
                <item><type>{$type}</type><geo></geo><loc>{$altItem}</loc><id>{$id}</id></item>
              ) else (
                <item><type>{$type}</type><geo>{$geodata}</geo><loc>{$locname}</loc><id>{$id}</id></item>
              )
          
          )  else ()
         
let $out1 := <r>{$out}</r> 
let $out := 
  for $item at $icnt in $out1/item 
    let $loc := $item/loc/string(),$geo := $item/geo
              
    for $id in $item/id
      group by $loc
            
      let $s := for $i in $item/id
         return $i/text()||","         
    
      return 
        if (string-length($geo[1]/text()) > 0) then (
          (: if the <geo> element is empty, no output should be generated:)
        
          if ($item/type = 'geo') then (
            <r type='geo'><loc>{$geo[1]/text()}</loc><alt>{$loc}</alt><freq>{count($id)}</freq></r>            
          ) else (            
            <r type='reg'><loc>{$geo[1]/text()}</loc><alt>{$loc}</alt><freq>{count($id)}</freq></r>
          ) 
        ) else ()

  (: return file:write("c:\dicttemp\geo_bibl_001.txt", $out) :)
  return <rs type="{count($out)}">{$out}</rs>
                 
};        

declare
  %rest:path("vicav/profile_markers")
  %rest:GET
  %output:method("xml")
  
function vicav:get_profile_markers() {
    let $entries := collection('vicav_profiles')//tei:TEI
    let $out := 
        for $item in $entries
            return <r type='geo'>{$item/@xml:id}
                       <loc>{$item/tei:text/tei:body/tei:div/tei:div/tei:p/tei:geo/text()}</loc>
                       <alt>{$item//tei:text[1]/tei:body[1]/tei:div[1]/tei:head[1]/tei:name[1]/text()}</alt>
                       <freq>1</freq>
                   </r>
  
    return <rs>{$out}</rs>
};
