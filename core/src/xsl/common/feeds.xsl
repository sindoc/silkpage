<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:date="http://exslt.org/dates-and-times"
		exclude-result-prefixes=" html rdf dc cvs rss cvsf date atom "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/feeds.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Feeds</dc:title>
    <cvs:date>$Date: 2009-10-26 23:58:47 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This style sheet is intended to syndicate Atom feeds in a specific page
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

  <!-- ==================================================================== -->
  

<xsl:template name="feeds">
  <table border="{$feeds.table.border}" class="{$feeds.label}">
    <xsl:attribute name="summary">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'RSS'"/>
	<xsl:with-param name="name" select="'caption'"/>
      </xsl:call-template>      
    </xsl:attribute>
    <caption>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'RSS'"/>
	<xsl:with-param name="name" select="'caption'"/>
      </xsl:call-template>      
    </caption>
      <thead>
	<th id="feed-title">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'RSS'"/>
	    <xsl:with-param name="name" select="'title'"/>
	  </xsl:call-template>
	</th>
	<th id="feed-description" class="feed-description">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'RSS'"/>
	    <xsl:with-param name="name" select="'description'"/>
	  </xsl:call-template>
	</th>
	<th id="feed-subscribe">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'RSS'"/>
	    <xsl:with-param name="name" select="'Subscribe'"/>
	  </xsl:call-template>
	</th>
      </thead>
      <tbody>
	<xsl:apply-templates select="//rss" mode="feeds.mode"/>
      </tbody>
    </table>
</xsl:template>
  
<xsl:template match="rss" mode="feeds.mode">
  <xsl:variable name="feed" select="document(@feed, .)"/>
  <xsl:choose>
    <xsl:when test="not($feed)">
      <xsl:message>
	<xsl:text>Failed to read feed [</xsl:text>
	<xsl:value-of select="@feed"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:when test="$feed/atom:feed">
      <xsl:apply-templates select="$feed/atom:feed" mode="feeds.mode">
	<xsl:with-param name="feeduri" select="@feed"/>
	<xsl:with-param name="feed" select="$feed"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$feed/rss[@version='2.0']/channel">
      <xsl:apply-templates select="$feed/rss/channel" mode="feeds.mode">
	<xsl:with-param name="feeduri" select="@feed"/>
	<xsl:with-param name="feed" select="$feed"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unknown feed format [</xsl:text>
	<xsl:value-of select="@feed"/>
        <xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="atom:feed" mode="feeds.mode">
  <xsl:param name="feeduri"/>
  <xsl:param name="feed"/>
  <tr>
    <xsl:call-template name="syndicate.feeds">
      <xsl:with-param name="feeduri" select="$feeduri"/>
      <xsl:with-param name="feed" select="$feed"/>
      <xsl:with-param name="feed-title" select="atom:title[1]"/>
      <xsl:with-param name="feed-desc" select="atom:subtitle[1]"/>
      <xsl:with-param name="feed-type" select="'Atom'"/>
    </xsl:call-template>
  </tr>
</xsl:template>

<xsl:template match="channel" mode="feeds.mode">
  <xsl:param name="feeduri"/>
  <xsl:param name="feed"/>
  <tr>
    <xsl:call-template name="syndicate.feeds">
      <xsl:with-param name="feeduri" select="$feeduri"/>
      <xsl:with-param name="feed" select="$feed"/>
      <xsl:with-param name="feed-title" select="title[1]"/>
      <xsl:with-param name="feed-desc" select="description[1]"/>
      <xsl:with-param name="feed-type" select="'RSS'"/>
    </xsl:call-template>
  </tr>
</xsl:template>

<xsl:template name="syndicate.feeds">
  <xsl:param name="feeduri"/>
  <xsl:param name="feed"/>
  <xsl:param name="feed-title"/>
  <xsl:param name="feed-desc"/>
  <xsl:param name="feed-type"/>
  <td headers="feed-title">
    <xsl:apply-templates select="$feed-title" mode="feeds.mode">
      <xsl:with-param name="wrapper" select="'p'"/>
    </xsl:apply-templates>
  </td>
  <td headers="feed-description" class="feed-description">
    <xsl:apply-templates select="$feed-desc"/>
  </td>
  <td headers="feed-subscribe">
    <p class="feed">
      <a href="{$feeduri}" title="{$feed-title}" class="atom">
        <span>
          <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="$feed-type"/>
	    <xsl:with-param name="name" select="$feed-type"/>
          </xsl:call-template>
        </span>
      </a>
    </p>
  </td>
</xsl:template>

<xsl:template match="atom:title" mode="feeds.mode">
  <xsl:apply-templates select=".">
    <xsl:with-param name="wrapper" select="'p'"/>
  </xsl:apply-templates>
</xsl:template>

  <xsl:template match="title" mode="feeds.mode">
    <xsl:param name="wrapper" select="'p'"/>
    <xsl:element name="{$wrapper}">
      <xsl:choose>
	<xsl:when test="../link">
	  <a href="{../link[1]/text()}">
	    <xsl:apply-templates/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="feed.date.format">
    <xsl:param name="ancestor" select="."/>
    <xsl:param name="node" select="."/>
    <xsl:variable name="format">
      <xsl:choose>
        <xsl:when test="name($ancestor)='sidebar'">
       	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'datetime'"/>
 	    <xsl:with-param name="name" select="'news-sidebar-format'"/>
          </xsl:call-template>
	 </xsl:when>
	 <xsl:when test="name($ancestor)='webpage' or
			name($ancestor)='section'">
           <xsl:call-template name="gentext.template">
	     <xsl:with-param name="context" select="'datetime'"/>
 	     <xsl:with-param name="name" select="'feed-format'"/>
           </xsl:call-template>
	  </xsl:when>
	  <xsl:when test="$ancestor/@id=$news.archive.label">
            <xsl:call-template name="gentext.template">
	      <xsl:with-param name="context" select="'datetime'"/>
 	      <xsl:with-param name="name" select="'news-archive-format'"/>
            </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
            <xsl:call-template name="gentext.template">
	      <xsl:with-param name="context" select="'datetime'"/>
 	      <xsl:with-param name="name" select="'format'"/>
            </xsl:call-template>
	   </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
     <xsl:choose>
       <xsl:when test="function-available('date:date-time') or 
		       function-available('date:dateTime')">
	<xsl:call-template name="datetime.format">
          <xsl:with-param name="date" select="$node"/>
          <xsl:with-param name="format" select="$format"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          Timestamp processing requires XSLT processor with EXSLT date support.
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
