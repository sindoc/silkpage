<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
		xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
		xmlns:cvs='http://www.markupware.com/metadata/cvs#'
		xmlns:exsl="http://exslt.org/common"
                xmlns:xweb="xalan://com.nwalsh.xalan.Website"
		xmlns:sweb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Website"
                extension-element-prefixes=" exsl "
		exclude-result-prefixes=" html rdf dc cvs sweb xweb "
                version='1.0'>


<xsl:output indent="yes"
            method="xml"
            encoding="UTF-8"/>

<xsl:template match="toc|tocentry|notoc" mode="trl">
  <xsl:param name="lang"/>
  <xsl:call-template name="trl.tocentry">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:apply-templates select="tocentry" mode="trl">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template name="trl.tocentry">
  <xsl:param name="lang"/>
  <xsl:variable name="trl-dir">
    <xsl:choose>
      <xsl:when test="//config[@param=$trl.label]/@path">
	<xsl:value-of select="//config[@param=$trl.label]/@path"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>../</xsl:text>
	<xsl:value-of select="config[@param=$trl.label]/@value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="srcFile" select="concat($trl-dir,'/',@page)"/>
<!--
  <xsl:variable name="srcFile" select="concat(@page,'.fr')"/>
-->
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@filename">
	<xsl:value-of select="concat(@filename,'.',$lang)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('index.html',$lang)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="dir">
    <xsl:apply-templates select="." mode="calculate-dir"/>
  </xsl:variable>

  <xsl:variable name="targetFile">
    <xsl:value-of select="$dir"/>
    <xsl:value-of select="$filename-prefix"/>
    <xsl:value-of select="$filename"/>
  </xsl:variable>

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
	<xsl:apply-templates select="$webpage/webpage" mode="trl"/>
      </xsl:variable>

      <xsl:if test="$dry-run = 0">
	<xsl:call-template name="write.chunk">
	  <xsl:with-param name="filename" select="$output-file"/>
          <xsl:with-param name="content" select="$content"/>
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

<xsl:template match="*" mode="calculate-dir">
  <xsl:choose>
    <xsl:when test="@dir">
      <!-- if there's a directory, use it -->
      <xsl:choose>
        <xsl:when test="starts-with(@dir, '/')">
          <!-- if the directory on this begins with a "/", we're done... -->
          <xsl:value-of select="substring-after(@dir, '/')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@dir"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="parent::*">
      <!-- if there's a parent, try it -->
      <xsl:apply-templates select="parent::*" mode="calculate-dir"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- nop -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
