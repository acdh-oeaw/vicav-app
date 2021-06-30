xquery version "3.1";
module namespace api = "http://acdh.oeaw.ac.at/vicav/api/http";
import module namespace request = "http://exquery.org/ns/request";
import module namespace jobs = "http://basex.org/modules/jobs";
import module namespace l = "http://basex.org/modules/admin";

import module namespace rest = "http://exquery.org/ns/restxq";

declare function api:get-base-uri-public() as xs:string {
    let $forwarded-hostname := if (contains(request:header('X-Forwarded-Host'), ',')) 
                                 then substring-before(request:header('X-Forwarded-Host'), ',')
                                 else request:header('X-Forwarded-Host'),
        $urlScheme := if ((lower-case(request:header('X-Forwarded-Proto')) = 'https') or 
                          (lower-case(request:header('Front-End-Https')) = 'on')) then 'https' else 'http',
        $port := if ($urlScheme eq 'http' and request:port() ne 80) then ':'||request:port()
                 else if ($urlScheme eq 'https' and not(request:port() eq 80 or request:port() eq 443)) then ':'||request:port()
                 else '',
        (: FIXME: this is to naive. Works for ProxyPass / to /exist/apps/cr-xq-mets/project
           but probably not for /x/y/z/ to /exist/apps/cr-xq-mets/project. Especially check the get module. :)
        $xForwardBasedPath := (request:header('X-Forwarded-Request-Uri'), request:path())[1]
    return $urlScheme||'://'||($forwarded-hostname, request:hostname())[1]||$port||$xForwardBasedPath
};

(:~
 : Returns a html or related file.
 : @param  $file  file or unknown path
 : @return rest response and binary file
 :)
declare
  %rest:path("vicav/{$file=[^/]+}")
function api:file($file as xs:string) as item()+ {
  let $path := api:base-dir()|| $file
  return if (file:exists($path)) then
    if (matches($file, '\.(htm|html|pdf|m4a|js|docx|map|css|png|gif|jpg|jpeg|woff|woff2|svg|ttf)$', 'i')) then
    (
      web:response-header(map { 'media-type': web:content-type($path) }, 
                          map { 'X-UA-Compatible': 'IE=11' }),
      file:read-binary($path)
    ) else api:forbidden-file($file)
  else
  (
  <rest:response>
    <http:response status="404" message="{$file} was not found.">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
  </rest:response>,
  <html xmlns="http://www.w3.org/1999/xhtml">
    <title>{$file||' was not found'}</title>
    <body>        
       <h1>{$file||' was not found'}</h1>
    </body>
  </html>
  )
};

declare
  %rest:path("vicav/js/{$file=.+}")
function api:bower_components-file($file as xs:string) as item()+ {
  api:file('js/'||$file)
};

declare
  %rest:path("vicav/downloads/{$file=.+}")
function api:docs-file($file as xs:string) as item()+ {
  api:file('downloads/'||$file)
};

declare
  %rest:path("vicav/docs/{$file=.+}")
function api:pdf-file($file as xs:string) as item()+ {
  api:file('docs/'||$file)
};

declare
  %rest:path("vicav/css/{$file=.+}")
function api:css-file($file as xs:string) as item()+ {
  api:file('css/'||$file)
};

declare
  %rest:path("vicav/vendor/{$file=.+}")
function api:vendor-file($file as xs:string) as item()+ {
  api:file('vendor/'||$file)
};


declare
  %rest:path("vicav/images/{$file=.+}")
function api:images-file($file as xs:string) as item()+ {
  api:file('images/'||$file)
};

declare
  %rest:path("vicav/sound/{$file=.+}")
function api:sound-file($file as xs:string) as item()+ {
  api:file('sound/'||$file)
};

declare
  %rest:path("vicav/fonts/{$file=.+}")
function api:fonts-file($file as xs:string) as item()+ {
  api:file('fonts/'||$file)
};

declare
  %rest:path("vicav/favicons/{$file=.+}")
function api:favicons-file($file as xs:string) as item()+ {
  api:file('favicons/'||$file)
};

