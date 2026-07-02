# VICAV Framework Data Architecture
Daniel Schopper, 10/2024 (Update 07/2026)

VICAV is both a service providing a research platform which collects data from several projects into one environment, and the underlying software of this platform which can be customized to host a single dataset from a specific project in a dedicated application. This document describes the architecture of such a dataset and the rules which it needs to follow if it should be published in an instance of the VICAV application framework.

The VICAV application framework provides the following basic functionality:

* list documents in a tabular view
* list documents per data type, potentially grouping by Country, Region and Settlement 
* visualise documents on a map
* render a single document
* query all documents of a given type
* cross-link between query results and documents

## Key concepts

Each VICAV instance is populated from data sourced coming from three layers:

* *VICAV Library*: A central repository with data shared across all VICAV datasets. Next to the VICAV bibliography, the gazetteer and the taxonomy of text classes, this also includes common ODDs and schemas for the defalut data types.
* *Dataset Catalogue*: Each VICAV dataset is described in a *Dataset Catalogue*. Next to a complete list of recordings in the dataset this includes data shared across all resources in the dataset in question, esp. list of participants, custom vocabularies (keywords) or project-specific data types. Dataset Catalogues are described further below.
* *Data Documents*: These are single TEI documents providing one data point (e.g. one feature list, one transcription, one language profile)

## Default data types

The data documents in a VICAV dataset follow a predefined structure and comparable content:

* Feature Lists
* Sample Texts
* Unmonitored Speech (dialogues, narration and similar more or less spontaneous speech)

Moreover, VICAV-compatible dataset can contain:

* Glossaries or dictionaries
* Language Profiles (describing the socio-demographic or linguistic particularities of a given place)
* Bibliographies
* Paratexts


Each VICAV data document declares its datatype in its header (see below).

## Dataset Catalogues

