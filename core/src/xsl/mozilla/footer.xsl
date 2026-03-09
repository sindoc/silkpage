<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exslt">

<xsl:output indent="yes"
            method="xml"/>

<!-- ==================================================================== -->


<xsl:template name="webpage.footer">

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="page" select="."/>
  <xsl:variable name="pageid" select="@id"/>

  <xsl:variable name="tocentry" select="$autolayout//*[@id=$page/@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc[1]
                                   | $autolayout//toc[1])[last()]"/>

  <xsl:variable 
	name="footitems"
	select="$page/config[@param='footlink']
		|$page/config[@param='footer']
		|$autolayout/autolayout/config[@param='footlink']
		|$autolayout/autolayout/config[@param='footer']"/>

  <xsl:variable name="dir">
    <xsl:choose>

      <xsl:when test="starts-with($tocentry/@dir, '/')">
        <xsl:value-of select="substring($tocentry/@dir, 2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$tocentry/@dir"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="feedback">
    <xsl:choose>
      <xsl:when test="$page/config[@param='feedback.href']">
        <xsl:value-of select="($page/config[@param='feedback.href'])[1]/@value"/>
      </xsl:when>
      <xsl:when test="$autolayout/autolayout/config[@param='feedback.href']">
        <xsl:value-of select="($autolayout/autolayout/config[@param='feedback.href'])[1]/@value"/>
      </xsl:when>
      <xsl:otherwise>

        <xsl:value-of select="$feedback.href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div>
    <xsl:attribute name="id">
      <xsl:value-of select="$footer.label"/>
    </xsl:attribute>

    <xsl:if test="$footer.hr != 0">
      <hr/>
    </xsl:if>
    <xsl:if test="$copyright.label != ''">
      <xsl:choose>
        <xsl:when test="./head/copyright">
          <xsl:apply-templates select="head/copyright" mode="footer.mode">
	    <xsl:with-param name="page" select="$page"/>
	  </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$autolayout/autolayout/copyright" mode="footer.mode">
	    <xsl:with-param name="page" select="$page"/>
	  </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="$updated.label != ''">
      <p>
        <xsl:attribute name="id">
          <xsl:value-of select="$updated.label"/>
        </xsl:attribute>
        <xsl:call-template name="rcsdate.format">
          <xsl:with-param name="rcsdate" 
			  select="$page/config[@param='rcsdate']/@value"/>
        </xsl:call-template>
      </p>
    </xsl:if>
    <xsl:if test="$compliance.label != ''">
      <ul>
        <xsl:attribute name="id">
          <xsl:value-of select="$compliance.label"/>
        </xsl:attribute>
	<li>

           <a href="http://validator.w3.org/check/referer">XHTML</a>
        </li>
        <li>
           <a href="http://jigsaw.w3.org/css-validator/check/referer">CSS</a>
	</li>
      </ul>
    </xsl:if>

    <xsl:if test="$footitems.label != ''">
    <xsl:attribute name="id">
      <xsl:value-of select="$footitems.label"/>
    </xsl:attribute>
      <ul>
          <xsl:choose>
            <xsl:when test="not($toc)">
              <xsl:message>
                <xsl:text>Cannot determine TOC for </xsl:text>
                <xsl:value-of select="$page/@id"/>
              </xsl:message>
            </xsl:when>
            <xsl:when test="$toc/@id = $page/@id">
              <!-- nop; this is the home page -->
            </xsl:when>
            <xsl:otherwise>
	      <li>
        	<xsl:attribute name="class">
	          <xsl:value-of select="$footitem.label"/>
	        </xsl:attribute>
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="homeuri"/>
                  </xsl:attribute>
                  <xsl:call-template name="gentext.nav.home"/>
                </a>
              </li>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="$footitems" mode="footer.item.mode">
	    <xsl:with-param name="page" select="$page"/>
	  </xsl:apply-templates>
           <xsl:choose>
              <xsl:when test="$feedback != ''">
	        <li>
        	  <xsl:attribute name="class">
	            <xsl:value-of select="$footitem.label"/>
	          </xsl:attribute>
                  <a>
                    <xsl:choose>
                      <xsl:when test="$feedback.with.ids != 0">
                        <xsl:attribute name="href">
                          <xsl:value-of select="$feedback"/>
                          <xsl:value-of select="$page/@id"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="href">
                          <xsl:value-of select="$feedback"/>
                        </xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="$feedback.link.text"/>
                  </a>
                </li>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
	  </ul>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template name="rcsdate.format">
  <xsl:param name="rcsdate" select="./config[@param='rcsdate']/@value"/>
  <xsl:variable name="timeString" select="$rcsdate"/>
  <xsl:value-of select="substring($timeString, 7, 5)"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="substring($timeString, 13, 2)"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="substring($timeString, 16, 2)"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="substring($timeString, 18, 6)"/>
</xsl:template>

<xsl:template match="copyright" mode="footer.mode">
  <xsl:param name="page" select="''"/>

  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="./holder/@role">
	<xsl:value-of select="./holder/@role"/>
      </xsl:when>
      <xsl:otherwise>copyright</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="altval">
    <xsl:call-template name="gentext.element.name"/>
  </xsl:variable>
  <p>
    <xsl:attribute name="id">
      <xsl:value-of select="$copyright.label"/>
     </xsl:attribute>

     <xsl:call-template name="links">
       <xsl:with-param name="page" select="$page"/>
       <xsl:with-param name="altval" select="$altval"/>
       <xsl:with-param name="id" select="$id"/>
     </xsl:call-template>

    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="year" mode="footer.mode"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="holder" mode="footer.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </p>
</xsl:template>

<xsl:template match="config" mode="footer.item.mode">
  <xsl:param name="page" select="''"/>
  <li>
    <xsl:attribute name="class">
      <xsl:value-of select="$footitem.label"/>
     </xsl:attribute>
    <xsl:choose>
      <xsl:when test="@param='footlink'">
	<xsl:call-template name="items">
	  <xsl:with-param name="page" select="$page"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@value}">
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

</xsl:stylesheet>
