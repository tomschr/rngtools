<?xml version="1.0" encoding="UTF-8"?>
<!--
   Purpose:
     Create a list of all attributes and elements for a specific element

   Input:
     Simplified RNG from rng2srng output.

   Output:
     Structured text

   See also:
     * obs://home/thomas.schraitle/rng2srng

   Author:    Thomas Schraitle <toms@opensuse.org>
   Copyright (C) 2016 SUSE Linux GmbH
-->
<xsl:stylesheet version="1.0"
 xmlns:rng="http://relaxng.org/ns/structure/1.0"
 xmlns="http://relaxng.org/ns/structure/1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 exclude-result-prefixes="rng">


 <xsl:key name="rng.element"
  match="rng:define[rng:element[rng:name]]"
  use="@name"/>

 <xsl:output method="text"/>
 <xsl:strip-space elements="*"/>

 <!-- ================================================================ -->
 <xsl:template match="rng:start">
  <xsl:text>start = </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
 </xsl:template>

 <xsl:template match="rng:ref">
  <xsl:variable name="rng.element.node" select="key('rng.element', @name)"/>
  <xsl:variable name="ref.name" select="$rng.element.node/rng:element/rng:name"/>

  <xsl:value-of select="$ref.name"/>
 </xsl:template>

 <xsl:template match="rng:define">
  <xsl:variable name="rng.element.node" select="key('rng.element', @name)"/>
  <xsl:variable name="def.name" select="$rng.element.node/rng:element/rng:name"/>
  <xsl:variable name="all.attribs" select=".//rng:attribute"/>
  <xsl:variable name="all.refs" select=".//rng:ref"/>

  <xsl:text>element </xsl:text>
  <xsl:value-of select="$def.name"/>
  <xsl:text> = &#10;</xsl:text>
  <xsl:if test="$all.attribs">
   <xsl:text>  attributes = </xsl:text>
   <xsl:for-each select="$all.attribs">
    <xsl:apply-templates select="current()" mode="attrib"/>
    <xsl:choose>
     <xsl:when test="position() = last()"/>
     <xsl:otherwise>, </xsl:otherwise>
    </xsl:choose>
   </xsl:for-each>
   <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$all.refs">
   <xsl:text>  children = </xsl:text>
   <xsl:for-each select="$all.refs">
    <xsl:apply-templates select="current()"/>
    <xsl:choose>
     <xsl:when test="position() = last()"/>
     <xsl:otherwise>, </xsl:otherwise>
    </xsl:choose>
   </xsl:for-each>
   <xsl:text>&#10;</xsl:text>
  </xsl:if>
 </xsl:template>

 <xsl:template match="rng:attribute" mode="attrib">
  <xsl:value-of select="rng:name"/>
 </xsl:template>

</xsl:stylesheet>