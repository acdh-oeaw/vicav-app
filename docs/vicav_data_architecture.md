# VICAV Framework Data Architecture
Daniel Schopper, 10/2024

VICAV is both a service providing a research platform which collects data from several projets into one environment, and the underlying software of this platform which can be customized to host a single data set from a specific project in a dedicated application. This document describes the architecture of such a dataset and the rules which it needs to follow if it should be published in an instance of the VICAV application framework.

The VICAV application framework provides the following basic functionality:

* list documents in a tabular view
* list documents per data type, potentially grouping by Country, Region and Settlement 
* visualise documents on a map
* render a single document
* query all documents of a given type
* cross-link between query results and documents


## Default data types

VICAV-compatible datasets share a set of common corpus-like data types, i.e. TEI documents with a similar structure and comparable content:

* Feature Lists
* Sample Texts
* Unmonitored Speech (dialogues, narration)

Moreover, VICAV-compatible dataset can contain:

* Glossaries or dictionaries
* Profiles (describing the socio-demographic or linguistic particularities of a given place)
* Bibliographies
* Paratexts

Next to these default data types, projects can define their own specific type of data which can be published via VICAV (see below).

Since the main content of a VICAV-compatible data set is contained within those documents, they are called **Data Documents** in contrast to the **Corpus Document** which holds corpus-wide metadata and points to all the available **Data Documents**.


## Corpus Document

