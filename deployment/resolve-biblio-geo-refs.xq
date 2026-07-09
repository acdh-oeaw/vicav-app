declare namespace tei = 'http://www.tei-c.org/ns/1.0';

collection("vicav_biblio")//tei:ref[starts-with(@target, 'geo:')]/ancestor::tei:biblStruct!(
for $ref in .//tei:ref[starts-with(@target, 'geo:')]
return replace node $ref with collection("vicav_geo")//*[data(@xml:id) = substring($ref/@target, 5)]
)