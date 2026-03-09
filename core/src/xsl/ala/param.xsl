<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc html"
                version="1.0">

<xsl:output method="html"/>

<!-- ==================================================================== -->

<xsl:param name="subnav.label">subnav</xsl:param>
<xsl:param name="wrapper.label">wrapper</xsl:param>
<xsl:param name="body.label">pagebody</xsl:param>
<xsl:param name="content.label">maincontent</xsl:param>
<xsl:param name="primnav.label">menu</xsl:param>
<xsl:param name="sidebar.label">sidebar</xsl:param>
<xsl:param name="access.class" select="'access'"/>
</xsl:stylesheet>
