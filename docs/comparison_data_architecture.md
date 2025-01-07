# Comparison of VICAV Framework Data Architecture docs to TUNOCENT and WIBARAB

## [Corpus document](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#corpus-document)

> The corpus document has an identifier within `/TEI/teiHeader/fileDesc/publicationStmt/idno`

is also the case with WIBARAB, but sounds misleading in my opinion (as if an overall ID for the corpus and not for the individual documents in the corpus was meant here)

## [Team members](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#team-members-and-their-responsibilities)

> Each team member is represented in the corpus document by a `<person>` element in the Team Member List at `/teiCorpus/standOff/listPerson[@type="team"]`

is neither for TUNOCENT nor WIBARAB the case. For WIBARAB, there is a list in `wibarab_dmp.xml`, but not `@type="team"`, but with `xml:id="coreTeam"` and `xml:id="extendedTeam"`. In the [WIBRAB corpus document](https://github.com/wibarab/corpus-data/blob/main/103_tei_w/wibarabCorpus.xml), the team members are listed in titleStmt/respStmt (i.e. `/teiCorpus/teiHeader/fileDesc/titleStmt/respStmt`) (with refs to the dmp xml) e.g. `ref="dmp:RZ"`, same as for the individual documents.

For TUNOCENT, the list is also not `@type="team"`, but `xml:id="projectTeam"`.

> Each `<respStmt>` … MUST contain only one empty `<persName>` element pointing to the team list in the corpus document via @ref:

```xml
<!-- In a data document -->
<respStmt>
   <resp>author</resp>
   <persName ref="corpus:MM"/></persName>
</respStmt>
```

true for TUNOCENT, but there are also `respStmt` elements in the `titleStmt` of the corpus xml, and the `persName` elements there are not empty, meaning everyone with more than one resp has their surname and forename included multiple times.

```xml
            <respStmt>
               <persName ref="corpus:VR">
                  <surname>Ritt-Benmimoun</surname>
                  <forename>Veronika</forename>
               </persName>
               <resp>Interviewer</resp>
            </respStmt>
```

for WIBARAB, the `persName` elements are also never empty. The names are always directly included in `persName`, both in the dmp and the corpus document. (i.e. not separated into `surname` and `forename`)

```xml
            <respStmt>
               <persName ref="dmp:SP">Stephan Procházka</persName>
               <resp>Principal investigator</resp>
            </respStmt>
```

> While the content of `<resp>` is generally not enforced, there are two execptions which are relevant for displaying data in the VICAV app framework:
>
> > - The members mainly responsible for a profile, a sample text or a feature list are encoded in a `<respStmt>` with `<resp>author</resp>` (irrespective of the seemingly difficult use of the term author in such a case)
> > - Interviewers are encoded as `<resp>interviewer</resp>`
> > - The PI of a project is encoded as `<resp>principal</resp>`

None of this applies to WIBARAB, PI is encoded as `<resp>Principal investigator</resp>`, for the others their roles are not “author” or “interviewer” either, but “pre-doc researcher”, “post-doc researcher” etc
these resp values are taken from the @role values in the dmp document  
! the WIBARAB corpus XML is generated automatically, so each person from the coreTeam list ends up getting a `<respStmt>` for each and every document in `/teiCorpus/TEI/teiHeader/fileDesc/titleStmt`

`/teiCorpus/TEI/teiHeader/fileDesc/sourceDesc/recordingStmt/recording/respStmt` -> here is the person responsible from the one column in the meatadata table

## [Informants](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#informants)

> Each informant is represented by a `<person>` element in the main participants list at `/teiCorpus/teiHeader/particDesc/listPerson`

the list is actually at `/teiCorpus/teiHeader/profileDesc/particDesc/listPerson`

> The `<person>` element …

> > - MUST have an @xml:id AND an `<idno>` element with the ID/sigil of the person

WIBARAB doesn't have an `<idno>` element, the id of a person is encoded like `<name type="pseudonym">SAU_2022_UnknownMarketSeller</name>`

> > - MUST have @sex and @age attributes

WIBARAB has "sex" as an element, not an attribut. Instead of "age", WIBARAB uses a `<birth>` element with `<date>` and `<place>`. Date only contains a year (rounded to a decade?), but often this information is completely missing
Example:

```xml
                  <birth>
                     <date when="1940">1940</date>
                     <placeName>Kuwait</placeName>
                  </birth>
```

> > - CAN contain `<ptr type="patricipatedIn">` elements to reference the data documents which they have contributed to.

missing for WIBARAB

> > - CAN contain one `<note>` element for further information on the person

### [Referencing the participant list](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#referencing-the-participants-list)

> Informants in a data document are encoded in the document's local participant list at TEI/teiHeader/particDesc/listPerson, however unlike the entry in the main participants list they do not have any content but only reference their counterpart via @sameAs

Same as above, profileDesc is missing before particDesc

Not true for TUNOCENT either, the `<idno>` is included in the `<person>` element again:

```xml
                  <person sameAs="corpus:AinDifla1">
                     <idno>AinDifla1/f/56</idno>
                  </person>
```

For WIBARAB `<name type="pseudonym">SAU_2022_UnknownMarketSeller</name>` is repeated here:

```xml
                  <person sameAs="corpus:SAU_2022_Speaker10">
                     <name type="pseudonym">SAU_2022_Speaker10</name>
                  </person>
```

## [Places](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#places)

> The list of places is encoded within /teiCorpus/standOff/listPlace. This semantically neutral position takes into account that places play various roles in a corpus.

Does not apply to either TUNOCENT or WIBARAB. For WIBARAB this data is in `featuredb\010_manannot\vicav_geodata.xml`, for Tunocent it appears to be `fvo-docs/places.xml`

> MUST have an @xml:id
> MUST contain ONE `<settlement>` element with exactly ONE `<name xml:lang="en">` containing the place's name in English (which will be used for displaying a label for the place in the application); moreover, `<settlement>`
> MAY contain several other `<name>` elements with different values in @xml:lang.
> MAY contain exactly one `<region>` element containing a text node with the region's name in English (which can be used in the frontend to group places)
> MUST contain exactly one `<country>` element containing a text node with the region's name in English
> MUST contain exactly one `<location>` element with `<geo>` containing the coordinates of the place in decimal notation
> MAY contain several `<idno>` elements providing authority file identifiers for the settlement in question

Structure for WIBARAB completely different, an entry looks like this

```xml
            <place type="geo" xml:id="aaouade">
               <placeName>Aaouade</placeName>
               <location>
                  <geo decls="#dms">34°37'34"N 36°22'38"E</geo>
                  <geo decls="#dd">34.62611 36.37722</geo>
                  <country key="LB">Lebanon</country>
                  <country/>
               </location>
               <idno type="geoNames">2266310</idno>
               <note>Location for the ʕAṛaḅ al-ʕAtīǧ</note>
            </place>
```

No `<settlement>` element with the names, instead just `<placeName>` (sometimes multiple)
`<country>` is contained in `<location>`, no `<region>` elements at all.
`<location>` contains two geo elements with different notations, neither match the decimal notation mentioned above

NOTE: the geo prefix in TUNOCENT does not seem to be resolved anywhere?

### [Referencing places](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#referencing-places)

It's supposed to look like this:

```xml
<!-- in the data document -->
<settingDesc>
    <place sameAs="corpus:place0134"/>
</settingDesc>
```

but TUNOCENT includes all the information about the place again:

```xml
            <settingDesc>
               <place sameAs="geo:AinDifla">
                  <settlement>
                     <name xml:lang="en">Ain Difla</name>
                     <name xml:lang="aeb">ʕĒn Difla</name>
                  </settlement>
                  <region>Kasserine</region>
                  <country>Tunisia</country>
                  <location>
                     <geo>35.581769, 8.564029</geo>
                  </location>
                  <ptr type="isPlaceOf"
                       target="../vicav_lingfeatures/tunocent/vicav_lingfeatures_aindifla_01.xml"
                       n="Linguistic features of Ain Difla Arabic"/>
               </place>
            </settingDesc>
```

WIBARAB uses `<placeName>` and not `<place>`, also the element is not empty and the references are missing, there is only the prefix “geo:”
Example:

```xml
            <settingDesc>
               <setting>
                  <placeName sameAs="geo:">El-Karantina</placeName>
               </setting>
            </settingDesc>
```

[Datatype taxonomy](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#data-type-taxonomy)

WIBARAB has it's own taxonomy that doesn't refer to datatypes, instead it refers to categories for the linguistic features. It's located in the wibarab_dmp.xml file. WIBARAB doesn't use any prefixes like textclass.WIBARAB either

> MUST have an @n attribute with an abbreviated label for the data type which can be

(which can be what?) The WIBARAB taxonomy doesn't have an @n attribute

[Data document level](https://github.com/acdh-oeaw/vicav-app/blob/devel/docs/vicav_data_architecture.md#data-document-level)

> Each document …

> > MUST have an @xml:id on its root `<TEI>` element

@xml:id is missing for the documents in the WIBARAB corpus document
NOTE: TUNOCENT also has @type="recording" on the root `<TEI>` element

> > MUST have an <idno> within TEI/fileDesc/publicationStmt.

(should be `//TEI/teiHeader/fileDesc/publicationStmt`)

> > MUST have a title encoded in `<title level="a">` within TEI/fileDesc/titleStmt. The name of the dataset must be encoded in a sibling `<title level="s">` element.

same as above, "teiHeader" is missing

> Any data document can be sourced from one or more audio or video recordings. For the time being we assume that one document corresponds to exactly one recording session which is represented by exactly one <recording> element in sourceDesc/recodingStmt.

> The recordings corresponding to this recording session might be split into several media files, thus <recording> can contain zero or more <media>elements.

applies to both TUNOCENT and WIBARAB
