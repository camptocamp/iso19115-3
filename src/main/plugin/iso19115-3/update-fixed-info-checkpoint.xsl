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
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
  xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:java="java:org.fao.geonet.util.XslUtil"
  xmlns:mime="java:org.fao.geonet.util.MimeTypeFinder"
  xmlns:gn="http://www.fao.org/geonetwork"
  exclude-result-prefixes="#all">

  <xsl:variable name="componentScopeCode" as="xs:string"
                select="'datasetComponent'"/>
  <xsl:variable name="componentCodeSeparator" as="xs:string"
                select="'/CP'"/>

  <xsl:variable name="dateFormat" as="xs:string"
                select="'[Y0001]-[M01]-[D01]'"/>

  <xsl:variable name="isDps"
                select="count(
                            /root/mdb:MD_Metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Data Product Specification']
                          ) = 1"/>

  <xsl:variable name="isTdp"
                select="count(
                            /root/mdb:MD_Metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Targeted Data Product']
                          ) = 1"/>

  <xsl:variable name="isUd"
                select="count(
                            /root/mdb:MD_Metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Upstream Data']
                          ) = 1"/>



  <xsl:variable name="product2deliverables">
    <entry key='MEDSEA_CH1_Product_1 / Wind and wave data set from MARINA project' value='MEDSEA D2.3.5'/>
    <entry key='MEDSEA_CH1_Product_2 / Suitability index of a wind farm in the NWMed concerning the environmental resources' value='MEDSEA D2.3.5'/>
    <entry key='MEDSEA_CH1_Product_3 / Suitability index of a wind farm in the NWMed concerning the environmental resources, the natural barriers, human activities, MPA and fisheries.' value='MEDSEA D2.3.5'/>
    <entry key='MEDSEA_CH2_Product_1 / Med protection initiatives (management and conservation areas)' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Product_2 / Med conservation areas and depth zones' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Product_3 / Proposed regional conservation areas in the Mediterranean' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Product_4 / Qualitative analysis of connectivity between MPAs' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Product_5 / Representativity of habitats/species/other features' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Product_6 / The monitoring capacity of biodiversity in MPAs' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH3_Product_1 / Oil Platform Leak Bulletin released after a DG MARE request received by email on the 28th of July 2014' value='MEDSEA D4.3.5'/>
    <entry key='MEDSEA_CH3_Product_2 / Oil Platform Leak Bulletin released after the DG MARE alert received by email on the 10th of May 2016' value='MEDSEA D4.3.5'/>
    <entry key='MEDSEA_CH4_Product_1 / Spatial layers of Sea surface temperature trend from observations (HadISST dataset) over periods of 10 (2003 – 2012), 50 (1963-2012) and 100 (1913-2012) years. Basin maps and NUTS3 region are considered' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_2 / Spatial layer of Sea temperature trend at mid-depth and at sea-bottom from reanalysis (CMEMS Mediterranean Physics Reanalysis) over period of 10 (2003 – 2012) years' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_3 / Spatial layer of Sea internal energy trend from reanalysis (CMEMS Mediterranean Physics Reanalysis) over period of 20 (1993 – 2012) years' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_4 / Spatial layers of sea level trend from MyOcean-CMCC reconstruction over periods of 50 years (1963 – 2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_5 / Spatial layer of sea-level trend from AVISO reconstruction over period of 10 years (2003 – 2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_6 / Spatial layers of sea–level trend from PSMSL tide-gauges over periods of 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_7 / Sediment Mass Balance at the Coast from Experts Survey and Scientific Literature Review' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_8 / Time series of annual average sea surface temperature from observations (HadISST dataset) over periods of 10 years (2003-2012), 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_9 / Time series of annual average sea temperature at mid-depth and sea-bottom from reanalysis (CMEMS Mediterranean Physics Reanalysis dataset) over period of 10 years (2003-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_10 / Time series of annual average sea internal energy from reanalysis (CMEMS Mediterranean Physics Reanalysis dataset) over period of 20 years (1993-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_11 / Time series of annual average sea level from MyOcean-CMCC reconstruction over periods of 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_12 / Time series of annual average sea level from PSMSL time-gauges over periods of 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Product_13 / Time series of annual average sea-level from AVISO satellite altimetry over period of 10 years (2003-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH5_Product_1 / Collated data set of fish landings by species and year, for mass and number' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_2 / Collated data set of fish discards by species and year, for mass and number' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_3 / Collated data set of fish bycatch by species and year, for mass and number' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_4 / Impact of fisheries on the bottom from VMS data combined with seabed substrate and habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_5 / Change level of disturbance from VMS data combined with habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_6 / Impact of fisheries on the bottom from AIS data combined with seabed substrate and habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_7 / Change level of disturbance from AIS data combined with habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Product_8 / Impact of fisheries on the bottom from Data Logger combined with seabed substrate and habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH6_product_1 / Maps of Chlorophyll concentration seasonal climatologies (i.e., Winter, Spring, Summer, and Fall) over the Mediterranean Sea relative to the period 1998-2009.' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH6_product_2 / Map of Chlorophyll concentration trend over the Mediterranean Sea, relative to the period 1998-2009, expressed as percent of variation respect to the climatological field' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH6_product_3 / Maps of average TRIX indices calculated from Mediterranean sea surface data for the periods 2008-2012, 1998-2002, and 1993-1997' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH6_product_4 / Maps showing differences between most recent TRIX estimates (2008-2012) and TRIX from the earlier periods 1998-2002 and 1993-1997' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH7_Product_1 / Annual time series of Water Discharge (Qw) [m3/s]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_2 / Monthly time series of Water Discharge (Qw) [m3/s]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_3 / Annual time series of TSM from satellite data' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_4 / Monthly time series of TSM from satellite data' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_5 / Annual time series of Total Nitrogen [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_6 / Monthly time series of Total Nitrogen from model data [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_7 / Annual time series of Total Phosphorous/Phosphates [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_8 / Monthly time series of Total Phosphorous from model data [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Product_9 / Annual time series of Eels production[tons]' value='MEDSEA D8.3.5'/>

    <entry key='MEDSEA_CH1_Specification_1 / Wind and wave data set from MARINA project' value='MEDSEA D2.3.5'/>
    <entry key='MEDSEA_CH1_Specification_2 / Suitability index of a wind farm in the NWMed concerning the environmental resources' value='MEDSEA D2.3.5'/>
    <entry key='MEDSEA_CH1_Specification_3 / Suitability index of a wind farm in the NWMed concerning the environmental resources, the natural barriers, human activities, MPA and fisheries.' value='MEDSEA D2.3.5'/>
    <entry key='MEDSEA_CH2_Specification_1 / Med protection initiatives (management and conservation areas)' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Specification_2 / Med conservation areas and depth zones' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Specification_3 / Proposed regional conservation areas in the Mediterranean' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Specification_4 / Qualitative analysis of connectivity between MPAs' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Specification_5 / Representativity of habitats/species/other features' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH2_Specification_6 / The monitoring capacity of biodiversity in MPAs' value='MEDSEA D3.3.5'/>
    <entry key='MEDSEA_CH3_Specification_1 / Oil Platform Leak Bulletin released after a DG MARE request received by email on the 28th of July 2014' value='MEDSEA D4.3.5'/>
    <entry key='MEDSEA_CH3_Specification_2 / Oil Platform Leak Bulletin released after the DG MARE alert received by email on the 10th of May 2016' value='MEDSEA D4.3.5'/>
    <entry key='MEDSEA_CH4_Specification_1 / Spatial layers of Sea surface temperature trend from observations (HadISST dataset) over periods of 10 (2003 – 2012), 50 (1963-2012) and 100 (1913-2012) years. Basin maps and NUTS3 region are considered' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_2 / Spatial layer of Sea temperature trend at mid-depth and at sea-bottom from reanalysis (CMEMS Mediterranean Physics Reanalysis) over period of 10 (2003 – 2012) years' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_3 / Spatial layer of Sea internal energy trend from reanalysis (CMEMS Mediterranean Physics Reanalysis) over period of 20 (1993 – 2012) years' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_4 / Spatial layers of sea level trend from MyOcean-CMCC reconstruction over periods of 50 years (1963 – 2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_5 / Spatial layer of sea-level trend from AVISO reconstruction over period of 10 years (2003 – 2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_6 / Spatial layers of sea–level trend from PSMSL tide-gauges over periods of 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_7 / Sediment Mass Balance at the Coast from Experts Survey and Scientific Literature Review' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_8 / Time series of annual average sea surface temperature from observations (HadISST dataset) over periods of 10 years (2003-2012), 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_9 / Time series of annual average sea temperature at mid-depth and sea-bottom from reanalysis (CMEMS Mediterranean Physics Reanalysis dataset) over period of 10 years (2003-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_10 / Time series of annual average sea internal energy from reanalysis (CMEMS Mediterranean Physics Reanalysis dataset) over period of 20 years (1993-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_11 / Time series of annual average sea level from MyOcean-CMCC reconstruction over periods of 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_12 / Time series of annual average sea level from PSMSL time-gauges over periods of 50 years (1963-2012) and 100 years (1913-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH4_Specification_13 / Time series of annual average sea-level from AVISO satellite altimetry over period of 10 years (2003-2012)' value='MEDSEA D5.3.5'/>
    <entry key='MEDSEA_CH5_Specification_1 / Collated data set of fish landings by species and year, for mass and number' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_2 / Collated data set of fish discards by species and year, for mass and number' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_3 / Collated data set of fish bycatch by species and year, for mass and number' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_4 / Impact of fisheries on the bottom from VMS data combined with seabed substrate and habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_5 / Change level of disturbance from VMS data combined with habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_6 / Impact of fisheries on the bottom from AIS data combined with seabed substrate and habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_7 / Change level of disturbance from AIS data combined with habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH5_Specification_8 / Impact of fisheries on the bottom from Data Logger combined with seabed substrate and habitat vulnerability' value='MEDSEA D6.3.5'/>
    <entry key='MEDSEA_CH6_Specification_1 / Maps of Chlorophyll concentration seasonal climatologies (i.e., Winter, Spring, Summer, and Fall) over the Mediterranean Sea relative to the period 1998-2009.' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH6_Specification_2 / Map of Chlorophyll concentration trend over the Mediterranean Sea, relative to the period 1998-2009, expressed as percent of variation respect to the climatological field' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH6_Specification_3 / Maps of average TRIX indices calculated from Mediterranean sea surface data for the periods 2008-2012, 1998-2002, and 1993-1997' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH6_Specification_4 / Maps showing differences between most recent TRIX estimates (2008-2012) and TRIX from the earlier periods 1998-2002 and 1993-1997' value='MEDSEA D7.3.5'/>
    <entry key='MEDSEA_CH7_Specification_1 / Annual time series of Water Discharge (Qw) [m3/s]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_2 / Monthly time series of Water Discharge (Qw) [m3/s]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_3 / Annual time series of TSM from satellite data' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_4 / Monthly time series of TSM from satellite data' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_5 / Annual time series of Total Nitrogen [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_6 / Monthly time series of Total Nitrogen from model data [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_7 / Annual time series of Total Phosphorous/Phosphates [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_8 / Monthly time series of Total Phosphorous from model data [mg/l]' value='MEDSEA D8.3.5'/>
    <entry key='MEDSEA_CH7_Specification_9 / Annual time series of Eels Specificationion[tons]' value='MEDSEA D8.3.5'/>

    <entry key='ATLANTIC_CH' value='Not Applicable'/>
    <entry key='BLACKSEA_CH' value='Not Applicable'/>
  </xsl:variable>

  <!-- In TDP set deliverable info if not set based on product name -->
  <xsl:template
    match="cit:issueIdentification[($isTdp or $isDps)]"
    priority="2000">

    <xsl:variable name="product"
                  select="ancestor::cit:CI_Citation/cit:title/gco:CharacterString/text()"/>

    <xsl:variable name="deliverable"
                  select="$product2deliverables/entry[contains($product, @key)]/@value"/>
    <xsl:copy>
      <xsl:copy-of select="./@*"/>
      <gco:CharacterString><xsl:value-of select="if ($deliverable != '') then $deliverable else ''"/></gco:CharacterString>
    </xsl:copy>
  </xsl:template>



  <!-- Compute title and identifier as "P02 - P01 - Dataprovider - Datasetname" -->
  <xsl:template
    match="mdb:MD_Metadata[$isUd and
                    contains(mdb:metadataStandard/
                                        */cit:title/gco:CharacterString, 'Emodnet Checkpoint')]/
                      mdb:identificationInfo/*/mri:citation/cit:CI_Citation/
                        cit:title/gco:CharacterString|
                  mdb:MD_Metadata[$isUd and
                    contains(mdb:metadataStandard/
                                        */cit:title/gco:CharacterString, 'Emodnet Checkpoint')]/
                      mdb:identificationInfo/*/mri:citation/cit:CI_Citation/
                        cit:identifier/mcc:MD_Identifier/
                          mcc:code/gco:CharacterString"
    priority="200">
    <!-- String join in case of multiple but this should not happen -->
    <xsl:variable name="p02" select="string-join(ancestor::mdb:MD_Metadata/mdb:identificationInfo/*/
                    mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'NVS.P02')]/*/mri:keyword/*, ' | ')"/>


    <xsl:variable name="P01" select="string-join(ancestor::mdb:MD_Metadata/mdb:identificationInfo/*/
                    mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'parameter.NVS.P01')]/*/mri:keyword/*, ' | ')"/>
    <xsl:variable name="otherP01" select="string-join(ancestor::mdb:MD_Metadata/mdb:identificationInfo/*/
                      mri:descriptiveKeywords/*
                      [contains(mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                      'Parameter Usage Vocabulary (other)')]/mri:keyword/*, ' | ')"/>
    <xsl:variable name="tokenP01"
                  select="if ($P01 = '') then $otherP01 else $P01"/>

    <xsl:variable name="edmoProvider" select="ancestor::mdb:MD_Metadata/mdb:identificationInfo/*/mri:pointOfContact[*/cit:role/*/@codeListValue='edmo']/*/cit:party/*/cit:name/gco:CharacterString"/>


    <xsl:variable name="dataSetName" select="ancestor::mdb:MD_Metadata/mdb:identificationInfo/*/mri:citation/*/cit:alternateTitle[1]/gco:CharacterString"/>

    <xsl:copy>
      <xsl:value-of select="concat($p02, ' | ', $tokenP01, ' | ', $edmoProvider[1], ' | ', $dataSetName)"/>
    </xsl:copy>
  </xsl:template>



  <!-- Component / Set UUID if empty or not starting with DPS UUID.

  Do not apply this rule to TDP or UD as we need to preserve component UUID
  from DPS to TDP and UD.
  Component UUID is based on DPS UUID + DQ position.
  -->
  <xsl:template match="mdb:MD_Metadata[$isDps]
                          /mdb:dataQualityInfo[
                            */mdq:scope/*/mcc:level/*/@codeListValue = $componentScopeCode
                            and (
                              not(*/@uuid) or */@uuid = '' or not(starts-with(*/@uuid, /root/env/uuid)))
                            ]">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <mdq:DQ_DataQuality>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="uuid"
                       select="concat(/root/env/uuid,
                                      $componentCodeSeparator,
                                      position())"/>
        <xsl:apply-templates select="*/*"/>
      </mdq:DQ_DataQuality>
    </xsl:copy>
  </xsl:template>



  <!-- When creating a component, the extent is based
       on the extent of the DPS. -->
  <xsl:template match="mdb:dataQualityInfo[
                          not($isUd) and
                          */mdq:scope/*/mcc:level/*/@codeListValue = $componentScopeCode
                          and (
                            not(*/@uuid) or */@uuid = '' or not(starts-with(*/@uuid, /root/env/uuid)))
                            ]/*/mdq:scope/*[not(mcc:extent)]">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="mcc:level"/>
      <xsl:apply-templates select="mcc:levelDescription"/>

      <xsl:variable name="extent"
                    select="ancestor::mdb:MD_Metadata/mdb:identificationInfo/*/
                                mri:extent[1]/*"/>
      <mcc:extent>
        <gex:EX_Extent>
          <xsl:copy-of select="$extent/gex:geographicElement"/>
          <gex:temporalElement>
            <gex:EX_TemporalExtent>
              <gex:extent>
                <gml:TimePeriod>
                  <xsl:copy-of select="$extent/gex:temporalElement//gml:TimePeriod/@id"
/>
                  <xsl:choose>
                    <xsl:when test="$extent/gex:temporalElement//gml:TimePeriod/gml:beginPosition">
                      <xsl:copy-of select="$extent/gex:temporalElement//gml:TimePeriod/gml:beginPosition"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <gml:beginPosition></gml:beginPosition>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$extent/gex:temporalElement//gml:TimePeriod/gml:endPosition">
                      <xsl:copy-of select="$extent/gex:temporalElement//gml:TimePeriod/gml:endPosition"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <gml:endPosition></gml:endPosition>
                    </xsl:otherwise>
                  </xsl:choose>
                </gml:TimePeriod>
              </gex:extent>
            </gex:EX_TemporalExtent>
          </gex:temporalElement>
          <xsl:copy-of select="$extent/gex:verticalElement"/>
        </gex:EX_Extent>
      </mcc:extent>
    </xsl:copy>
  </xsl:template>



  <!-- Component / Set date of each measure if empty

   This basically means that when the user click add component
   based on a template with empty dates, then dates are initialized
   to current date time.
   -->
  <xsl:template match="mdq:result/*/mdq:dateTime/gco:Date[normalize-space() = '']" priority="200">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="format-dateTime(current-dateTime(), $dateFormat)"/>
    </xsl:copy>
  </xsl:template>



  <!-- Component in UD does not contains component details ie. only uuid and name.

   We used to remove extent.
                       mdb:MD_Metadata[$isUd]
                          /mdb:dataQualityInfo/*/mdq:scope/*[
                            mcc:level/*/@codeListValue = $componentScopeCode
                            ]/mcc:extent
   -->
  <xsl:template match="mdb:MD_Metadata[$isUd]
                          /mdb:dataQualityInfo/*/mdq:scope/*[
                            mcc:level/*/@codeListValue = $componentScopeCode
                            ]/mcc:levelDescription[position() > 1]"/>



  <!-- If a component is removed, remove also related QE or FU -->
  <xsl:template match="mdb:dataQualityInfo[ends-with(*/@uuid, '#QE')]" priority="200">
    <xsl:variable name="qeUuid" select="*/uuid"/>

    <xsl:if test="count(/root/mdb:MD_Metadata/mdb:dataQualityInfo[
                            starts-with(*/@uuid, $qeUuid) and not(ends-with(*/@uuid, '#QE'))
                          ]) > 0">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|*"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>


  <!--
      Compute number of characteristics value based
      on the number of lineage for the component.
      For Upstream data, this is not applicable.
  -->
  <xsl:template match="mdb:dataQualityInfo/*/mdq:report/*[
                          mdq:measure/*/mdq:nameOfMeasure/*/text() =
                          'Number of Characteristics'
                        ]/mdq:result/*/mdq:value"
                priority="2000">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="$isUd">
          <xsl:attribute name="gco:nilReason" select="'inapplicable'"/>
          <gco:Record/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="currentValue"
                        select="normalize-space(gco:Record)"/>
          <xsl:variable name="numberOfLineage"
                        select="count(ancestor::mdb:dataQualityInfo/*/mdq:scope/*/mcc:levelDescription) - 2"/>
          <gco:Record>
            <xsl:value-of select="if ($currentValue != '')
                                  then $currentValue
                                  else $numberOfLineage"/>
          </gco:Record>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Set nilReason to inapplicable to all
  QM without any value. -->
  <xsl:template match="mdb:dataQualityInfo/*/mdq:report/*/mdq:result/*/mdq:value"
                priority="1000">
    <xsl:copy>
      <xsl:if test="gco:Record = ''">
        <xsl:attribute name="gco:nilReason" select="'inapplicable'"/>
      </xsl:if>
      <xsl:copy-of select="gco:Record" copy-namespaces="no"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
