<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:output method="html"/>

<!-- ==================================================================== -->

<xsl:param name="site.url" select="''"/>
<xsl:param name="site.license" select="''"/>
<xsl:param name="site.lang" select="''"/>
<xsl:param name="site.id" select="''"/>
<xsl:param name="output.method" select="'xhtml10'"/>

<xsl:param name="site.generator.url" select="'http://silkpage.markupware.com/docs/silkpaged/'"/>
<xsl:param name="markupware.url" select="'http://www.markupware.com'"/>
<xsl:param name="markupware.taxonomy.url">
  <xsl:value-of select="$markupware.url"/>
  <xsl:text>/metadata/taxonomy</xsl:text>
</xsl:param>
<xsl:param name="pages.search-box" select="''"/>
<xsl:param name="pages.search.input-label">Example.org</xsl:param>

<xsl:param name="atom.label">atom</xsl:param>
<xsl:param name="foaf.label">foaf</xsl:param>
<xsl:param name="doap.label">doap</xsl:param>
<xsl:param name="rss10.label">rss</xsl:param>
<xsl:param name="urfm.label">urfm</xsl:param>
<xsl:param name="rdf.label">rdf</xsl:param>
<xsl:param name="xml.label">xml</xsl:param>

<xsl:param name="sources.rdf">RDF</xsl:param>
<xsl:param name="sources.urfm">URFM</xsl:param>
<xsl:param name="sources.foaf">FOAF</xsl:param>
<xsl:param name="sources.doap">DOAP</xsl:param>
<xsl:param name="sources.atom">Atom</xsl:param>
<xsl:param name="sources.rss10">RSS</xsl:param>
<xsl:param name="sources.xml">XML</xsl:param>
<xsl:param name="sources.label">sources</xsl:param>

<xsl:param name="sitemap.pageformats" select="'0'"/>

<xsl:param name="generate.translation" select="'no'"/>
<xsl:param name="generate.rdf" select="'no'"/>
<xsl:param name="rdf.ext">.rdf.xml</xsl:param>
<xsl:param name="html.ext">.html</xsl:param>
<xsl:param name="doap.ext">.doap</xsl:param>
<xsl:param name="output-root" select="."/>

<xsl:param name="right.label">right</xsl:param>
<xsl:param name="left.label">left</xsl:param>
<xsl:param name="meta.label">meta</xsl:param>
<xsl:param name="title.label">title</xsl:param>
<xsl:param name="feedback.label">feedback</xsl:param>
<xsl:param name="homelink.label">home</xsl:param>
<xsl:param name="header.label">header</xsl:param>
<xsl:param name="compliance.label">compliance</xsl:param>
<xsl:param name="updated.label">updated</xsl:param>
<xsl:param name="address.label">address</xsl:param>
<xsl:param name="copyright.label">copyright</xsl:param>
<xsl:param name="breadcrumb.label">breadcrumb</xsl:param>
<xsl:param name="privacy.label">privacy</xsl:param>
<xsl:param name="headitems.label">headitems</xsl:param>
<xsl:param name="headitem.label">headitem</xsl:param>
<xsl:param name="trl.label">translation</xsl:param>
<xsl:param name="trls.label">trls</xsl:param>
<xsl:param name="footitems.label">footitems</xsl:param>
<xsl:param name="footitem.label">footitem</xsl:param>
<xsl:param name="footer.label">footer</xsl:param>
<xsl:param name="footer.inner.label">footer-inner</xsl:param>
<xsl:param name="body.label">body</xsl:param>
<xsl:param name="content.label">content</xsl:param>
<xsl:param name="content.title.label">content-title</xsl:param>
<xsl:param name="description.label">desc</xsl:param>
<xsl:param name="primnav.label">primnav</xsl:param>
<xsl:param name="sidebar.label">sidebar</xsl:param>
<xsl:param name="secnav.label">secnav</xsl:param>
<xsl:param name="secnav.linkwrapper">strong</xsl:param>
<xsl:param name="nav.breadcrumb.separator">&#187;</xsl:param>
<xsl:param name="nav.current.label">current</xsl:param>
<xsl:param name="nav.ancestor.label">ancestor</xsl:param>
<xsl:param name="news.archive.label" select="'newsArchives'"/>
<xsl:param name="xhtml.validator.url">http://validator.w3.org/check?uri=referer</xsl:param>
<xsl:param name="css.validator.url" select="'http://jigsaw.w3.org/css-validator/check/referer'"/>

<xsl:param name="sitemap.label">sitemap</xsl:param>
<xsl:param name="feeds.label">feeds</xsl:param>
<xsl:param name="clients.label">clients</xsl:param>
<xsl:param name="clients-all.label">clients-all</xsl:param>
<xsl:param name="sponsors.label">sponsors</xsl:param>
<xsl:param name="sponsor.label">sponsor</xsl:param>
<xsl:param name="partner.label">sponsor</xsl:param>
<xsl:param name="dev.label">dev</xsl:param>
<xsl:param name="feeds.table.border" select="'0'"/>
<xsl:param name="sponsors.table.border" select="'0'"/>

<xsl:param name="access.validator.url" select="concat('http://wave.webaim.org/report?url=',$site.url)"/>
<xsl:param name="access.key.home" select="'1'"/>
<xsl:param name="access.key.content" select="'2'"/>
<xsl:param name="access.key.searchbox" select="'4'"/>
<xsl:param name="access.key.feedback" select="'9'"/>
<xsl:param name="access.key.statement" select="'0'"/>
<xsl:param name="access.class" select="'access'"/>
<xsl:param name="css.decoration" select="0"/>

<xsl:param name="biblioentry.item.separator" select="':'"/>
<xsl:param name="urfm.type.document" select="'http://xmlns.com/wordnet/1.6/Document'"/>
<xsl:param name="urfm.type.package.Software" select="'http://purl.org/dc/dcmitype/Software'"/>
<xsl:param name="urfm.type.file.SourceDist" select="'http://purl.org/urfm/SourceDist'"/>
<xsl:param name="urfm.type.file.DocumentationDist" select="'http://purl.org/urfm/DocumentationDist'"/>
<xsl:param name="urfm.type.file.BinaryDist" select="'http://purl.org/urfm/BinaryDist'"/>
<xsl:param name="urfm.files.table.border" select="'0'"/>


<xsl:param name="rdf.to.html.stylesheet.path" select="'/rdf-html.xsl'"/>

</xsl:stylesheet>
