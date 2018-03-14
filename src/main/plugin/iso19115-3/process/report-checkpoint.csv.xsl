<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                version="2.0" exclude-result-prefixes="#all">


  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:variable name="measures">
    <entry>AP.1.1</entry>
    <entry>AP.1.2</entry>
    <entry>AP.1.3</entry>
    <entry>AP.1.4</entry>
    <entry>AP.2.1</entry>
    <entry>AP.3.1</entry>
    <entry>AP.3.2</entry>
    <entry>AP.3.3</entry>
    <entry>AP.3.4</entry>
    <entry>AP.4.1</entry>
    <entry>AP.5.1</entry>
  </xsl:variable>


  <xsl:template match="/">
    <xsl:text>type;hierarchyLevel;status;challenge;UDp01;UDotherp01;UDp02;UDp03;processingLevel;productionMode;inspireTheme;</xsl:text>
    <xsl:text>UDenvMatrix;visibility;serviceExtent;policyVisibility;UDdataDelivery;UDdataPolicy;costBasis;readyness;</xsl:text>
    <xsl:text>responsiveness;spatialRepType;refSystem;useLimitation;useConstraints;dataFormats;</xsl:text>
    <xsl:text>uuid;productName;dates;extentWSEN;minZ;maxZ;minT;maxT;component;description;dqDate;covered;</xsl:text>
    <xsl:for-each select="$measures/entry">
      <xsl:variable name="mId" select="."/>

      <xsl:value-of select="."/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text> UOM;</xsl:text>
      <xsl:value-of select="concat(., ' ERROR')"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="concat(., ' FU')"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="$mId"/>
      <xsl:text> DESC</xsl:text>
      <xsl:text>;</xsl:text>

    </xsl:for-each>
    <xsl:text>lineage;spatialDims;CPTextentWSEN;CPTminZ;CPTmaxZ;CPTminT;CPTmaxT;program;provider;pointOfContact;DPSuuid;TDPuuid;UDuuids;</xsl:text>
    <xsl:text>link;catUrl;datasetUrl</xsl:text>
    <xsl:text>&#xA;</xsl:text>

    <xsl:apply-templates select="//mdb:MD_Metadata"/>
  </xsl:template>


  <xsl:template
    match="mdb:MD_Metadata"
    priority="2">

    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="metadata"
                  select="."/>

    <xsl:variable name="uuid"
                  select="normalize-space($metadata/mdb:metadataIdentifier/*/mcc:code/gco:CharacterString/text())"/>

    <xsl:variable name="hl"
                  select="normalize-space($metadata/mdb:metadataScope/mdb:MD_MetadataScope/
                          mdb:resourceScope/*/@codeListValue)"/>

    <xsl:variable name="isDps"
                  select="count(mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Data Product Specification']
                          ) = 1"/>

    <xsl:variable name="isTdp"
                  select="count(mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Targeted Data Product']
                          ) = 1"/>

    <xsl:variable name="isUd"
                  select="count(mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Upstream Data']
                          ) = 1"/>

    <xsl:variable name="p02"
                  select="string-join(mdb:identificationInfo/*/mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'NVS.P02')]/*/mri:keyword/*, ' | ')"/>


    <xsl:variable name="p01"
                  select="string-join(mdb:identificationInfo/*/mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'NVS.P01')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="otherp01"
                  select="string-join(mdb:identificationInfo/*/
                      mri:descriptiveKeywords/*
                      [contains(mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                      'Parameter Usage Vocabulary (other)')]/mri:keyword/*, ' | ')"/>

    <xsl:variable name="p03"
                  select="string-join(mdb:identificationInfo/*/mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'NVS.P03')]/*/mri:keyword/*, ' | ')"/>


    <xsl:variable name="challenges"
                  select="string-join(mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/*/cit:title/gco:CharacterString,
                            'Used by challenges')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="processingLevel"
                  select="string-join(mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                            'Processing level of characteristics')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="productionMode"
                  select="string-join(mdb:identificationInfo/*/
                              mri:descriptiveKeywords
                              [contains(*/mri:thesaurusName/*/cit:title/gco:CharacterString,
                              'Production mode')]/*/mri:keyword/*, ' | ')"/>


    <xsl:variable name="visibility"
                  select="string-join(mdb:identificationInfo/*/
                          mri:descriptiveKeywords
                          [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                          'emodnet-checkpoint.visibility')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="serviceExtent"
                  select="string-join(mdb:identificationInfo/*/
                          mri:descriptiveKeywords
                          [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                          'theme.emodnet-checkpoint.service.extent')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="readyness"
                  select="string-join(mdb:identificationInfo/*/
                          mri:descriptiveKeywords
                          [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                          'emodnet-checkpoint.readyness')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="policyVisibility"
                  select="string-join(mdb:identificationInfo/*/
                          mri:descriptiveKeywords
                          [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                          'emodnet-checkpoint.policy.visibility')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="dataDelivery"
                  select="string-join(mdb:identificationInfo/*/
                          mri:descriptiveKeywords
                          [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                          'Data delivery mechanism')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="dataPolicy"
                  select="string-join(replace(mdb:identificationInfo/*/
                          mri:resourceConstraints/mco:MD_LegalConstraints/mco:otherConstraints/*, '&#xA;', ''), ' | ')"/>

    <xsl:variable name="costBasis"
                  select="string-join(mdb:identificationInfo/*/
                            mri:resourceConstraints/mco:MD_Constraints/mco:useLimitation/*, ' | ')"/>

    <xsl:variable name="envMatrix"
                  select="string-join(mdb:identificationInfo/*/
                    mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                    'Environmental matrix')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="status"
                  select="string-join(mdb:identificationInfo/*/
                    mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'emodnet-checkpoint.status')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="program"
                  select="string-join(mdb:identificationInfo/*/
                              mri:pointOfContact[*/cit:role/*/@codeListValue='edmerp']/
                              */cit:party/*/cit:name/gco:CharacterString, ' | ')"/>

    <xsl:variable name="provider"
                  select="string-join(mdb:identificationInfo/*/
                              mri:pointOfContact[*/cit:role/*/@codeListValue='edmo']/
                              */cit:party/*/cit:name/gco:CharacterString, ' | ')"/>

    <xsl:variable name="dates"
                  select="string-join(mdb:identificationInfo/*/
                          mri:citation/*/cit:date[
                            */cit:dateType/*/@codeListValue = 'creation' or
                            */cit:dateType/*/@codeListValue = 'revision'], ' | ')"/>

    <xsl:variable name="pointOfContact"
                  select="string-join(mdb:identificationInfo/*/
                              mri:pointOfContact[*/cit:role/*/@codeListValue='pointOfContact']/
                              */cit:party/*/cit:name/gco:CharacterString, ' | ')"/>

    <xsl:variable name="responsiveness"
                  select="string-join(mdb:dataQualityInfo/*/
                      mdq:report/mdq:DQ_DomainConsistency[mdq:measure/*/mdq:nameOfMeasure/gco:CharacterString = 'Responsiveness']/
                      mdq:result/mdq:DQ_QuantitativeResult/mdq:value, ' | ')"/>

    <xsl:variable name="inspiretheme"
                  select="string-join(mdb:identificationInfo/*/
                              mri:descriptiveKeywords
                              [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                              'INSPIRE themes')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="spatialRepType"
                  select="string-join(mdb:identificationInfo/*/
                              mri:spatialRepresentationType/*/@codeListValue, ' | ')"/>

    <xsl:variable name="refSystem"
                  select="string-join(mdb:referenceSystemInfo/*/
                              mrs:referenceSystemIdentifier/*/mcc:code/*, ' | ')"/>


    <xsl:variable name="useLimitation"
                  select="replace(string-join(mdb:identificationInfo/*/
                              mri:resourceConstraints/*/mco:useLimitation, ' | '), '&#xA;', '')"/>

    <xsl:variable name="useConstraints"
                  select="replace(string-join(mdb:identificationInfo/*/
                              mri:resourceConstraints/*/mco:useConstraints/*/@codeListValue, ' | '), '&#xA;', '')"/>

    <xsl:variable name="dataFormats"
                  select="string-join(mdb:distributionInfo/*/mrd:distributionFormat/
                            mrd:MD_Format/mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/*, ' | ')"/>

    <xsl:choose>
      <xsl:when test="mdb:dataQualityInfo[*/matches(@uuid, '.*/CP[0-9]*(/.*|$)') and not(ends-with(@uuid, '#QE'))]">
        <xsl:for-each select="mdb:dataQualityInfo">
          <xsl:variable name="cptId" select="*/@uuid"/>

          <!-- Only report DQ mesure on CP - not QE which are added as column -->
          <xsl:if test="matches($cptId, '.*/CP[0-9]*(/.*|$)') and not(ends-with($cptId, '#QE'))">
            <!-- type -->
            <xsl:value-of select="if ($isDps) then 'DPS' else if ($isTdp) then 'TDP' else if ($isUd) then 'UD' else ''"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$hl"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$status"/>
            <xsl:text>;</xsl:text>

            <!-- challenge -->
            <xsl:value-of select="$challenges"/>
            <xsl:text>;</xsl:text>


            <!-- p01;p02;p03 -->
            <xsl:value-of select="$p01"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$otherp01"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$p02"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$p03"/>
            <xsl:text>;</xsl:text>


            <!-- ;processingLevel;productionMode -->
            <xsl:value-of select="$processingLevel"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$productionMode"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$inspiretheme"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$envMatrix"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$visibility"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$serviceExtent"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$policyVisibility"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$dataDelivery"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$dataPolicy"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$costBasis"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$readyness"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$responsiveness"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$spatialRepType"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$refSystem"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$useLimitation"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$useConstraints"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$dataFormats"/>
            <xsl:text>;</xsl:text>


            <!-- ;uuid;title;component; -->
            <xsl:value-of select="$uuid"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="normalize-space($metadata/mdb:identificationInfo/*/mri:citation/*/cit:title/*/text())"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$dates"/>
            <xsl:text>;</xsl:text>


            <xsl:value-of select="concat(
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:westBoundLongitude/*/text(), ',',
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:southBoundLatitude/*/text(), ',',
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:eastBoundLongitude/*/text(), ',',
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:northBoundLatitude/*/text()
            )"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:verticalElement/*/gex:minimumValue/text()"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:verticalElement/*/gex:maximumValue/text()"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:beginPosition/text()"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:endPosition/text()"/>
            <xsl:text>;</xsl:text>


            <!-- Checkpoint / Index component id.
              If not set, then index by dq section position. -->
            <xsl:variable name="cptName" select="*/mdq:scope/*/mcc:levelDescription[1]/*/mcc:other/*/text()"/>
            <xsl:variable name="cptDesc" select="replace(*/mdq:scope/*/mcc:levelDescription[2]/*/mcc:other/*/text(), '&#xA;', '')"/>
            <xsl:variable name="dqId" select="if ($cptId != '') then $cptId else position()"/>
            <xsl:variable name="cptCovered" select="*/mdq:standaloneQualityReport/*/mdq:reportReference/*/cit:title/*/text()"/>


            <xsl:value-of select="$cptCovered"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="normalize-space($cptName)"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$cptDesc"/>
            <xsl:text>;</xsl:text>


            <!-- Assuming only one date -->
            <xsl:variable name="dq" select="."/>

            <!--Date  -->
            <xsl:value-of select="string-join(distinct-values(
                          $dq/*/mdq:report/*/mdq:result/*/mdq:dateTime/*), ' | ')"/>
            <xsl:text>;</xsl:text>
            <xsl:for-each select="$measures/entry">
              <xsl:variable name="mId" select="."/>


              <xsl:variable name="report"
                            select="$dq/*/mdq:report/*[
                                      mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $mId
                                    ]"/>
              <xsl:variable name="value"
                            select="$report/mdq:result/mdq:DQ_QuantitativeResult/mdq:value/gco:Record/text()"/>

              <xsl:value-of select="$value"/>
              <xsl:text>;</xsl:text>
              <xsl:value-of select="if ($value != '')
                                    then $report/mdq:result/mdq:DQ_QuantitativeResult/mdq:valueUnit/*/gml:identifier/text()
                                    else ''"/>
              <xsl:text>;</xsl:text>

              <xsl:variable name="qeId"
                            select="concat(
                              (if ($isUd) then 'UD.' else 'P.'),
                              replace($mId/text(), 'AP', 'APE'))"/>
              <xsl:variable name="fuId"
                            select="concat(
                              (if ($isUd) then 'UD.' else 'P.'),
                              replace($mId/text(), 'AP', 'FU'))"/>
              <xsl:variable name="cptIdForQe"
                            select="substring-before($cptId, concat('/', $uuid))"/>
              <xsl:variable name="tdpQe"
                            select="$metadata/mdb:dataQualityInfo/*[starts-with(@uuid, $cptId)]
                                                      /mdq:report/*[
                                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $qeId
                                                      ]/mdq:result/*/mdq:value/*/text()"/>
              <xsl:variable name="tdpFu"
                            select="$metadata/mdb:dataQualityInfo/*[starts-with(@uuid, $cptId)]
                                                      /mdq:report/*[
                                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $fuId
                                                      ]/mdq:result/*/mdq:value/*/text()"/>
              <xsl:value-of select="$tdpQe"/>
              <xsl:text>;</xsl:text>
              <xsl:value-of select="$tdpFu"/>
              <xsl:text>;</xsl:text>
              <xsl:value-of select="replace($report/mdq:result/mdq:DQ_DescriptiveResult/
                                      mdq:statement/gco:CharacterString/text(), '&#xA;', '')"/>
              <xsl:text>;</xsl:text>
            </xsl:for-each>

            <!-- lineage; -->
            <xsl:value-of select="replace(string-join(*/mdq:scope/*/mcc:levelDescription[
                                                                    position() > 2
                                                                  ]//mcc:other[
                                                                    gco:CharacterString/text() != ''
                                                                  ], ','), '&#xA;', '')"/>
            <xsl:text>;</xsl:text>

            <!-- spatialDims;extent;minZ;maxZ;minT;maxT -->
            <xsl:variable name="hasExtent"
                          select="count(*/mdq:scope/*/mcc:extent[
                            */gex:geographicElement/*/gex:westBoundLongitude/*/text() != '' and
                            */gex:geographicElement/*/gex:eastBoundLongitude/*/text() != '' and
                            */gex:geographicElement/*/gex:southBoundLatitude/*/text() != '' and
                            */gex:geographicElement/*/gex:northBoundLatitude/*/text() != ''
                          ]) > 0"/>
            <xsl:if test="$hasExtent">
              <xsl:text>XY</xsl:text>
            </xsl:if>
            <xsl:if test="count(*/mdq:scope/*/mcc:extent[
                            */gex:temporalElement/*/gex:extent/*/gml:beginPosition/text() != ''
                            ]) > 0">
              <xsl:text>Z</xsl:text>
            </xsl:if>
            <xsl:if test="count(*/mdq:scope/*/mcc:extent[
                            */gex:verticalElement/*/gex:minimumValue/*/text() != '' and
                            */gex:verticalElement/*/gex:maximumValue/*/text() != ''
                            ]) > 0">
              <xsl:text>T</xsl:text>
            </xsl:if>
            <xsl:text>;</xsl:text>

            <xsl:value-of select="concat(
            */mdq:scope/*/mcc:extent/*/gex:geographicElement/*/gex:westBoundLongitude/*/text(), ',',
            */mdq:scope/*/mcc:extent/*/gex:geographicElement/*/gex:southBoundLatitude/*/text(), ',',
            */mdq:scope/*/mcc:extent/*/gex:geographicElement/*/gex:eastBoundLongitude/*/text(), ',',
            */mdq:scope/*/mcc:extent/*/gex:geographicElement/*/gex:northBoundLatitude/*/text()
            )"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="*/mdq:scope/*/mcc:extent/*/gex:verticalElement/*/gex:minimumValue/text()"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="*/mdq:scope/*/mcc:extent/*/gex:verticalElement/*/gex:maximumValue/text()"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="*/mdq:scope/*/mcc:extent/*/gex:temporalElement/*/gex:extent/*/gml:beginPosition/text()"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="*/mdq:scope/*/mcc:extent/*/gex:temporalElement/*/gex:extent/*/gml:endPosition/text()"/>
            <xsl:text>;</xsl:text>

            <xsl:value-of select="$program"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$provider"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="$pointOfContact"/>
            <xsl:text>;</xsl:text>

            <!-- DPSuuid;TDPuuid -->
            <xsl:value-of select="substring-before($cptId, '/')"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="substring-after(substring-after($cptId, '/'), '/')"/>
            <xsl:text>;</xsl:text>

            <!-- UDuuids-->
            <xsl:variable name="udUuids"
                          select="$metadata//mri:associatedResource/*[
                                mri:initiativeType/*/@codeListValue = 'upstreamData'
                              ]/mri:metadataReference/@uuidref"/>
            <xsl:for-each select="$udUuids">
              <xsl:variable name="title"
                            select="util:getIndexField('', string(.), '_defaultTitle', 'eng')"/>
              <xsl:value-of select="concat(., ' ', $title)"/>
              <xsl:text>#</xsl:text>
            </xsl:for-each>
            <xsl:text>;</xsl:text>


            <xsl:value-of select="concat(util:getSiteUrl(), '/', util:getNodeId(), '/metadata/', $uuid)"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="string-join($metadata/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine[1]/*/cit:linkage/*, '#')"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="replace(normalize-space($metadata/mdb:identificationInfo/*/mri:citation/*/cit:otherCitationDetails/*), '&#xA;', '')"/>

            <xsl:text>&#xA;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="if ($isDps) then 'DPS' else if ($isTdp) then 'TDP' else if ($isUd) then 'UD' else ''"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$hl"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$status"/>
        <xsl:text>;</xsl:text>

        <!-- challenge -->
        <xsl:value-of select="$challenges"/>
        <xsl:text>;</xsl:text>


        <!-- p01;p02;p03 -->
        <xsl:value-of select="$p01"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$otherp01"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$p02"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$p03"/>
        <xsl:text>;</xsl:text>


        <!-- ;processingLevel;productionMode -->
        <xsl:value-of select="$processingLevel"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$productionMode"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$inspiretheme"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$envMatrix"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$visibility"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$serviceExtent"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$policyVisibility"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$dataDelivery"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$dataPolicy"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$costBasis"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$readyness"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$responsiveness"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$spatialRepType"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$refSystem"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$useLimitation"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$useConstraints"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$dataFormats"/>
        <xsl:text>;</xsl:text>



        <!-- ;uuid;title;component; -->
        <xsl:value-of select="$uuid"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="normalize-space($metadata/mdb:identificationInfo/*/mri:citation/*/cit:title/*/text())"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$dates"/>
        <xsl:text>;</xsl:text>

        <xsl:value-of select="concat(
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:westBoundLongitude/*/text(), ',',
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:southBoundLatitude/*/text(), ',',
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:eastBoundLongitude/*/text(), ',',
            $metadata/mdb:identificationInfo/*/mri:extent/*/gex:geographicElement/*/gex:northBoundLatitude/*/text()
            )"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:verticalElement/*/gex:minimumValue/text()"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:verticalElement/*/gex:maximumValue/text()"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:beginPosition/text()"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$metadata/mdb:identificationInfo/*/mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:endPosition/text()"/>
        <xsl:text>;</xsl:text>


        <xsl:text>None described;</xsl:text>
        <!-- Empty measures, errors, fu and desc -->
        <xsl:text>;;;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;;;</xsl:text>
        <!--<xsl:for-each select="$measures/entry">
          <xsl:text>;</xsl:text>
        </xsl:for-each>-->
        <xsl:text>;;</xsl:text>
        <xsl:text>;;;;;</xsl:text>

        <xsl:value-of select="$program"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$provider"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$pointOfContact"/>
        <xsl:text>;;;;</xsl:text>

        <xsl:value-of select="concat(util:getSiteUrl(), '/', util:getNodeId(), '/metadata/', $uuid)"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="normalize-space($metadata/mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine[1]/*/cit:linkage/*)"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="replace(normalize-space($metadata/mdb:identificationInfo/*/mri:citation/*/cit:otherCitationDetails/*), '&#xA;', '')"/>

        <xsl:text>&#xA;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
