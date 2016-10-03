<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gn-fn-iso19115-3="http://geonetwork-opensource.org/xsl/functions/profiles/iso19115-3"
  exclude-result-prefixes="#all">

  <xsl:import href="../layout/utility-fn.xsl"/>

  <xsl:param name="urlPrefix"
             select="'http://www.emodnet-mediterranean.eu/documents/'"/>

  <xsl:param name="urlSuffix"
             select="'.pdf'"/>

  <xsl:variable name="linkName"
                select="'Deliverable report '"/>

  <xsl:variable name="metadataIdentifier"
                select="/mdb:MD_Metadata/mdb:metadataIdentifier[position() = 1]/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>

  <xsl:variable name="deliverableIdentifier"
                select="/mdb:MD_Metadata/mdb:identificationInfo/*/mri:citation/
                            */cit:series/*/cit:issueIdentification/gco:CharacterString/text()"/>

  <xsl:template match="/mdb:MD_Metadata|*[contains(@gco:isoType, 'mdb:MD_Metadata')]">
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

      <xsl:if test="$deliverableIdentifier != ''">
        <mdb:distributionInfo>
          <mrd:MD_Distribution>
            <mrd:transferOptions>
              <mrd:MD_DigitalTransferOptions>
                <xsl:call-template name="createOnlineSrc"/>
              </mrd:MD_DigitalTransferOptions>
            </mrd:transferOptions>
          </mrd:MD_Distribution>
        </mdb:distributionInfo>
      </xsl:if>

      <xsl:apply-templates select="mdb:dataQualityInfo"/>
      <xsl:apply-templates select="mdb:resourceLineage"/>
      <xsl:apply-templates select="mdb:portrayalCatalogueInfo"/>
      <xsl:apply-templates select="mdb:metadataConstraints"/>
      <xsl:apply-templates select="mdb:applicationSchemaInfo"/>
      <xsl:apply-templates select="mdb:metadataMaintenance"/>
      <xsl:apply-templates select="mdb:acquisitionInformation"/>

    </xsl:copy>
  </xsl:template>


  <xsl:template name="createOnlineSrc">
    <mrd:onLine>
      <cit:CI_OnlineResource>
        <cit:linkage>
          <gco:CharacterString>
            <xsl:value-of select="concat($urlPrefix, $deliverableIdentifier, $urlSuffix)"/>
          </gco:CharacterString>
        </cit:linkage>

        <cit:protocol>
          <gco:CharacterString>WWW-LINK</gco:CharacterString>
        </cit:protocol>

        <cit:name>
          <gco:CharacterString>
            <xsl:value-of select="concat($linkName, $deliverableIdentifier)"/>
          </gco:CharacterString>
        </cit:name>
      </cit:CI_OnlineResource>
    </mrd:onLine>
  </xsl:template>


  <!-- Remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>

  <!-- Copy everything. -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
