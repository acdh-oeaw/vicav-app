xquery version "3.0";

module namespace vicav_001 = "http://acdh.oeaw.ac.at/vicav_001";
declare namespace bib = 'http://purl.org/net/biblio#';
declare namespace dc = 'http://purl.org/dc/elements/1.1/';

declare 
    %rest:path("vicav_001/biblio")
    %rest:query-param("q", "{$q}")
    %rest:query-param("s", "{$style}")
   
    %rest:GET 
    
function vicav_001:query-index($q as xs:string*, $style as xs:string) {
  let $ns := "declare namespace bib = 'http://purl.org/net/biblio#'; "||
             "declare namespace rdf = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'; "||
             "declare namespace foaf= 'http://xmlns.com/foaf/0.1/'; "||  
             "declare namespace dc = 'http://purl.org/dc/elements/1.1/';"
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $style
  let $style := doc($stylePath)
  let $num := count($results)
  let $results := <results num="{$num}">{$results}</results>
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

declare 
    %rest:path("vicav_001/profile")
    %rest:query-param("q", "{$q}")
    %rest:query-param("s", "{$style}")
   
    %rest:GET 
    
function vicav_001:get_profile($q as xs:string*, $style as xs:string) {
    
  let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $style
  let $style := doc($stylePath)
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

declare 
    %rest:path("vicav_001/text")
    %rest:query-param("q", "{$q}")
    %rest:query-param("s", "{$style}")
   
    %rest:GET 
    
function vicav_001:get_text($q as xs:string*, $style as xs:string) {
  let $ns := "declare namespace tei = 'http://www.tei-c.org/ns/1.0';"
  let $query := $ns||$q
  let $results := xquery:eval($query)   
  let $stylePath := file:base-dir() || 'xslt/' || $style
  let $style := doc($stylePath)
  let $sHTML := xslt:transform-text($results, $style)
  return $sHTML
};

(:~
 : Returns a file.
 : @param  $file  file or unknown path
 : @return rest response and binary file
 :)
declare
  %rest:path("vicav_001/{$file=.+}")
  %rest:GET

function vicav_001:deliver_file($file as xs:string) as item()+ {
  let $path := file:base-dir() || $file
  return (
    web:response-header(map { 'media-type': web:content-type($path) }),  file:read-binary($path) 
  )
};
