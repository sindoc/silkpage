<?xml version="1.0" encoding="UTF-8"?>
<!--
  cv.xsl — XSLT 1.0 stylesheet: cv-data.xml → A4 HTML CV
  Produces HTML5 with:
    • h-card / microformats2 class attributes
    • schema.org itemscope / itemprop RDFa-lite
    • Two A4 pages (.page[data-page])
    • Download toolbar that calls /api/cv/download?format=X
    • FOAF, SKOS, Collibra namespace awareness preserved as data-* attributes
-->
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:schema="http://schema.org/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:sg="https://ontology.lutino.io/singine/1.0/"
  xmlns:collibra="https://ontology.lutino.io/collibra/1.0/"
  exclude-result-prefixes="schema foaf skos sg collibra"
>

<xsl:output
  method="html"
  encoding="UTF-8"
  indent="yes"
  doctype-public=""
  doctype-system=""
/>

<!-- ── Root template ─────────────────────────────────────────────────────── -->
<xsl:template match="/cv">
<html lang="en"
  vocab="http://schema.org/"
  prefix="foaf: http://xmlns.com/foaf/0.1/ skos: http://www.w3.org/2004/02/skos/core# sg: https://ontology.lutino.io/singine/1.0/"
>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><xsl:value-of select="person/@foaf:name"/> — CV</title>
  <meta name="generator" content="singine cv html (XSLT)" />
  <meta property="og:title">
    <xsl:attribute name="content"><xsl:value-of select="person/@foaf:name"/> — CV</xsl:attribute>
  </meta>
  <style>
    /* ── Reset ────────────────────────────────────────────────────────────── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --ink:    #1a1a2e;
      --mid:    #3a3a5c;
      --accent: #4a6fa5;
      --rule:   #c8d0dc;
      --bg:     #e8ecf0;
      --page-w: 210mm;
      --page-h: 297mm;
      --pad-x:  16mm;
      --pad-y:  14mm;
      font-size: 10pt;
    }
    body { background: var(--bg); font-family: Georgia,'Times New Roman',serif; color: var(--ink); padding: 0; margin: 0; }

    /* ── Toolbar ─────────────────────────────────────────────────────────── */
    #sg-toolbar {
      position: sticky; top: 0; z-index: 100;
      background: var(--ink); color: #fff;
      display: flex; align-items: center; gap: 8px;
      padding: 8px 18px; font-family: 'Helvetica Neue',Arial,sans-serif;
      font-size: 11px; letter-spacing: .03em;
      box-shadow: 0 2px 12px rgba(0,0,0,.3);
    }
    #sg-toolbar .sg-brand { font-weight: 700; color: var(--accent); margin-right: 8px; }
    #sg-toolbar button {
      background: var(--accent); color: #fff; border: none; border-radius: 4px;
      padding: 5px 12px; cursor: pointer; font-size: 11px; font-family: inherit;
      transition: opacity .15s;
    }
    #sg-toolbar button:hover { opacity: .82; }
    #sg-toolbar button:disabled { opacity: .45; cursor: default; }
    #sg-toolbar .sg-sep { color: #555; }
    #sg-status { font-size: 10px; color: #aaa; margin-left: auto; }

    /* ── A4 pages ────────────────────────────────────────────────────────── */
    .cv-pages { padding: 12mm 0 24mm; }
    .page {
      width: var(--page-w); height: var(--page-h);
      padding: var(--pad-y) var(--pad-x);
      margin: 0 auto 8mm; background: #fff;
      box-shadow: 0 2px 16px rgba(26,26,46,.18);
      position: relative; overflow: hidden;
      display: flex; flex-direction: column;
    }
    .page::before {
      content: attr(data-page); position: absolute; top: 4mm; right: 5mm;
      font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 7pt; color: #aab;
      letter-spacing: .05em;
    }
    .page-break-label {
      width: var(--page-w); margin: 0 auto;
      padding: 3px 0; text-align: center;
      font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 8pt; color: #99a;
      letter-spacing: .1em; background: #dde0e8;
    }

    /* ── Typography ─────────────────────────────────────────────────────── */
    h1 { font-size: 22pt; font-weight: 700; color: var(--ink); line-height: 1.15; letter-spacing: -.01em; }
    h2 { font-size: 9pt; font-weight: 700; color: var(--accent); text-transform: uppercase; letter-spacing: .12em; margin: 8px 0 4px; border-bottom: 1px solid var(--rule); padding-bottom: 2px; }
    h3 { font-size: 10.5pt; font-weight: 700; color: var(--ink); margin-bottom: 1px; }
    p, li { font-size: 9pt; line-height: 1.55; color: var(--mid); }

    /* ── Header ─────────────────────────────────────────────────────────── */
    .cv-header { margin-bottom: 5mm; }
    .cv-tagline { font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 9pt; color: var(--accent); margin-top: 3px; letter-spacing: .02em; }
    .contact-bar { display: flex; flex-wrap: wrap; gap: 0 10px; margin-top: 5px; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 8pt; color: var(--mid); }
    .contact-bar span::before { content: '· '; color: var(--rule); }
    .contact-bar span:first-child::before { content: ''; }

    /* ── Skills grid ─────────────────────────────────────────────────────── */
    .skills-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 4px 10px; margin-top: 4px; }
    .skill-group h4 { font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 8pt; font-weight: 700; color: var(--accent); text-transform: uppercase; letter-spacing: .08em; margin-bottom: 3px; }
    .skill-group li { list-style: none; font-size: 8.5pt; padding: 1px 0; }
    .skill-group li::before { content: '▸ '; color: var(--accent); }

    /* ── Experience ─────────────────────────────────────────────────────── */
    .exp-block { margin-bottom: 7px; }
    .exp-meta { font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 8.5pt; color: var(--accent); margin-bottom: 2px; }
    .exp-block ul { padding-left: 0; }
    .exp-block li { list-style: none; padding: 1px 0; font-size: 8.5pt; }
    .exp-block li::before { content: '– '; color: var(--accent); }

    /* ── Projects table ─────────────────────────────────────────────────── */
    table { width: 100%; border-collapse: collapse; font-size: 8.5pt; margin-top: 4px; }
    th { text-align: left; font-family: 'Helvetica Neue',Arial,sans-serif; font-size: 7.5pt; color: var(--accent); text-transform: uppercase; letter-spacing: .1em; padding: 2px 6px 2px 0; border-bottom: 1px solid var(--rule); }
    td { padding: 2.5px 6px 2.5px 0; vertical-align: top; border-bottom: 1px solid #eef; }
    td:first-child { font-weight: 700; color: var(--ink); white-space: nowrap; }
    td code { font-family: 'Courier New',monospace; font-size: 7.5pt; color: var(--mid); }

    /* ── Two-column layout ───────────────────────────────────────────────── */
    .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 0 12mm; }

    /* ── Print ───────────────────────────────────────────────────────────── */
    @media print {
      #sg-toolbar, .page-break-label { display: none !important; }
      .cv-pages { padding: 0; }
      .page { box-shadow: none; margin: 0; page-break-after: always; }
      body { background: #fff; }
    }

    /* ── Result panel ────────────────────────────────────────────────────── */
    #sg-result {
      display: none; position: fixed; bottom: 0; left: 0; right: 0;
      background: var(--ink); color: #eee; font-family: monospace;
      font-size: 11px; padding: 10px 18px; border-top: 2px solid var(--accent);
      max-height: 120px; overflow-y: auto;
    }
    #sg-result.visible { display: block; }
  </style>
