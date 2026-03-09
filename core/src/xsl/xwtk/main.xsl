<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="html doc"
                version="1.0">

<xsl:import href="../common/website-common.xsl"/>
<xsl:include href="tabular/toc.xsl"/>

<xsl:output method="html"
            indent="yes"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
            doctype-system="http://www.w3.org/TR/xhtml/DTD/xhtml-transitional.dtd"
/>

<xsl:param name="autolayout" select="document($autolayout-file, /*)"/>
<xsl:param name="pages.siteinfo.id">siteInfoIndex</xsl:param>
<xsl:param name="pages.sitemap.id">sitemap</xsl:param>

<xsl:param name="pages.footer.links.siteinfo" select="1"/>
<xsl:param name="pages.footer.links.sitemap" select="1"/>

<xsl:param name="pages.footer.output" select="0"/>
<xsl:param name="pages.footer.output.spanclass">footoutput</xsl:param>
<xsl:param name="pages.footer.output.xmlsrc" select="0"/>
<xsl:param name="pages.footer.output.pdfview" select="0"/>
<xsl:param name="pages.footer.output.rssfeed" select="0"/>
<xsl:param name="pages.footer.output.txtview" select="0"/>

<xsl:param name="pages.navhead.output.pdfview" select="0"/>
<xsl:param name="pages.navhead.output.txtview" select="0"/>
<xsl:param name="pages.navhead.output.tblview" select="0"/>
<xsl:param name="label.output.tblview">Tabular</xsl:param>
<xsl:param name="label.output.pdfview">PDF</xsl:param>
<xsl:param name="label.output.txtview">TEXT</xsl:param>
<xsl:param name="label.footer.links.siteinfo">About Site</xsl:param>
<xsl:param name="label.footer.links.sitemap">Site Map</xsl:param>



<!-- ==================================================================== -->

<!-- Netscape gets badly confused if it sees a CSS style... -->
<xsl:param name="admon.style" select="''"/>
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.path">graphics/</xsl:param>
<xsl:param name="admon.graphics.extension">.gif</xsl:param>

<xsl:attribute-set name="table.properties">
  <xsl:attribute name="border">0</xsl:attribute>
  <xsl:attribute name="cellpadding">0</xsl:attribute>
  <xsl:attribute name="cellspacing">0</xsl:attribute>
  <xsl:attribute name="width">100%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.body.sidebanner.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="border">0</xsl:attribute>
  <xsl:attribute name="cellpadding">0</xsl:attribute>
  <xsl:attribute name="cellspacing">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.body.rightsidebar.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="border">0</xsl:attribute>
  <xsl:attribute name="cellpadding">0</xsl:attribute>
  <xsl:attribute name="cellspacing">0</xsl:attribute>
  <xsl:attribute name="width">150</xsl:attribute>
</xsl:attribute-set>


<xsl:attribute-set name="table.navigation.cell.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="align">left</xsl:attribute>
  <!-- width is set with $navotocwidth -->
  <xsl:attribute name="bgcolor">
    <xsl:choose>
      <xsl:when test="/webpage/config[@param='navbgcolor']/@value[. != '']">
        <xsl:value-of select="/webpage/config[@param='navbgcolor']/@value"/>
      </xsl:when>
      <xsl:when test="$autolayout/autolayout/config[@param='navbgcolor']/@value[. != '']">
        <xsl:value-of select="$autolayout/autolayout/config[@param='navbgcolor']/@value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$navbgcolor"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.body.cell.properties">
  <xsl:attribute name="valign">top</xsl:attribute>
  <xsl:attribute name="align">left</xsl:attribute>
  <!-- width is set with $navobodywidth -->
  <xsl:attribute name="bgcolor">
    <xsl:value-of select="$textbgcolor"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:param name="body.columns" select="2"/>

<!-- ==================================================================== -->
<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="home.navhead">
 <!--<xsl:text>Navhead</xsl:text>-->
</xsl:template>

<xsl:template name="home.navhead.upperright">
 <!--<xsl:text>Upper-right</xsl:text>-->
</xsl:template>


<xsl:template name="home.navhead.cell">
  <td width="50%" valign="middle" align="left">
    <xsl:call-template name="home.navhead"/>
  </td>
</xsl:template>

  <xsl:template name="home.navhead.separator">
    <hr/>
  </xsl:template>

