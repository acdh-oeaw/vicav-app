module namespace vicav = "http://acdh.oeaw.ac.at/vicav";
declare namespace bib = 'http://purl.org/net/biblio#';
declare namespace dc = 'http://purl.org/dc/elements/1.1/';
declare namespace tei = 'http://www.tei-c.org/ns/1.0';
declare namespace dcterms = "http://purl.org/dc/terms/";
declare namespace prof = "http://basex.org/modules/prof";


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

declare function vicav:get_project_name() as xs:string {
    let $project := doc('vicav_projects/projects.xml')/projects/project[matches(request:hostname(), @regex)]/text()
    return if (empty($project) or $project = '') then 'vicav' else $project
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
%rest:path("vicav/project")
%rest:GET

function vicav:project_config() {
    let $path := 'vicav_projects/' || vicav:get_project_name() || '.xml'
    let $config := if (doc-available($path)) then doc($path)/projectConfig else <projectConfig><menu></menu></projectConfig>
    let $renderedMenu := xslt:transform($config/menu, 'xslt/menu.xslt')
    return <project><config>{$config}</config><renderedMenu>{$renderedMenu}</renderedMenu></project>
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
        else
           '[.//node()[text() contains text "' || $query || '" using wildcards using diacritics sensitive]]'  
    
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'let $arts := ' ||
    'collection("vicav_biblio'  || vicav:get_project_db() || '")//tei:biblStruct' ||
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
    
    let $stylePath := file:base-dir() || 'xslt/' || $xsltfn
    let $style := doc($stylePath)
    let $num := count($results)
    
    let $results := <results
        num="{$num}">{$results}</results>
    let $sHTML := xslt:transform-text($results, $style)
    return
        (: <r>{$sHTML}</r> :)
        $sHTML
        (: <r>{$query2}</r> :)
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
        collection("vicav_biblio" || vicav:get_project_db())//tei:biblStruct[@corresp = 'http://zotero.org/groups/2165756/items/' || $id]
    
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
    let $stylePath := file:base-dir() || 'xslt/'
    let $style := doc($stylePath || $xsltfn)

    let $xslt := if (empty($print)) then $style else xslt:transform-text(doc($stylePath || 'printable.xslt'), doc($stylePath || 'printable_path.xslt'), map {'xslt': $stylePath || $xsltfn})

    let $sHTML := xslt:transform-text($doc, $xslt, $options)
    return
        $sHTML
};

declare
%rest:path("vicav/profile")
%rest:query-param("coll", "{$coll}")
%rest:query-param("id", "{$id}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("print", "{$print}")

%rest:GET

function vicav:get_profile($coll as xs:string, $id as xs:string*, $xsltfn as xs:string, $print as xs:string*) {
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("' || $coll || vicav:get_project_db() || '")//tei:TEI[@xml:id="' || $id || '"]'
    let $query := $ns || $q
    let $results := xquery:eval($query)
    return vicav:transform($results, $xsltfn, $print, ())
};

declare
%rest:path("vicav/sample")
%rest:query-param("coll", "{$coll}")
%rest:query-param("id", "{$id}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("print", "{$print}")

%rest:GET

function vicav:get_sample($coll as xs:string*, $id as xs:string*, $xsltfn as xs:string, $print as xs:string*) {
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("' || $coll || vicav:get_project_db() || '")//tei:TEI[@xml:id="' || $id || '"]'
    let $query := $ns || $q
    let $results := xquery:eval($query)
    return vicav:transform($results, $xsltfn, $print, ())
};


declare
%rest:path("vicav/features")
%rest:query-param("ana", "{$ana}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:query-param("expl", "{$expl}")

%rest:GET

function vicav:get_lingfeatures($ana as xs:string*, $expl as xs:string*, $xsltfn as xs:string) {
    let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
    let $q := 'collection("vicav_lingfeatures'  || vicav:get_project_db() ||'")//tei:cit[@type="featureSample" and (.//tei:w[contains-token(@ana,"' || $ana || '")][1] or .//tei:phr[contains-token(@ana,"' || $ana || '")][1])]'
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
        $sHTML
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
        '(.//tei:person/text() = ['|| string-join($ps, ',') ||'])'
        else ''

    let $words_q := for $w in tokenize($word, ',')
            let $match_str := if (contains($w, '*')) then
                '[matches(.,"(^|\W)' || replace($w, '\*', '.*') || '($|\W)")][1]'
                else 
                '[contains-token(.,"' || $w || '")][1]'
            return 
                vicav:or(('.//tei:w' || $match_str, './/tei:f' || $match_str, './/tei:phr' || $match_str))

    let $word_q := if (empty($words_q)) then '' else vicav:or($words_q)

    let $age_bounds := if ($age) then
            for $a in tokenize($age, ',')
            order by number($a)
            return $a
        else ()

    let $age_q := if (not(empty($age_bounds)) and ($age_bounds[2] != "100" or $age_bounds[1] != "0")) then 
        vicav:and((
            '(.//tei:person/@age > ' || min($age_bounds) || ')',
            ' (.//tei:person/@age < ' || max($age_bounds) || ')'
        ))
        else ''

    let $sex_qqs := if (not(empty($sex))) then
        for $s in tokenize($sex, ',')
            return '"' || lower-case($s) || '"'
        else ()

    let $sex_q := if (not(empty($sex_qqs))) then
        ' (.//tei:person/@sex = [' || string-join($sex_qqs, ',') || '])'
        else ''
    
    let $loc_qs := for $id in tokenize($location, ',')
            return "'" || $id || "'" 

    let $location_q := if(not(empty($loc_qs))) then 
        vicav:or((
            './/tei:settlement/tei:name/text() = [' || string-join($loc_qs, ',') || ']', 
            './/tei:name/text() = [' || string-join($loc_qs, ',') || ']',  
            './/tei:region/text() = [' || string-join($loc_qs, ',') || ']',        
            './/tei:country/text() = [' || string-join($loc_qs, ',') || ']'
        ))
    else
        ""

    let $loc_word_age_sex_q := if (($location_q != '' or $word_q != '') or $person_q = '') then vicav:and(($location_q, $word_q, $age_q, $sex_q)) else ''

    let $full_tei_query := vicav:or(($person_q, $loc_word_age_sex_q))

    let $full_tei_query := if (not($full_tei_query = '')) then
        '[' || $full_tei_query || ']'
        else 
        $full_tei_query

    let $query := 'declare namespace tei = "http://www.tei-c.org/ns/1.0"; collection("' || $collection ||'")//tei:TEI' 
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
        let $city := $item//tei:teiHeader//tei:profileDesc/tei:settingDesc/tei:place/tei:settlement/tei:name[@xml:lang="en"]/text()
        let $informant := $item//tei:teiHeader//tei:profileDesc/tei:particDesc/tei:person[1]/text()
        let $age := $item//tei:teiHeader//tei:profileDesc/tei:particDesc/tei:person[1]/@age
        let $sex := $item//tei:teiHeader//tei:profileDesc/tei:particDesc/tei:person[1]/@sex

        return
           <item city="{$city}" informant="{$informant}" age="{$age}" sex="{$sex}">{$item}</item>
    let $ress1 := <items>{$ress}</items>
    return $ress1    
};


declare
%rest:path("vicav/explore_samples")
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
    let $comment_filter := if (empty($comment)) then '' else $comment

 (:   let $ress := vicav:explore-query(
        'vicav_' || $resourcetype || vicav:get_project_db(),
        $location, 
        $word,
        $person, 
        $age, 
        $sex
    )

    return $ress
    :)

    let $ress1 := vicav:explore-data(
        'vicav_' || $resourcetype || vicav:get_project_db(),
        $location, 
        $word,
        $person, 
        $age, 
        $sex
    )//item

    let $ress := <items>{$ress1}</items>

    let $sHTML := vicav:transform($ress, $xsltfn, $print, map {
        "highlight":string($word),
        "filter-words": string($word), 
        "filter-features":$filter_features, 
        "filter-translations": $trans_filter,
        "filter-comments": $comment_filter
    })

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
    let $rs := (# db:enforceindex #) {
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
    }

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
%rest:path("vicav/dicts_api")
%rest:query-param("query", "{$query}")
%rest:query-param("dicts", "{$dicts}")
%rest:query-param("xslt", "{$xsltfn}")
%rest:GET

function vicav:dicts_query($dicts as xs:string, $query as xs:string*, $xsltfn as xs:string) {
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

let $style := doc("xslt/" || $xsltfn)
let $ress := <results xmlns="http://www.tei-c.org/ns/1.0">{$results}</results>
let $sReturn := xslt:transform-text($ress, $style)
return
  $sReturn
  (: $ress :)
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
    (: $res :)
    (: <r>{$qs}</r> :)
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
    let $q := 'let $arts := collection("vicav_biblio' || vicav:get_project_db() || '")//node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection") or (name()="bib:Thesis")]' ||
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
  
    let $q := 'let $arts := collection("vicav_biblio' || vicav:get_project_db() ||'")//tei:biblStruct' || string-join($qs) || 
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
                        return $subj/tei:note/tei:note[(tei:name/@type = 'reg') or (tei:name/@type = 'geo') or (tei:name/@type = 'diaGroup')]
                    case 'geo'
                        return $subj/tei:note/tei:note[tei:name/@type = 'geo']
                    case 'diaGroup'
                        return $subj/tei:note/tei:note[tei:name/@type = 'diaGroup']
                    case 'reg'
                        return $subj/tei:note/tei:note[tei:name/@type = 'reg']
            default return ()
    
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
        
    return <rs type="{count($out2)}">{$out2}</rs>
    (: return <res>{$out}</res> :)
    (: return <res>{$query}</res> :) 
};

declare
%rest:path("vicav/profile_markers")
%rest:GET
%output:method("xml")

function vicav:get_profile_markers() {
    let $entries := collection('vicav_profiles' || vicav:get_project_db())//tei:TEI
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
    
    return
        <rs>{$out}</rs>
};

declare
%rest:path("vicav/data_locations")
%rest:GET
%rest:query-param("type", "{$type}")
%output:method("xml")
function vicav:data_locations($type as xs:string*) {
    let $type := if ($type = () or $type = '') then 'samples' else $type

    let $entries := collection('vicav_' || $type || vicav:get_project_db())//tei:TEI/(.//tei:name[1], .//tei:settlement[1]/tei:name[@xml:lang="en"], .//tei:place/tei:region[1], .//tei:place/tei:country[1])

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
            <name>{replace($label, '^.+:', '')}</name>
        </location>
       
    return  <results>{$out}</results>
};

declare
%rest:path("vicav/sample_markers")
%rest:GET
%output:method("xml")

function vicav:get_sample_markers() {
    let $entries := collection("vicav_samples" || vicav:get_project_db())//tei:TEI
    let $out :=
    for $item in $entries
        order by $item/@xml:id
        let $loc := replace($item//tei:geo/text(), '(\d+(\.|,)\s*\d+,\s*\d+(\.|,)\s*\d+).*', '$1')
        let $alt := if ($item//tei:person) then string-join(($item//tei:person[1]/text(), $item//tei:person[1]/@sex, $item//tei:person[1]/@age), '/') else $item//tei:name[1]/text()
        
        return
            if (string-length($loc[1])>0) then
            <r
                type='geo'>{$item/@xml:id}
                <loc>{$loc[1]}</loc>
                <locName></locName>
                <alt>{$alt[1]}</alt>
                <freq>1</freq>
            </r>
            else ()
    
    return
        <rs>{$out}</rs>
};

declare
%rest:path("vicav/feature_labels")
%rest:GET
%output:method("xml")

function vicav:get_feature_labels() {
    let $features := collection('vicav_lingfeatures' || vicav:get_project_db())//tei:TEI//tei:cit[@type="featureSample"]
    let $out := for $ana in distinct-values($features/@ana)
        return <feature ana="{$ana}">{$features[./@ana = $ana][1]/tei:lbl/text()}</feature>

    return
        <features>{$out}</features>
};


declare
%rest:path("vicav/data_persons")
%rest:GET
%rest:query-param("type", "{$type}")
%output:method("xml")

function vicav:get_sample_persons($type as xs:string*) {
    let $type := if ($type = () or $type = '') then 'samples' else $type

    let $persons := collection('vicav_' || $type || vicav:get_project_db())//tei:TEI//tei:person
    let $out :=
    for $person in $persons
        order by $person/text()
        return 
        <person age="{$person/@age}" sex="{$person/@sex}">
            {$person/text()}
        </person>
    
    return
        <persons>{$out}</persons>
};

declare
%rest:path("vicav/data_words")
%rest:query-param("type", "{$type}")
%rest:GET
%output:method("xml")

function vicav:get_sample_words($type as xs:string*) {
    let $type := if ($type = () or $type = '') then 'samples' else $type

    let $persons := for $w in collection('vicav_' || $type || vicav:get_project_db())//tei:TEI//tei:w//tei:f[@name="wordform"]/text()
       return replace(normalize-space($w), '[\s&#160;]', '')

    let $out :=
    for $person in distinct-values($persons)
        order by $person
        return 
        <word>
            {$person}
        </word>
    
    return
        <words>{$out}</words>
};


declare
%rest:path("vicav/feature_markers")
%rest:GET
%output:method("xml")

function vicav:get_feature_markers() {
    let $entries := collection('vicav_lingfeatures' || vicav:get_project_db())//tei:TEI
    let $out :=
        for $item in $entries
            order by $item/@xml:id
            let $loc := replace($item//tei:geo/text(), '(\d+(\.|,)\s*\d+,\s*\d+(\.|,)\s*\d+).*', '$1')
            let $alt := if ($item//tei:person) then $item//tei:person[1]/text() || '/' || $item//tei:person[1]/@sex || '/' || $item//tei:person[1]/@age else $item//tei:name[1]/text()
            return
                if ($item/@xml:id and $loc) then
                <r type='geo'>    {$item/@xml:id}
                    <loc>{$item//tei:geo/text()}</loc>
                    <loc type="decimal">{$item//tei:geo[@decls="decimal"]/text()}</loc>
                    <alt>{$item//tei:head[1]/tei:name[1]/text()}</alt>
                    <freq>1</freq>
                </r>
                else ''
    
    return
        <rs>{$out}</rs>
};


declare
%rest:path("vicav/data_list")
%rest:query-param("type", "{$type}")
%rest:GET
%output:method("xml")
function vicav:get_data_list($type as xs:string*) {
    let $type := if (empty($type) or $type = '') then 'samples' else $type

    let $items := collection('vicav_' || $type)//tei:TEI

    let $typestring := switch($type)
        case 'lingfeatures' return
            'data-featurelist'
        case 'profiles' return
            'data-profile'
        default return
            'data-sampletext'

    let $out := for $region in distinct-values($items//tei:region)
        order by $region 
        return <div class="region"><h3>{$region}</h3> {for $city in distinct-values($items[.//tei:region[./text() = $region]]//tei:settlement/tei:name[@xml:lang="en"])
            order by $city
            return
                <div class="settlement"><h5>{$city} ({count($items[.//tei:settlement/tei:name[@xml:lang="en"] = $city])})</h5>
                {for $item in $items[.//tei:settlement/tei:name[@xml:lang="en"] = $city]
                                order by $item//tei:person[1]/text()
                                return element p {
                                    element a {
                                        attribute href { '#' },
                                        attribute {$typestring} {$item/@xml:id},
                                        text {$item//tei:person[1]/text()},
                                        text { string-join((' (Revision: ', replace($item//tei:revisionDesc/tei:change[1]/@when, 'T.*', ''), ')')) }
                                    }, element br {}
                                }
                            
                                }</div> 
        }</div>
    return
        <div>Total: {count($items)}<br/>{$out}</div>
};


(:****************************************************************************:)
(:** MANAGEMENT FUNCS ********************************************************:)
(:****************************************************************************:)
declare
%rest:path("vicav/show_docs")
%rest:query-param("db", "{$db}")
%rest:GET
%output:method("html")

function vicav:vicav_show_docs($db as xs:string*) {
  let $docs := db:list($db)
  let $out :=
  for $item in $docs 
    return <div>{$item}</div>
  
  return <p>{$out}</p>
};


declare
%rest:path("vicav/delete_dbase")
%rest:query-param("db", "{$db}")
%rest:GET

updating function vicav:vicav_delete_db($db as xs:string*) {
   db:delete($db, '')
};

declare
%rest:path("vicav/refill_texts")
%rest:query-param("src", "{$src}")
%rest:query-param("db", "{$db}")
%rest:GET

updating function vicav:refill_texts($src as xs:string, $db as xs:string) {
  for $file in file:list($src, true())
  let $path := $src || '\' || $file
  where not(contains($file, 'backup') or contains($file, '.jpg') or contains($file, '.png'))
  return db:add($db, $path)
};

declare
%rest:path("vicav/profiles")
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
        return $tei
};
  
 
