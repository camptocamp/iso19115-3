<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mas="http://standards.iso.org/iso/19115/-3/mas/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mda="http://standards.iso.org/iso/19115/-3/mda/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/1.0"
                xmlns:mdt="http://standards.iso.org/iso/19115/-3/mdt/1.0"
                xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                exclude-result-prefixes="#all"
                version="2.0">
  <xsl:output indent="yes"/>

  <!-- Updates related to MedSea form changes

  See https://docs.google.com/spreadsheets/d/1F1H1zzg04IgVnvUSVtY9_bkj8hWHhiv_Lj0YjBgXndo/edit#gid=1611821433 for details
  -->


  <!-- Add validation. -->
  <xsl:template match="mri:descriptiveKeywords[position() = last()]">
    <xsl:copy>
      <xsl:apply-templates select="@*|*"/>
    </xsl:copy>
    <mri:descriptiveKeywords>
      <mri:MD_Keywords>
        <mri:type>
          <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"
                                  codeListValue="theme"/>
        </mri:type>
        <mri:thesaurusName>
          <cit:CI_Citation>
            <cit:title>
              <gco:CharacterString>Validation</gco:CharacterString>
            </cit:title>
            <cit:date>
              <cit:CI_Date>
                <cit:date>
                  <gco:Date>2015-01-29</gco:Date>
                </cit:date>
                <cit:dateType>
                  <cit:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                                       codeListValue="publication"/>
                </cit:dateType>
              </cit:CI_Date>
            </cit:date>
            <cit:identifier>
              <mcc:MD_Identifier>
                <mcc:code>
                  <gcx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=local.theme.emodnet-checkpoint.status">geonetwork.thesaurus.local.theme.emodnet-checkpoint.status</gcx:Anchor>
                </mcc:code>
              </mcc:MD_Identifier>
            </cit:identifier>
          </cit:CI_Citation>
        </mri:thesaurusName>
      </mri:MD_Keywords>
    </mri:descriptiveKeywords>
  </xsl:template>



  <xsl:template match="mdq:report[*/mdq:measure/*/
                    mdq:measureIdentification/*/mcc:code/* = 'AP.4.1']">
    <xsl:copy>
      <xsl:apply-templates select="@*|*"/>
    </xsl:copy>

    <mdq:report>
      <mdq:DQ_UsabilityElement>
        <mdq:measure>
          <mdq:DQ_MeasureReference>
            <mdq:measureIdentification>
              <mcc:MD_Identifier>
                <mcc:code>
                  <gco:CharacterString>AP.5.1</gco:CharacterString>
                </mcc:code>
              </mcc:MD_Identifier>
            </mdq:measureIdentification>
            <mdq:nameOfMeasure>
              <gco:CharacterString>Usability</gco:CharacterString>
            </mdq:nameOfMeasure>
            <mdq:measureDescription>
              <gco:CharacterString></gco:CharacterString>
            </mdq:measureDescription>
          </mdq:DQ_MeasureReference>
        </mdq:measure>
        <mdq:result>
          <mdq:DQ_QuantitativeResult>
            <mdq:value>
              <gco:Record/>
            </mdq:value>
          </mdq:DQ_QuantitativeResult>
        </mdq:result>
        <mdq:result>
          <mdq:DQ_DescriptiveResult>
            <mdq:dateTime>
              <gco:Date/>
            </mdq:dateTime>
            <mdq:statement gco:nilReason="missing">
              <gco:CharacterString/>
            </mdq:statement>
          </mdq:DQ_DescriptiveResult>
        </mdq:result>
      </mdq:DQ_UsabilityElement>
    </mdq:report>
  </xsl:template>


  <xsl:template match="mcc:levelDescription[position() > 2]/*/
          mcc:other/gco:CharacterString[. != '']">
    <xsl:copy>
      <xsl:value-of select="concat(., ' (mandatory)')"/>
    </xsl:copy>
  </xsl:template>



  <xsl:template match="mri:resourceConstraints/mco:MD_Constraints">
    <!-- Add 2 use limitation to store expert score and opinion -->
    <mco:MD_Constraints>
      <mco:useLimitation>
        <gco:CharacterString></gco:CharacterString>
      </mco:useLimitation>
      <mco:useLimitation>
        <gco:CharacterString></gco:CharacterString>
      </mco:useLimitation>
    </mco:MD_Constraints>
  </xsl:template>


  <!--
  MD_LegalConstraints > useLimitation = removed from template and remove from editor
  MD_LegalConstraints > useConstraints = otherRestrictions (replace existing value)
  MD_LegalConstraints > otherConstraints (update editor)
  -->
  <xsl:template match="mco:MD_LegalConstraints">
    <xsl:copy>
      <mco:useConstraints>
        <mco:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
                                codeListValue="otherRestrictions"/>
      </mco:useConstraints>
      <mco:otherConstraints gco:nilReason="missing">
        <gco:CharacterString/>
      </mco:otherConstraints>
    </xsl:copy>
  </xsl:template>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|comment()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="gn:*" priority="2"/>
</xsl:stylesheet>
