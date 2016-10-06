<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:gn="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all"
                version="2.0">

  <xsl:template match="cit:CI_Organisation/cit:contactInfo/*/cit:phone[position() > 1]|
                       cit:CI_Organisation/cit:contactInfo/*/cit:address[position() > 1]"/>


  <xsl:template match="cit:CI_RoleCode[@codeListValue = 'resourceProvider']">
    <xsl:copy>
      <xsl:copy-of select="@codeList"/>
      <xsl:attribute name="codeListValue" select="'edmo'"/>
    </xsl:copy>
  </xsl:template>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>
</xsl:stylesheet>
