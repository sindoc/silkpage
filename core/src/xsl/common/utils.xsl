<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                exclude-result-prefixes=" html dc rdf saxon date "
                version='1.0'>

<xsl:output method="html"/>


<xsl:param name="nav.position.first">first</xsl:param>
<xsl:param name="nav.position.second">second</xsl:param>
<xsl:param name="nav.position.third">third</xsl:param>
<xsl:param name="nav.position.fourth">fourth</xsl:param>
<xsl:param name="nav.position.fifth">fifth</xsl:param>
<xsl:param name="nav.position.sixth">sixth</xsl:param>
<xsl:param name="nav.position.seventh">seventh</xsl:param>
<xsl:param name="nav.position.eighth">eighth</xsl:param>
<xsl:param name="nav.position.ninth">ninth</xsl:param>
<xsl:param name="nav.position.tenth">tenth</xsl:param>
<xsl:param name="nav.position.eleventh">eleventh</xsl:param>
<xsl:param name="nav.position.twelfth">twelfth</xsl:param>
<xsl:param name="nav.position.thirteenth">thirteenth</xsl:param>
<xsl:param name="nav.position.fourteenth">fourteenth</xsl:param>
<xsl:param name="nav.position.fifteenth">fifteenth</xsl:param>
<xsl:param name="nav.position.sixteenth">sixteenth</xsl:param>
<xsl:param name="nav.position.seventeenth">seventeenth</xsl:param>
<xsl:param name="nav.position.eighteenth">eighteenth</xsl:param>
<xsl:param name="nav.position.nineteenth">nineteenth</xsl:param>
<xsl:param name="nav.position.twentieth">twentieth</xsl:param>

<xsl:param name="mime.text.html">mime-html</xsl:param>
<xsl:param name="mime.application.xhtml">mime-xhtml</xsl:param>
<xsl:param name="mime.application.pdf">mime-pdf</xsl:param>
<xsl:param name="mime.application.xml">mime-xml</xsl:param>
<xsl:param name="mime.application.rdfxml">mime-rdfxml</xsl:param>
<xsl:param name="mime.application.sgml">mime-sgml</xsl:param>
<xsl:param name="mime.application.postscript">mime-postscript</xsl:param>
<xsl:param name="mime.application.javascript">mime-javascript</xsl:param>
<xsl:param name="mime.application.zip">mime-zip</xsl:param>
<xsl:param name="mime.application.tgz">mime-tgz</xsl:param>
<xsl:param name="mime.application.xtar">mime-tar</xsl:param>
<xsl:param name="mime.application.rtf">mime-rtf</xsl:param>
<xsl:param name="mime.application.xsl">mime-xsl</xsl:param>
<!--
<xsl:param name="mime.application.">mime-</xsl:param>
-->
<xsl:param name="mime.image.jpeg">mime-jpeg</xsl:param>
<xsl:param name="mime.image.gif">mime-gif</xsl:param>
<xsl:param name="mime.image.png">mime-png</xsl:param>

<!--
<xsl:param name="mime.image.">mime-</xsl:param>
-->
<xsl:param name="mime.unknown">mime-unknown</xsl:param>

