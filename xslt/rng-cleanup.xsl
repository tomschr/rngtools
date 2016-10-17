<?xml version="1.0" encoding="UTF-8"?>
<!--
   Purpose:
     Copies RNG tree, but renames defines and refs to its original name.

   Input:
     Simplified RNG from rng2srng output.

   Output:
     Simplified RNG with correct names.

   See also:
     * obs://home/thomas.schraitle/rng2srng

   Author:    Thomas Schraitle <toms@opensuse.org>
   Copyright (C) 2016 SUSE Linux GmbH
-->
<xsl:stylesheet version="1.0"
 xmlns:rng="http://relaxng.org/ns/structure/1.0"
 xmlns="http://relaxng.org/ns/structure/1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="rng">

 <xsl:key name="rng.element"
  match="rng:define[rng:element[rng:name]]"
  use="@name"/>

 <!-- ================================================================ -->
 <xsl:param name="ref.prefix">k.</xsl:param>

 <!-- ================================================================ -->
 <xsl:template match="node() | @*" name="copy">
  <xsl:copy>
   <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
 </xsl:template>

 <!-- ================================================================ -->
 <xsl:template match="rng:start">
  <xsl:message>Start found!</xsl:message>
  <xsl:call-template name="copy"/>
 </xsl:template>

 <xsl:template match="rng:ref">
  <xsl:variable name="rng.element.node" select="key('rng.element', @name)"/>
  <xsl:variable name="name" select="$rng.element.node/rng:element/rng:name"/>
  <xsl:variable name="ref.name" select="concat($ref.prefix, $name)"/>
  <xsl:message>Renamed ref <xsl:value-of select="@name"/> => <xsl:value-of
    select="$ref.name"/>
  </xsl:message>
  <ref name="{$ref.name}"/>
 </xsl:template>

 <xsl:template match="rng:define">
  <xsl:variable name="rng.element.node" select="key('rng.element', @name)"/>
  <xsl:variable name="name" select="$rng.element.node/rng:element/rng:name"/>
  <xsl:variable name="define.name">
   <xsl:choose>
    <xsl:when test="generate-id(.) = generate-id($rng.element.node)">
     <xsl:value-of select="concat($ref.prefix, $name)"/>
     <xsl:message>Renamed define <xsl:value-of select="@name"/> => <xsl:value-of
      select="concat($ref.prefix, $name)"/></xsl:message>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="@name"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <define name="{$define.name}">
   <xsl:apply-templates/>
  </define>
 </xsl:template>
</xsl:stylesheet>
