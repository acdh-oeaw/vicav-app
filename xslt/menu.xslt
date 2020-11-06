<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml" version="2.0">
<xsl:strip-space elements="*"/>
<xsl:output method="xml"/>
	
<xsl:template match="/">
	<menu><xsl:apply-templates/></menu>
</xsl:template>


<xsl:template match="main">
	<main>
		<ul class="navbar-nav mr-auto">
			<xsl:apply-templates/>
			<li class="navbar-icons">
		      <a href="https://github.com/acdh-oeaw/vicav-app"
		         target="_blank"
		         rel="noopener"
		         aria-label="GitHub">
		         <i class="fa fa-github"
		            aria-hidden="true"
		            title="GitHub" />
		      </a>
		      <a class="search-button">
		         <i class="fa fa-search"
		            aria-hidden="true"
		            title="Search Bibliography" />
		      </a>
		   </li>
		</ul>
	</main>
</xsl:template>

<xsl:template match="dropdown">
	<li class="nav-item dropdown">
		<a class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<xsl:attribute name="id" select="./@xml:id"/>
			<xsl:value-of select="./@title"/>
		</a>
	    <div class="dropdown-menu">
	    	<xsl:attribute name="aria-labelledby" select="./@xml:id"/>
			<xsl:apply-templates select="./*"/>		    	
	    </div>
	</li>
</xsl:template>

<xsl:template match="item">
	<a class="dropdown-item">
		<xsl:attribute name="id" select="./@xml:id"/>
		<xsl:if test="not(empty(./@target)) and not(empty(./@type))">
			<xsl:attribute name="data-target" select="./@target"/>
			<xsl:attribute name="data-type" select="./@type"/>
		</xsl:if>
		<xsl:value-of select="."/></a>
</xsl:template>

<xsl:template match="separator">
	<div class="dropdown-divider"></div>
</xsl:template>
	
<xsl:template match="subnav/item">
	<span xml:space='preserve'><xsl:attribute name="id" select="./@xml:id"/><i class="fa fa-map" aria-hidden="true"></i> <xsl:value-of select="."/></span>
</xsl:template>
<xsl:template match="subnav">
	<xsl:copy><xsl:apply-templates select="./*"/></xsl:copy>
</xsl:template>

</xsl:stylesheet>
