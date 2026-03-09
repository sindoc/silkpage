<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="en" lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="HTML Tidy for Java (vers. 2009-08-01), see jtidy.sourceforge.net" name="generator" />
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii" />
<meta name="generator" content="SilkPage" />
<meta name="author" content="SilkTeam" />
<link rel="home" href="../../index.html" title="What&#39;s SilkPage?" />
<link rel="up" href="../../about/index.html" title="About" />
<link rel="previous" href="../../about/team/index.html" title="Silk Team" />
<link rel="next" href="../../docs/index.html" title="Documentation" />
<link rel="first" href="../../about/participate/index.html" title="Participate" />
<link rel="stylesheet" href="../../css/silkpage.css" type="text/css" />
<title>Contact Us -- How to reach us</title>
<meta name="description" content="How to reach us" />
<meta name="keywords" content="SilkPage Contact information" />
</head>
<body class="contact">
<div id="wrapper">
<div id="header">
<ul class="skipNav">
<li><a href="#maincontent">Skip to Content</a></li>
</ul>
<div id="title"><a title="An XML based Publishing Framework for Web" href="../../index.html" accesskey="1">SilkPage</a></div>
<div id="headitems"><span class="headitem contact"><a href="../../about/contact/index.php" title="Contact">Contact</a></span> <span class="vbar sitemap">|</span> <span class="headitem sitemap"><a href="../../site/map/index.html" title="Site Map">Site Map</a></span> <span class="vbar search">|</span> <span class="headitem search"><a href="../../site/search/index.html" title="Search">Search</a></span></div>
<hr class="access" /></div>
<div id="menu">
<ul>
<li class="ancestor about"><a href="../../about/index.html" title="About SilkPage goals and principles"><span>About</span></a></li>
<li class="docs"><a href="../../docs/index.html" title="Installation, Customization and Usage Guides"><span>Documentation</span></a></li>
<li class="downloads"><a href="../../downloads/index.html" title="Download SilkPage software distribution"><span>Download</span></a></li>
<li class="dev"><a href="../../dev/index.html" title="SilkPage for developers"><span>Developers</span></a></li>
</ul>
</div>
<div id="pagebody">
<div id="maincontent">
<h1>Contact Us</h1>
<p>Thanks you for your interest in SilkPage. If you have a general comment on SilkPage project, please submit the following form. For technical support and public discussions, feel free to post to <a class="ulink" href="https://silkpage.dev.java.net/servlets/ProjectMailingListList" target="_top">silkpage-users</a> mailing-list.</p>
<?php if ((@$_GET["komail"]==1) OR (@$_GET["notext"]==1) OR (@$_GET["ko"]==1)) {
    $msg='<div class="error"><strong>ERROR: </strong>';
    $msg.='Please correct the following errors and re-submit your message.<ol>';
    if (@$_GET["komail"]==1)
    $msg.='<li>Invalid <em>Email</em> address.</li>' ;
    if (@$_GET["notext"]==1)
    $msg.='<li>Invalid <em>Name</em> or <em>Subject</em> or <em>Comment</em>.</li>' ;
    if (@$_GET["ko"]==1)
    $msg.='<li>Failed to send your message. Please try later.</li>' ;
    $msg.='</ol></div>' ;
    echo $msg;
    }
  ?>
<form action="/about/contact-send.php" method="post" id="contactForm" name="contactForm">
<fieldset><legend>Contact Form</legend>
<p class="name"><label for="contactForm-name" accesskey="9">Name:</label> <em>*</em><br />
<input id="contactForm-name" name="name" type="text" size="40" tabindex="1" /></p>
<p class="email"><label for="contactForm-email">Email:</label> <em>*</em><br />
<input name="email" type="text" id="contactForm-email" size="40" tabindex="2" /></p>
<p class="subject"><label for="contactForm-subject">Subject:</label> <em>*</em><br />
<input name="subject" type="text" id="contactForm-subject" size="40" tabindex="5" /></p>
<p class="comment"><label for="contactForm-comment">Comment:</label> <em>*</em><br />
<textarea name="comment" id="contactForm-comment" rows="20" cols="60" tabindex="6">
</textarea></p>
<p><input class="button" type="submit" value="send" tabindex="7" /></p>
<p class="note"><strong class="alert">Note</strong>: Fields marked with a <em>*</em> are required.</p>
</fieldset>
</form>
<hr class="access" />
<div id="breadcrumb">
<ul>
<li class="home"><a title="Home" href="../../index.html">Home</a></li>
<li class="about"><span class="navsep">&#187;</span><a title="About SilkPage goals and principles" href="../../about/index.html">About</a></li>
<li class="contact"><span class="navsep">&#187;</span><span>Contact Us</span></li>
</ul>
</div>
</div>
<hr class="access" />
<div id="sidebar">
<div id="subnav">
<div id="secnav">
<ul>
<li class="participate"><a href="../../about/participate/index.html" title="Join SilkPage team"><strong>Participate</strong></a></li>
<li class="colophon"><a href="../../about/colophon/index.html" title="Colophon and Typography"><strong>Colophon</strong></a></li>
<li class="license"><a href="../../about/licence/index.html" title="About Licensing and Trademarks"><strong>Licensing</strong></a></li>
<li class="team"><a href="../../about/team/index.html" title="People behind SilkPage"><strong>Silk Team</strong></a></li>
<li class="current contact"><span>Contact Us</span></li>
</ul>
</div>
</div>
</div>
</div>
<hr class="access" />
<div id="footer">
<div id="footitems"><span class="footitem"><a title="Home" href="../../index.html">Home</a></span></div>
<div class="right">
<div class="sources">Sources<span>:</span> <span class="rdf"><a href="../../about/contact/index.php.rdf.xml" title="RDF - Contact Us">RDF</a> |</span> <span class="xml"><a href="../../about/contact.xml" title="XML - Contact Us">XML</a></span></div>
<div class="compliance">Compliance<span>:</span> <a href="http://validator.w3.org/check?uri=referer" class="xhtml" title="Validate XHTML">XHTML</a> | <a href="http://jigsaw.w3.org/css-validator/check/referer" class="css" title="Validate CSS">CSS</a> | <a href="http://wave.webaim.org/report?url=http://silkpage.markupware.com" title="508" class="access">508</a> | <a href="http://silkpage.markupware.com/docs/silkpaged/" class="silkpage" title="SilkPaged">SilkPaged</a></div>
</div>
<div class="left">
<div class="copyright"><a href="../../about/licence/index.html" title="Copyright">Copyright</a> &#169; 2004 - 2011 <a title="MarkupWare" href="http://www.markupware.com/">MarkupWare</a></div>
<div class="updated"><span>Last Updated: 2010-12-19T 01:24</span></div>
</div>
</div>
</div>
</body>
</html>
