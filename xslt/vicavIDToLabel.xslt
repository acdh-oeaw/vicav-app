<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs = "http://www.w3.org/2001/XMLSchema"
    xmlns:_ = "urn:_"
    version="3.1">

<xsl:variable name="captionFromMenuID" select=" map{
    'vicavArabicTools': 'Arabic Tools',
    'vicavContributeBibliography': 'Contribute to Bibliography',
    'vicavContributeDictionary': 'Contribute a Dictionary',
    'vicavContributeFeature': 'Contribute a Feature List',
    'vicavContributeProfile': 'Contribute a Profile',
    'vicavContributeSample': 'Contribute a Sample',
    
    'vicavContributors': 'Contributors',
    'vicavDictionaryEncoding': 'Dictionaries (Encoding)',
    'vicavDictionariesTechnicalities': 'Dictionaries (Technicalities)',
    'vicavOverview_corpora_spoken': 'Corpora of Spoken Arabic',
    'vicavOverview_corpora_msa': 'MSA Corpora',
    'vicavOverview_special_corpora': 'Special Corpora',
    'vicavOverview_corpora_historical_varieties': 'Corpora of Historical Language',
    'vicavOverview_dictionaries': 'Dictionary Projects',
    'vicavOverview_nlp': 'Arabic NLP',
    'vicavOverview_otherStuff': 'Other Websites &amp; Projects',
    'vicavLearning': 'Learning',
    'vicavLearningTextbookDamascus': 'Textbook Damascus',
    'vicavLearningSmartphone': 'VOCABULARIES on Smartphones',
    'vicavLearningPrograms': 'Learning Programs',
    'vicavLearningData': 'Learning Data',
    'vicavKeyboards': 'Keyboards',
    'vicavVLE': 'Dictionary Editor (VLE)',
    
    'vicavExplanationBibliography': 'Bibliography (Details)',
    'vicavExplanationCorpusTexts': 'Corpus Texts (Details)',
    'vicavExplanationFeatures': 'Features (Details)',
    'vicavExplanationProfiles': 'rofiles (Details)',
    'vicavExplanationSamples': 'Samples (Details)',
    'vicavExploreFeatures': 'Explore Features',
    
    
    'vicavLinguistics': 'Linguistics',
    'vicavMission': 'Mission',
    'vicavNews': 'VICAV News',
    'vicavTypesOfText': 'Types of Text'}"/>
</xsl:stylesheet>