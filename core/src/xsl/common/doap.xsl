<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		extension-element-prefixes=" html rdf rdfs cvs xlink urfm doap rss cvsf date foaf dc "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/urfm.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common URFM</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:50 $</cvs:date>
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
	<xsl:variable name="multi-contrib">
	  <xsl:choose>
	    <xsl:when test="count(//link[@xlink:role=$namespace.doap]) &gt; '1'">1</xsl:when>
	    <xsl:otherwise>0</xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:if test="@xlink:href = ../link[1]/@xlink:href">
	  <xsl:apply-templates select="document(@xlink:href, .)//foaf:*[@rdf:about=$href//doap:Project/foaf:maker/@rdf:resource]" mode="sponsor"/>
	  <h2>
	    <xsl:choose>
	      <xsl:when test="$multi-contrib = '1'">
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key" select="'Contributions'"/>
		</xsl:call-template>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key" select="'Contribution'"/>
		</xsl:call-template>	
	      </xsl:otherwise>
	    </xsl:choose>
	  </h2>
	</xsl:if>
	<xsl:apply-templates select="$href//doap:Project" mode="sponsor"/>
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
  <div class="{local-name(.)}">
    
    <xsl:apply-templates select="doap:homepage|doap:license
				 |doap:created
				 |doap:category|doap:name"/>
    <xsl:if test="foaf:maker">
      <p class="maker">
	<strong>
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'FOAF'"/>
	    <xsl:with-param name="name" select="'maker'"/>
	  </xsl:call-template>
	  <xsl:value-of select="$biblioentry.item.separator"/>
	  <xsl:call-template name="gentext.space"/>        
	</strong>
	<xsl:apply-templates select="foaf:maker"/>
      </p>
    </xsl:if>
    <xsl:apply-templates select="doap:description|doap:download-page"/> 
  </div>
</xsl:template>

<xsl:template match="doap:Project" mode="sponsor">
  <p>
    <xsl:apply-templates select="doap:name" mode="sponsor"/>
  </p>
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

<xsl:template match="doap:homepage|doap:download-mirror|doap:mailing-list|doap:category|foaf:homepage">
  <p class="{local-name(.)}">
    <strong>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'DOAP'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>        
    </strong>
    <a href="{@rdf:resource}" title="{@rdf:resource}">
      <xsl:value-of select="@rdf:resource"/>
    </a>
  </p>
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
  <xsl:choose>
    <xsl:when test="starts-with(@rdf:resource,'http://')
		    and $process.external-url = '0'">
      <xsl:message>
	<xsl:text>Failed to process: [</xsl:text>
	<xsl:value-of select="@rdf:resource"/>
	<xsl:text>] External file processing disabled</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="urfm" select="document(@rdf:resource, .)"/>
      <xsl:choose>
	<xsl:when test="not($urfm//urfm:Channel)">
	  <xsl:message>
	    <xsl:text>Unable to process URFM file: [</xsl:text>
	    <xsl:value-of select="@rdf:resource"/>
	    <xsl:text>]</xsl:text>
	  </xsl:message>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="$urfm//urfm:Channel">
	    <xsl:with-param name="pkgid" select="$pkgid"/>
	  </xsl:apply-templates>
	</xsl:otherwise>
      </xsl:choose>
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

</xsl:stylesheet>
  