declare %private function api:base-dir() as xs:string {
  file:base-dir()
  (: if this is in a subdirectory say "responses"
  replace(file:base-dir(), '^(.+)responses.*$', '$1') :)
};

(:~
 : Returns index.html on /.
 : @param  $file  file or unknown path
 : @return rest response and binary file
 :)
declare
  %rest:path("vicav")
function api:index-file() as item()+ {
  let $index-html := api:base-dir()||'index.html',
      $index-htm := api:base-dir()||'index.htm',
      $uri := rest:uri(),
(:      $log := l:write-log('api:index-file() $uri := '||$uri||' base-uri-public := '||api:get-base-uri-public(), 'DEBUG'),:)
      $absolute-prefix := if (matches(api:get-base-uri-public(), '/$')) then () else api:get-base-uri-public()||'/'
  return if (exists($absolute-prefix)) then
    <rest:response>
      <http:response status="302">
        <http:header name="Location" value="{$absolute-prefix}"/>
      </http:response>
    </rest:response>
  else if (file:exists($index-html)) then
    <rest:forward>index.html</rest:forward>
  else if (file:exists($index-htm)) then
    <rest:forward>index.htm</rest:forward>
  else api:forbidden-file($index-html)    
};

(:~
 : Return 403 on all other (forbidden files).
 : @param  $file  file or unknown path
 : @return rest response and binary file
 :)
declare
  %private
function api:forbidden-file($file as xs:string) as item()+ {
  <rest:response>
    <http:response status="403" message="{$file} forbidden.">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
  </rest:response>,
  <html xmlns="http://www.w3.org/1999/xhtml">
    <title>{$file||' forbidden'}</title>
    <body>        
       <h1>{$file||' forbidden'}</h1>
    </body>
  </html>
};

declare
  %rest:error('*')
  %rest:error-param("code", "{$code}")
  %rest:error-param("description", "{$description}")
  %rest:error-param("value", "{$value}")
  %rest:error-param("module", "{$module}")
  %rest:error-param("line-number", "{$line-number}")
  %rest:error-param("column-number", "{$column-number}")
  %rest:error-param("additional", "{$additional}")
function api:error-handler($code as xs:string, $description, $value, $module, $line-number, $column-number, $additional) as item()+ {
  <rest:response>
    <http:response status="500" message="{$description}.">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
  </rest:response>,
  <html xmlns="http://www.w3.org/1999/xhtml">
    <title>{$description}</title>
    <body>        
       <h1>{$description}</h1>
	   <p>
       {$code}:{$description} {$value} in {$module} at {$line-number}:{$column-number}:<br/>
       {for $match in analyze-string($additional, '.*\n', 'm')/*
          return ($match/text(),<br/>)
       }
	   </p>
    </body>
  </html>
};

declare
  %rest:path("vicav/test-error.xqm")
function api:test-error() as item()+ {
  api:test-error('api:test-error')
};

declare
  %rest:path("vicav/test-error.xqm/{$error-qname}")
function api:test-error($error-qname as xs:string) as item()+ {
  error(xs:QName($error-qname))
};

declare
  %rest:path("vicav/runtime")
function api:runtime-info() as item()+ {
  let $runtime-info := db:system(),
      $xslt-runtime-info := xslt:transform(<_/>,
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml"/><xsl:template match='/'><_><product-name><xsl:value-of select="system-property('xsl:product-name')"/></product-name><product-version><xsl:value-of select="system-property('xsl:product-version')"/></product-version></_></xsl:template></xsl:stylesheet>)/*
  return
  <html xmlns="http://www.w3.org/1999/xhtml">
    <title>Runtime info</title>
    <body>
       <h1>Runtime info</h1>
       <table>
       {for $item in $runtime-info/*:generalinformation/*
       return
         <tr>
           <td>{$item/local-name()}</td>
           <td>{$item}</td>
         </tr>
       }
         <tr>
           <td>{$xslt-runtime-info/*:product-name/text()}</td>
           <td>{$xslt-runtime-info/*:product-version/text()}</td>
         </tr>
       </table>
    </body>
  </html>
};