<xsl:template name="home.navhead.upperright.cell">
  <td width="50%" valign="middle" align="right">
    <xsl:call-template name="home.navhead.upperright"/>
  </td>
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

  <xsl:variable name="page" select="."/>

  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc
                                   |$autolayout/autolayout/toc[1])[last()]"/>

  <xsl:variable name="rightsidebar" select="$autolayout/autolayout/config[@param='rightsidebar']|$page/config[@param='rightsidebar']"/>

  <html xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>
    <body class="tabular">
      <xsl:call-template name="body.attributes"/>

      <div class="{name(.)}">
        <a name="{$id}"/>

        <xsl:call-template name="allpages.banner"/>

        <table xsl:use-attribute-sets="table.properties">
          <xsl:if test="$nav.table.summary!=''">
            <xsl:attribute name="summary">
              <xsl:value-of select="$nav.table.summary"/>
            </xsl:attribute>
          </xsl:if>
          <tr>
            <td xsl:use-attribute-sets="table.navigation.cell.properties">
              <xsl:if test="$navtocwidth != ''">
                <xsl:attribute name="width">
                  <xsl:choose>
                    <xsl:when test="/webpage/config[@param='navtocwidth']/@value[. != '']">
                      <xsl:value-of select="/webpage/config[@param='navtocwidth']/@value"/>
                    </xsl:when>
                    <xsl:when test="$autolayout/autolayout/config[@param='navtocwidth']/@value[. != '']">
                      <xsl:value-of select="$autolayout/autolayout/config[@param='navtocwidth']/@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                     <xsl:value-of select="$navtocwidth"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$toc">
                  <p class="navtoc">
                    <xsl:apply-templates select="$toc">
                      <xsl:with-param name="pageid" select="@id"/>
                    </xsl:apply-templates>
                  </p>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </td>
           <xsl:call-template name="hspacer"/>

	    <xsl:if test="$tocentry/@sidebanref">
            <td xsl:use-attribute-sets="table.body.sidebanner.properties">
	      <img src="{unparsed-entity-uri($tocentry/@sidebanref)}"/>
	    </td>
	    </xsl:if>

            <td xsl:use-attribute-sets="table.body.cell.properties">
              <xsl:if test="$navbodywidth != ''">
                <xsl:attribute name="width">
                  <xsl:value-of select="$navbodywidth"/>
                </xsl:attribute>
              </xsl:if>

              <xsl:if test="$autolayout/autolayout/toc[1]/@id != $id
                            or $suppress.homepage.title = 0">
                <xsl:apply-templates select="./head/title" mode="title.mode"/>
              </xsl:if>

              <xsl:if test="$pages.navhead != 0">
		<div id="navhead">
                  <xsl:call-template name="pages.navhead"/>
		</div>
                </xsl:if>
                <xsl:call-template name="home.navhead.separator"/>
		<xsl:if test="$autolayout/autolayout/toc[$id=@id] and $pages.search-box != ''">
		  <xsl:call-template name="user.search-box"/>
		</xsl:if>
              <xsl:apply-templates select="child::*[name(.) != 'webpage']"/>
              <xsl:call-template name="process.footnotes"/>
              <br/>
            </td>
	    <xsl:if test="$pages.rightsidebar != 0">
              <xsl:call-template name="pages.rightsidebar.filter"/>
	    </xsl:if>
          </tr>
          <xsl:call-template name="webpage.table.footer"/>
        </table>

        <xsl:call-template name="webpage.footer"/>
      </div>

    </body>
  </html>
</xsl:template>

<xsl:template name="hspacer">
  <!-- nop -->
</xsl:template>

<xsl:template match="config[@param='filename']" mode="head.mode">
</xsl:template>

<xsl:template match="webtoc">
  <!-- nop -->
</xsl:template>

