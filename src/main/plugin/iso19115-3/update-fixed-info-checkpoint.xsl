<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
  xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
  xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
  xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:java="java:org.fao.geonet.util.XslUtil"
  xmlns:mime="java:org.fao.geonet.util.MimeTypeFinder"
  xmlns:gn="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">

  <xsl:variable name="componentScopeCode" select="'datasetComponent'"/>
  <xsl:variable name="componentCodeSeparator" select="'/CP#'"/>

  <!-- Component / Set UUID if empty or not starting with DPS UUID.

  Component UUID is based on DPS UUID + DQ position.
  -->
  <xsl:template match="mdb:dataQualityInfo[
                          */mdq:scope/*/mcc:level/*/@codeListValue = $componentScopeCode
                          and (
                            not(*/@uuid) or */@uuid = '' or not(starts-with(*/@uuid, /root/env/uuid)))
                            ]">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <mdq:DQ_DataQuality>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="uuid"
                       select="concat(/root/env/uuid, $componentCodeSeparator, position())"/>
        <xsl:apply-templates select="*/*"/>
      </mdq:DQ_DataQuality>
    </xsl:copy>
  </xsl:template>

  <!-- Component / Set date of each measure if empty

   This basically means that when the user click add component
   based on a template with empty dates, then dates are initialized
   to current date time.
   -->
</xsl:stylesheet>
