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
    <dc:title>SilkPage Core XSLT, Customization Layer</dc:title>
    <cvs:date>$Date: 2005-07-28 22:09:50 $</cvs:date>
    <dc:rights>Copyright &#169; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/site#license"/>
    <dc:description>
    This XSLT stylesheet customizes the generation of the Website.
  </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:param name="site.url" select="'http://www.markupware.com'"/>
  <xsl:param name="site.lang" select="''"/>
  <xsl:param name="site.id" select="'MarkupWare'"/>
  <xsl:param name="site.license" select="'http://www.markupware.com/metadata/site#license'"/>
  <xsl:param name="css.decoration" select="0"/>
  <xsl:param name="collect.xref.targets" select="'yes'"/>

  <!-- Search Box -->
  <xsl:param name="search.url" select="'www.markupware.com'"/>
  <xsl:param name="pages.search-box" select="1"/>
  <xsl:param name="pages.search.input-label" select="'Search MarkupWare'"/>
  <xsl:param name="pages.search.submit-label" select="'Go'"/>

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
</xsl:stylesheet>
