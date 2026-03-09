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
    <cvs:date>$Date: 2009-03-23 23:15:21 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 - 2005 MarkupWare.</dc:rights>
    <dc:description>
     This stylesheet processes URFM files and generates an XHTML version of it.
    </dc:description>
  </rdf:Description>
  
  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

<xsl:template match="urfm:Channel" mode="doap">
  <xsl:param name="pkgid" select="''"/>
  <xsl:variable name="release" select="//urfm:releases/urfm:Release/urfm:package[@rdf:resource = $pkgid]/ancestor-or-self::urfm:Release"/>
  <xsl:variable name="releases" select="$release/ancestor-or-self::urfm:releases"/>
  <xsl:choose>
    <xsl:when test="$pkgid != ''">
      <xsl:apply-templates select="$releases">
<xsl:with-param name="release" select="$release"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>
	  Failed to process URFM. No package identifer found.
	</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="urfm:Channel">
  <xsl:param name="doap" select="'true'"/>
  <xsl:if test="$doap = 'false'">
    <xsl:apply-templates select="urfm:description"/>
  </xsl:if>
  <xsl:apply-templates select="urfm:packages/urfm:Package"/>
</xsl:template>

<xsl:template match="urfm:releases"> 
  <xsl:param name="release" select="''"/>
  <xsl:param name="file" select="''"/>
  <div class="{local-name(.)}">
    <h2>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'URFM'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
    </h2>
      <xsl:apply-templates select="$release"/>
  </div>
</xsl:template>

<xsl:template match="urfm:Release"> 
  <xsl:variable name="release" select="@rdf:about"/>
  <xsl:variable name="file" select="//urfm:files/urfm:File/urfm:release[@rdf:resource = $release]/ancestor-or-self::urfm:File"/>
  <xsl:variable name="files" select="$file/ancestor-or-self::urfm:files"/>
  <div class="{local-name(.)}">
	  <xsl:apply-templates select="urfm:revision" mode="object.id"/>
    <table>
      <xsl:attribute name="summary">
	<xsl:text>Available files for this release</xsl:text>
      </xsl:attribute>
      <caption>
	<xsl:apply-templates select="urfm:revision|urfm:status|urfm:name"/>
	<xsl:if test="not(urfm:revision)">
	  <xsl:apply-templates select="urfm:created[1]"/>
	</xsl:if>	
      </caption>
      <xsl:apply-templates select="$files">
	<xsl:with-param name="file" select="$file"/>
      </xsl:apply-templates>
    </table>
  </div>
</xsl:template>

<xsl:template match="urfm:revision" mode="object.id">
  <xsl:attribute name="id">
    <xsl:value-of select="concat('v', text())"/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="urfm:files">
  <xsl:param name="file" select="''"/>
  <thead>
    <tr>
      <xsl:apply-templates select="$file[1]/urfm:size|$file[1]/urfm:basename|$file[1]/urfm:language|$file[1]/rdf:type" mode="urfm.file.head.mode"/>
    </tr>
  </thead>
  <tbody>
    <xsl:apply-templates select="$file"/>
  </tbody>
</xsl:template>

<xsl:template match="urfm:File">
  <tr class="{local-name(.)}">
    <xsl:apply-templates select="urfm:basename|urfm:language|urfm:size|rdf:type"/>
  </tr>
</xsl:template>

<xsl:template match="urfm:name">
  <span class="{local-name(.)}">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="urfm:status">
  <p class="{local-name(.)}">
    <strong>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'URFM'"/>
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

<xsl:template match="rdf:type" mode="urfm.file.head.mode">
  <th class="{local-name(.)}">
    <span>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'URFM'"/>
	<xsl:with-param name="name" select="'Dist-type'"/>
      </xsl:call-template>
    </span>
  </th>  
</xsl:template>

<xsl:template match="urfm:size|urfm:basename|urfm:language" mode="urfm.file.head.mode">
  <th class="{local-name(.)}">
    <span>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'URFM'"/>
	<xsl:with-param name="name" select="local-name(.)"/>
      </xsl:call-template>
    </span>
  </th>
</xsl:template>

