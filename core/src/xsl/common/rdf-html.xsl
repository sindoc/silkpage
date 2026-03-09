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
	<xsl:value-of select="$webpage/dc:title"/>
      </title>
    </head>
    <style type="text/css">
      div.resource { 
      border-bottom: solid black 1px;
      margin-bottom: 0.4in;
      padding-bottom: 0.25in;
      }
      tr.odd { 
      background-color: #E4E4E4;
      }
    </style>
    <body>
      <h1>Metadata about “<xsl:value-of select="$webpage/dc:title"/>”</h1>
      <xsl:apply-templates select="$webpage" mode="summary"/>
      <hr/>
      <h1>RDF:</h1>
      <xsl:apply-templates select="*" mode="fred"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="*" mode="summary">
  <table border="0" cellspacing="0" cellpadding="2">
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
      <td><xsl:apply-templates select="dc:author|dc:creator" mode="value"/></td>
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
	    <xsl:otherwise>even</xsl:otherwise>
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
  <div class="resource">
    <h2>
      <xsl:if test="contains(@rdf:about,'#')">
	<a name="{substring-after(@rdf:about, '#')}"/>
      </xsl:if>
      <xsl:value-of select="@rdf:about"/>
    </h2>

    <table border="1" width="90%">
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
  </div>
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
                      = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'">rdf:</xsl:when>
      <xsl:when test="namespace-uri(.)
                      = 'http://www.w3.org/2000/01/rdf-schema#'">rdfs:</xsl:when>
      <xsl:when test="namespace-uri(.)
                      = 'http://purl.org/dc/elements/1.1/'">dc:</xsl:when>
      <xsl:when test="namespace-uri(.)
                      = 'http://purl.org/dc/terms/'">dcterms:</xsl:when>
      <xsl:when test="namespace-uri(.)
                      = 'http://www.w3.org/2003/01/geo/wgs84_pos#'">geo:</xsl:when>
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