<xsl:template name="item-position">
  <xsl:param name="prefix" select="''"/>
  <xsl:param name="input" select="''"/>

  <xsl:variable name="number">
    <xsl:choose>
      <xsl:when test="$input = '1'">
	<xsl:value-of select="$nav.position.first"/>
      </xsl:when>
      <xsl:when test="$input = '2'">
	<xsl:value-of select="$nav.position.second"/>
      </xsl:when>
      <xsl:when test="$input = '3'">
	<xsl:value-of select="$nav.position.third"/>
      </xsl:when>
      <xsl:when test="$input = '4'">
	<xsl:value-of select="$nav.position.fourth"/>
      </xsl:when>
      <xsl:when test="$input = '5'">
	<xsl:value-of select="$nav.position.fifth"/>
      </xsl:when>
      <xsl:when test="$input = '6'">
	<xsl:value-of select="$nav.position.sixth"/>
      </xsl:when>
      <xsl:when test="$input = '7'">
	<xsl:value-of select="$nav.position.seventh"/>
      </xsl:when>
      <xsl:when test="$input = '8'">
	<xsl:value-of select="$nav.position.eighth"/>
      </xsl:when>
      <xsl:when test="$input = '9'">
	<xsl:value-of select="$nav.position.ninth"/>
      </xsl:when>
      <xsl:when test="$input = '10'">
	<xsl:value-of select="$nav.position.tenth"/>
      </xsl:when>
      <xsl:when test="$input = '11'">
	<xsl:value-of select="$nav.position.eleventh"/>
      </xsl:when>
      <xsl:when test="$input = '12'">
	<xsl:value-of select="$nav.position.twelfth"/>
      </xsl:when>
      <xsl:when test="$input = '13'">
	<xsl:value-of select="$nav.position.thirteenth"/>
      </xsl:when>
      <xsl:when test="$input = '14'">
	<xsl:value-of select="$nav.position.fourteenth"/>
      </xsl:when>
      <xsl:when test="$input = '15'">
	<xsl:value-of select="$nav.position.fifteenth"/>
      </xsl:when>
      <xsl:when test="$input = '16'">
	<xsl:value-of select="$nav.position.sixteenth"/>
      </xsl:when>
      <xsl:when test="$input = '17'">
	<xsl:value-of select="$nav.position.seventeenth"/>
      </xsl:when>
      <xsl:when test="$input = '18'">
	<xsl:value-of select="$nav.position.eighteenth"/>
      </xsl:when>
      <xsl:when test="$input = '19'">
	<xsl:value-of select="$nav.position.nineteenth"/>
      </xsl:when>
      <xsl:when test="$input = '20'">
	<xsl:value-of select="$nav.position.twentieth"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$prefix"/>
  <xsl:value-of select="$number"/>

</xsl:template>

<xsl:template name="utils-mimetypes">
  <xsl:param name="mime" select="''"/>

  <xsl:choose>

    <xsl:when test="$mime = 'text/html'">
      <xsl:value-of select="$mime.text.html"/>
    </xsl:when>

    <xsl:when test="$mime = 'application/xhtml+xml'">
      <xsl:value-of select="$mime.application.xhtml"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/pdf'">
      <xsl:value-of select="$mime.application.pdf"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/xml'">
      <xsl:value-of select="$mime.application.xml"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/rdf+xml'">
      <xsl:value-of select="$mime.application.rdfxml"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/sgml'">
      <xsl:value-of select="$mime.application.sgml"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/postscript'">
      <xsl:value-of select="$mime.application.postscript"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/javascript'">
      <xsl:value-of select="$mime.application.javascript"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/zip'
		    or $mime = 'application/x-zip-compressed'">
      <xsl:value-of select="$mime.application.zip"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/tgz'">
      <xsl:value-of select="$mime.application.tgz"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/rtf'">
      <xsl:value-of select="$mime.application.rtf"/>
    </xsl:when>
    <xsl:when test="$mime = 'application/x-tar'">
      <xsl:value-of select="$mime.application.xtar"/>
    </xsl:when>

    <xsl:when test="$mime = 'application/xsl+xml'">
      <xsl:value-of select="$mime.application.rtf"/>
    </xsl:when>
<!--
    <xsl:when test="$mime = 'application/'">
      <xsl:value-of select="$mime.application."/>
    </xsl:when>
-->
    <xsl:when test="$mime = 'image/jpeg'">
      <xsl:value-of select="$mime.image.jpeg"/>
    </xsl:when>
    <xsl:when test="$mime = 'image/gif'">
      <xsl:value-of select="$mime.image.gif"/>
    </xsl:when>
    <xsl:when test="$mime = 'image/png'">
      <xsl:value-of select="$mime.image.png"/>
    </xsl:when>

    <!--
	<xsl:when test="$mime = 'image/png'">
	<xsl:value-of select="$mime.image.png"/>
	</xsl:when>
    -->
    <xsl:otherwise>
      <xsl:value-of select="$mime.unknown"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


</xsl:stylesheet>