Each dataset is represented by a "Dataset Catalogue", i.e. a [TEI Corpus Document](https://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-teiCorpus.html) which contains information common to all data documents in one central place. The Dataset Catalogue has an identifier within `/TEI/teiHeader/fileDesc/publicationStmt/idno`. The name of the dataset is encoded within `/TEI/teiHeader/fileDesc/titleStmt/title[@level="s"]`.

The Dataset Catalogue contains a series of `<TEI>` elements, each representing one data document. 

```xml
<teiCorpus xml:id="tunocentDataset">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title level="s">TUNOCENT dataset</title>
            <!-- ... -->
         </titleStmt>
      </fileDesc>
   </teiHeader>
   <!-- one <TEI> element for each data point / recording including references to derived data document where applicable -->
   <TEI><!-- ... --></TEI>
</teiCorpus>
```

The main principle of this architecture is that information common to all data specifc to the dataset is centrally defined whereas the data documents only contain pointers to these where needed.

### Team Members and their responsibilities

Each team member is represented in the Dataset Catalogue by a `<person>` element in the **Team Member List** at `/teiCorpus/standOff/listPerson[@type="projectTeam"]`. This is the authoratitve place where other documents point to when referencing the person in question and where the application is fetching labels and other metadata for display.

The `<person>` element …

* MUST have an `@xml:id` with ID/sigil of the person, 
* SHOULD contain one `<persName>` element with `<forename>` and `<surname>` 
* CAN contain one `<note>` element for further information on ther person.

#### Referencing team members

Each data document references relevant team members and their contribution in a series of `<respStmt>` elements in their `<titleStmt>`.

Each `<respStmt>` … 

* MUST contain only one `<resp>` element. Thus, if a contributor had several roles in the creation of a document, the whole `<respStmt>` repeats
* MUST contain only one empty `<persName>` element pointing to the team list in the Dataset Catalogue via `@ref`:

```xml
<!-- In the Dataset Catalogue -->
<listPerson type="projectTeam">
   <head>Team Members</head>
   <person xml:id="VRB">
      <forename>Veronika</forename>
      <surname>Ritt-Benmioun</surname>
   </person>
</listPerson>

<!-- In a data document -->
<respStmt>
   <resp>author</resp>
   <persName ref="corpus:VRB"/></persName>
</respStmt>
```

**Note:**     
While the content of `<resp>` is generally not enforced, there are a few execptions which are relevant for displaying data in the VICAV app framework:

* The members mainly responsible for a profile, a sample text or a feature list are encoded in a `<respStmt>` with `<resp>author</resp>` (irrespective of the seemingly difficult use of the term *author* in such a case)
* Interviewers are encoded as `<resp>interviewer</resp>`
* The PI of a project is encoded as `<resp>principal</resp>`

### Informants

Each informant is represented by a `<person>` element in the **main participants list** at `/teiCorpus/teiHeader/profileDesc/particDesc/listPerson`. 

The `<person>` element …

* MUST have an `@xml:id` AND an `<idno>` element with the ID/sigil of the person
* MUST have `@sex` and `@age` (= age group) attributes: Both are used by the VICAV application to provide filter options.
* MAY contain `<ptr type="patricipatedIn">` elements to reference the data documents which they have contributed to.
* MAY contain a `<state type="consent">` construct to indicate what consent the person has given
* MAY contain a `<birth>` element which provides…
   * an empty `<placeName>` with  `@sameAs` pointing to the VICAV gazetteer 
   * a `<date>` element containing the decade of birth (e.g. "1950s") and `@notBefore`/`@notAfter` to translate this into a machine-readable period. (e.g. `<date notBefore="1990" notAfter="1999">1990s</date>`)
* MAY contain one `<note>` element for further information on the person

 *Remarks:*
 
 * We chose `<idno>` since we assume that only pseudonyms / identifiers should be encoded in TEI documents, not clear names. 
 * Even if `@xml:id` and `<idno>` in most cases are the same, we assume that an informant's identifier might have to contain characters not allowed in `xs:NCname`.


#### Referencing the participants list

Informants in a data document are encoded in the document's local participant list at `TEI/teiHeader/profileDesc/particDesc/listPerson`, however unlike the entry in the **main participants list** they do not have any content but only reference their counterpart via `@sameAs`:


```xml
<!-- in the Dataset Catalogue -->
<particDesc>
   <listPerson>
      <head>Informants</head>
      <person sex="f" age="56" xml:id="AinDifla1">
         <idno>AinDifla1</idno>
      </person>
   </listPerson>
</particDesc>

<!-- in a data document -->
<particDesc>
   <listPerson>
      <head>Informants</head>
      <person sameAs="corpus:AinDifla1"/>
   </listPerson>
</particDesc>
```

### Places

The list of places is encoded within `/teiCorpus/standOff/listPlace`. This semantically neutral position takes into account that places play various roles in a corpus. It should only contain places which are relevant to the data points in the dataset in question. Each place is represented by a `<place>` element containing exactly one empty `<placeName>` element wiht a `@sameAs` attribute pointing to a `<place>` entry in the central [VICAV Gazetteer](https://github.com/acdh-oeaw/vicav-library/blob/main/vicav_geo/vicav_geodata.xml) in the *VICAV Library*.

```xml 
<listPlace>
   <head>Places in the WIBARAB dataset</head>
   <place sameAs="geo:place0134"/>
</listPerson>
```

**TODO**
* CHECK if that is the case and whether the list in the Catalogue document is used anywhere in the application. 
* CHECK if there is any need to include places directly in the Dataset Catalogue.



<!-- Revisit! -->
### References to data documents

In its `<body>`, each `<TEI>` element in the Dataset Catalogue should contain references to the data document(s) derived from it in the dataset:

* `<xi:include>` element pointing to all TEI documents contained in the dataset
* `<TEI>` stubs for audio recordings which have not been transcribed.

If a recording has been transcribed and encoded into a properly-encoded TEI document (e.g. a sample text or a feature list document), the stub in the Dataset Catalogue points to the respective TEI document it its `<body>`:

```xml
 <body>
    <ab>
         <ref target="datatypes.vicav.st:vicav_sample_arish_02">A sample of l-Aʕrīš Arabic</ref>
         <note>The content of this recording has been processed into a TEI document.</note>
    </ab>
</body>
```

In order one is able to reference the value of `@target`, there should be a `<prefixDef>` for each datatype with the URI prefix equal to the datatype's identifier:

```xml
<prefixDef ident="datatypes.vicav.st"
           matchPattern="^(.+)$"
           replacementPattern="vicav_samples/tunocent/vicav_sample_text_003.xml#$1">
      <p>Private URIs using the <code>datatypes.vicav.st</code> prefix are pointers to VICAV sample texts.</p>
</prefixDef>
```

## Data Document level

Each data document must be encoded within a `<TEI>` element. Documents can be stored as one file each, or grouped together within one file in a `<teiCorpus>` element.

Each document … 

* MUST have an `@xml:id` on its root `<TEI>` element 
* MUST have an `<idno>` within `TEI/fileDesc/publicationStmt`.
* MUST have a title encoded in `<title level="a">` within `TEI/fileDesc/titleStmt`. The name of the dataset must be encoded in a sibling `<title level="s">` element.

### Datatype declaration

Each data document should declare its type by referencing the [centrally managed text classes taxonomy](https://github.com/acdh-oeaw/vicav-library/blob/main/vicav_textClasses.xml). It must contain a `<catRef>` element within `teiHeader/profileDesc/textClass` pointing to the relevant `<catDesc>` element in the taxonomy.


```xml
<!-- in the VICAV text classes taxonomy -->              
<taxonomy xml:id="datatypes.vicav">
   <desc>VICAV Default Data Types</desc>
   <category xml:id="datatypes.vicav.fl" n="FL">
      <catDesc>
         <name xml:lang="en">VICAV Feature List</name>
      </catDesc>
   </category>
</taxonomy>

<!-- in a data document --> 
<textClass>
    <catRef  scheme="vtc:datatypes.vicav" target="vtc:datatypes.vicav.fl"/>
</textClass>
```

The `vtc:` prefix (standing for "VICAV Text Classes") should be defined in a `<prefixDef>` Element in the document's `<teiHeader>` and point to the VICAV Text Classes taxonomy in *VICAV Library*: 

```xml
<prefixDef ident="vtc" matchPattern="^(.+)$" replacementPattern="../vicav-library/vicav_textClasses.xml">
   <p>Private URIs using the <code>vtc</code> prefix are pointers to the list of VICAV text classes.</p>
</prefixDef>
```

Next to these default data types, projects can define their own specific type of data which can be published via VICAV (see below).

### Referencing Places

Most of the data documents have attached metadata of their geographic relevance, e.g. where its content was collected or for which geographic region its data is representative. 

```xml
<!-- In a data document -->
<settingDesc corresp="sources:KUW_2022_GK">
   <setting>
      <place sameAs="geo:place0134"/>
   </setting>
</settingDesc>
```

If a project has collected data in several campaigns, these can be documented in a dedicated sources document. The recording can be related to the respective campaign by adding a `@corresp` attribute to `<settingDesc>`.

The `geo:` prefix used in the example above is defined in a `<prefixDef>` elment in the data document's header:

```xml
<prefixDef ident="geo" matchPattern="^(.+)$" replacementPattern="../../vicav_library/vicav_biblio/vicav_geodata.xml#$1">
   <p>Private URIs using the <code>geo</code> prefix are pointers to the <att>xml:id</att> attribute on a <gi>place</gi> element in the <ref target="https://github.com/acdh-oeaw/vicav-content/blob/master/vicav_biblio/vicav_geodata.xml">VICAV Gazetteer</ref>.</p>
</prefixDef>
```

### Media Files

#### Document-wide audio 

Any data document can be sourced from one or more audio or video recordings. For the time being we assume that one document corresponds to exactly one recording session which is represented by exactly one `<recording>` element in `sourceDesc/recodingStmt`.

Usually, the outcome of a recording session is a digital audio recording which can manifest itself in different variants, each of which is encoded as a `<media>` element within the `<recording>` element: 

* The `master file` is the original, unaltered file as it has been produced by the audio recording device/software. (`<media type="master">`)
* The `distribution file` are versions of the master file which have been edited or compressed to be be disseminated e.g. via the VICAV web application.  (`<media type="distributionFile">`)

Each `<media>` element can be described by different metadata elements (e.g. license information in `<availibility>`), which are referenced with the `@decls` attribute attached to it.

#### Utterance-wide audio

Especially in case of transcriptions of unmonitored speech or sample texts, the transcription will be seperated in single utterances (`<u>`). In this case, the audio can be segmented into smaller units, each corresponding with an utterance. In such cases, the `<media>` element is embedded within the corresponding `<u>` element.

```xml
<u xml:id="text001_utterance001" who="corpus:speakerID">
   <!-- many tokens ... -->
   <w xml:id="text001_utterance001_token000038">gʕad</w>
   <w xml:id="text001_utterance001_token000039">fǟli</w>
   <w join="right" xml:id="text001_utterance001_token000040">ṯammⁱkīya</w>
   <pc join="right" xml:id="text001_utterance001_token000040">.</pc>
   <media mimeType="audio/mp3" url="publicAssets:magsamtrab1_f_72_e4_a/magsamtrab1_f_72_e4_a_a1.mp3"/>
   <media mimeType="audio/wav" url="arche:magsamtrab1_f_72_e4_a/magsamtrab1_f_72_e4_a_a1.wav"/>
</u>
```


**TODO**s Add information regarding
* types auf media files (master/derived)
* locations
* availibility


## VICAV datasets repository layout

**TODO** Describe the standard layout of a VICAV dataset repository. 

* corpus.xml on top level
* one directory per datatype with a subdirectory named after the project acronym
* VICAV Library repository included as a submodule


## VICAV Platform 

**TODO** *The VICAV Platform merges several datasets into one instance. What does this mean for the data architecture proposed here?* 

## Defining custom data types 

**TOOD** *What's needed if someone needs a new data type?*

Next to the common VICAV data types mentioned above, a project can also define a custom data type which can then be listed, displayed or searched. The actual functionality depends, of course, on the implementation in the VICAV framework, however the data structures to describe the data type is generic and require:

* a description text (a custom paratext document)
* an entry in the data type taxonomy in the datasets' Dataset Catalogue (see below)
* an ODD and RNG schema


### Custom Data Type Taxonomy 

Custom data types need to be listed in a `<taxonomy>` element in the project's Dataset Catalogue within `/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy`. Each data type is represented by a `<category>` element which …

* MUST have an `@xml:id`
* MUST have an `@n` attribute with an abbreviated label for the data type which can be  
* MUST have an `<catDesc>` element with `<name>` containing a name for the data type

Data documents should reference the project-specific datatypes taxonomy similar to the VICAV datatypes taxonomy (replacing the `vtc:` prefix with the `corpus:` prefix). 

```xml
<!-- in the Dataset Catalogue-->
<taxonomy xml:id="datatypes.tunocent">
   <category xml:id="datatypes.tunocent.tun" n="TUN">
      <catDesc>
         <name xml:lang="en">TUNOCENT Questionnaire</name>
      </catDesc>
   </category>
</taxonomy>

<!-- in a TEI document --> 
<textClass>
    <catRef scheme="corpus:datatypes.tunocent" target="corpus:datatypes.tunocent.tun"/>
</textClass>
```

**Notes:**    
* the `@scheme` attribute provides a reference to the data types `<taxonomy>` element.
* In order to avoid identifier conflicts, the ids of dataset-specific data types should be prefixed with the project name, e.g. `datatypes.tunocent.tun`
* The default VICAV data types are prefixed with in `datatypes.vicav` (e.g.`datatypes.vicav.p`
for *Profiles*, `datatypes.vicav.st` for *Sample Texts* or  `datatypes.vicav.fl` for *Feature Lists*)
* Please note that the datatype identies must only contain lowercase characters and dots (see section below "Data Document references")



## How VICAV App uses the data 

**TODO** Add pointers to documentation how the data is processed / consumed by VICAV app both in the backend and frontend.
