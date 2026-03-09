<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:output method="html"/>

<xsl:param name="feedback.label">feedback</xsl:param>
<xsl:param name="homelink.label">home</xsl:param>
<xsl:param name="header.label">header</xsl:param>
<xsl:param name="compliance.label">compliance</xsl:param>
<xsl:param name="updated.label">updated</xsl:param>
<xsl:param name="address.label">address</xsl:param>
<xsl:param name="copyright.label">copyright</xsl:param>
<!--
<xsl:param name="headitems.label">headitems</xsl:param>
-->
<xsl:param name="headitems.label"/>
<xsl:param name="headitem.label">headitem</xsl:param>

<xsl:param name="footitems.label">footitems</xsl:param>
<xsl:param name="footitem.label">footitem</xsl:param>
<xsl:param name="footer.label">footer</xsl:param>
<xsl:param name="sitemap.label">sitemap</xsl:param>
<xsl:param name="content.label">mainContent</xsl:param>
<xsl:param name="navbar.label">navbar</xsl:param>
<xsl:param name="navbaritem.label">navbaritem</xsl:param>
<xsl:param name="navmenu.label">side</xsl:param>
<xsl:param name="navmenuitem.label">navmenuitem</xsl:param>
<xsl:param name="nav.current.label">current</xsl:param>
<xsl:param name="nav.ancestor.label">ancestor</xsl:param>

</xsl:stylesheet>
