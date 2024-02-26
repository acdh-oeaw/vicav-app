declare namespace tei="http://www.tei-c.org/ns/1.0";

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
return file:write('feature_list.json', $json)