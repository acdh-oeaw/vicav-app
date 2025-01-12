module namespace _ = "http://acdh.oeaw.ac.at/vicav-wibarab";
import module namespace vicav = 'http://acdh.oeaw.ac.at/vicav' at 'vicav.xqm';
import module namespace cors = 'https://www.oeaw.ac.at/acdh/tools/vle/cors' at 'cors.xqm';
import module namespace api-problem = "https://tools.ietf.org/html/rfc7807" at "api-problem.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare
   %rest:path('/vicav/featurelist.json')
   %rest:produces("application/json")
   %rest:GET
 function _:featurelist(){
 api-problem:or_result (prof:current-ns(),
    _:_featurelist#0, [], map:merge((cors:header(()), map{'Content-Type': 'application/json;charset=UTF-8'}))
  )
};

declare function _:_featurelist(){
  serialize(<json type="object">{vicav:get_featurelist()}</json>, map { "method": "json", "indent": "yes" })
};