<xsl:template name="pages.rightsidebar.filter">
  <xsl:choose>
    <xsl:when test="$pages.rightsidebar.select = 1">
      <xsl:call-template name="page.rightsidebar"/>
    </xsl:when>
    <xsl:when test="$pages.rightsidebar.all = 1">
      <xsl:call-template name="pages.rightsidebar"/>
    </xsl:when>
    <xsl:when test="$pages.rightsidebar.select = $pages.rightsidebar.all">
      <xsl:message>Both $pages.rightsidebar.select and $pages.rightsidebar.all have been enabled!</xsl:message>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="pages.rightsidebar">
  <xsl:choose>
    <xsl:when test="$autolayout/autolayout/config[@param='rightsidebar']">
  <td xsl:use-attribute-sets="table.body.rightsidebar.properties">
    <div id="rightsidebar">
        <h3>
          <a>
	    <xsl:attribute name="href">
		<xsl:value-of select="$autolayout/autolayout/config[@param='rightsidebar']/@value"/>
	    </xsl:attribute>
	    <xsl:value-of select="$autolayout/autolayout/config[@param='rightsidebar']/@altval"/>
	  </a>
	</h3>
	<p>
	  <xsl:value-of select="$autolayout/autolayout/config[@param='rightsidebar'][1]"/>
	</p>
    </div>
   </td>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="page.rightsidebar">
  <xsl:choose>
    <xsl:when test="./config[@param='rightsidebar']">
  <td xsl:use-attribute-sets="table.body.rightsidebar.properties">
    <div id="rightsidebar">
        <h3>
          <a>
	    <xsl:attribute name="href">
		<xsl:value-of select="./config[@param='rightsidebar']/@value"/>
	    </xsl:attribute>
	    <xsl:value-of select="./config[@param='rightsidebar']/@altval"/>
	  </a>
	</h3>
	<p>
	  <xsl:value-of select="./config[@param='rightsidebar'][1]"/>
	</p>
    </div>
   </td>
    </xsl:when>
  </xsl:choose>
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

  <xsl:variable name="sitemap-dir">
    <xsl:if test="$autolayout//*[@id='$pages.sitemap.id']/@dir">
      <xsl:value-of select="$autolayout//*[@id=$pages.sitemap.id]/@dir"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="siteinfo-dir">
     <xsl:if test="$autolayout//*[@id=$pages.siteinfo.id]/@dir">
      <xsl:value-of select="$autolayout//*[@id=$pages.siteinfo.id]/@dir"/>
    </xsl:if>
  </xsl:variable>

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
        <td width="23%">
          <span class="footdate">
            <xsl:call-template name="rcsdate.format">
              <xsl:with-param name="rcsdate"
                              select="$page/config[@param='rcsdate']/@value"/>
            </xsl:call-template>
          &#160;
          </span>
          <span class="footw3c">
             <a href="http://validator.w3.org/check/referer">XHTML</a>
          </span>
          <span class="footw3c">
             <a href="http://jigsaw.w3.org/css-validator/check/referer">CSS</a>
          </span>
	  <br/>
          <span class="footcopy">
            <xsl:choose>
              <xsl:when test="head/copyright">
                <xsl:apply-templates select="head/copyright" mode="footer.mode"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates mode="footer.mode"
                                     select="$autolayout/autolayout/copyright"/>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </td>
        <td width="34%">
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
                  <xsl:text>Home</xsl:text>
                </a>
                <xsl:if test="$footers">
                  <!-- <xsl:text> | </xsl:text>-->
                </xsl:if>
              </span>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:apply-templates select="$footers" mode="footer.link.mode"/>

       <xsl:if test="$pages.footer.links.sitemap != 0 and $autolayout//*[@id=$pages.sitemap.id]">
         <span>
      <xsl:attribute name="class">
	<xsl:value-of select="$pages.footer.links.spanclass"/>
      </xsl:attribute>
           <a>
             <xsl:attribute name="href">
       	       <xsl:call-template name="root-rel-path"/>
	       <xsl:value-of select="$sitemap-dir"/>
	       <xsl:value-of select="$filename-prefix"/>
               <xsl:value-of select="$autolayout//*[@id='sitemap']/@filename"/>
             </xsl:attribute>
	     <xsl:value-of select="$label.footer.links.sitemap"/>
           </a>
         </span>
       </xsl:if>

       <xsl:if test="$pages.footer.links.siteinfo != 0 and $autolayout//*[@id=$pages.siteinfo.id]">
         <span>
      <xsl:attribute name="class">
	<xsl:value-of select="$pages.footer.links.spanclass"/>
      </xsl:attribute>
           <a>
             <xsl:attribute name="href">
       	       <xsl:call-template name="root-rel-path"/>
	       <xsl:value-of select="$siteinfo-dir"/>
	       <xsl:value-of select="$filename-prefix"/>
               <xsl:value-of select="$autolayout//*[@id=$pages.siteinfo.id]/@filename"/>
             </xsl:attribute>
	     <xsl:value-of select="$label.footer.links.siteinfo"/>
           </a>
         </span>
       </xsl:if>
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

<xsl:template match="config" mode="footer.link.mode">
  <span class="foothome">
    <xsl:if test="position() &gt; 1">
      <!-- <xsl:text> | </xsl:text> -->
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@param='footlink'">
        <xsl:variable name="id" select="@value"/>
        <xsl:variable name="tocentry"
                      select="$autolayout//*[@id=$id]"/>
        <xsl:if test="count($tocentry) != 1">
          <xsl:message>
            <xsl:text>Footlink to </xsl:text>
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
            <xsl:call-template name="root-rel-path"/>
            <xsl:value-of select="$dir"/>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:value-of select="$tocentry/@filename"/>
          </xsl:attribute>
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{@value}">
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

</xsl:stylesheet>
