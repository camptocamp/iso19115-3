<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                version="2.0" exclude-result-prefixes="#all">

  <xsl:param name="nodeUrl"/>

  <xsl:param name="debug" select="true()"/>
  <xsl:variable name="componentMatch" select="'.*/CP#[0-9]*$'"/>

  <xsl:template match="/mdb:MD_Metadata|*[@gco:isoType='mdb:MD_Metadata']">
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
      <xsl:apply-templates select="mdb:referenceSystemInfo"/>
      <xsl:apply-templates select="mdb:metadataExtensionInfo"/>
      <xsl:apply-templates select="mdb:identificationInfo"/>
      <xsl:apply-templates select="mdb:contentInfo"/>
      <xsl:apply-templates select="mdb:distributionInfo"/>

      <!-- Copy existing quality measures and do not copy QE or FU.
           Distinction is made by the fact that QE and FU do not provide
           component details.
            -->
      <xsl:apply-templates select="mdb:dataQualityInfo[
                                    count(*/mdq:scope/*/mcc:levelDescription) = 1 and
                                    matches(*/@uuid, $componentMatch)]"/>


      <xsl:variable name="isTdp"
                    select="count(
                            mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Targeted Data Product']
                          ) = 1"/>

      <xsl:variable name="isUd"
                    select="count(
                            mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint']
                          ) = 1"/>

      <!-- For each component registered (and bypass QE or FU) -->
      <xsl:for-each select="mdb:dataQualityInfo/*[matches(@uuid, $componentMatch)]">
        <xsl:variable name="componentId"
                      select="@uuid"/>
        <xsl:message>Processing component '<xsl:value-of select="$componentId"/>' ...</xsl:message>

        <xsl:variable name="dpsId"
                      select="substring-before($componentId, '/')"/>
        <!--<xsl:variable name="dpsUrl"
                          select="concat($nodeUrl, 'api/records/', $dpsId, '/formatters/xml')"/>
        <xsl:message>DPS: <xsl:copy-of select="$dpsUrl"/></xsl:message>
        <xsl:variable name="dpsDocument"
          select="document($dpsUrl)"/>-->
        <xsl:variable name="dpsDocument"
                      select="java:getRecord($dpsId)"/>
        <!--<xsl:message>DPS: <xsl:copy-of select="$dpsDocument"/></xsl:message>-->

        <xsl:if test="$isTdp or $isUd">
          <xsl:call-template name="compute-qe">
            <xsl:with-param name="dps" select="$dpsDocument"/>
          </xsl:call-template>
        </xsl:if>


        <xsl:if test="$isUd">
          <xsl:variable name="tdpId"
                        select="''"/>
          <xsl:variable name="tdpDocument"
                        select="."/>
          <xsl:call-template name="compute-fu">
            <xsl:with-param name="dps" select="$dpsDocument"/>
            <xsl:with-param name="tdp" select="$tdpDocument"/>
          </xsl:call-template>
        </xsl:if>

      </xsl:for-each>

      <xsl:apply-templates select="mdb:resourceLineage"/>
      <xsl:apply-templates select="mdb:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="mdb:metadataConstraints"/>
      <xsl:apply-templates select="mdb:applicationSchemaInfo"/>
      <xsl:apply-templates select="mdb:metadataMaintenance"/>
      <xsl:apply-templates select="mdb:acquisitionInformation"/>
    </xsl:copy>
  </xsl:template>



  <xsl:template name="compute-qe">
    <xsl:param name="dps" as="node()"/>
    <xsl:message>Creating QE ...</xsl:message>

    <mdb:dataQualityInfo>
      <xsl:copy>
        <xsl:attribute name="uuid" select="concat(@uuid, '#QE')"/>
        <xsl:apply-templates select="*"/>
      </xsl:copy>
    </mdb:dataQualityInfo>
  </xsl:template>




  <xsl:template name="compute-fu">
    <xsl:param name="dps" as="node()"/>
    <xsl:param name="tdp" as="node()"/>

    <xsl:message>Creating FU ...</xsl:message>
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