<xsl:template match="urfm:basename">
  <xsl:variable name="extension" select="../urfm:extension[1]"/>

  <xsl:variable name="mime">
    <xsl:apply-templates select="../urfm:format[1]"/>
  </xsl:variable>

  <xsl:variable name="mime-class">
    <xsl:call-template name="utils-mimetypes">
      <xsl:with-param name="mime" select="$mime"/>
    </xsl:call-template>
  </xsl:variable>
  <td class="{local-name(.)}">
    <p class="{$mime-class}">
      <a class="{$mime-class}" href="{../urfm:link[1]}">
        <xsl:attribute name="title">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'URFM'"/>
	    <xsl:with-param name="name" select="'Download'"/>
	  </xsl:call-template>
	  <xsl:call-template name="gentext.space"/>        
	  <xsl:apply-templates/>
	  <xsl:value-of select="$extension"/>
        </xsl:attribute>
        <span class="{local-name(.)}">
	  <xsl:apply-templates/>
        </span>
        <span class="{local-name($extension)}">
	  <xsl:value-of select="$extension"/>
        </span>
      </a>
    </p>
  </td>
</xsl:template>

<xsl:template match="urfm:language">
  <xsl:variable name="lang">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'Languages'"/>
      <xsl:with-param name="name" select="node()"/>
    </xsl:call-template>
  </xsl:variable>
  <td class="{local-name(.)}">
    <span>
      <xsl:choose>
	<xsl:when test="$lang != ''">
	  <xsl:value-of select="$lang"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </span>
  </td>
</xsl:template>

<xsl:template match="urfm:revision">
  <span class="{local-name(.)}">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'URFM'"/>
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:choose>
      <xsl:when test="../urfm:notes/@rdf:resource">
	<a href="{../urfm:notes[1]/@rdf:resource}" title="{.}">
	  <xsl:apply-templates/>
	</a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>	  
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="../urfm:created[1]"/>
  </span>
</xsl:template>

<xsl:template match="urfm:format">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="urfm:description">
  <p class="{local-name(.)}">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="urfm:created">
  <xsl:variable name="format">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'datetime'"/>
      <xsl:with-param name="name" select="'feed-format'"/>
    </xsl:call-template>
  </xsl:variable>
  <span class="{local-name(.)}">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'URFM'"/>
      <xsl:with-param name="name" select="'ReleaseDate'"/>
    </xsl:call-template>
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
  </span>
</xsl:template>

<xsl:template match="urfm:size">
  <xsl:variable name="unit" select="urfm:unit[1]/@rdf:resource"/>
  <xsl:variable name="value" select="rdf:value[1]"/>
  <xsl:choose>
    <xsl:when test="$unit and $value">
      <td class="{local-name(.)}">
	<xsl:choose>
	  <xsl:when test="$unit='http://purl.org/urfm/Kilobyte'
			  or $unit='http://purl.org/urfm/Megabyte'
			  or $unit='http://purl.org/urfm/Gigabyte'">
	    <span>
	      <xsl:value-of select="rdf:value"/>
	      <xsl:call-template name="gentext.space"/>
	    </span>
	    <span class="size-unit">
	      <xsl:call-template name="gentext.template">
		<xsl:with-param name="context" select="'URFM'"/>
		<xsl:with-param name="name" select="$unit"/>
	      </xsl:call-template>
	    </span>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      No unit of length for size class found
	    </xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
      </td>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	Unable to find either unit or value properties of size class
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:type">
  <td class="{local-name(.)}">
    <span>
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'URFM'"/>
	<xsl:with-param name="name" select="@rdf:resource"/>
      </xsl:call-template>
    </span>
  </td>
</xsl:template>

<xsl:template name="urfm">
  <xsl:param name="href" select="."/>
  <xsl:choose>
    <xsl:when test="$href//urfm:Channel">
      <div class="{$urfm.label}">
	<xsl:apply-templates select="$href//urfm:Channel[1]">
	  <xsl:with-param name="doap" select="'false'"/>
	</xsl:apply-templates>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Unable to process URFM file!</xsl:text>
      </xsl:message>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="urfm:Package">
  <xsl:variable name="doap" select="document(urfm:description/doap:Project/@rdf:about, /)"/>
  <xsl:variable name="package" select="@rdf:about"/>
  <xsl:apply-templates select="$doap//doap:Project/doap:name[1]"/>
  <xsl:for-each select="../../urfm:releases/urfm:Release">
    <xsl:if test="urfm:package/@rdf:resource = $package">
      <xsl:apply-templates select="."/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
  
