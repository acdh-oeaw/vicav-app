(:~
 : API Problem and JSON HAL based API for editing dictionary like XML datasets.
 :)
xquery version "3.1";

module namespace _ = 'https://www.oeaw.ac.at/acdh/tools/vle/cors';
import module namespace rest = "http://exquery.org/ns/restxq";
import module namespace req = "http://exquery.org/ns/request";
import module namespace util = "https://www.oeaw.ac.at/acdh/tools/vle/util" at 'util.xqm';
import module namespace admin = "http://basex.org/modules/admin"; (: for logging :)

declare namespace http = "http://expath.org/ns/http-client";

declare variable $_:enable_trace := false();

declare 
    %rest:path("restvle{$path=.*}")
    %rest:header-param("Access-Control-Request-Method", "{$requested-method}", "GET")
    %rest:header-param("Access-Control-Request-Headers", "{$requested-headers}")
    %rest:OPTIONS
function _:cors_options_response($path as xs:string, $requested-method as xs:string+, $requested-headers as xs:string*) as element(rest:response){
  let $config := <restCORSconfig/>,
      $origin := try { req:header("Origin") } catch basex:http {'urn:local'}
  return <rest:response>
    <http:response status="200" message="OK">
      <http:header name="Access-Control-Allow-Origin" value="{$origin}"/>
      <http:header name="Access-Control-Allow-Credentials" value="true"/>
      <http:header name="Access-Control-Allow-Methods" value="{string-join($requested-method, ', ')}"/>
      {if (exists($requested-headers)) then <http:header name="Access-Control-Allow-Headers" value="{string-join($requested-headers, ', ')}"/> else ()}
      <http:header name="Access-Control-Max-Age" value="300"/>
    </http:response>
  </rest:response>
};

declare function _:header($config as element(restCORSconfig)?) as map(xs:string, xs:string)? {
  let $origin := try { req:header("Origin") } catch basex:http {'urn:local'}
  return if (exists($origin)) then
  map{"Access-Control-Allow-Origin": $origin,
      "Access-Control-Allow-Credentials": "true"}
  else ()
};

declare %private function _:write-log($message as xs:string, $severity as xs:string) {
  if ($_:enable_trace) then admin:write-log($message, $severity) else ()
};