</head>
<body vocab="http://schema.org/" typeof="Person">

  <!-- ── Download toolbar ───────────────────────────────────────────────── -->
  <nav id="sg-toolbar" aria-label="CV actions">
    <span class="sg-brand">sg:cv</span>
    <button onclick="sgDownload('pdf')" title="Generate PDF via Chrome headless">⬇ PDF</button>
    <button onclick="sgDownload('rtf')" title="Generate RTF document">⬇ RTF</button>
    <button onclick="sgDownload('html')" title="Download raw HTML">⬇ HTML</button>
    <button onclick="sgDownload('md')"  title="Download Markdown source">⬇ MD</button>
    <span class="sg-sep">|</span>
    <button onclick="window.print()" style="background:#556">🖨 Print</button>
    <button onclick="sgRegenerate()" title="Re-apply XSLT from cv-data.xml">↺ Regenerate</button>
    <span id="sg-status">singine cv serve · localhost</span>
  </nav>

  <!-- ── Page 1 ─────────────────────────────────────────────────────────── -->
  <div class="cv-pages">
  <article class="page h-card" data-page="1 / 2"
    itemscope="" itemtype="http://schema.org/Person"
  >
    <!-- Header -->
    <header class="cv-header">
      <h1 class="p-name" itemprop="name">
        <xsl:value-of select="person/@foaf:name"/>
      </h1>
      <p class="cv-tagline p-job-title" itemprop="jobTitle">
        <xsl:value-of select="person/foaf:title"/>
      </p>
      <div class="contact-bar">
        <span class="p-locality" itemprop="addressLocality">
          <xsl:value-of select="person/schema:homeLocation"/>
        </span>
        <span>
          <a class="u-url" itemprop="url">
            <xsl:attribute name="href">https://<xsl:value-of select="person/foaf:homepage"/></xsl:attribute>
            <xsl:value-of select="person/foaf:homepage"/>
          </a>
        </span>
        <xsl:for-each select="person/schema:knowsLanguage">
          <span><xsl:value-of select="."/></span>
        </xsl:for-each>
      </div>
    </header>

    <!-- Profile -->
    <h2>Professional Profile</h2>
    <p class="p-note" itemprop="description">
      <xsl:value-of select="normalize-space(profile)"/>
    </p>

    <!-- Skills -->
    <h2>Core Competencies</h2>
    <div class="skills-grid">
      <xsl:apply-templates select="skills/skill-group"/>
    </div>

    <!-- Experience — first two positions -->
    <h2>Professional Experience</h2>
    <xsl:apply-templates select="experience/position[position() &lt;= 2]"/>
  </article>

  <!-- ── Page break ──────────────────────────────────────────────────────── -->
  <div class="page-break-label" aria-hidden="true">— page break —</div>

  <!-- ── Page 2 ─────────────────────────────────────────────────────────── -->
  <article class="page" data-page="2 / 2">
    <!-- Remaining experience -->
    <h2>Professional Experience (continued)</h2>
    <xsl:apply-templates select="experience/position[position() &gt; 2]"/>

    <!-- Projects -->
    <h2>Key Projects</h2>
    <table>
      <thead>
        <tr><th>Project</th><th>Stack</th><th>Description</th></tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="projects/project"/>
      </tbody>
    </table>

    <!-- Education + Certs | Languages + Profiles -->
    <div class="two-col" style="margin-top:6mm">
      <div>
        <h2>Education</h2>
        <xsl:for-each select="education/degree">
          <p><strong><xsl:value-of select="level"/>, <xsl:value-of select="field"/></strong></p>
          <p style="font-size:8.5pt;color:#3a3a5c"><xsl:value-of select="institution"/> · <xsl:value-of select="year"/></p>
        </xsl:for-each>

        <h2 style="margin-top:5mm">Certifications</h2>
        <ul style="padding-left:0;list-style:none">
          <xsl:for-each select="certifications/cert">
            <li style="font-size:8.5pt;padding:1px 0">
              <xsl:if test="@collibra:level">
                <span style="color:var(--accent);font-family:Helvetica Neue,Arial,sans-serif;font-size:7pt;font-weight:700;margin-right:4px">
                  [<xsl:value-of select="@collibra:level"/>]
                </span>
              </xsl:if>
              <xsl:value-of select="."/>
            </li>
          </xsl:for-each>
        </ul>
      </div>
      <div>
        <h2>Languages</h2>
        <p style="font-size:9pt">
          <xsl:for-each select="person/schema:knowsLanguage">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()"> · </xsl:if>
          </xsl:for-each>
          (all fluent)
        </p>

        <h2 style="margin-top:5mm">Profiles &amp; Communities</h2>
        <ul style="padding-left:0;list-style:none">
          <xsl:for-each select="person/foaf:account">
            <li style="font-size:8pt;padding:1px 0">
              <xsl:attribute name="data-service"><xsl:value-of select="@service"/></xsl:attribute>
              <xsl:value-of select="."/>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>

    <!-- Personal -->
    <h2 style="margin-top:5mm">Personal</h2>
    <p style="font-size:8.5pt"><xsl:value-of select="normalize-space(personal)"/></p>
  </article>
  </div><!-- .cv-pages -->

  <!-- ── Result panel ───────────────────────────────────────────────────── -->
  <div id="sg-result"></div>

  <!-- ── Client-side scripts ────────────────────────────────────────────── -->
  <script>
    var _status = document.getElementById('sg-status');
    var _result = document.getElementById('sg-result');

    function sgStatus(msg) { _status.textContent = msg; }
    function sgLog(msg) {
      _result.className = 'visible';
      _result.textContent = msg;
      setTimeout(function() { _result.className = ''; }, 6000);
    }

    function sgDownload(fmt) {
      sgStatus('generating ' + fmt + '…');
      fetch('/api/cv/download?format=' + fmt)
        .then(function(r) {
          if (!r.ok) return r.text().then(function(t) { throw new Error(t); });
          var cd = r.headers.get('Content-Disposition') || '';
          var fname = 'cv-sina-heshmati.' + fmt;
          var m = cd.match(/filename="?([^"]+)"?/);
          if (m) fname = m[1];
          return r.blob().then(function(b) { return {blob: b, name: fname}; });
        })
        .then(function(obj) {
          var a = document.createElement('a');
          a.href = URL.createObjectURL(obj.blob);
          a.download = obj.name;
          a.click();
          sgStatus('✓ ' + obj.name + ' ready');
          sgLog('Downloaded: ' + obj.name);
        })
        .catch(function(e) {
          sgStatus('error');
          sgLog('Error: ' + e.message);
        });
    }

    function sgRegenerate() {
      sgStatus('regenerating…');
      fetch('/api/cv/regenerate', {method:'POST'})
        .then(function(r) { return r.json(); })
        .then(function(d) {
          sgStatus('✓ regenerated');
          sgLog('XSLT applied at ' + d.timestamp + '. Refresh to see updates.');
        })
        .catch(function(e) { sgStatus('error'); sgLog('' + e); });
    }

    /* Show server info on load */
    fetch('/api/cv/status')
      .then(function(r) { return r.json(); })
      .then(function(d) { sgStatus('singine cv serve · ' + d.url); })
      .catch(function() { sgStatus('singine cv serve · offline'); });
  </script>
