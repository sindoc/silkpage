<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:pm="http://www.web-semantics.org/ns/pm#"
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		extension-element-prefixes=" html rdf rdfs cvs xlink urfm pm doap rss cvsf date foaf dc "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/doap.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common DOAP</dc:title>
    <cvs:date>$Date: 2007-10-24 20:28:38 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 - 2005 MarkupWare.</dc:rights>
    <dc:description>
      This stylesheet displays DOAP files as HTML.
    </dc:description>
  </rdf:Description>
  
  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

<xsl:template name="doap">
  <xsl:param name="href"/>
  <xsl:param name="id"/>
  <xsl:variable name="sponsor" select="$href//foaf:*[@rdf:about=$href//doap:Project/foaf:maker/@rdf:resource]"/>
  <div class="{$doap.label}">
    <xsl:choose>
      <xsl:when test="$href//doap:Project
		      and starts-with($id,$sponsor.label)
		      and $sponsor">
	<xsl:if test="@param = ../config[1]/@param">
	  <xsl:apply-templates select="document(@param, .)//foaf:*[@rdf:about=$href//doap:Project/foaf:maker/@rdf:resource]" mode="sponsor"/>
	  <xsl:call-template name="sponsor-contribution"/>
	</xsl:if>
	<xsl:apply-templates select="$href//doap:Project" mode="sponsor"/>
      </xsl:when>
      <xsl:when test="$href//doap:Project and $id=$dev.label">
	<xsl:apply-templates select="$href//doap:Project">
	  <xsl:with-param name="dev" select="true()"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$href//doap:Project">
	<xsl:apply-templates select="$href//doap:Project"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>
	  <xsl:text>Unable to process DOAP file</xsl:text>
	</xsl:message>      
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="doap:Project">
  <xsl:param name="dev" select="false()"/>
  <div class="{local-name(.)}">
    <xsl:choose>
      <xsl:when test="$dev = true()">
	<xsl:apply-templates select="doap:bug-database|doap:mailing-list|doap:repository"/>
      </xsl:when>
      <xsl:otherwise>
    <xsl:apply-templates select="doap:name|doap:license|doap:homepage|
				 doap:created|rdfs:seeAlso/foaf:Document"/>
    
    <!-- This stupid hack works for a while -->
    <xsl:variable name="id" select="dc:identifier/text()"/>
    <xsl:variable name="urfm" select="document(doap:download-page/@rdf:resource, .)"/>
    <xsl:if test="$urfm">
      <p class="updated">
	<strong>
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'Meta'"/>
	    <xsl:with-param name="name" select="'LastUpdated'"/>
	  </xsl:call-template>
	  <xsl:value-of select="$biblioentry.item.separator"/>
	  <xsl:call-template name="gentext.space"/>        
	</strong>
	<span>
      <xsl:choose>
	<xsl:when test="function-available('date:date-time') or 
			function-available('date:dateTime')">
	  <xsl:call-template name="datetime.format">
	    <xsl:with-param name="date" select="$urfm//urfm:releases/urfm:Release/urfm:package[@rdf:resource=$id]/../urfm:created"/>
	    <xsl:with-param name="format">
    		<xsl:call-template name="gentext.template">
	          <xsl:with-param name="context" select="'datetime'"/>
	          <xsl:with-param name="name" select="'feed-format'"/>
  	        </xsl:call-template>
	      </xsl:with-param>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    Timestamp processing requires XSLT processor with EXSLT date support.
	  </xsl:message>
	</xsl:otherwise>
      </xsl:choose>
	</span>
      </p>
    </xsl:if>
    <xsl:if test="foaf:maker or
		  rdfs:seeAlso[@rdf:resource=//foaf:*/@rdf:about]">
      <p class="maker">
	<strong>
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'FOAF'"/>
	    <xsl:with-param name="name" select="'maker'"/>
	  </xsl:call-template>
	  <xsl:value-of select="$biblioentry.item.separator"/>
	  <xsl:call-template name="gentext.space"/>        
	</strong>
	<xsl:apply-templates select="foaf:maker|rdfs:seeAlso[@rdf:resource=//foaf:*/@rdf:about]"/>
      </p>
    </xsl:if>
    <xsl:if test="doap:category">
      <p class="category">
	<strong>
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'DOAP'"/>
	    <xsl:with-param name="name" select="'category'"/>
	  </xsl:call-template>
	  <xsl:value-of select="$biblioentry.item.separator"/>
	  <xsl:call-template name="gentext.space"/>        
	</strong>
	<xsl:apply-templates select="doap:category"/>
      </p>
    </xsl:if>
    <xsl:apply-templates select="doap:description|doap:download-page|pm:subProject"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="rdfs:seeAlso/doap:Project[@rdf:about != '']">
  <xsl:variable name="doap" select="document(@rdf:about, .)"/>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$doap//doap:Project/doap:name">
	<xsl:value-of select="normalize-space($doap//doap:Project/doap:name[1]/text())"/>
      </xsl:when>
      <xsl:when test="$doap//doap:Project/doap:shortname">
	<xsl:value-of select="normalize-space($doap//doap:Project/doap:shortname[1]/text())"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <li class="maker">
     <a href="{$doap//doap:Project/doap:homepage/@rdf:resource}" title="{string($title)}">
      <xsl:value-of select="$title"/>
    </a>
  </li>
</xsl:template>

<xsl:template match="doap:Project" mode="sponsor">
  <p>
    <xsl:apply-templates select="doap:name" mode="sponsor"/>
  </p>
</xsl:template>

<xsl:template match="doap:category|dc:category">
  <span>
    <xsl:choose>
      <xsl:when test="@rdf:resource">
	<xsl:variable name="category">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'Category'"/>
	    <xsl:with-param name="name" select="@rdf:resource"/>
	  </xsl:call-template>
	</xsl:variable>
	<xsl:if test="starts-with(@rdf:resource,'http://')">
	<!--
	  <a href="{@rdf:resource}" title="{$category}">
	  </a>
	  -->
	    <xsl:value-of select="$category"/>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <span class="csep">, </span>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template match="doap:name">
  <h2 class="{local-name(.)}">
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="doap:name" mode="sponsor">
  <span class="{local-name(.)}">
    <a href="{../doap:homepage[1]/@rdf:resource}" title="{node()}">
      <xsl:apply-templates/>
    </a>
  </span>
</xsl:template>

<xsl:template match="doap:description|dc:description">
  <div class="{local-name(.)}">
    <h2>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
    </h2>
    <p>
      <xsl:apply-templates/>
    </p>
  </div>
</xsl:template>

<xsl:template match="doap:shortname|doap:shortdesc
		     |doap:os|doap:programming-language">
  <p class="{local-name(.)}">
    <strong>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>        
    </strong>
    <span>
      <xsl:apply-templates/>
    </span>
  </p>
</xsl:template>

<xsl:template match="doap:maintainer">
  <p class="{local-name(.)}">
    <strong>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>        
    </strong>
    <span>
      <xsl:apply-templates select="foaf:Person/foaf:name[1]"/>
    </span>
  </p>
</xsl:template>

<xsl:template match="doap:download-mirror|doap:mailing-list|doap:bug-database">
  <xsl:variable name="label">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'DOAP'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:variable>
  <h2 class="{local-name(.)}">
    <xsl:value-of select="$label"/>
  </h2>
  <p class="{local-name(.)}">
    <a href="{@rdf:resource}" title="{$label}">
      <xsl:value-of select="@rdf:resource"/>
    </a>
  </p>
</xsl:template>

<xsl:template match="doap:browse">
  <xsl:variable name="label">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'DOAP'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:variable>
  <dt class="{local-name(.)}">
    <xsl:value-of select="$label"/>
  </dt>
  <dd class="{local-name(.)}">
    <a href="{@rdf:resource}" title="{$label}">
      <xsl:value-of select="@rdf:resource"/>
    </a>
  </dd>
</xsl:template>


<xsl:template match="doap:homepage|foaf:homepage">
  <xsl:variable name="label">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'DOAP'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:variable>

  <p class="{local-name(.)}">
    <strong>
      <xsl:value-of select="$label"/>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>
    </strong>
    <a href="{@rdf:resource}" title="{$label}">
      <xsl:value-of select="@rdf:resource"/>
    </a>
  </p>
</xsl:template>

<xsl:template match="rdfs:seeAlso/foaf:Document">
  <xsl:variable name="label">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'FOAF'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:variable>

  <p class="{local-name(.)}">
    <strong>
      <xsl:value-of select="$label"/>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>
    </strong>
    <a href="{@rdf:about}" title="{$label}">
      <xsl:value-of select="@rdf:about"/>
    </a>
  </p>
</xsl:template>

<xsl:template match="doap:repository">
  <h2 class="{local-name(.)}">
    <span>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
    </span>
  </h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="doap:license">
  <p class="{local-name(.)}">
    <strong>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>        
    </strong>
    <span>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="@rdf:resource"/>
      </xsl:call-template>
    </span>
  </p>
</xsl:template>

<xsl:template match="doap:download-page">
  <xsl:variable name="pkgid">
    <xsl:choose>
      <xsl:when test="//doap:Project/dc:identifier">
	<xsl:value-of select="//doap:Project/dc:identifier"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="//doap:Project/doap:homepage/@rdf:resource"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="urfm" select="document(@rdf:resource, .)"/>
  <xsl:choose>
    <xsl:when test="not($urfm//urfm:Channel)">
      <xsl:message terminate="no">
	<xsl:text>Unable to process URFM file: [</xsl:text>
	<xsl:value-of select="@rdf:resource"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$urfm//urfm:Channel" mode="doap">
	<xsl:with-param name="pkgid" select="$pkgid"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="doap:created">

  <xsl:variable name="format">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'datetime'"/>
      <xsl:with-param name="name" select="'feed-format'"/>
    </xsl:call-template>
  </xsl:variable>

  <p class="{local-name(.)}">
    <strong>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
    </strong>
    <xsl:value-of select="$biblioentry.item.separator"/>
    <xsl:call-template name="gentext.space"/>  
    <span>
      <xsl:choose>
	<xsl:when test="function-available('date:date-time') or 
			function-available('date:dateTime')">
	  <xsl:call-template name="datetime.format">
	    <xsl:with-param name="date" select="."/>
	    <xsl:with-param name="format" select="$format"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    Timestamp processing requires XSLT processor with EXSLT date support.
	  </xsl:message>
	</xsl:otherwise>
      </xsl:choose>
    </span>
  </p>
</xsl:template>

<xsl:template name="sponsor-contribution">
  <h2>
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'FOAF'"/>
      <xsl:with-param name="name" select="'Contributions'"/>
    </xsl:call-template>
  </h2>
</xsl:template>

<xsl:template match="doap:CVSRepository">
  <h3>
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'DOAP'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>    
  </h3>
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="doap:anon-root|doap:module">
  <dt class="{local-name(.)}">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'DOAP'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>    
  </dt>
  <dd class="{local-name(.)}">
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="pm:subProject">
  <xsl:variable name="sp" select="document(@rdf:resource,/)"/>
  <xsl:apply-templates select="$sp//doap:Project/doap:download-page"/>
</xsl:template>

</xsl:stylesheet>
