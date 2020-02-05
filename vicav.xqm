module namespace vicav = "http://acdh.oeaw.ac.at/vicav";
declare namespace bib = 'http://purl.org/net/biblio#';
declare namespace dc = 'http://purl.org/dc/elements/1.1/';
declare namespace tei = 'http://www.tei-c.org/ns/1.0';
declare namespace dcterms = "http://purl.org/dc/terms/";


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
    let $q := 'let $arts := collection("vicav_biblio")//node()[(name()="bib:Article") or 
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
        $sHTML
};

declare
%rest:path("vicav/biblio_tei")
%rest:query-param("query", "{$query}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:GET

function vicav:query_biblio_tei($query as xs:string*, $xsltfn as xs:string) {
    let $queries := tokenize($query, ',')
    let $qs :=
    for $query in $queries
    return
        if (contains($query, 'geo:')) then
            '[tei:note/tei:note[@type="tag"]
                                          [text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
        else
            if (contains($query, 'reg:')) then
                '[tei:note/tei:note[@type="tag"]
                                          [text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
            else
                if (contains($query, 'vt:')) then
                    '[tei:note/tei:note[@type="tag"]
                                         [text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
                else
                    '[.//node()[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
    
    
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'let $arts := ' ||
    'collection("vicav_biblio")//tei:biblStruct' ||
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
    let $query := $ns || $q
    let $results := xquery:eval($query)
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $num := count($results)
    let $results := <results
        num="{$num}">{$results}</results>
    let $sHTML := xslt:transform-text($results, $style)
    return
        $sHTML
};

declare
%rest:path("vicav/biblio_id")
%rest:query-param("query", "{$query}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:GET

function vicav:query_biblio_id($query as xs:string*, $xsltfn as xs:string) {
    let $ids := tokenize($query, ' ')
    let $bibls :=
    for $id in $ids
    return
        collection("vicav_biblio")//tei:biblStruct[@corresp = 'http://zotero.org/groups/2165756/items/' || $id]
    
    let $results :=
    for $bibl in $bibls
    let $author :=
    if ($bibl/tei:analytic)
    then
        ($bibl/tei:analytic[1]/tei:author[1]/tei:surname[1] | $bibl/tei:analytic[1]/tei:author[1]/tei:name[1] | $bibl/tei:analytic[1]/tei:editor[1]/tei:surname[1] | $bibl/tei:analytic[1]/tei:editor[1]/tei:name[1])
    else
        ($bibl/tei:monogr[1]/tei:author[1]/tei:surname[1] | $bibl/tei:monogr[1]/tei:author[1]/tei:name[1] | $bibl/tei:monogr[1]/tei:editor[1]/tei:surname[1] | $bibl/tei:monogr[1]/tei:editor[1]/tei:name[1])
    
    let $date := $bibl/tei:monogr[1]/tei:imprint[1]/tei:date[1]
    order by $author,
        $date
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

declare
%rest:path("vicav/profile")
%rest:query-param("coll", "{$coll}")
%rest:query-param("id", "{$id}")
%rest:query-param("xslt", "{$xsltfn}")

%rest:GET

function vicav:get_profile($coll as xs:string, $id as xs:string*, $xsltfn as xs:string) {
    
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("' || $coll || '")//tei:TEI[@xml:id="' || $id || '"]'
    let $query := $ns || $q
    let $results := xquery:eval($query)
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $sHTML := xslt:transform-text($results, $style)
    return
        $sHTML
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
    let $query := $ns || $q
    let $results := xquery:eval($query)
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $sHTML := xslt:transform-text($results, $style)
    return
        $sHTML
};

declare
%rest:path("vicav/features")
%rest:query-param("ana", "{$ana}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("expl", "{$expl}")

%rest:GET

function vicav:get_lingfeatures($ana as xs:string*, $expl as xs:string*, $xsltfn as xs:string) {
    
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("vicav_lingfeatures")//tei:cit[@type="featureSample" and (.//tei:w[contains-token(@ana,"' || $ana || '")][1] || .//tei:phr[contains-token(@ana,"' || $ana || '")][1])]'
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
        (:$ress1:)
        $sHTML
};

declare
%rest:path("vicav/explore_samples")
%rest:query-param("query", "{$query}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("sentences", "{$sentences}")
%rest:query-param("highlight", "{$highlight}")
%rest:query-param("person", "{$person}")


%rest:GET

function vicav:explore_samples($query as xs:string*, $sentences as xs:string*, $person as xs:string*, $highlight as xs:string*, $xsltfn as xs:string) {
    let $places := tokenize($query, ',')

    let $ss := if (not($sentences) or $sentences = 'any' or $sentences = 'all') then 
            "any"
        else 
           $sentences


    if ($person) 
    else 

        (:if ($sentences != '') then
        
    else
      :)  

    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    
    let $qs :=
        for $id in $places
            return "'" || $id || "'" 

    
    let $qq := 'collection("vicav_samples")//tei:TEI[(@xml:id = [' || 
        string-join($qs, ',') || 
        '] or .//tei:name/text() = [' || 
        string-join($qs, ',') || 
        '])]'

    let $query := $ns || $qq    
    let $results := xquery:eval($query)

    let $ress := 
      for $item in $results
        let $city := $item//tei:body/tei:head/tei:name
        let $informant := $item//tei:teiHeader//tei:profileDesc/tei:particDesc/tei:person[1]/text()
        let $age := $item//tei:teiHeader//tei:profileDesc/tei:particDesc/tei:person[1]/@age
        let $sex := $item//tei:teiHeader//tei:profileDesc/tei:particDesc/tei:person[1]/@sex

        return
           <item city="{$city}" informant="{$informant}" age="{$age}" sex="{$sex}">{$item}</item>

    let $ress1 := <items>{$ress}</items>

    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $sHTML := xslt:transform-text($ress1, $style, map {"highlight":string($highlight),"sentences":$ss})

    return
        (:<div type="lingFeatures">{$sHTML}</div>:)
        (:$ress1:)
        $sHTML
};


declare
%rest:path("vicav/text")
%rest:query-param("id", "{$id}")
%rest:query-param("xslt", "{$xsltfn}")

%rest:GET

function vicav:get_text($id as xs:string*, $xsltfn as xs:string) {
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("vicav_texts")//tei:div[@xml:id="' || $id || '"]'
    let $query := $ns || $q
    let $results := parse-xml(serialize(xquery:eval($query), map {'method': 'xml', 'indent': 'yes'}))
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $sHTML := xslt:transform-text($results, $style)
    return
        $sHTML
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
    switch ($ind)
        case "any"
            return
                collection($dict)//index/w[starts-with(., $str)]
        default return
            if ($str = '*')
            then
                collection($dict)//index[@id = $ind]/w
            else
                collection($dict)//index[@id = $ind]/w[starts-with(., $str)]

let $rs2 := <res>{
        for $r in $rs
        return
            <w
                index="{$r/../@id}">{$r/text()}</w>
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
    if (contains($s, '*') or contains($s, '.') or contains($s, '^') or contains($s, '$') or contains($s, '+'))
    then
        'matches(., "' || $s || '")'
    else
        '.="' || $s || '"'
    return
        $s1
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
        switch (normalize-space($terms[1]))
            case 'any'
                return
                    '[.//node()[' || vicav:createMatchString($terms[2]) || ']]'
            case 'lem'
                return
                    '[tei:form[@type="lemma"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'infl'
                return
                    '[tei:form[@type="inflected"]/tei:orth[' || vicav:createMatchString($terms[2]) || ']]'
            case 'en'
                return
                    '[tei:sense/tei:cit[@type="translation"][@xml:lang="en"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'de'
                return
                    '[tei:sense/tei:cit[@type="translation"][@xml:lang="de"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'fr'
                return
                    '[tei:sense/tei:cit[@type="translation"][@xml:lang="fr"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'es'
                return
                    '[tei:sense/tei:cit[@type="translation"][@xml:lang="es"]/tei:quote[' || vicav:createMatchString($terms[2]) || ']]'
            case 'etymLang'
                return
                    '[tei:etym/tei:lang[' || vicav:createMatchString($terms[2]) || ']]'
            case 'etymSrc'
                return
                    '[tei:etym/tei:mentioned[' || vicav:createMatchString($terms[2]) || ']]'
            case 'root'
                return
                    '[tei:gramGrp/tei:gram[@type="root"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'subc'
                return
                    '[tei:gramGrp/tei:gram[@type="subc"][' || vicav:createMatchString($terms[2]) || ']]'
            case 'pos'
                return
                    '[tei:gramGrp/tei:gram[@type="pos"][' || vicav:createMatchString($terms[2]) || ']]'
            default return
                ()

let $qq := 'collection("' || $dict || '")//tei:entry' || string-join($qs)
let $results := xquery:eval($nsTei || $qq)
(: return <answer>{count($res)}||{$res}</answer> :)

(: let $results := xquery:eval($query):)

(:
let $eds := distinct-values($results//tei:fs/tei:f[@name = 'who']/tei:symbol/@value)
let $editors :=
for $ed in $eds
return
    <ed>{$ed}</ed>
:)

let $ress1 :=
   for $entry in $results
      let $eds := distinct-values($entry//tei:fs/tei:f[@name = 'who']/tei:symbol/@value)
      let $editors :=
      for $ed in $eds
      return
        <span xmlns="http://www.tei-c.org/ns/1.0" type="editor">{$ed}</span>
        return <div xmlns="http://www.tei-c.org/ns/1.0" type="entry">{$entry}{$editors}</div>
        
let $exptrs := $ress1//tei:ptr[@type = 'example']
let $entries :=
for $r in $ress1
return
    ($r/ancestor::tei:entry, $r/ancestor::tei:cit[@type = 'example'], $r)[1]

let $res := vicav:distinct-nodes($entries)
let $res2 := for $e in $res
return
    vicav:expandExamplePointers($e, collection($dict))

let $style := doc("xslt/" || $xsltfn)
let $ress := <results  xmlns="http://www.tei-c.org/ns/1.0">{$res2}</results>
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
    let $q := 'let $arts := collection("vicav_biblio")//node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection") or (name()="bib:Thesis")]' ||
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
    <rs
        type="{count($out)}">{$out}</rs>

};

declare
%rest:path("vicav/bibl_markers_tei")
%rest:query-param("query", "{$query}")
%rest:query-param("scope", "{$scope}")
%rest:GET
%output:method("xml")

function vicav:get_bibl_markers_tei($query as xs:string, $scope as xs:string) {
    let $queries := tokenize($query, ',')
    let $qs :=
        for $query in $queries
            return '[tei:note/tei:note[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'
  
    let $q := 'let $arts := collection("vicav_biblio")//tei:biblStruct' || string-join($qs) || 
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
        for $subj at $icnt in $tempresults
        return
            let $geos :=
                switch ($scope)
                    case 'geo_reg'
                        return $subj/tei:note/tei:note[contains(., 'reg:') or contains(., 'geo:')]
                    case 'geo'
                        return $subj/tei:note/tei:note[contains(., 'geo:')]
                    case 'reg'
                        return $subj/tei:note/tei:note[contains(., 'reg:')]
            default return ()
    
    for $geo in $geos
    return
        let $id := $subj/@corresp
        
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
            else ()

    let $out1 := <r>{$out}</r>
    let $out :=
    for $item at $icnt in $out1/item
    let $loc := $item/loc/string(),
    $geo := $item/geo

    for $id in $item/id
    group by $loc

    let $s := for $i in $item/id
    return $i/text() || ","

    return
    if (string-length($geo[1]/text()) > 0) then
        (
       
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
    else  ()
        
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
    return
        <r
            type='geo'>{$item/@xml:id}
            <loc>{$item/tei:text/tei:body/tei:div/tei:div/tei:p/tei:geo/text()}</loc>
            <alt>{$item//tei:text[1]/tei:body[1]/tei:div[1]/tei:head[1]/tei:name[1]/text()}</alt>
            <freq>1</freq>
        </r>
    
    return
        <rs>{$out}</rs>
};

declare
%rest:path("vicav/sample_markers")
%rest:GET
%output:method("xml")

function vicav:get_sample_markers() {
    let $entries := collection('vicav_samples')//tei:TEI
    let $out :=
    for $item in $entries
        order by $item/@xml:id
        let $loc := $item/tei:text/tei:body//tei:geo[1]/text()
        let $alt := $item//tei:text[1]/tei:body[1]//tei:head[1]/tei:name[1]/text()

        let $same_loc := $entries[.//tei:text/tei:body//tei:geo[1]/text() = $loc]/@xml:id
        let $index := if ($same_loc) then 
                        index-of($same_loc, $item/@xml:id)
                        else (0) 
(:
        let $alt := if ($index > 1) then
                        concat($alt, ' ', $index)
                    else ($alt) :)
        
        return
            <r
                type='geo'>{$item/@xml:id}
                <loc>{$loc}</loc>
                <alt>{$alt}</alt>
                <freq>1</freq>
            </r>
    
    return
        <rs>{$out}</rs>
};

declare
%rest:path("vicav/feature_markers")
%rest:GET
%output:method("xml")

function vicav:get_feature_markers() {
    let $entries := collection('vicav_lingfeatures')//tei:TEI
    let $out :=
        for $item in $entries
            return
                if ($item/@xml:id and $item//tei:geo/text()) then
                <r
                    type='geo'>{$item/@xml:id}
                    <loc>{$item//tei:geo/text()}</loc>
                    <alt>{$item//tei:head[1]/tei:name[1]/text()}</alt>
                    <freq>1</freq>
                </r>
                else ''
    
    return
        <rs>{$out}</rs>
};
