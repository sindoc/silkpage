<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/rdf/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <xsl:import href="http://silkpage.markupware.com/release/core/current/src/xsl/ala/chunk.xsl"/>
  <xsl:import href="param.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/custom.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Customization Layer</dc:title>
    <cvs:date>$Date: 2010-12-19 01:09:31 $</cvs:date>
    <dc:rights>Copyright &#169; 2004 MarkupWare.</dc:rights>
    <dc:description>
    This XSLT stylesheet customizes the generation of MarkupWare Website.
  </dc:description>
  </rdf:Description>

<!-- ==================================================================== -->

  <xsl:template match="sidebar">
    <xsl:variable name="address" select="address"/>
    <xsl:variable name="rss" select="rss"/>
    <xsl:choose>
      <xsl:when test="$address">
        <xsl:apply-templates select="*[name(.) != name($address)]"/>
	<xsl:apply-templates select="$address" mode="sidebar.mode"/>
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
<xsl:template match="address" mode="sidebar.mode">
  <dl>
    <xsl:call-template name="insert.class"/>
    <xsl:call-template name="sidebar.address"/>
  </dl>
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
  <span>
    <xsl:call-template name="insert.class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template name="sidebar.address">
  <xsl:param name="link" select="''"/>
  <xsl:param name="altval" select="''"/>
  <xsl:param name="class" select="local-name(.)"/>
  <dt>
    <xsl:call-template name="insert.class">
      <xsl:with-param name="value" select="$class"/>
    </xsl:call-template>
    <span>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'Address'"/>
        <xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
    </span>
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
        <span>
          <xsl:apply-templates mode="sidebar.mode"/>
        </span>
      </dd>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
