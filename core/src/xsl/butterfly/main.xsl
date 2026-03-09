<?xml version='1.0'?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/website-common.xsl"/>
<xsl:include href="toc.xsl"/>

<xsl:output indent="yes"
            method="xml"
            encoding="UTF-8"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

<xsl:param name="autolayout" select="document($autolayout-file, /*)"/>

<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="webpage">

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc
                                   |$autolayout/autolayout/toc[1])[last()]"/>

  <html>

    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>

    <body>

      <xsl:call-template name="allpages.banner"/>

      <div class="{name(.)}">
        <a name="{$id}"/>

        <table class="layout">
          <xsl:if test="$nav.table.summary!=''">
            <xsl:attribute name="summary">
              <xsl:value-of select="$nav.table.summary"/>
            </xsl:attribute>
          </xsl:if>
          <tr>
            <td class="menu" valign="top">
	     <div class="navtoc">
              <xsl:choose>
                <xsl:when test="$toc">
                  <xsl:apply-templates select="$toc">
                    <xsl:with-param name="pageid" select="@id"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
	     </div>
            </td>
            <xsl:call-template name="hspacer"/>
            <td class="main" valign="top">
              <xsl:choose>
<!--
		<xsl:when test="$autolayout/autolayout/toc[$id=@id] and $pages.search-box != ''">
                  <xsl:call-template name="user.search-box"/>
                </xsl:when>
-->
		<xsl:when test="$autolayout/autolayout/toc[$id=@id]">
		  <br/>
                </xsl:when>
	        <xsl:otherwise>
		  <xsl:apply-templates select="./head/title" mode="title.mode"/>
       	        </xsl:otherwise>
       	      </xsl:choose>
              <xsl:if test="$pages.navhead != ''">
                <xsl:call-template name="pages.navhead"/>
	      </xsl:if>
              <xsl:apply-templates select="child::*[name(.) != 'webpage']"/>
              <xsl:call-template name="process.footnotes"/>
              <br/>
            </td>
          </tr>
        </table>
      </div>
      <xsl:call-template name="webpage.footer"/>
    </body>

  </html>
</xsl:template>

<xsl:template name="allpages.banner">

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="banner-left"
                select="$autolayout/autolayout/config[@param='banner-left'][1]"/>
  <xsl:variable name="banner-right"
                select="$autolayout/autolayout/config[@param='banner-right'][1]"/>

  <div class="titlebar">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$relpath"/>
        <xsl:value-of select="$autolayout/autolayout/toc[1]/@filename"/>
      </xsl:attribute>
      <xsl:if test="$banner-left">
        <img class="titlebarleft">
          <xsl:attribute name="src">
            <xsl:value-of select="$relpath"/>
            <xsl:value-of select="$banner-left/@value"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="$banner-left/@altval"/>
          </xsl:attribute>
        </img>
       </xsl:if>
    </a>
    <xsl:choose>
    <xsl:when test="not($banner-right) and $pages.search-box != ''">
      <xsl:call-template name="user.search-box"/>
    </xsl:when>
    <xsl:otherwise>
      <img class="titlebarright">
        <xsl:attribute name="src">
          <xsl:value-of select="$relpath"/>
          <xsl:value-of select="$banner-right/@value"/>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:value-of select="$banner-right/@altval"/>
        </xsl:attribute>
      </img>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="title" mode="head.mode">
  <xsl:variable name="title"
                select="$autolayout/autolayout/config[@param='title'][1]"/>
  <title>
    <xsl:if test="$title">
      <xsl:value-of select="$title/@value"/>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <xsl:value-of select="."/>
  </title>
</xsl:template>

<xsl:template name="hspacer">
  <!-- nop -->
</xsl:template>

