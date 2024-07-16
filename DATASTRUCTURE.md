# Relations between text types and collections/DBs in BaseX

The vicav app treats different TEI text types differently and they are stored in different collections.  
Each collection can be listed which means that the teiHeader metadata is retruned as JSON. This can be consumed by a frontend to show lists an filter them.  
By default a virtual teiCorpus document will be created from the teiHeader data in a collection.
If there is a document containing a teiCorpus in a collection this will be used instead.  
The idea is to have such a document whenever there are resources of that type that can only be presented as their metadata.  
For example texts that only exist as audio recordings and were not transcribed or recordings that can not be presented due to legal and/or privacy protection reasons.

## Supported TEI text types

* Meta texts (About, News, etc.) -> vicav_texts
* Bibliographic entries -> vicav_biblio
* Language profiles -> vicav_profiles
* Sample texts -> vicav_samples
* Linguisitic feature descriptions -> vicav_lingfeatures
* Text cropora -> vicav_cropus

### Recommended structure for meta texts

For a schema example see: 

### Recommeded structure for bibliographic entries

We usually collect bibliographic entries in Zotero and export them to TEI.

For a schema example see: 

### Recommeded structure for language profiles

For a schema example see: 

### Recommeded structure for sample texts

For a schema example see:

### Recommeded structure for linguisitic feature descriptions

For a schema example see:

### Recommeded structure for text cropora

We use NoSketchEngine as the search engine beckend.   
There is a workflow that takes TEI texts or ELAN files and converts them to TEI with the text tokenized.  
Search results from NoSketchEngine are resolved to w-tags in XML files that are genereated using the above workflow that also generates the NoSketchEngine verticals.
The xml:id attributes on any w-tag in the vicav_corpus collection needs to be unique within the collection. We therefore usually prefix the token ID with a document ID.

The corpus in NoSketchEngine has to have the same name as the project configured in vicav_projects.

For a schema example see:

## Other collections

* vicav_projects -> settings for a particular instance of the vicav-app
* prerendered_json -> the project config including all metadata that is requested via the settings. created on build.
* dict_users -> users for the dictionary part. See the vleserver-basex API
* Dictionary collections -> See the vleserver-basex API
