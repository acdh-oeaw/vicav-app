declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare variable $colls external := ('dc_apc_eng_publ');

let $lems := <index id="lem">{
  for $coll in $colls return 
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]
                    /tei:form[@type="lemma"]/tei:orth[@xml:lang=("ar-x-DMG", "ar")]//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $orths := <index id="ar">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:form/tei:orth[@xml:lang=("ar-arz-x-cairo-vicav", "ar-acm-x-baghdad-vicav", "ar-apc-x-damascus-vicav")]//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $infls := <index id="infl">{
  for $coll in $colls return 
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]
                    /tei:form[@type="infl" or @type="inflected"]/tei:orth[@xml:lang="ar-x-DMG"]
                    //text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $poss := <index id="pos">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:gramGrp/tei:gram[@type="pos"]//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $roots := <index id="root">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:gramGrp/tei:gram[@type="root"]//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $subcs := <index id="subc">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:gramGrp/tei:gram[@type="subc"]//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $ens := <index id="en">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:sense/tei:cit[@xml:lang="en"]/tei:quote//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $des := <index id="de">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:sense/tei:cit[@xml:lang="de"]/tei:quote//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $frs := <index id="fr">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:sense/tei:cit[@xml:lang="fr"]/tei:quote//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $ess := <index id="es">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:sense/tei:cit[@xml:lang="es"]/tei:quote//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $etymLang := <index id="etymLang">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:etym/tei:lang//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $etymSrc := <index id="etymSrc">{
  for $coll in $colls return
    for $v in distinct-values(collection($coll)//tei:entry[tei:fs/tei:f/tei:symbol/@value="released"]/tei:etym/tei:mentioned//text()) 
    order by $v
    return <w>{$v}</w>
}</index>

let $indxs := 
  <indices>{($lems,$infls,$des,$ens,$frs,$ess,$poss,$roots,$orths,$subcs,$etymLang,$etymSrc)!.[*]}</indices>

return db:create(replace($colls[1], '^(.+)_(\d\d\d)$', '$1') || "__ind", $indxs, "ind.xml",
  map { 'ftindex': true(),
        'stemming': false(),
        'tokenindex': false(),
        'casesens': false(),
        'language': 'en',
        'diacritics': false(),
        'autooptimize': false()
      }
)