<xsl:template name="webpage.footer">

  <xsl:param name="relpath" select="''"/>
  <xsl:variable name="page" select="."/>

  <xsl:variable name="tocentry" select="$autolayout//*[@id=$page/@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc[1]
                                   | $autolayout//toc[1])[last()]"/>

  <xsl:variable name="footers" select="$page/config[@param='footer']
                                       |$page/config[@param='footlink']
                                       |$autolayout/autolayout/config[@param='footer']
                                       |$autolayout/autolayout/config[@param='footlink']"/>

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

  <div class="navfoot">
    <xsl:if test="$footer.hr != 0">
       <div>
         <xsl:attribute name="class">
            <xsl:text>hrule</xsl:text>
         </xsl:attribute>
         <hr />
       </div>
    </xsl:if>

    <table width="100%" border="0" summary="Footer navigation">
      <tr>
	<td width="50%">
          <xsl:choose>
            <xsl:when test="./head/copyright">
              <xsl:apply-templates select="head/copyright" mode="footer.mode"/>
            </xsl:when>
            <xsl:otherwise>
	      <xsl:call-template name="copyright-link"/>
            </xsl:otherwise>
          </xsl:choose>
          <span class="footdate">
            <xsl:call-template name="rcsdate.format">
              <xsl:with-param name="rcsdate"
                              select="$page/config[@param='rcsdate']/@value"/>
            </xsl:call-template>
          </span>
          <span class="footw3c">
             <a href="http://validator.w3.org/check/referer">XHTML</a>
          </span>
          <span class="footw3c">
             <a href="http://jigsaw.w3.org/css-validator/check/referer">CSS</a>
          </span>
	</td>
        <td width="50%" align="right">
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
              <span>
      <xsl:attribute name="class">
	<xsl:value-of select="$pages.footer.links.spanclass"/>
      </xsl:attribute>
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="homeuri"/>
                  </xsl:attribute>
                  <xsl:call-template name="gentext.nav.home"/>
                </a>
                <xsl:if test="$footers">
                  <!-- <xsl:text> | </xsl:text>-->
                </xsl:if>
              </span>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:apply-templates select="$footers" mode="footer.link.mode"/>

           <xsl:choose>
              <xsl:when test="$feedback != ''">
                <span class="footfeed">
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
                </span>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
        </td>

      </tr>
      <xsl:if test="$sequential.links != 0">
        <tr>
          <xsl:variable name="prev">
            <xsl:call-template name="prev.page"/>
          </xsl:variable>
          <xsl:variable name="next">
            <xsl:call-template name="next.page"/>
          </xsl:variable>
          <xsl:variable name="ptoc"
                        select="$autolayout/autolayout//*[$prev=@id]"/>
          <xsl:variable name="ntoc"
                        select="$autolayout/autolayout//*[$next=@id]"/>

          <td align="left" valign="top">
            <xsl:choose>
              <xsl:when test="$prev != ''">
                <xsl:call-template name="link.to.page">
                  <xsl:with-param name="frompage" select="$tocentry"/>
                  <xsl:with-param name="page" select="$ptoc"/>
                  <xsl:with-param name="linktext" select="'Prev'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </td>
          <td>&#160;</td>
          <td align="right" valign="top">
            <xsl:choose>
              <xsl:when test="$next != ''">
                <xsl:call-template name="link.to.page">
                  <xsl:with-param name="frompage" select="$tocentry"/>
                  <xsl:with-param name="page" select="$ntoc"/>
                  <xsl:with-param name="linktext" select="'Next'"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>
    </table>
  </div>
</xsl:template>

<xsl:template name="rcsdate.format">
  <xsl:param name="rcsdate" select="./config[@param='rcsdate']/@value"/>
  <!--<xsl:value-of select="$rcsdate"/>-->
  <xsl:variable name="timeString" select="$rcsdate"/>
  <xsl:value-of select="substring($timeString, 7, 5)"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="substring($timeString, 13, 2)"/>
  <xsl:text>-</xsl:text>
  <xsl:value-of select="substring($timeString, 16, 2)"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="substring($timeString, 18, 6)"/>
</xsl:template>
<xsl:template match="headlink" mode="webpage.linkbar">
  <xsl:if test="@rel='bookmark'">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@href" />
      </xsl:attribute>
      <xsl:value-of select="@title" />
    </a>
    <xsl:if test="following-sibling::headlink[@rel='bookmark']"> | </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="webtoc">
  <!-- nop -->
</xsl:template>

<xsl:template name="user.search-box">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="copyright-link">
  <xsl:param name="copyright" select="$autolayout/autolayout/copyright[1]"/>
  <span class="copyright">
      <xsl:if test="$autolayout/autolayout/config[@param='copyright']">
        <xsl:variable name="id" select="$autolayout/autolayout/config[@param='copyright']/@value"/>
        <xsl:variable name="tocentry"
                      select="$autolayout//*[@id=$id]"/>
        <xsl:if test="count($tocentry) != 1">
          <xsl:message>
            <xsl:text>Copyright link to </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> does not id a unique page.</xsl:text>
          </xsl:message>
        </xsl:if>
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
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="root-rel-path">
              <xsl:with-param name="webpage" select="."/>
	    </xsl:call-template>
            <xsl:value-of select="$dir"/>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:value-of select="$tocentry/@filename"/>
          </xsl:attribute>
          <xsl:value-of select="$autolayout/autolayout/config[@param='copyright']/@altval"/>
        </a>
     </xsl:if>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="$copyright/year" mode="footer.mode"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="$copyright/holder" mode="footer.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </span>

</xsl:template>

<xsl:template name="footlinks">
      <xsl:if test="$autolayout/autolayout/config[@param='footlink']">
        <xsl:variable name="target-id" select="$autolayout/autolayout/config[@param='footlink']/@value"/>
	<xsl:variable name="target" select="$autolayout//*[$target-id=@id]"/>
        <xsl:variable name="tocentry" select="$autolayout//*"/>
        <xsl:if test="count($tocentry) != 1">
          <xsl:message>
            <xsl:text>Copyright link to </xsl:text>
            <xsl:value-of select="$target-id"/>
            <xsl:text> does not id a unique page.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:variable name="dir">
          <xsl:choose>
            <xsl:when test="starts-with($target/@dir, '/')">
              <xsl:value-of select="substring($target/@dir, 2)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$target/@dir"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="root-rel-path">
              <xsl:with-param name="webpage" select="document($tocentry,.)/webpage"/>
	    </xsl:call-template>
            <xsl:value-of select="$dir"/>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:value-of select="$tocentry/@filename"/>
          </xsl:attribute>
          <xsl:value-of select="$autolayout/autolayout/config[@param='footlink']/@altval"/>
        </a>
     </xsl:if>
</xsl:template>


</xsl:stylesheet>
