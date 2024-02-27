module namespace _ = "http://acdh.oeaw.ac.at/vicav-wibarab";
import module namespace cors = 'https://www.oeaw.ac.at/acdh/tools/vle/cors' at 'cors.xqm';
import module namespace api-problem = "https://tools.ietf.org/html/rfc7807" at "api-problem.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare
   %rest:path('/vicav/featurelist.json')
   %rest:produces("application/json")
   %rest:GET
 function _:featurelist(){
 api-problem:or_result (prof:current-ns(),
    _:_featurelist#0, [], map:merge((cors:header(()), _:return_content_header()))
  )
};

declare function _:_featurelist(){
  let $docs := db:open('wibarab_features')//tei:TEI
let $result :=
   array{ for $doc in $docs
  let $filename := fn:tokenize(base-uri($doc), '/')[last()]
    where starts-with($filename, 'feature')
    return
        map {
           string($doc/@xml:id): 
                map {
                    "title": string($doc//tei:title),
                    "values": array {
                        let $items := $doc//tei:list[@type = "featureValues"]/tei:item
                        for $item in $items
                        return map {string($item/@xml:id): string($item/tei:label)}
                    }
                }
            }
        }

let $json := fn:serialize($result, map { "method": "json", "indent": "yes" })
return $json
};

declare function _:return_content_header() {
  let $first-accept-header := replace(try { request:header("ACCEPT") } catch basex:http { 'application/xhtml+xml' }, '^([^,]+).*', '$1')
  return switch ($first-accept-header)
  case '' return map{}
  default return map{'Content-Type': $first-accept-header||';charset=UTF-8'}
};