Each data set is represented by one [TEI Corpus Document](https://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-teiCorpus.html) which contains information common to all data documents in one central place. The corpus document has an identifier within `/TEI/teiHeader/fileDesc/publicationStmt/idno`. The name of the dataset is encoded within `/TEI/teiHeader/fileDesc/titleStmt/title[@level="s"]`.

The corpus document contains a series of `<TEI>` elements, each representing one data document. 

```xml
<teiCorpus xml:id="tunocentDataset">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title level="s">TUNOCENT Data Set</title>
            <!-- ... -->
         </titleStmt>
      </fileDesc>
   </teiHeader>
   <!-- one <TEI> element for each recording/data point including references to derived data document where applicable -->
   <TEI><!-- ... --></TEI>
</teiCorpus>
```

The main principle of this architecture is that information common to all data is centrally defined in the TEI Corpus document whereas the data documents only contain pointers to these where needed.

### Team Members and their responsibilities

Each team member is represented in the corpus document by a `<person>` element in the **Team Member List** at `/teiCorpus/standOff/listPerson[@type="projectTeam"]`. This is the authoratitve place where other documents point to when referencing the person in question and where the application is fetching labels and other metadata for display.

The `<person>` element …

* MUST have an `@xml:id` with ID/sigil of the person, 
* SHOULD contain one `<persName>` element with `<forename>` and `<surname>` 
* CAN contain one `<note>` element for further information on ther person.

#### Referencing team members

Each data document references relevant team members and their contribution in a series of `<respStmt>` elements in their `<titleStmt>`.

Each `<respStmt>` … 

* MUST contain only one `<resp>` element. Thus, if a contributor had several roles in the creation of a document, the whole `<respStmt>` repeats
* MUST contain only one empty `<persName>` element pointing to the team list in the corpus document via `@ref`:

```xml
<!-- In the Corpus document -->
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
   <persName ref="corpus:MM"/></persName>
</respStmt>
```

**Note:**     
While the content of `<resp>` is generally not enforced, there are two execptions which are relevant for displaying data in the VICAV app framework: 

* The members mainly responsible for a profile, a sample text or a feature list are encoded in a `<respStmt>` with `<resp>author</resp>` (irrespective of the seemingly difficult use of the term *author* in such a case)
* Interviewers are encoded as `<resp>interviewer</resp>`
* The PI of a project is encoded as `<resp>principal</resp>`

### Informants

Each informant is represented by a `<person>` element in the **main participants list** at `/teiCorpus/teiHeader/profileDesc/particDesc/listPerson`. 

The `<person>` element …

* MUST have an `@xml:id` AND an `<idno>` element with the ID/sigil of the person
* MUST have `@sex` and `@age` attributes 
* CAN contain `<ptr type="patricipatedIn">` elements to reference the data documents which they have contributed to.
* CAN contain one `<note>` element for further information on the person


 *Remarks:*
 
 * We chose `<idno>` since we assume that only pseudonyms / identifiers should be encoded in TEI documents, not clear names. 
 * Even if `@xml:id` and `<idno>` in most cases are the same, we assume that an informant's identifier might have to contain characters not allowed in `xs:NCname`.


#### Referencing the participants list

Informants in a data document are encoded in the document's local participant list at `TEI/teiHeader/profileDesc/particDesc/listPerson`, however unlike the entry in the **main participants list** they do not have any content but only reference their counterpart via `@sameAs`:


```xml
<!-- in the corpus document -->

<particDesc>
   <listPerson>
      <head>Informants</head>
      <person sex="f" age="56" xml:id="AinDifla1">
         <idno>AinDifla1</idno>
         <ptr type="participatedIn" target="corpus.xml#aindifla1_f_56_tun1"/>
      </person>
   </listPerson>
</particDesc>

<!-- in a data document -->
<particDesc>
   <listPerson>
      <head>Informants</head>
      <person sameAs="corpus:Frikhat5"/>
   </listPerson>
</particDesc>
```

### Places

The list of places is encoded within `/teiCorpus/standOff/listPlace`. This semantically neutral position takes into account that places play various roles in a corpus.   

Each place is represented by a `<place>` element which … 

* MUST have an `@xml:id`
* MUST contain ONE `<settlement>` element with exactly ONE `<name xml:lang="en">` containing the place's name in English (which will be used for displaying a label for the place in the application); moreover, `<settlement>` MAY contain several other `<name>` elements with different values in `@xml:lang`.
* MAY contain exactly one `<region>` element containing a text node with the region's name in English (which can be used in the frontend to group places)
* MUST contain exactly one `<country>` element containing a text node with the region's name in English
* MUST contain exactly one `<location>` element with `<geo>` containing the coordinates of the place in decimal notation
* MAY contain several `<idno>` elements providing authority file identifiers for the settlement in question  

```xml
<place xml:id="place0134">
    <settlement>
       <name xml:lang="en">Tajerouine</name>
       <name xml:lang="aeb">Tāžirwīn</name>
    </settlement>
    <region>Kef</region>
    <country>Tunisia</country>
    <location>
        <geo>35.97545, 8.5505</geo>
    </location>
</place>
```

#### Referencing Places

Most of the TEI documents document have attached metadata of their geographic relevance, e.g. where its content was collected or for which geographic region its data is representative. This is encoded in a `<place>` element within `teiHeader/profileDesc/settingDesc`. For the time being, we assume that there is exactly ONE empty `<place>` element within `<settingDesc>` which points to a `<place>` entry within `/teiCorpus/standOff/listPlace` via a `@sameAs` attribute.

```xml
<!-- in the data document -->
<settingDesc>
    <place sameAs="corpus:place0134"/>
</settingDesc>
```

### Data Type Taxonomy 

Next to the common VICAV data types mentioned above, a project can also define its own data types. These need to be listed in a `<taxonomy>` element in the Corpus Document within `/teiCorpus/teiHeader/encodingDesc/classDecl/taxonomy`. 

Each data type is represented by a `<category>` element which …

* MUST have an `@xml:id`
* MUST have an `@n` attribute with an abbreviated label for the data type which can be  
* MUST have an `<catDesc>` element with `<name>` containing a name for the data type


##### Referencing the data type taxonomy

Each TEI Header must contain a `<catRef>` element within `teiHeader/profileDesc/textClass` pointing to the relevant `<catDesc>` element in the corpus document.

```xml
<!-- in the corpus document-->
<taxonomy xml:id="datatypes.tunocent">
   <category xml:id="datatypes.tunocent.tun" n="TUN">
      <catDesc>
         <name xml:lang="en">TUNOCENT Questionnaire</name>
      </catDesc>
   </category>
</taxonomy>

<!-- in a TEI document --> 
<textClass>
    <catRef target="corpus:datatypes.tunocent.tun"/>
</textClass>
```

**Notes:**    
* In order to avoid identifier conflicts, the ids of dataset-specific data types should be prefixed with the project name, e.g. `datatypes.tunocent.tun`
* The default VICAV data types are prefixed with in `datatypes.vicav`:
    * `datatypes.vicav.p`
    * `datatypes.vicav.st`
    * `datatypes.vicav.fl`
* Please note that the datatype identies must only contain lowercase characters and dots (see section below "Data Document references") 

<!-- Revisit! -->
### Data Document references

In its `<body>`, each `<TEI>` element in the corpus document should contain references to the data document(s) derived from it in the data set:

* `<xi:include>` element pointing to all TEI documents contained in the data set
* `<TEI>` stubs for audio recordings

If a recording has been reworked into a properly-encoded TEI document (e.g. a sample text or a feature list document), the stub in the corpus document points to the respective TEI document it its `<body>`:

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

## Data Document Level

Each data document must be encoded within a `<TEI>` element. Documents can be stored as one file each, or grouped together within one file in a `<teiCorpus>` element.

Each document … 

* MUST have an `@xml:id` on its root `<TEI>` element 
* MUST have an `<idno>` within `TEI/fileDesc/publicationStmt`.
* MUST have a title encoded in `<title level="a">` within `TEI/fileDesc/titleStmt`. The name of the dataset must be encoded in a sibling `<title level="s">` element.

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
* locationsx
* availibility


## VICAV Platform 

**TODO** *The VICAV Platform merges several datasets into one instance. What does this mean for the data architecture proposed here?* 

## Defining custom data types 

**TOOD** *What's needed if someone needs a new data type?*

It may be necessary that a new type of data needs to be defined which can then be listed, displayed or searched. The actualy functionality depends, of course, on the data itself. The mini

* A description text
* an entry in the data type taxonomy in the datasets' corpus document
* an ODD


## How VICAV App uses the data 

**TODO** Add pointers to documentation how the data is processed / consumed by VICAV app both in the backend and frontend.
