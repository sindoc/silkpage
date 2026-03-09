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
    <cvs:date>$Date: 2006-01-26 21:28:16 $</cvs:date>
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
    <xsl:variable name="css">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'CSS'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="gentext-feedback">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'Feedback'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="xhtml">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'XHTML'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="compliance">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'Compliance'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="access">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'508'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="sources">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'Sources'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="silkpaged">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'SilkPaged'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="validate">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'Validate'"/>
      </xsl:call-template>      
    </xsl:variable>
    <xsl:variable name="updated">
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'LastUpdated'"/>
      </xsl:call-template>      
    </xsl:variable>
    <div id="{$footer.label}">
      <xsl:if test="$footitems.label != ''">
	<div id="{$footitems.label}">
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
	      <span class="{$footitem.label}">
		<a>
		  <xsl:attribute name="title">
		    <xsl:call-template name="gentext.nav.home"/>
		  </xsl:attribute>
		  <xsl:attribute name="href">
		    <xsl:call-template name="homeuri"/>
		  </xsl:attribute>
		  <xsl:call-template name="gentext.nav.home"/>
                </a>
              </span>
	      <xsl:if test="$footitems">
	        <span class="vbar home"> | </span>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
	  <xsl:apply-templates select="$footitems" mode="item.mode">
            <xsl:with-param name="page" select="$page"/>
          </xsl:apply-templates>
          <xsl:if test="$feedback != ''">
            <span>
              <xsl:attribute name="class">
                <xsl:value-of select="$footitem.label"/>
		<xsl:text> </xsl:text>
                <xsl:value-of select="'feedback'"/>
              </xsl:attribute>
              <xsl:text> | </xsl:text>
	      <a title="{$gentext-feedback}">
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
                    <xsl:attribute name="title">
		      <xsl:value-of select="$gentext-feedback"/>
                    </xsl:attribute>
		  </xsl:otherwise>
                </xsl:choose>
		<xsl:value-of select="$gentext-feedback"/>
	      </a>
            </span>
          </xsl:if>
        </div>
      </xsl:if>
      <div class="{$right.label}">
	<xsl:if test="$sources.label != ''">
	  <div class="{$sources.label}">
	    <xsl:value-of select="$sources"/>
	    <span>
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
	    <xsl:value-of select="$compliance"/>
	    <span>
	      <xsl:value-of select="$biblioentry.item.separator"/>
	      <xsl:call-template name="gentext.space"/>
	    </span>
	    <a href="{$xhtml.validator.url}" class="xhtml" 
	       title="{$validate} {$xhtml}">
	      <xsl:value-of select="$xhtml"/>
            </a>
	    <xsl:text> | </xsl:text>
	    <a href="{$css.validator.url}" class="css"
	       title="{$validate} {$css}">
	      <xsl:value-of select="$css"/>
	    </a>
            <xsl:text> | </xsl:text>
	    <a href="{$access.validator.url}" title="{$access}" class="access">
	      <xsl:value-of select="$access"/>
            </a>
	    <xsl:text> | </xsl:text>
	    <a href="{$site.generator.url}" class="silkpage" title="{$silkpaged}">
	      <xsl:value-of select="$silkpaged"/>
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
	    <xsl:value-of select="$updated"/>
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
    <xsl:variable name="privacy"
	  select="$autolayout/autolayout/config[@param=$privacy.label]"/>
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
      <!-- privacy -->
      <xsl:if test="$privacy">
	<span class="vbar {$privacy.label}"> | </span>
	<span class="{$privacy.label}">
	  <xsl:call-template name="links">
	    <xsl:with-param name="page" select="$page"/>
	    <xsl:with-param name="altval" select="$privacy/@altval"/>
	    <xsl:with-param name="id" select="$privacy/@value"/>
	  </xsl:call-template>
	</span>
      </xsl:if>
    </div>
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
	  <xsl:if test="position() != last()">
	    <span class="csep">, </span>
	  </xsl:if>
	</a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
	<xsl:if test="position() != last()">
	  <span class="csep">, </span>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
