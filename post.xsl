<?xml version="1.0"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>
<xsl:output
	method="html"
	doctype-public="-//W3C//DTD HTML 4.01//EN"
	doctype-system="http://www.w3.org/TR/html4/strict.dtd"
/>

<xsl:param name="archive"/>
<xsl:param name="title"/>
<xsl:param name="topic"/>
<xsl:param name="dir_prefix"/>

<xsl:template match="/log">
<html><head>
<link rel="stylesheet" href="{$dir_prefix}main.css"/>
<link rel="alternate" type="application/rss+xml" title="RSS" href="{$dir_prefix}index.rdf"/>
<xsl:choose>
	<xsl:when test="string-length($title) = 0 and string-length($topic) = 0 and string-length($archive) = 0"><title><xsl:value-of select="@title"/>: Description goes here</title></xsl:when>
	<xsl:when test="string-length($title) = 0 and string-length($topic) = 0"><title>News Archive</title></xsl:when>
	<xsl:when test="string-length($title) = 0"><title><xsl:value-of select="@title"/>: <xsl:value-of select="$topic"/></title></xsl:when>
	<xsl:otherwise><title><xsl:value-of select="@title"/>: <xsl:value-of select="$topic"/>: <xsl:value-of select="$title"/></title></xsl:otherwise>
</xsl:choose>
</head>
<body>
<div id="main">

<div id="leftout">
<div class="bar" id="left">
<h3>News</h3>
<ul>
<li><a href="{$dir_prefix}index.rdf">News Feed</a></li>
</div>
</div>

<div class="main" id="right">
<h1 class="title"><a href="http://site.com/">Site name</a></h1>

<xsl:if test="string-length($title) = 0 and string-length($topic) = 0 and string-length($archive) = 0">
<div class="box">
<p><a href="http://site.com/">Site description here<span class="divlink"></span></a></p>
<h3><a href="http://site.com/downloads/">Download goes here</a></h3>
</div>
</xsl:if>

<xsl:choose>
<xsl:when test="string-length($archive) = 0">
	<xsl:variable name="single"><xsl:if test="string-length($title) != 0 and string-length($topic) != 0">yes</xsl:if></xsl:variable>
	<xsl:for-each select="post[(string-length($title) = 0 and string-length($topic) = 0) or (string-length($title) = 0 and string-length($topic) != 0 and @topic = $topic) or (string-length($title) != 0 and string-length($topic) != 0 and @title = $title and @topic = $topic)]">
	<xsl:if test="position() &lt;= 4">
	<div class="news">
	<h2>
	<xsl:value-of select="@topic"/>: <xsl:value-of select="@title"/>
	</h2>
	<p class="subtitle"><xsl:value-of select="@timestamp"/></p>
	<xsl:for-each select="image">
	<div class="image">
	<a href="{$dir_prefix}{@file}"><img src="{$dir_prefix}{@thumb}" alt="{@caption}"/></a><br/>
	<small><xsl:value-of select="@caption"/></small>
	</div>
	</xsl:for-each>
	<xsl:value-of select="body" disable-output-escaping="yes"/>
	<!-- Rating -->
	<ul>
	<xsl:for-each select="reference">
		<li><a href="{@uri}"><xsl:value-of select="@label"/></a></li>
	</xsl:for-each>
	<li><a href="{@uri}">Permanent Link</a></li>
	<xsl:variable name="current_uri" select="@uri"/>
	<xsl:for-each select="/log/post[@uri != $current_uri]/reference[@uri = $current_uri]">
		<li><a href="{@uri}">Follow Up: <xsl:value-of select="../@title"/></a></li>
	</xsl:for-each>
	<xsl:if test="string-length($single) > 0">
	<li><a href="{$dir_prefix}{@safetopic}/archive.html">Topic: <xsl:value-of select="@topic"/></a></li>
	</xsl:if>
	</ul>
    <hr/>
	</div>
	</xsl:if>
	</xsl:for-each>
</xsl:when>
<xsl:otherwise>
	<ul>
	<xsl:for-each select="post[string-length($topic) = 0 or (string-length($topic) != 0 and @topic = $topic)]">
		<li><xsl:value-of select="substring-before(@timestamp, 'T')"/>: <a href="{@uri}"><xsl:if test="string-length($topic) = 0"><xsl:value-of select="@topic"/>: </xsl:if><xsl:value-of select="@title"/></a></li>
	</xsl:for-each>
	</ul>
</xsl:otherwise>
</xsl:choose>

</div>

</div>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