</body>
</html>
</xsl:template>

<!-- ── Skill group ─────────────────────────────────────────────────────── -->
<xsl:template match="skill-group">
  <div class="skill-group"
    data-skos-label="{@skos:prefLabel}"
    data-collibra-domain="{@collibra:domain}"
  >
    <h4><xsl:value-of select="@skos:prefLabel"/></h4>
    <ul>
      <xsl:for-each select="skill">
        <li><xsl:value-of select="."/></li>
      </xsl:for-each>
    </ul>
  </div>
</xsl:template>

<!-- ── Position ───────────────────────────────────────────────────────── -->
<xsl:template match="position">
  <div class="exp-block"
    itemprop="worksFor" itemscope="" itemtype="http://schema.org/Organization"
    data-collibra-role="{@collibra:role}"
  >
    <h3 itemprop="name">
      <xsl:value-of select="@schema:jobTitle"/>
      <xsl:text> — </xsl:text>
      <xsl:value-of select="company"/>
    </h3>
    <p class="exp-meta">
      <xsl:value-of select="start"/>
      <xsl:text> – </xsl:text>
      <xsl:value-of select="end"/>
      <xsl:text> · </xsl:text>
      <xsl:value-of select="location"/>
    </p>
    <ul>
      <xsl:for-each select="achievement">
        <li><xsl:value-of select="."/></li>
      </xsl:for-each>
    </ul>
  </div>
</xsl:template>

<!-- ── Project row ────────────────────────────────────────────────────── -->
<xsl:template match="project">
  <tr data-sg-repo="{@sg:repo}">
    <td><strong><xsl:value-of select="name"/></strong></td>
    <td><code><xsl:value-of select="stack"/></code></td>
    <td><xsl:value-of select="description"/></td>
  </tr>
</xsl:template>

</xsl:stylesheet>
