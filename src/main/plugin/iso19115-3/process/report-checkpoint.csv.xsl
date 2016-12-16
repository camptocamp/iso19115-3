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
    <entry>AP.2.1</entry>
    <entry>AP.3.1</entry>
    <entry>AP.3.2</entry>
    <entry>AP.3.3</entry>
    <entry>AP.3.4</entry>
    <entry>AP.4.1</entry>
  </xsl:variable>


  <xsl:template match="/">
    <xsl:text>type;challenge;p01;p02;p03;processingLevel;productionMode;inspireTheme;envMatrix;visibility;uuid;title;component;</xsl:text>
    <xsl:for-each select="$measures/entry">
      <xsl:value-of select="."/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text> UOM;</xsl:text>
      <xsl:value-of select="concat(., ' ERROR')"/>
      <xsl:text>;</xsl:text>
    </xsl:for-each>
    <xsl:text>lineage;spatialDims;extentWSEN;minZ;maxZ;minT;maxT;program;provider;DPSuuid;TDPuuid;UDuuids;link</xsl:text>
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

    <xsl:variable name="envMatrix"
                  select="string-join(mdb:identificationInfo/*/
                    mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                    'Environmental matrix')]/*/mri:keyword/*, ' | ')"/>

    <xsl:variable name="program"
                  select="string-join(mdb:identificationInfo/*/
                              mri:pointOfContact[*/cit:role/*/@codeListValue='edmerp']/
                              */cit:party/*/cit:name/gco:CharacterString, ' | ')"/>

    <xsl:variable name="provider"
                  select="string-join(mdb:identificationInfo/*/
                              mri:pointOfContact[*/cit:role/*/@codeListValue='edmo']/
                              */cit:party/*/cit:name/gco:CharacterString, ' | ')"/>

    <xsl:variable name="inspiretheme"
                  select="string-join(mdb:identificationInfo/*/
                              mri:descriptiveKeywords
                              [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                              'INSPIRE themes')]/*/mri:keyword/*, ' | ')"/>
    <xsl:choose>
      <xsl:when test="mdb:dataQualityInfo[*/matches(@uuid, '.*/CP[0-9]*(/.*|$)') and not(ends-with(@uuid, '#QE'))]">
        <xsl:for-each select="mdb:dataQualityInfo">
          <xsl:variable name="cptId" select="*/@uuid"/>

          <!-- Only report DQ mesure on CP - not QE which are added as column -->
          <xsl:if test="matches($cptId, '.*/CP[0-9]*(/.*|$)') and not(ends-with($cptId, '#QE'))">
            <!-- type -->
            <xsl:value-of select="if ($isDps) then 'DPS' else if ($isTdp) then 'TDP' else if ($isUd) then 'UD' else ''"/>
            <xsl:text>;</xsl:text>

            <!-- challenge -->
            <xsl:value-of select="$challenges"/>
            <xsl:text>;</xsl:text>


            <!-- p01;p02;p03 -->
            <xsl:value-of select="$p01"/>
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


            <!-- ;uuid;title;component; -->
            <xsl:value-of select="$uuid"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="normalize-space($metadata/mdb:identificationInfo/*/mri:citation/*/cit:title/*/text())"/>
            <xsl:text>;</xsl:text>


            <!-- Checpoint / Index component id.
              If not set, then index by dq section position. -->
            <xsl:variable name="cptName" select="*/mdq:scope/*/mcc:levelDescription[1]/*/mcc:other/*/text()"/>
            <xsl:variable name="dqId" select="if ($cptId != '') then $cptId else position()"/>

            <xsl:choose>
              <xsl:when test="count(*/mdq:standaloneQualityReport[*/mdq:reportReference/*/
                                  cit:title/*/text() = 'Component not covered']) > 0">
                <xsl:value-of select="concat(normalize-space($cptName), ': Not covered')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($cptName)"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>


            <!-- Assuming only one date -->
            <xsl:variable name="dq" select="."/>
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
              <xsl:variable name="cptIdForQe"
                            select="substring-before($cptId, concat('/', $uuid))"/>
              <xsl:variable name="tdpQe"
                            select="$metadata/mdb:dataQualityInfo/*[starts-with(@uuid, $cptId)]
                                                      /mdq:report/*[
                                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $qeId
                                                      ]/mdq:result/*/mdq:value/*/text()"/>
              <xsl:value-of select="$tdpQe"/>
              <xsl:text>;</xsl:text>
            </xsl:for-each>

            <!-- lineage; -->
            <xsl:value-of select="string-join(*/mdq:scope/*/mcc:levelDescription[
                                                                    position() > 2
                                                                  ]//mcc:other[
                                                                    gco:CharacterString/text() != ''
                                                                  ], ',')"/>
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

            <!-- DPSuuid;TDPuuid -->
            <xsl:value-of select="substring-before($cptId, '/')"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="substring-after(substring-after($cptId, '/'), '/')"/>
            <xsl:text>;</xsl:text>

            <!-- UDuuids-->
            <xsl:value-of select="string-join(
                            $metadata//mri:associatedResource/*[
                                mri:initiativeType/*/@codeListValue = 'upstreamData'
                              ]/mri:metadataReference/@uuidref,
                            '|')"/>
            <xsl:text>;</xsl:text>

            <xsl:value-of select="concat(util:getSiteUrl(), '/', util:getNodeId(), '/metadata/', $uuid)"/>

            <xsl:text>&#xA;</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="if ($isDps) then 'DPS' else if ($isTdp) then 'TDP' else if ($isUd) then 'UD' else ''"/>
        <xsl:text>;</xsl:text>

        <!-- challenge -->
        <xsl:value-of select="$challenges"/>
        <xsl:text>;</xsl:text>


        <!-- p01;p02;p03 -->
        <xsl:value-of select="$p01"/>
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



        <!-- ;uuid;title;component; -->
        <xsl:value-of select="$uuid"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="normalize-space($metadata/mdb:identificationInfo/*/mri:citation/*/cit:title/*/text())"/>
        <xsl:text>;</xsl:text>
        <xsl:text>None described</xsl:text>
        <xsl:text>;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;</xsl:text>
        <xsl:text>;;;;;;;;;;</xsl:text>
        <!--<xsl:for-each select="$measures/entry">
          <xsl:text>;</xsl:text>
        </xsl:for-each>-->
        <xsl:text>;;</xsl:text>
        <xsl:text>;;;;;</xsl:text>

        <xsl:value-of select="$program"/>
        <xsl:text>;</xsl:text>
        <xsl:value-of select="$provider"/>
        <xsl:text>;;;</xsl:text>

        <xsl:value-of select="concat(util:getSiteUrl(), '/', util:getNodeId(), '/metadata/', $uuid)"/>

        <xsl:text>&#xA;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
