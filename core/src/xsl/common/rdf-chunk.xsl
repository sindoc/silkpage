<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
		xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
		xmlns:cvs='http://www.markupware.com/metadata/cvs#'
                xmlns:exsl="http://exslt.org/common"
                xmlns:xweb='xalan://com.nwalsh.xalan.Website'
                xmlns:sweb='http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Website'
                extension-element-prefixes=" exsl "
		exclude-result-prefixes=" html rdf dc cvs sweb xweb "
                version='1.0'>

<xsl:output indent="yes"
            method="xml"
            encoding="UTF-8"/>

<xsl:template match="toc|tocentry|notoc" mode="rdf.mode">
  <xsl:call-template name="rdf.tocentry"/>
  <xsl:apply-templates select="tocentry" mode="rdf.mode"/>
</xsl:template>

<xsl:template name="rdf.tocentry">
  <xsl:variable name="srcFile" select="@page"/>

  <xsl:if test="@page and @href">
    <xsl:message terminate="yes">
      <xsl:text>Fail: tocentry has both page and href attributes.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@filename">
        <xsl:value-of select="concat(@filename, $rdf.ext)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="'index.html'"/>
	<xsl:value-of select="$rdf.ext"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="targetFile">
   <xsl:apply-templates select="." mode="calculate-dir"/> 
    <xsl:value-of select="$filename-prefix"/>
    <xsl:value-of select="$filename"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('sweb:exists')">
      <xsl:if test="not(@href) and not(sweb:exists($srcFile))">
        <xsl:message terminate="yes">
          <xsl:value-of select="$srcFile"/>
          <xsl:text> does not exist.</xsl:text>
        </xsl:message>
      </xsl:if>
    </xsl:when>
    <xsl:when test="function-available('xweb:exists')">
      <xsl:if test="not(@href) and not(xweb:exists($srcFile))">
        <xsl:message terminate="yes">
          <xsl:value-of select="$srcFile"/>
          <xsl:text> does not exist.</xsl:text>
        </xsl:message>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="no">
        <xsl:value-of select="$srcFile"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:variable name="output-file">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$output-root"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$targetFile"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="needsUpdate">
    <xsl:choose>
      <xsl:when test="@href">0</xsl:when>
      <xsl:when test="function-available('sweb:needsUpdate')">
        <xsl:choose>
          <xsl:when test="$rebuild-all != 0
                          or sweb:needsUpdate($autolayout-file, $output-file)
                          or sweb:needsUpdate($srcFile, $output-file)">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="function-available('xweb:needsUpdate')">
        <xsl:choose>
          <xsl:when test="$rebuild-all != 0
                          or xweb:needsUpdate($autolayout-file, $output-file)
                          or xweb:needsUpdate($srcFile, $output-file)">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$needsUpdate != 0">
      <xsl:message>
        <xsl:text>Update: </xsl:text>
        <xsl:value-of select="$output-file"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$srcFile"/>
      </xsl:message>

      <xsl:variable name="webpage" select="document($srcFile,.)"/>
      <xsl:variable name="content">
        <xsl:apply-templates select="$webpage/webpage" mode="rdf.mode"/>
      </xsl:variable>

      <xsl:if test="$dry-run = 0">
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename" select="$output-file"/>
	  <xsl:with-param name="content" select="$content"/>
	  <xsl:with-param name="doctype-public" select="''"/>
	  <xsl:with-param name="doctype-system" select="''"/>
	  <xsl:with-param name="saxon.character.representation" select="'decimal'"/>
	  <xsl:with-param name="method" select="'xml'"/>
	  <xsl:with-param name="encoding" select="'UTF-8'"/>
	  <xsl:with-param name="indent" select="'yes'"/>
	  <xsl:with-param name="standalone" select="'yes'"/>
	  <xsl:with-param name="omit-xml-declaration" select="'no'"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Up-to-date: </xsl:text>
        <xsl:value-of select="$output-file"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
