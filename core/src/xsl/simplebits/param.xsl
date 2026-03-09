<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:output method="html"/>

<!-- ==================================================================== -->

<xsl:param name="title.label">logo</xsl:param>
<xsl:param name="secnav.label">sub</xsl:param>
<xsl:param name="wrapper.label">wrapper</xsl:param>
<xsl:param name="body.label">main-body</xsl:param>
<xsl:param name="content.label">content</xsl:param>
<xsl:param name="content.title.label">title</xsl:param>
<xsl:param name="primnav.label">nav</xsl:param>
<xsl:param name="sidebar.label">sidebar</xsl:param>
<xsl:param name="footer.label">footer</xsl:param>
<xsl:param name="footer.inner.label">footer-inner</xsl:param>
<xsl:param name="nav.current.label">active</xsl:param>
<xsl:param name="access.class" select="'access'"/>
<xsl:param name="secnav.linkwrapper" select="''"/>
</xsl:stylesheet>
