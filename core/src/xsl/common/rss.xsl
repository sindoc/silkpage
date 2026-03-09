<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:atom="http://www.w3.org/2005/Atom" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:date="http://exslt.org/dates-and-times"
		exclude-result-prefixes=" html rdf dc cvs rss cvsf date atom "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/rss.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common RSS</dc:title>
    <cvs:date>$Date: 2009-10-26 23:58:47 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>This stylesheets processes the rss tag.</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

<xsl:template match="rss">
  <xsl:param name="wrapper" select="'div'"/>
  <xsl:variable name="ancestor" select="."/>
  <xsl:choose>
    <xsl:when test="$wrapper != ''">
      <xsl:element name="{$wrapper}">
	<xsl:attribute name="class">
	  <xsl:value-of select="name(.)"/>
	</xsl:attribute>
	<xsl:call-template name="feed">
	  <xsl:with-param name="ancestor" select=".."/>
	</xsl:call-template>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="feed">
	<xsl:with-param name="ancestor" select=".."/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="feed">
  <xsl:param name="ancestor" select="."/>
  <xsl:variable name="feed" select="document(@feed, .)"/>
  <xsl:choose>
    <xsl:when test="not($feed)">
      <xsl:message>
	<xsl:text>Feed Failed: </xsl:text>
	<xsl:value-of select="@feed"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
      <xsl:value-of select="@feed"/>
    </xsl:when>
    <xsl:when test="$feed/rdf:RDF and ancestor::webpage[@id != $feeds.label]">
      <xsl:apply-templates select="$feed/*/rss:channel">
	<xsl:with-param name="ancestor" select="$ancestor"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$feed/atom:feed and ancestor::webpage[@id != $feeds.label]">
      <xsl:apply-templates select="$feed/atom:feed">
	<xsl:with-param name="ancestor" select="$ancestor"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="ancestor::webpage[@id != $feeds.label]">
	<xsl:apply-templates select="$feed//rss:channel">
	  <xsl:with-param name="ancestor" select="$ancestor"/>
	</xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

  <xsl:template match="rss:channel">
    <xsl:param name="ancestor" select="."/>
    <xsl:variable name="image-resource" select="rss:image/@rdf:resource"/>
    <xsl:variable name="image" select="//rss:image[@rdf:about = $image-resource]"/>
    <xsl:if test="$image">
      <xsl:choose>
        <xsl:when test="$image/rss:link">
          <a href="{$image/rss:link}">
            <img align="right" border="0">
              <xsl:attribute name="src">
                <xsl:value-of select="$image/rss:url[1]"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="$image/rss:title[1]"/>
              </xsl:attribute>
              <xsl:if test="$image/rss:width">
                <xsl:attribute name="width">
                  <xsl:value-of select="$image/rss:width[1]"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$image/rss:height">
                <xsl:attribute name="height">
                  <xsl:value-of select="$image/rss:height[1]"/>
                </xsl:attribute>
              </xsl:if>
            </img>
          </a>
        </xsl:when>
        <xsl:otherwise>
<!--    <img src="{$image/rss:url}" alt="{$image/rss:title}" align="right">-->
          <img align="right" border="0">
            <xsl:attribute name="src">
              <xsl:value-of select="$image/rss:url[1]"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="$image/rss:title[1]"/>
            </xsl:attribute>
            <xsl:if test="$image/width">
              <xsl:attribute name="width">
                <xsl:value-of select="$image/height[1]"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$image/height">
              <xsl:attribute name="height">
                <xsl:value-of select="$image/height[1]"/>
              </xsl:attribute>
            </xsl:if>
          </img>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- RSS feed description will not be shown
    <xsl:if test="name($ancestor) != 'sidebar'">
      <xsl:apply-templates select="rss:description">
	</xsl:apply-templates>
    </xsl:if>
     -->
    <xsl:apply-templates select="rss:items">
      <xsl:with-param name="ancestor" select="$ancestor"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="rss:title">
    <xsl:param name="ancestor" select="."/>
    <xsl:param name="wrapper" select="'h3'"/>

    <xsl:variable name="date.wrapper" select="'dd'"/>

    <xsl:element name="{$wrapper}">
      <xsl:choose>
        <xsl:when test="../rss:link">
	  <a href="{../rss:link[1]}">
	    <xsl:apply-templates/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:if test="../dc:date|../cvs:date and not(ancestor::rss:channel)">
      <xsl:element name="{$date.wrapper}">
	<xsl:attribute name="class">
	  <xsl:value-of select="'date'"/>
	</xsl:attribute>
        <xsl:choose>
          <xsl:when test="../dc:date">
	    <xsl:call-template name="feed.date.format">
      	      <xsl:with-param name="ancestor" select="$ancestor"/>
      	      <xsl:with-param name="node" select="../dc:date"/>
	    </xsl:call-template>
          </xsl:when>
          <xsl:when test="function-available('cvsf:localTime')">
            <xsl:variable name="timeString" select="cvsf:localTime(../cvs:date[1])"/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="substring($timeString, 1, 3)"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="substring($timeString, 9, 2)"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring($timeString, 5, 3)"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring($timeString, 25, 4)"/>
            <xsl:text>)</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="../cvs:date[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rss:description">
    <xsl:param name="wrapper" select="'p'"/>
    <xsl:element name="{$wrapper}">
      <xsl:call-template name="insert.class">
	<xsl:with-param name="value" select="$description.label"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rss:items">
    <xsl:param name="ancestor" select="."/>
    <dl>
      <xsl:for-each select="rdf:Seq/rdf:li[@rdf:resource and @rdf:resource != '']">
        <xsl:variable name="resource" select="@rdf:resource"/>
        <xsl:variable name="item" select="//rss:item[@rdf:about = $resource]"/>
        <xsl:if test="not($item)">
          <xsl:message>
            <xsl:text>RSS Warning: there is no item labelled: </xsl:text>
            <xsl:value-of select="$resource"/>
          </xsl:message>
        </xsl:if>
        <xsl:if test="count($item) &gt; 1">
          <xsl:message>
            <xsl:text>RSS Warning: there is more than one item labelled: </xsl:text>
            <xsl:value-of select="$resource"/>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="$item">
          <xsl:with-param name="ancestor" select="$ancestor"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </dl>
  </xsl:template>
  <xsl:template match="rss:item">
    <xsl:param name="ancestor" select="."/>
    <xsl:message>
      <xsl:text>RSS item: </xsl:text>
      <xsl:value-of select="rss:title"/>
    </xsl:message>
    <xsl:apply-templates select="rss:title">
      <xsl:with-param name="wrapper" select="'dt'"/>
      <xsl:with-param name="ancestor" select="$ancestor"/>
    </xsl:apply-templates>
    <xsl:if test="rss:description">
      <dd>
        <xsl:apply-templates select="rss:description"/>
      </dd>
    </xsl:if>
</xsl:template>


</xsl:stylesheet>
