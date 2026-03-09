<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:template match="olink">
  <xsl:choose>
    <xsl:when test="@targetdoc != '' or @targetptr != ''">
      <xsl:apply-imports/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="olink-entity"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
