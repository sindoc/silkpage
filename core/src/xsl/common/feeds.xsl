<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
                xmlns:date="http://exslt.org/dates-and-times"
		exclude-result-prefixes=" html rdf dc cvs rss cvsf date "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/feeds.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Feeds</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:51 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

  <!-- ==================================================================== -->
  

  <xsl:template name="feeds">
    <div class="{$feeds.label}">
    <table border="{$feeds.table.border}">
      <thead>
	<th>
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedTopic'"/>
	  </xsl:call-template>
	</th>
	<th>
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedDescription'"/>
	  </xsl:call-template>
	</th>
	<th>
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedRSS'"/>
	  </xsl:call-template>
	</th>
	<th>
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedAtom'"/>
	  </xsl:call-template>
	</th>
      </thead>
      <tbody>
	<xsl:apply-templates select="//rss" mode="feeds.mode"/>
      </tbody>
    </table>
<!--
    <p class="sub-bloglines">
      <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="$feeds.subscribe.bloglines"/>
	  <xsl:value-of select="document(@feed, //rss:channel/dc:identifier[1])"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedSubscribe'"/>
	  </xsl:call-template>
	</xsl:attribute>
	<xsl:call-template name="gentext">
	  <xsl:with-param name="key" select="'FeedSubscribe'"/>
	</xsl:call-template>
      </a>
    </p>
-->
    </div>
  </xsl:template>
  
  <xsl:template match="rss" mode="feeds.mode">
    <xsl:variable name="feed" select="document(@feed, .)"/>
    <xsl:choose>
      <xsl:when test="not($feed)">
	<xsl:message>
	  <xsl:text>Failed to read the specified feed [</xsl:text>
	  <xsl:value-of select="@feed"/>
	  <xsl:text>]</xsl:text>
        </xsl:message>
      </xsl:when>
      <xsl:when test="$feed/rdf:RDF">
	<xsl:apply-templates select="$feed/*/rss:channel" mode="feeds.mode">
	  <xsl:with-param name="feeduri" select="@feed"/>
	  <xsl:with-param name="feed" select="$feed"/>
	</xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rss:channel" mode="feeds.mode">
    <xsl:param name="feeduri"/>
    <xsl:param name="feed"/>
    <tr>
      <xsl:call-template name="syndicate.feeds">
	<xsl:with-param name="feeduri" select="$feeduri"/>
	<xsl:with-param name="feed" select="$feed"/>
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template name="syndicate.feeds">
    <xsl:param name="feeduri"/>
    <xsl:param name="feed"/>
    <xsl:variable name="title" select="$feed//rss:channel/rss:title[1]"/>
    <th>
      <xsl:apply-templates select="rss:title">
	<xsl:with-param name="wrapper" select="'p'"/>
      </xsl:apply-templates>
    </th>
    <th>	
      <xsl:apply-templates select="rss:description">
	<xsl:with-param name="wrapper" select="'p'"/>
      </xsl:apply-templates>
    </th>
    <th class="rss">
      <p>
	<a href="{$feeduri}" title="{$title}">
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedRSS'"/>
	  </xsl:call-template>
	</a>
      </p>
    </th>
    <th class="atom">
      <p>
	<a title="{$title}">
	  <xsl:attribute name="href">
	    <xsl:value-of select="substring-before($feeduri,'rss')"/>
	    <xsl:text>xml</xsl:text>
	  </xsl:attribute>
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'FeedAtom'"/>
	  </xsl:call-template>
	</a>
      </p>
    </th>
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
	 <xsl:when test="name($ancestor)='webpage'">
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
