<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:output method="xml" indent="no"/>
      
    <xsl:template match="/">                                       
        <TEI xmlns="http://www.tei-c.org/ns/1.0" >
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
                        <ab>The links for the profiles were assembled by scriptor.exe:createListOfVICAVProfiles</ab>
                    </projectDesc>
                </encodingDesc>
            </teiHeader>
            <text>
                <body>
                    <div xml:id="vicavExplanationProfiles" n="PROFILE">
                        <head>Language profiles</head>
                        
                        <p>An important part of this website are information units which we call <hi rendition="#i">language
                            profiles</hi>. This types of text consist in short sketches of varieties of
                            spoken contemporary Arabic. The intention is to work in a
                            complementary manner to similar endeavours (such as EALL). For the
                            time being, we do not plan to provide detailed grammatical descriptions
                            but rather focus on general information, research histories and available literature.</p>
                        
                        <p>The following overview lists all profiles (<xsl:value-of select="count(//item)"/>) according to political entities.</p>
                        
                        <div xml:id="profiles_algeria">
                            <head>Algeria (<xsl:value-of select="count(//item[country='Algeria'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Algeria']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                        <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_egypt">
                            <head>Egypt (<xsl:value-of select="count(//item[country='Egypt'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Egypt']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                                
                        <div xml:id="profiles_iran">
                            <head>Iran (<xsl:value-of select="count(//item[country='Iran'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Iran']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_iraq">
                            <head>Iraq (<xsl:value-of select="count(//item[country='Iraq'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Iraq']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                                              
                        <div xml:id="profiles_Israel">
                            <head>Israel (<xsl:value-of select="count(//item[country='Israel'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Israel']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>                       
                        
                        <div xml:id="profiles_jordan">
                            <head>Jordan (<xsl:value-of select="count(//item[country='Jordan'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Jordan']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>

                        <div xml:id="profiles_kuweit">
                            <head>Kuweit (<xsl:value-of select="count(//item[country='Kuwait'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Kuweit']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_lebanon">
                            <head>Lebanon (<xsl:value-of select="count(//item[country='Lebanon'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Lebanon']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_libya">
                            <head>Libya (<xsl:value-of select="count(//item[country='Libya'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Libya']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        
                        <div xml:id="profiles_morocco">
                            <head>Morocco (<xsl:value-of select="count(//item[country='Morocco'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Morocco']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_oman">
                            <head>Oman (<xsl:value-of select="count(//item[country='Oman'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Oman']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>  

                        <div xml:id="profiles_palestine">
                            <head>Palestine (<xsl:value-of select="count(//item[country='Palestine'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Palestine']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>

                        <div xml:id="profiles_saudi_arabia">
                            <head>Saudi Arabia (<xsl:value-of select="count(//item[country='Saudi Arabia'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Saudi Arabia']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                                               
                        <div xml:id="profiles_sudan">
                            <head>Sudan (<xsl:value-of select="count(//item[country='Sudan'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Sudan']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>

                        <div xml:id="profiles_syria">
                            <head>Syria (<xsl:value-of select="count(//item[country='Syria'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Syria']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_tunisia">
                            <head>Tunisia (<xsl:value-of select="count(//item[country='Tunisia'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Tunisia']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>                      
                        
                        <div xml:id="profiles_turkey">
                            <head>Turkey (<xsl:value-of select="count(//item[country='Turkey'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Turkey']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_united_arab_emirates">
                            <head>United Arab Emirates (<xsl:value-of select="count(//item[country='United Arab Emirates'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='United Arab Emirates']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                        
                        <div xml:id="profiles_yemen">
                            <head>Yemen (<xsl:value-of select="count(//item[country='Yemen'])"/>)</head>
                            <list>
                                <xsl:for-each select="//item[country='Yemen']">
                                    <xsl:sort select="name"></xsl:sort>
                                    <item>
                                        <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                                        <rs><xsl:attribute name="ref">profile:<xsl:value-of select="@xml:id"/>/<xsl:value-of select="name"/></xsl:attribute>
                                            <xsl:value-of select="name"/></rs> (<xsl:value-of select="author"/>)</item>
                                </xsl:for-each>
                            </list>
                        </div>
                                              
                        
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>