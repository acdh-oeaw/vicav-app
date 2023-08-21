<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    version="2.0">
    <xsl:include/>

    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                    body {
                        font-family: "Junicode";
                    }
                    @media screen {
                        body {
                            font-size: 18pt;
                        }
                    }
                    @media print {
                        body {
                            font-size: 12pt;
                        }
                    }
                    a:link, a:hover, a:active, a:visited {
                        text-decoration: none;
                        color: inherit;
                        cursor: default;
                    }
                    .spSentence {
                        display: block;
                    }
                    .tdTeiLink, .tdPrintLink, .sentences-nav {
                        display: none;
                    }

                    @font-face {
                        font-family: Junicode;
                        src: url("fonts/junicode/Junicode.ttf") format("truetype");
                    }

                    @font-face {
                        font-family: Junicode;
                        font-weight: bold;
                        src: url("fonts/junicode/Junicode-Bold.ttf") format("truetype");
                    }

                    @font-face {
                        font-family: Junicode;
                        font-weight: normal;
                        font-style: italic;
                        src: url(fonts/junicode/Junicode-Italic.ttf") format("truetype");
                    }
                    p {
                        margin-top: 0px;
                    }

                    .tdFeaturesLeft, .tdFeaturesHeadRight, .tdFeaturesRightTarget {
                        vertical-align: top;
                    }
                    .tdFeaturesHeadRight {
                        min-width: 200px;
                    }
                    .tdFeaturesHeadRight small {
                        display: block;
                    }
                    .tdFeaturesHeadRight, .tdFeaturesRightSource, .tdFeaturesHead, .tdFeaturesLeft, .explore-samples .tdFeaturesRightTarget {
                        padding-top: 0.4em;
                        border-top: solid 1px silver;
                    }
                    .tdFeaturesRightSource {
                        font-size: 0.8em;
                    }
                    .tdFeaturesHead, .highlight {
                        font-weight: bold;
                    }
                    .corpus-utterances > .u {
                      white-space: nowrap;
                      overflow-x: scroll;                          
                    }
                    .corpus-utterances > .u .hit {
                        font-weight: bold;
                    }
                    .corpus-search-results {
                      display: table;
                      width: 100%
                    }
                    .corpus-search-result {
                      display: table-row;                     
                      width: 100%
                    }
                    .corpus-search-result > * {
                      display: table-cell;
                    }
                    .corpus-search-result > .left {
                      text-align: right;
                    }
                    .corpus-search-result > .keyword {
                      text-align: center;
                      padding-left: 1en;
                      padding-right: 1en;
                      background-color: yellow;
                    }
                    .corpus-search-result > .right {
                      text-align: left;
                    }
                    .spExampleQuote, .lemma {
                        font-weight: bold;
                    }
                </style>
            </head>
            <body><xsl:apply-templates/></body>
        </html>
    </xsl:template>
</xsl:stylesheet>
