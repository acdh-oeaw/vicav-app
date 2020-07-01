<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:acdh="http://acdh.oeaw.ac.at"
    version="2.0">
    <xsl:include/>

    <xsl:preserve-space elements="*"/>
    <xsl:template match="/">
        <html>
            <head>
                <style type="text/css">
                    body {
                        font-family: "Junicode";
                        font-size: 18pt;
                    }
                    a:link, a:hover, a:active, a:visited {
                        text-decoration: none;
                        color: inherit;
                        cursor: default;
                    }
                    .spSentence {
                        display: block;
                    }
                    .tdTeiLink, .tdPrintLink {
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

                    .tdFeaturesLeft {
                        vertical-align: top;
                    }
                    .tdFeaturesRightSource, .tdFeaturesHead, .tdFeaturesLeft {
                        padding-top: 0.4em;
                        border-top: solid 1px silver;
                    }
                    .tdFeaturesRightSource {
                        font-size: 0.8em;
                    }
                    .tdFeaturesHead {
                        font-weight: bold;
                    }
                </style>
            </head>
            <body><xsl:apply-templates/></body>
        </html>
    </xsl:template>
</xsl:stylesheet>
