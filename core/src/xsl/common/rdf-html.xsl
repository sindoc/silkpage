<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dc='http://purl.org/dc/elements/1.1/'
		xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:t="http://norman.walsh.name/knows/taxonomy#"
                version="1.0">

  <rdf:Description rdf:about=''
		   xmlns:cvs="http://nwalsh.com/rdf/cvs#">
    <rdf:type rdf:resource="http://norman.walsh.name/knows/taxonomy#XSL"/>
    <dc:type rdf:resource='http://purl.org/dc/dcmitype/Text'/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>RDF Stylesheet</dc:title>
    <dc:date>2003-05-12</dc:date>
    <cvs:date>2003-05-13T11:33:33Z</cvs:date>
    <dc:creator rdf:resource='http://norman.walsh.name/knows/who#norman-walsh'/>
    <dc:rights>Copyright © 2003 Norman Walsh. All rights reserved.</dc:rights>
    <dc:description>Display RDF as HTML.</dc:description>
  </rdf:Description>
  
  <xsl:output method="html"/>

<xsl:variable name="webpageType"
	      select="'http://www.markupware.com/metadata/taxonomy#Webpage'"/>

<xsl:template match="rdf:RDF">

  <xsl:variable name="webpage"
		select="//rdf:Description[rdf:type[@rdf:resource=$webpageType]]"/>

  <xsl:variable name="root" select="($webpage|//rdf:Description[@rdf:about=''])[1]"/>
  
  <html>
    <head>
      <title>
	<xsl:text>RDF - </xsl:text>
	<xsl:value-of select="$webpage/dc:title"/>
      </title>
      <style type="text/css">
	body { padding: 0; font-family: Verdana, sans-serif; font-size: small;
	text-align: left; color: #333; background: #ccc; width: 750px; 
	margin: 0 auto; }
	
	a:link { color: #3080CB; text-decoration: none; 
	border-bottom: 1px dotted #68C3EE; }
	
	a:visited { color: #5FB5E1; text-decoration: none; 
	border-bottom: 1px dotted #86D9F1; }
	
	a:hover { color: #fff; background-color: #3080CB; 
	text-decoration: none; border: none; }
	
	a:active { background-color: #6CA300; }
	
	#content { position: relative; padding: 50px; width: 80%;
	font-size: 95%; line-height: 1.5em; border: 4px solid #53584A; 
	background: #fff; margin: 5em 0 5em 0; }
	
	table.summary caption, hr { display: none; }
	
	table { border-top: 1px solid #999; border-left: 1px solid #999;
	width: 100%; border-collapse: collapse; margin: .5em .2em .8em .2em; }

	caption { font-size: 130%; color: #000; padding-bottom: 6px; }

	th, td { font-size:100%; padding: 1px 9px; 
	border-right: 1px solid #999; border-bottom: 1px solid #999; }
	
	tr.odd { background-color: #E4E4E4; }
	
	th { background: #ccc; }
      </style>
    </head>
    <body>
      <div id="content">
      <h1>Metadata about “<xsl:value-of select="$webpage/dc:title"/>”</h1>
      <xsl:apply-templates select="$webpage" mode="summary"/>
      <h1><acronym title="Resource Description Framework">RDF</acronym>:</h1>
      <xsl:apply-templates select="*" mode="fred"/>
      </div>
    </body>
  </html>
</xsl:template>

<xsl:template match="*" mode="summary">
  <table class="summary">
    <caption>Summary</caption>
    <tr class="odd">
      <th align="left" valign="top">URI:</th>
      <td>
	<a href="{@rdf:about}"><xsl:value-of select="@rdf:about"/></a>
      </td>
    </tr>
    <tr class="even">
      <th align="left" valign="top">Title:</th>
      <td><xsl:apply-templates select="dc:title" mode="value"/></td>
    </tr>
    <tr class="odd">
      <th align="left" valign="top">Author:</th>
      <td><xsl:apply-templates select="dc:creator" mode="value"/></td>
    </tr>
    <tr class="even">
      <th align="left" valign="top">Date:</th>
      <td>
	<xsl:choose>
	  <xsl:when test="dcterms:created"> 
	    <xsl:apply-templates select="dcterms:created" mode="value"/>
	    <xsl:if test="dcterms:modified">
	      <xsl:text> (last updated: </xsl:text>
	      <xsl:apply-templates select="dcterms:modified" mode="value"/>
	      <xsl:text>)</xsl:text>
	    </xsl:if>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="dc:date" mode="value"/>
	  </xsl:otherwise>
	</xsl:choose>
      </td>
    </tr>
    <tr class="odd">
      <th align="left" valign="top">Copyright:</th>
      <td><xsl:apply-templates select="dc:rights" mode="value"/></td>
    </tr>

    <xsl:if test="dc:coverage">
      <tr class="even">
	<th align="left" valign="top">Location:</th>
	<td><xsl:apply-templates select="dc:coverage" mode="value"/></td>
      </tr>
    </xsl:if>

    <tr>
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="dc:coverage">odd</xsl:when>
	  <xsl:otherwise>even</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <th align="left" valign="top">Abstract:</th>
      <td><xsl:apply-templates select="dc:description" mode="value"/></td>
    </tr>

    <xsl:if test="t:indexterm|t:person|t:application">
      <tr>
	<xsl:attribute name="class">
	  <xsl:choose>
	    <xsl:when test="dc:coverage">even</xsl:when>
	    <xsl:otherwise>odd</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<th align="left" valign="top">Mentions:</th>
	<td>
	  <xsl:for-each select="t:indexterm|t:person|t:application">
	    <xsl:sort select="@rdf:resource"/>
	      
	    <xsl:variable name="rsrc" select="@rdf:resource"/>
	    <xsl:variable name="term"
			  select="//rdf:Description[@rdf:about=$rsrc]"/>

	    <xsl:if test="position() &gt; 1"><br/></xsl:if>

	    <xsl:choose>
	      <xsl:when test="self::t:indexterm">
		<xsl:value-of select="$term/t:primary"/>
		<xsl:if test="$term/t:secondary">, </xsl:if>
		<xsl:value-of select="$term/t:secondary"/>
		<xsl:if test="$term/t:tertiary">, </xsl:if>
		<xsl:value-of select="$term/t:tertiary"/>
	      </xsl:when>
	      <xsl:when test="self::t:person">
		<xsl:value-of select="$term/t:surname"/>
		<xsl:if test="$term/t:firstname">, </xsl:if>
		<xsl:value-of select="$term/t:firstname"/>
	      </xsl:when>
	      <xsl:when test="self::t:application">
		<xsl:value-of select="$term/t:application"/>
	      </xsl:when>
	    </xsl:choose>
	  </xsl:for-each>
	</td>
      </tr>
    </xsl:if>

    <xsl:if test="rdfs:seeAlso">
      <tr>
	<xsl:attribute name="class">
	  <xsl:choose>
	    <xsl:when test="dc:coverage
			    and t:indexterm|t:person|t:application">even</xsl:when>
	    <xsl:when test="dc:coverage">odd</xsl:when>
	    <xsl:otherwise>odd</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<th align="left" valign="top">See also:</th>
	<td>
	  <xsl:for-each select="rdfs:seeAlso">
	    <xsl:sort select="@rdf:resource"/>
	    <xsl:if test="position() &gt; 1"><br/></xsl:if>
	    <xsl:apply-templates select="." mode="value"/>
	  </xsl:for-each>
	</td>
      </tr>
    </xsl:if>
  </table>
</xsl:template>

<xsl:template match="*" mode="fred">
  <table class="resource">
    <caption>
      <xsl:if test="contains(@rdf:about,'#')">
	<a name="{substring-after(@rdf:about, '#')}"/>
      </xsl:if>
      <xsl:value-of select="@rdf:about"/>
    </caption>
      <tr>
        <th colspan="2" align="left">
          <a href="http://www.w3.org/1999/02/22-rdf-syntax-ns#about">

            <xsl:text>rdf:about</xsl:text>
          </a>
          <xsl:text> = '</xsl:text>
          <xsl:value-of select="@rdf:about"/>
          <xsl:text>'</xsl:text>
        </th>
      </tr>
    <xsl:if test="local-name(.) != 'Description'
                    or namespace-uri(.) != 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'">
        <tr>
	  <td width="25%">
            <a href="http://www.w3.org/1999/02/22-rdf-syntax-ns#type">
	      <xsl:text>rdf:type</xsl:text>
            </a>
          </td>
          <td>
	    <xsl:apply-templates select="." mode="uriref"/>
          </td>
        </tr>
      </xsl:if>

      <xsl:apply-templates mode="properties">
        <xsl:sort select="namespace-uri(.)" data-type="text" order="ascending"/>
        <xsl:sort select="local-name(.)" data-type="text" order="ascending"/>
      </xsl:apply-templates>
  </table>
</xsl:template>

<xsl:template match="*" mode="properties">
  <tr>
    <td width="25%">
      <xsl:apply-templates select="." mode="uriref"/>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="@rdf:resource">
          <a href="{@rdf:resource}">
            <xsl:value-of select="@rdf:resource"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </tr>
</xsl:template>

<xsl:template match="*" mode="uriref">
  <a href="{namespace-uri(.)}{local-name(.)}">
    <xsl:choose>
      <xsl:when test="namespace-uri(.)
		      = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'">
	<acroym title="RDF">rdf</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
		      = 'http://www.w3.org/2000/01/rdf-schema#'">
	<acroym title="RDF Schema">rdfs</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
		      = 'http://purl.org/dc/elements/1.1/'">
	<acroym title="Dublin Core">dc</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
                      = 'http://purl.org/dc/terms/'">
	<acroym title="Dublin Core Terms">dcterms</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
                      = 'http://www.w3.org/2003/01/geo/wgs84_pos#'">geo:</xsl:when>
      <xsl:when test="namespace-uri(.)
		      = 'http://purl.org/urfm/'">
	<acroym title="Universal Resource File Manifest">urfm</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
		      = 'http://xmlns.com/foaf/0.1/'">
	<acroym title="Friend Of A Friend">foaf</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
		      = 'http://usefulinc.com/ns/doap#'">
	<acroym title="Description Of A Project">doap</acroym>:
      </xsl:when>
      <xsl:when test="namespace-uri(.)
		      = 'http://web.resource.org/cc/'">
	<acroym title="Creative Commons">cc</acroym>:
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="namespace-uri(.)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="local-name(.)"/>
  </a>
</xsl:template>

<xsl:template match="*" mode="value">
  <xsl:choose>
    <xsl:when test="@rdf:resource">
      <a href="{@rdf:resource}">
	<xsl:value-of select="@rdf:resource"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
