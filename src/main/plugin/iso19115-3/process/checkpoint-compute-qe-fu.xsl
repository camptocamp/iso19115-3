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

  <xsl:param name="nodeUrl"/>

  <xsl:param name="debug" select="true()"/>

  <xsl:variable name="componentMatch" select="'.*/CP[0-9]*(/.*|$)'"/>

  <xsl:variable name="isTdp"
                select="count(
                            /mdb:MD_Metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Targeted Data Product']
                          ) = 1"/>

  <xsl:variable name="isUd"
                select="count(
                            /mdb:MD_Metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Upstream Data']
                          ) = 1"/>

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
                                    matches(*/@uuid, $componentMatch) and
                                    not(ends-with(*/@uuid, '#QE'))
                                    ]"/>

      <!-- For each component registered (and bypass QE or FU) -->
      <xsl:for-each select="mdb:dataQualityInfo/*[
                                  matches(@uuid, $componentMatch) and
                                  not(ends-with(@uuid, '#QE'))]">
        <xsl:variable name="componentId"
                      select="@uuid"/>
        <xsl:message>Processing component '<xsl:value-of select="$componentId"/>' ...</xsl:message>

        <xsl:variable name="dpsId"
                      select="tokenize($componentId, '/')[1]"/>
        <!--<xsl:variable name="dpsUrl"
                          select="concat($nodeUrl, 'api/records/', $dpsId, '/formatters/xml')"/>
        <xsl:message>DPS: <xsl:copy-of select="$dpsUrl"/></xsl:message>
        <xsl:variable name="dpsDocument"
          select="document($dpsUrl)"/>-->
        <xsl:variable name="dpsDocument"
                      select="java:getRecord($dpsId)"/>
        <!--<xsl:message>DPS: <xsl:copy-of select="$dpsDocument"/></xsl:message>-->
        <!--<xsl:message>DPS: <xsl:copy-of select="$dpsId"/></xsl:message>-->

        <xsl:choose>
          <xsl:when test="$isTdp">
            <xsl:call-template name="compute-qe">
              <xsl:with-param name="dps" select="$dpsDocument"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$isUd">
            <xsl:variable name="tdpId"
                          select="tokenize($componentId, '/')[3]"/>
            <xsl:variable name="tdpDocument"
                          select="java:getRecord($tdpId)"/>

            <xsl:call-template name="compute-qe">
              <xsl:with-param name="dps" select="$dpsDocument"/>
              <xsl:with-param name="tdp" select="$tdpDocument"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
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
    <xsl:param name="tdp" as="node()?"/>

    <xsl:variable name="cptId"
                  select="@uuid"/>
    <xsl:message>Computing derivated values for component <xsl:value-of select="$cptId"/> ...</xsl:message>

    <mdb:dataQualityInfo>
      <xsl:copy>
        <xsl:attribute name="uuid" select="concat($cptId, '#QE')"/>
        <xsl:apply-templates select="*" mode="qe">
          <xsl:with-param name="cptId" select="$cptId"/>
          <xsl:with-param name="dps" select="$dps"/>
          <xsl:with-param name="tdp" select="$tdp"/>
        </xsl:apply-templates>
      </xsl:copy>
    </mdb:dataQualityInfo>
  </xsl:template>




  <xsl:variable name="qConfig" select="document('checkpoint-expressions.xml')/expressions"/>




  <!-- Compute quality error based on measure -->
  <xsl:template match="*[*/mdq:measure]" mode="qe" priority="200">
    <xsl:param name="cptId"/>
    <xsl:param name="dps" as="node()"/>
    <xsl:param name="tdp" as="node()?"/>

    <xsl:variable name="qmId"
                  select="*/mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text()"/>
    <xsl:variable name="q"
                  select="$qConfig/qm[@id = $qmId]"/>

    <!-- Quality errors / start -->
    <!-- Derivated measure config -->
    <xsl:variable name="dm"
                  select="if ($isUd) then $q/udQe else $q/tdpQe"/>
    <xsl:variable name="expression"
                  select="replace($dm/@expression, '\.', '_')"/>

    <xsl:choose>
      <xsl:when test="$expression != ''">
        <xsl:variable name="qValue"
                      select="*/mdq:result/*/mdq:value/*/text()"/>

        <xsl:variable name="dpsCptId"
                      select="tokenize($cptId, '/')"/>
        <xsl:variable name="dpsValue"
                      select="$dps//mdq:DQ_DataQuality[
                                      @uuid = string-join($dpsCptId[position() &lt; 3], '/')
                                      ]/mdq:report/*[
                    mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $qmId
                  ]/mdq:result/*/mdq:value/*/text()"/>

        <xsl:variable name="params">
          <xsl:value-of select="concat(if ($isUd) then 'UD_' else 'TDP_', replace($qmId, '\.', '_'), '=', $qValue)"/>|
          <xsl:value-of select="concat('DPS_', replace($qmId, '\.', '_'), '=', $dpsValue)"/>
        </xsl:variable>

        <xsl:message>Compute qe for <xsl:value-of select="$qmId"/> using expression <xsl:value-of select="$expression"/> and with parameters <xsl:value-of select="normalize-space($params)"/></xsl:message>


        <!-- Variable names must start with a letter or the underscore _
        and can only include letters, digits or underscores. So replace
        . by _.-->
        <xsl:variable name="qeValue"
                      select="java:evaluate(
                        $expression,
                        $params)"/>

        <xsl:copy>
          <xsl:element name="{name(*[1])}">
            <mdq:measure>
              <mdq:DQ_MeasureReference>
                <mdq:measureIdentification>
                  <mcc:MD_Identifier>
                    <mcc:code>
                      <gco:CharacterString>
                        <xsl:value-of select="$dm/@id"/>
                      </gco:CharacterString>
                    </mcc:code>
                  </mcc:MD_Identifier>
                </mdq:measureIdentification>
                <mdq:nameOfMeasure>
                  <gco:CharacterString>
                    <xsl:value-of select="$dm/@name"/>
                  </gco:CharacterString>
                </mdq:nameOfMeasure>
                <mdq:measureDescription>
                  <gco:CharacterString>
                    <xsl:value-of select="$dm/text()"/>
                    <xsl:value-of select="$expression"/>
                  </gco:CharacterString>
                </mdq:measureDescription>
              </mdq:DQ_MeasureReference>
            </mdq:measure>
            <mdq:result>
              <mdq:DQ_QuantitativeResult>
                <mdq:dateTime>
                  <gco:Date></gco:Date>
                </mdq:dateTime>
                <mdq:value>
                  <gco:Record>
                    <xsl:choose>
                      <xsl:when test="string(number($qeValue)) = 'NaN'"/>
                      <xsl:otherwise>
                        <xsl:value-of select="$qeValue"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </gco:Record>
                </mdq:value>
                <mdq:valueUnit>
                  <gml:UnitDefinition>
                    <gml:identifier codeSpace="">%</gml:identifier>
                  </gml:UnitDefinition>
                </mdq:valueUnit>
                <mdq:valueRecordType>
                  <gco:RecordType>Percentage</gco:RecordType>
                </mdq:valueRecordType>
              </mdq:DQ_QuantitativeResult>
            </mdq:result>
          </xsl:element>
        </xsl:copy>
        <!-- Quality errors / end -->



        <!-- Fitness for use / start -->
        <xsl:if test="$isUd">
          <!-- Derivated measure config -->
          <xsl:variable name="dm"
                        select="$q/udFu"/>
          <xsl:variable name="expression"
                        select="replace($dm/@expression, '\.', '_')"/>

          <xsl:choose>
            <xsl:when test="$expression != ''">
              <!-- eg. abs(UD.APE.1.1)*P.APE.1.1/sqrt(UD.APE.1.1^2+P.APE.1.1^2) -->
              <xsl:variable name="tdpValue"
                            select="$tdp//mdq:DQ_DataQuality[@uuid = concat($cptId, '#QE')]/
                                      mdq:report/*[
                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() =
                                        concat('P.', replace($qmId, 'AP', 'APE'))
                                      ]/mdq:result/*/mdq:value/*/text()"/>
              <xsl:variable name="params">
                <!-- Rework variable ids to match how they are written in expressions -->
                <xsl:value-of select="concat('UD_', replace(replace($qmId, 'AP', 'APE'), '\.', '_'), '=', $qeValue)"/>|
                <xsl:value-of select="concat('P_', replace(replace($qmId, 'AP', 'APE'), '\.', '_'), '=', $tdpValue)"/>
              </xsl:variable>

              <xsl:message>Compute fu for <xsl:value-of select="$qmId"/> using expression <xsl:value-of select="$expression"/> and with parameters <xsl:value-of select="normalize-space($params)"/></xsl:message>

              <xsl:copy>
                <xsl:element name="{name(*[1])}">
                  <mdq:measure>
                    <mdq:DQ_MeasureReference>
                      <mdq:measureIdentification>
                        <mcc:MD_Identifier>
                          <mcc:code>
                            <gco:CharacterString>
                              <xsl:value-of select="$dm/@id"/>
                            </gco:CharacterString>
                          </mcc:code>
                        </mcc:MD_Identifier>
                      </mdq:measureIdentification>
                      <mdq:nameOfMeasure>
                        <gco:CharacterString>
                          <xsl:value-of select="$dm/@name"/>
                        </gco:CharacterString>
                      </mdq:nameOfMeasure>
                      <mdq:measureDescription>
                        <gco:CharacterString>
                          <xsl:value-of select="$dm/text()"/>
                          <xsl:value-of select="$expression"/>
                        </gco:CharacterString>
                      </mdq:measureDescription>
                    </mdq:DQ_MeasureReference>
                  </mdq:measure>
                  <mdq:result>
                    <mdq:DQ_QuantitativeResult>
                      <mdq:dateTime>
                        <gco:Date></gco:Date>
                      </mdq:dateTime>
                      <mdq:value>
                        <gco:Record>
                          <!-- Variable names must start with a letter or the underscore _
                          and can only include letters, digits or underscores. So replace
                          . by _.-->
                          <xsl:variable name="fuValue" select="java:evaluate(
                              $expression,
                              $params)"/>

                          <xsl:choose>
                            <xsl:when test="string(number($fuValue)) = 'NaN'">

                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$fuValue"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </gco:Record>
                      </mdq:value>
                      <mdq:valueUnit>
                        <gml:UnitDefinition>
                          <gml:identifier codeSpace="">%</gml:identifier>
                        </gml:UnitDefinition>
                      </mdq:valueUnit>
                      <mdq:valueRecordType>
                        <gco:RecordType>Percentage</gco:RecordType>
                      </mdq:valueRecordType>
                    </mdq:DQ_QuantitativeResult>
                  </mdq:result>
                </xsl:element>
              </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>No expression provided for fu <xsl:value-of select="$qmId"/>.</xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>No expression provided for qe <xsl:value-of select="$qmId"/>.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Ignore mdq:scope -->
  <xsl:template match="mdq:scope" mode="qe" priority="200"/>

  <!-- And copy everything else. -->
  <xsl:template match="@*|node()" mode="qe">
    <xsl:param name="cptId"/>
    <xsl:param name="dps"/>

    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="qe">
        <xsl:with-param name="cptId" select="$cptId"/>
        <xsl:with-param name="dps" select="$dps"/>
      </xsl:apply-templates>
    </xsl:copy>
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
