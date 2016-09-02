<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">

  <!--
   This is an example template to display quality measures
   as a simple table view. In this table, only values can be edited.
  -->
  <xsl:template name="iso19115-3-qm">
    <xsl:param name="config" as="node()?"/>

    <xsl:variable name="format" select="'#0'"></xsl:variable>

    <xsl:variable name="isDps"
                  select="count(
                            $metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Data Product Specification']
                          ) = 1"/>

    <xsl:variable name="isTdp"
                  select="count(
                            $metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Targeted Data Product']
                          ) = 1"/>

    <xsl:variable name="isUd"
                  select="count(
                            $metadata/mdb:metadataStandard/*/cit:title/*[text() =
                              'ISO 19115-3 - Emodnet Checkpoint - Upstream Data']
                          ) = 1"/>

    <!-- Component is in a section -->
    <xsl:variable name="cptId" select="*/@uuid[contains(., '/CP')]"/>

    <xsl:if test="matches($cptId, '.*/CP[0-9]*(/.*|$)') and not(ends-with($cptId, '#QE'))">
      <xsl:call-template name="render-boxed-element">
        <xsl:with-param name="label"
                        select="concat($strings/checkpoint-dps-component, ' ')"/>
        <xsl:with-param name="editInfo" select="gn:element"/>
        <xsl:with-param name="cls" select="local-name()"/>
        <!--<xsl:with-param name="attributesSnippet" select="$attributes"/>-->
        <xsl:with-param name="subTreeSnippet">


          <!-- TODO: List all related DPS/TDP/UD with link in editor mode -->



          <!-- Component description -->
          <xsl:for-each select="*/mdq:scope">
            <!-- TODO: In TDP do no display/or readonly component details ? -->

            <!-- Think to bypass choice element MD_ScopeDescription_TypeCHOICE_ELEMENT0 using // -->
            <xsl:apply-templates mode="mode-iso19115-3"
                                 select="*/mcc:levelDescription[1]//mcc:other">
              <xsl:with-param name="overrideLabel" select="$strings/checkpoint-dps-component-name"/>
              <xsl:with-param name="isDisabled" select="$isTdp"/>
            </xsl:apply-templates>

            <xsl:apply-templates mode="mode-iso19115-3"
                                 select="*/mcc:levelDescription[2]//mcc:other">
              <xsl:with-param name="overrideLabel" select="$strings/checkpoint-dps-component-description"/>
              <xsl:with-param name="isDisabled" select="$isTdp"/>
            </xsl:apply-templates>

            <xsl:if test="$isDps">
              <!--<xsl:apply-templates mode="mode-iso19115-3"
                                   select="*/mcc:levelDescription[3]//mcc:other">
                <xsl:with-param name="overrideLabel" select="$strings/checkpoint-dps-component-lineage"/>
                <xsl:with-param name="isDisabled" select="$isTdp"/>
              </xsl:apply-templates>-->

              <xsl:variable name="element"
                            select="*/mcc:levelDescription[3]//mcc:other"/>

              <xsl:call-template name="render-element">
                <xsl:with-param name="label" select="$strings/checkpoint-dps-component-lineage"/>
                <xsl:with-param name="value" select="$element/*"/>
                <xsl:with-param name="cls" select="local-name($element)"/>
                <xsl:with-param name="type" select="'text'"/>
                <xsl:with-param name="name" select="$element/*/gn:element/@ref"/>
                <xsl:with-param name="editInfo" select="$element/*/gn:element"/>
                <xsl:with-param name="parentEditInfo" select="$element/gn:element"/>
                <xsl:with-param name="listOfValues">
                  <directive name="gn-field-suggestions" data-field="checkpointUdLineageDesc"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>

            <xsl:apply-templates mode="mode-iso19115-3" select="*/mcc:extent"/>

          </xsl:for-each>

          <!-- MEDSEA Checkbox if component covered or not -->
          <xsl:variable name="sqr"
                        select="*/mdq:standaloneQualityReport/*"/>
          <xsl:variable name="sqrId"
                        select="concat('gn-sqr-', generate-id($sqr/mdq:reportReference))"/>
          <xsl:variable name="isCovered"
                        select="normalize-space($sqr/mdq:reportReference/*/cit:title) = ''"/>
          <div data-gn-checkpoint-cpt-covered="{$isCovered}"
               data-id="{$sqrId}"
               data-title-id="{$sqr/mdq:reportReference/*/cit:title/gco:CharacterString/gn:element/@ref}"
               data-abstract-id="{$sqr/mdq:abstract/gco:CharacterString/gn:element/@ref}"
          />

          <!-- If not display textearea to populate explanation
          in a standalone quality report.

          Component can not be covered
          -->
          <div id="{$sqrId}">
            <xsl:apply-templates mode="mode-iso19115-3"
                                 select="$sqr/mdq:reportReference/*/cit:title"/>
            <xsl:apply-templates mode="mode-iso19115-3"
                                 select="$sqr/mdq:abstract"/>
          </div>

          <!-- If covered, display table -->
          <div id="{$sqrId}-table">

            <!-- Component QMs -->
            <xsl:variable name="values">
              <header>
                <col>
                  <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'mdq:measureIdentification', $labels,'', '', '')/label"/>
                </col>
                <col>
                  <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'mdq:nameOfMeasure', $labels,'', '', '')/label"/>
                </col>
                <col>
                  <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'mdq:value', $labels,'', '', '')/label"/>
                </col>
                <col>
                  <xsl:value-of select="gn-fn-metadata:getLabel($schema, 'mdq:valueUnit', $labels,'', '', '')/label"/>
                </col>
                <xsl:choose>
                  <xsl:when test="$isTdp">
                    <col>
                      <xsl:value-of select="$strings/checkpoint-qe"/>
                    </col>
                    <col>
                      <xsl:value-of select="$strings/checkpoint-dps-value"/>
                    </col>
                  </xsl:when>
                  <xsl:when test="$isUd">
                    <col>
                      <xsl:value-of select="$strings/checkpoint-qe"/>
                    </col>
                    <col>
                      <xsl:value-of select="$strings/checkpoint-fu"/>
                    </col>
                    <col>
                      <xsl:value-of select="$strings/checkpoint-dps-value"/>
                    </col>
                    <col>
                      <xsl:value-of select="$strings/checkpoint-tdp-value"/>
                    </col>
                  </xsl:when>
                </xsl:choose>
              </header>
              <xsl:for-each select="*/mdq:report/mdq:*">
                <xsl:variable name="measureId"
                              select="mdq:measure/*/mdq:measureIdentification/*/mcc:code/*"/>
                <xsl:variable name="measureName"
                              select="mdq:measure/*/mdq:nameOfMeasure/*"/>
                <xsl:variable name="measureDesc"
                              select="mdq:measure/*/mdq:measureDescription/*"/>

                <xsl:for-each select="mdq:result">
                  <xsl:variable name="unit"
                                select="*/mdq:valueUnit/*/gml:identifier"/>

                  <!-- TODO: Add group by date -->
                  <row title="{$measureDesc}">
                    <xsl:choose>
                      <!-- Quantitative results with units -->
                      <xsl:when test="mdq:DQ_QuantitativeResult">
                        <col readonly="">
                          <xsl:value-of select="$measureId"/>
                        </col>
                        <col readonly="">
                          <xsl:value-of select="$measureName"/>
                        </col>
                        <col type="{*/mdq:valueRecordType/*/text()}">
                          <xsl:copy-of select="*/mdq:value/gco:*"/>
                        </col>
                        <col readonly="">
                          <xsl:value-of select="if ($unit/text() != '')
                                            then $unit/text()
                                            else */mdq:valueRecordType/*/normalize-space()"/>
                        </col>
                        <xsl:choose>
                          <xsl:when test="$isTdp">
                            <xsl:variable name="qeId"
                                          select="concat('P.', replace($measureId/text(), 'AP', 'APE'))"/>
                            <xsl:variable name="tdpQe"
                                          select="$metadata/mdb:dataQualityInfo/*[starts-with(@uuid, $cptId)]
                                                      /mdq:report/*[
                                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $qeId
                                                      ]"/>
                            <col readonly="" title="{$tdpQe/mdq:measure/*/mdq:measureDescription/*/text()}">
                              <xsl:value-of select="format-number($tdpQe/mdq:result/*/mdq:value/*/text(), $format)"/>
                            </col>
                            <col readonly="">
                              <span data-gn-qm-value="{concat($cptId, '|', $measureId/text())}"/>
                            </col>
                          </xsl:when>
                          <xsl:when test="$isUd">
                            <xsl:variable name="qeId"
                                          select="concat('UD.', replace($measureId/text(), 'AP', 'APE'))"/>
                            <xsl:variable name="udQe"
                                          select="$metadata/mdb:dataQualityInfo/*[starts-with(@uuid, $cptId)]
                                                      /mdq:report/*[
                                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $qeId
                                                      ]"/>
                            <col readonly="" title="{$udQe/mdq:measure/*/mdq:measureDescription/*/text()}">
                              <xsl:value-of select="format-number($udQe/mdq:result/*/mdq:value/*/text(), $format)"/>
                            </col>

                            <xsl:variable name="fuId"
                                          select="concat('UD.', replace($measureId/text(), 'AP', 'FU'))"/>
                            <xsl:variable name="udFu"
                                          select="$metadata/mdb:dataQualityInfo/*[starts-with(@uuid, $cptId)]
                                                      /mdq:report/*[
                                                        mdq:measure/*/mdq:measureIdentification/*/mcc:code/*/text() = $fuId
                                                      ]"/>

                            <col readonly="" title="{$udFu/mdq:measure/*/mdq:measureDescription/*/text()}">
                              <xsl:value-of select="format-number($udFu/mdq:result/*/mdq:value/*/text(), $format)"/>
                            </col>

                            <col readonly="">
                              <span data-gn-qm-value="{concat($cptId, '|', $measureId/text())}"/>
                            </col>
                            <col readonly="">
                              <span data-gn-qm-value="{concat($cptId, '|', $measureId/text())}" data-tdp="true"/>
                            </col>
                          </xsl:when>
                        </xsl:choose>



                        <!-- Measures can only be removed in the DPS. ie. once defined
                         in component in a spec, the related TDP and UDs MUST encode
                         the same list of values. -->
                        <xsl:if test="$isDps">
                          <col remove="">
                            <xsl:copy-of select="ancestor::mdq:report/gn:element"/>
                          </col>
                        </xsl:if>
                      </xsl:when>
                      <!-- Descriptive results -->
                      <xsl:when test="mdq:DQ_DescriptiveResult">
                        <col/>
                        <col readonly="">
                          <xsl:value-of select="$measureName"/>
                          (<xsl:value-of select="gn-fn-metadata:getLabel($schema, 'mdq:DQ_DescriptiveResult', $labels,'', '', '')/label"/>)
                        </col>
                        <col type="textarea" colspan="2">
                          <xsl:copy-of select="*/mdq:statement/gco:*"/>
                        </col>
                        <col/>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- Not supported -->
                      </xsl:otherwise>
                    </xsl:choose>
                  </row>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:variable>

            <xsl:call-template name="render-table">
              <xsl:with-param name="values" select="$values"/>
              <xsl:with-param name="addControl">
                <xsl:if test="$config/@or">
                  <xsl:apply-templates select="*/gn:child[@name = $config/@or]"
                                       mode="mode-iso19115-3"/>
                </xsl:if>
              </xsl:with-param>
            </xsl:call-template>
          </div>

        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
