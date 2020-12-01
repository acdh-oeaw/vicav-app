<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8"/>
      
    <xsl:template match="/">                                       
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Language profiles (Explanation)</title>
                        <title type="shortTitle">PROFILES</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
                <encodingDesc>
                    <projectDesc>
                        <ab>The links for the profiles were assembled by scriptor.exe--&lt;createListOfVICAVProfiles</ab>
                    </projectDesc>
                </encodingDesc>
            </teiHeader>
            <text>
                <div xml:id="vicavExplanationProfiles" n="PROFILE">
                    <head>Language profiles</head>
                    
                    <p>At the heart of this website, there are what we call <hi rendition="#i">language
                        profiles</hi>. This type of text consists in short sketches of varieties of
                        spoken contemporary Arabic. The intention is to work in a
                        complementary manner to similar endeavours (such as EALL). For the
                        time being, we do not plan to give detailed grammatical descriptions
                        but rather focus on general information, research histories and available literature.</p>
                </div>                
            </text>
        </TEI>
    </xsl:template>

    </xsl:stylesheet>

