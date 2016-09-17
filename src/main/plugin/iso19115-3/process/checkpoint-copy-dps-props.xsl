<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:gn-fn-math="http://geonetwork-opensource.org/xsl/functions/math"
                version="2.0" exclude-result-prefixes="#all">


  <!-- Assume only one specification is related to current project -->
  <xsl:variable name="dpsId"
                select="/mdb:MD_Metadata/mdb:identificationInfo/*/
                          mri:associatedResource/*[mri:initiativeType/*/@codeListValue = 'specification'][1]/
                          mri:metadataReference/@uuidref"/>

  <xsl:variable name="dpsDocument"
                select="java:getRecord($dpsId)"/>

  <xsl:variable name="hasDps"
                select="count($dpsDocument) > 0"/>

  <!-- Assume one mri:extent. Replace by the one from the DPS. -->
  <xsl:template match="mdb:identificationInfo/*/mri:extent[$hasDps]">
    <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:extent"/>
  </xsl:template>

  <xsl:template match="mdb:identificationInfo/*/mri:abstract[$hasDps]">
    <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:abstract"/>
  </xsl:template>

  <xsl:template match="mdb:identificationInfo/*/mri:purpose[$hasDps]">
    <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:purpose"/>
  </xsl:template>

  <xsl:template match="mdb:identificationInfo/*/mri:citation[$hasDps]">
    <xsl:variable name="dpsTitle"
                  select="$dpsDocument//mdb:identificationInfo/*/mri:citation/*/cit:title/gco:CharacterString"/>

    <mri:citation>
      <cit:CI_Citation>
        <cit:title>
          <gco:CharacterString>
            <xsl:value-of select="replace($dpsTitle, '_Specification_', '_Product_')"/>
          </gco:CharacterString>
        </cit:title>

        <xsl:copy-of select="*/cit:date"/>
        <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:citation/*/cit:series"/>
      </cit:CI_Citation>
    </mri:citation>
  </xsl:template>


  <xsl:template match="/mdb:MD_Metadata[$hasDps]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="mdb:metadataIdentifier"/>
      <xsl:apply-templates select="mdb:defaultLocale"/>
      <xsl:apply-templates select="mdb:parentMetadata"/>
      <xsl:apply-templates select="mdb:metadataScope"/>
      <xsl:apply-templates select="mdb:contact"/>
      <xsl:apply-templates select="mdb:dateInfo"/>
      <xsl:apply-templates select="mdb:metadataStandard"/>
      <xsl:apply-templates select="mdb:metadataProfile"/>
      <xsl:apply-templates select="mdb:alternativeMetadataReference"/>
      <xsl:apply-templates select="mdb:otherLocale"/>
      <xsl:apply-templates select="mdb:metadataLinkage"/>
      <xsl:apply-templates select="mdb:spatialRepresentationInfo"/>
      <xsl:copy-of select="$dpsDocument//mdb:referenceSystemInfo"/>
      <!--<xsl:apply-templates select="mdb:referenceSystemInfo"/>-->
      <xsl:apply-templates select="mdb:metadataExtensionInfo"/>
      <xsl:apply-templates select="mdb:identificationInfo"/>
      <xsl:apply-templates select="mdb:contentInfo"/>
      <!--<xsl:apply-templates select="mdb:distributionInfo"/>-->
      <xsl:copy-of select="$dpsDocument//mdb:distributionInfo"/>
      <xsl:apply-templates select="mdb:dataQualityInfo"/>
      <xsl:apply-templates select="mdb:resourceLineage"/>
      <xsl:apply-templates select="mdb:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="mdb:metadataConstraints"/>
      <xsl:apply-templates select="mdb:applicationSchemaInfo"/>
      <xsl:apply-templates select="mdb:metadataMaintenance"/>
      <xsl:apply-templates select="mdb:acquisitionInformation"/>
    </xsl:copy>
  </xsl:template>

  <!-- Copy DPS contact in the first pointOfContact -->
  <xsl:template match="mdb:identificationInfo/*/mri:pointOfContact[$hasDps][1]">
    <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:pointOfContact"/>
  </xsl:template>
  <xsl:template match="mdb:identificationInfo/*/mri:pointOfContact[$hasDps][position() > 1]"/>

  <xsl:template match="mdb:identificationInfo/*/mri:spatialRepresentationType[$hasDps]">
    <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:spatialRepresentationType"/>
  </xsl:template>

  <!-- Contact pour la ressource -->

  <!-- Copy challenge -->
  <xsl:template match="mri:descriptiveKeywords[$hasDps and (
              normalize-space(*/mri:thesaurusName/*/cit:title/gco:CharacterString) = 'Used by challenges' or
              normalize-space(*/mri:thesaurusName/*/cit:title/gco:CharacterString) = 'Production mode' or
              normalize-space(*/mri:thesaurusName/*/cit:title/gco:CharacterString) = 'GEMET - INSPIRE themes, version 1.0' or
              normalize-space(*/mri:thesaurusName/*/cit:title/gco:CharacterString) = 'Processing level of characteristics'
                        )]">
    <xsl:variable name="thesaurusKey"
                  select="*/mri:thesaurusName/*/cit:title/gco:CharacterString"/>
    <xsl:copy-of select="$dpsDocument//mdb:identificationInfo/*/mri:descriptiveKeywords[
                          normalize-space(*/mri:thesaurusName/*/cit:title/gco:CharacterString) =
                          $thesaurusKey]"/>
  </xsl:template>


  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
