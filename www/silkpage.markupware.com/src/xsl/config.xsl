<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/rdf/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <xsl:import href="http://silkpage.markupware.com/release/core/current/src/xsl/silkpage.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/custom.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage XSLT Customization Layer</dc:title>
    <cvs:date>$Date: 2005-07-28 22:02:27 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
    This XSLT stylesheet customizes the generation of SilkPage Website.
  </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:param name="site.author" select="'SilkTeam'"/>
  <xsl:param name="site.url" select="'http://silkpage.markupware.com'"/>
  <xsl:param name="site.id" select="'SilkPage'"/>
  <xsl:param name="site.license" select="'http://www.markupware.com/metadata/site#license'"/>
  <xsl:param name="css.decoration" select="0"/>
  <xsl:param name="collect.xref.targets" select="'yes'"/>
  <xsl:param name="website.database.document" select="'website.database.xml'"/>  <xsl:param name="acronyms.database.document" select="'glossary.xml'"/>
  <xsl:param name="process.acronyms" select="'1'"/>

  <!-- Search Box -->
  <xsl:param name="search.url" select="'silkpage.markupware.com'"/>
  <xsl:param name="pages.search-box" select="1"/>
  <xsl:param name="pages.search.input-label" select="'Search MarkupWare'"/>
  <xsl:param name="pages.search.submit-label" select="'Search'"/>

  <xsl:template name="user.search-box">
    <form id="search" title="{$pages.search.input-label}" action="http://www.google.com/search">
      <div>
        <input type="hidden" name="hl" value="en"/>
        <input type="hidden" name="ie" value="UTF-8"/>
        <input type="hidden" name="btnG" value="Google+Search"/>
        <input type="hidden" name="as_qdr" value="all"/>
        <input type="hidden" name="as_occt" value="any"/>
        <input type="hidden" name="as_dt" value="i"/>
        <input type="hidden" name="as_sitesearch" value="{$search.url}"/>
        <label for="searchQuery">
          <xsl:if test="$pages.search.input-label != ''">
            <xsl:value-of select="$pages.search.input-label"/>
          </xsl:if>
        </label>
        <input id="searchQuery" name="q" type="text" size="20" accesskey="{$access.key.searchbox}" maxlength="255"/>
        <input id="searchSubmit" type="submit" value="{$pages.search.submit-label}"/>
      </div>
    </form>
  </xsl:template>

  <xsl:template match="sidebar">
    <xsl:variable name="address" select="address"/>
    <xsl:variable name="rss" select="rss"/>
    <xsl:choose>
      <xsl:when test="$address">
        <xsl:apply-templates select="." mode="sidebar.mode"/>
      </xsl:when>
      <xsl:when test="$rss">
        <xsl:apply-templates select="$rss|*">
          <xsl:with-param name="wrapper" select="''"/>
  	</xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="insert.class">
    <xsl:param name="value" select="name(.)"/>
    <xsl:if test="$value != ''">
      <xsl:attribute name="class">
	<xsl:value-of select="$value"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="sidebar.address">
    <xsl:param name="link" select="''"/>
    <xsl:param name="altval" select="''"/>
    <xsl:param name="class" select="name(.)"/>
    <dt>
      <xsl:call-template name="insert.class">
        <xsl:with-param name="value" select="$class"/>
      </xsl:call-template>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="name(.)"/>
      </xsl:call-template>
    </dt>
    <xsl:choose>
      <xsl:when test="$link != ''">
	<dd>
      	  <xsl:call-template name="insert.class">
	    <xsl:with-param name="value" select="$class"/>
	  </xsl:call-template>
      	  <a href="{$link}">
	    <xsl:if test="$altval != ''">
	      <xsl:attribute name="title">
		<xsl:value-of select="$altval"/>
	      </xsl:attribute>
	    </xsl:if>
	    <xsl:apply-templates mode="sidebar.mode"/>
	  </a>
        </dd>
      </xsl:when>
      <xsl:otherwise>
        <dd>
      	  <xsl:call-template name="insert.class">
	    <xsl:with-param name="value" select="$class"/>
	  </xsl:call-template>
          <xsl:apply-templates mode="sidebar.mode"/>
        </dd>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="email" mode="sidebar.mode">
    <xsl:variable name="value">
      <xsl:text>mailto:</xsl:text>
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:call-template name="sidebar.address">
      <xsl:with-param name="link" select="$value"/>
      <xsl:with-param name="altval" select="$value"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="address" mode="sidebar.mode">
    <dl>
      <xsl:call-template name="insert.class"/>
      <xsl:call-template name="sidebar.address">
        <xsl:with-param name="class" select="''"/>
      </xsl:call-template>
    </dl>
  </xsl:template>

  <xsl:template match="phone|fax" mode="sidebar.mode">
    <xsl:call-template name="sidebar.address"/>
  </xsl:template>

  <xsl:template match="title" mode="sidebar.mode">
    <p>
      <xsl:call-template name="insert.class"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="postcode|city|country" mode="sidebar.mode">
    <xsl:apply-templates/>
    <xsl:call-template name="gentext.space"/>
  </xsl:template>

  <xsl:template match="street" mode="sidebar.mode">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

</xsl:stylesheet>
