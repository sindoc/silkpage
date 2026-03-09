<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/silkpage/footer.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, HTML Footer for SilkPage Theme</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:58 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

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
    <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc[1]                                    | $autolayout//toc[1])[last()]"/>
    <xsl:variable name="footitems" select="$page/config[@param='footlink']   |$page/config[@param='footer']   |$autolayout/autolayout/config[@param='footlink']   |$autolayout/autolayout/config[@param='footer']"/>
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
      <xsl:if test="$footitems.label != ''">
        <div>
          <xsl:attribute name="id">
            <xsl:value-of select="$footitems.label"/>
          </xsl:attribute>
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
                  <xsl:value-of select="$footitem.label"/>
                </xsl:attribute>
                <a>
                  <xsl:attribute name="title">
                    <xsl:call-template name="gentext.nav.home"/>
                  </xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:call-template name="homeuri"/>
                  </xsl:attribute>
                  <xsl:call-template name="gentext.nav.home"/>
                </a>
                <xsl:if test="$footitems">
                  <xsl:text> | </xsl:text>
                </xsl:if>
              </span>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="$footitems" mode="footer.item.mode">
            <xsl:with-param name="page" select="$page"/>
          </xsl:apply-templates>
          <xsl:if test="$feedback != ''">
            <span>
              <xsl:attribute name="class">
                <xsl:value-of select="$footitem.label"/>
              </xsl:attribute>
              <xsl:text> | </xsl:text>
              <a>
                <xsl:choose>
                  <xsl:when test="$feedback.with.ids != 0">
                    <xsl:attribute name="href">
                      <xsl:value-of select="$feedback"/>
                      <xsl:value-of select="$page/@id"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'Feedback'"/>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$feedback"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'Feedback'"/>
                      </xsl:call-template>
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'Feedback'"/>
                </xsl:call-template>
              </a>
            </span>
          </xsl:if>
        </div>
      </xsl:if>
<div class="{$right.label}">
      <xsl:if test="$viewsrc.label != ''">
        <div class="{$viewsrc.label}">
	  <span>
          <xsl:call-template name="gentext">
             <xsl:with-param name="key" select="'ViewSrc'"/>
          </xsl:call-template>
          <xsl:value-of select="$biblioentry.item.separator"/>
          <xsl:call-template name="gentext.space"/>
	  </span>
          <xsl:call-template name="page-formats">
	    <xsl:with-param name="page" select="$page"/>
	  </xsl:call-template>
        </div>
      </xsl:if>
      <xsl:if test="$compliance.label != ''">
        <div class="{$compliance.label}">
	  <span>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'Conformance'"/>
            </xsl:call-template>
            <xsl:value-of select="$biblioentry.item.separator"/>
            <xsl:call-template name="gentext.space"/>
	  </span>
          <a href="{$xhtml.validator.url}" class="xhtml">
              <xsl:attribute name="title">
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'Validate'"/>
                </xsl:call-template>
                <xsl:call-template name="gentext.space"/>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'XHTML'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'XHTML'"/>
              </xsl:call-template>
            </a>
            <xsl:text> | </xsl:text>
            <a href="{$css.validator.url}" class="css">
              <xsl:attribute name="title">
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'Validate'"/>
                </xsl:call-template>
                <xsl:call-template name="gentext.space"/>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'CSS'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'CSS'"/>
              </xsl:call-template>
            </a>
            <xsl:text> | </xsl:text>
            <a href="{$access.validator.url}" class="access">
              <xsl:attribute name="title">
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'508'"/>
                </xsl:call-template>
                <xsl:call-template name="gentext.space"/>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'Compliance'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'508'"/>
              </xsl:call-template>
            </a>
            <xsl:text> | </xsl:text>
            <a href="{$site.publisher.url}" class="silkpage">
              <xsl:attribute name="title">
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="'SilkPaged'"/>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'SilkPaged'"/>
              </xsl:call-template>
            </a>
          </div>
      </xsl:if>
        </div>
<div class="{$left.label}">
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
          <div class="{$updated.label}">
	    <span>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'LastUpdated'"/>
              </xsl:call-template>
              <xsl:value-of select="$biblioentry.item.separator"/>
              <xsl:call-template name="gentext.space"/>
              <xsl:call-template name="rcsdate.format">
                <xsl:with-param name="rcsdate" select="$page/config[@param='rcsdate']/@value"/>
              </xsl:call-template>
            </span>
	  </div>
        </xsl:if>
	  </div>
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
    <xsl:text>T</xsl:text>
    <xsl:value-of select="substring($timeString, 18, 6)"/>
  </xsl:template>
  <xsl:template match="copyright" mode="footer.mode">
    <xsl:param name="page" select="''"/>
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:value-of select="@role"/>
        </xsl:when>
        <xsl:otherwise>copyright</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="altval">
      <xsl:call-template name="gentext.element.name"/>
    </xsl:variable>
    <div class="{$copyright.label}">
      <xsl:call-template name="links">
        <xsl:with-param name="page" select="$page"/>
        <xsl:with-param name="altval" select="$altval"/>
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
      <xsl:call-template name="gentext.space"/>
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat" select="'copyright'"/>
      </xsl:call-template>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="year" mode="footer.mode"/>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="holder" mode="footer.mode"/>
    </div>
  </xsl:template>
  <xsl:template match="config" mode="footer.item.mode">
    <xsl:param name="page" select="''"/>
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="$footitem.label"/>
      </xsl:attribute>
      <xsl:if test="position() &gt; 1">
        <xsl:text> | </xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@param='footlink'">
          <xsl:call-template name="links">
            <xsl:with-param name="page" select="$page"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <a href="{@value}" title="{@altval}">
            <xsl:value-of select="@altval"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  <xsl:template match="holder" mode="footer.mode">
    <xsl:choose>
      <xsl:when test="@role">
        <a>
          <xsl:attribute name="title">
            <xsl:apply-templates/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
          <xsl:apply-templates/>
          <xsl:if test="position() != last()">, </xsl:if>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <xsl:if test="position() != last()">, </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
