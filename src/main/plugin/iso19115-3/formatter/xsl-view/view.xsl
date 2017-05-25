<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:reg="http://standards.iso.org/iso/19115/-3/reg/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/1.0"
                xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                xmlns:gn-fn-render="http://geonetwork-opensource.org/xsl/functions/render"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="#all">
  <!-- This formatter render an ISO19139 record based on the
  editor configuration file.


  The layout is made in 2 modes:
  * render-field taking care of elements (eg. sections, label)
  * render-value taking care of element values (eg. characterString, URL)

  3 levels of priority are defined: 100, 50, none

  -->


  <!-- Load the editor configuration to be able
  to render the different views -->
  <xsl:variable name="configuration"
                select="document('../../layout/config-editor.xml')"/>

  <!-- Some utility -->
  <xsl:include href="../../layout/evaluate.xsl"/>
  <xsl:include href="../../layout/utility-tpl-multilingual.xsl"/>

  <!-- The core formatter XSL layout based on the editor configuration -->
  <xsl:include href="sharedFormatterDir/xslt/render-layout.xsl"/>
  <!--<xsl:include href="../../../../../data/formatter/xslt/render-layout.xsl"/>-->

  <!-- Define the metadata to be loaded for this schema plugin-->
  <xsl:variable name="metadata"
                select="/root/mdb:MD_Metadata"/>


  <!-- Checkpoint resource type -->
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


  <!-- Specific schema rendering -->
  <xsl:template mode="getMetadataTitle" match="mdb:MD_Metadata">
    <xsl:variable name="value"
                  select="mdb:identificationInfo/*/mri:citation/*/cit:title"/>
    <xsl:value-of select="$value/gco:CharacterString"/>
  </xsl:template>

  <xsl:template mode="getMetadataAbstract" match="mdb:MD_Metadata">
    <xsl:variable name="value"
                  select="mdb:identificationInfo/*/mri:abstract"/>
    <xsl:value-of select="$value/gco:CharacterString"/>
  </xsl:template>


  <xsl:template mode="getMetadataHeader" match="mdb:MD_Metadata">
    <xsl:variable name="value"
                  select="mdb:identificationInfo/*/mri:citation/*/cit:title"/>

    <link rel="stylesheet" type="text/css"
          href="{$baseUrl}../../apps/sextant/css/schema/default.css"></link>

    <link rel="stylesheet" type="text/css"
          href="{$baseUrl}../../apps/sextant/css/metadata-view.css"></link>



    <xsl:choose>
      <xsl:when test="$isTdp">
        <div data-gn-related="md"
             data-types="siblings|associated"
             data-filter="associationType:specification"
             data-title="Links"></div>
      </xsl:when>
      <xsl:when test="$isDps">
        <div data-gn-related="md"
             data-types="siblings|associated"
             data-title="Links"></div>
      </xsl:when>
      <xsl:when test="$isUd">
        <div data-gn-related="md"
             data-types="siblings|associated"
             data-title="Links"></div>
      </xsl:when>
    </xsl:choose>

    <div class="ui-layout-content mdshow-tabpanel">
      <a class="file-link"
         title="Export HTML"
         target="_blank"
         style="display: block;float: right; text-decoration: none;"
         href="{$baseUrl}md.format.html?id={$metadataId}&amp;xsl=xsl-view&amp;view=medsea&amp;css=sextant">&#160;</a>
      <a class="file-xml"
         title="Export XML"
         target="_blank"
         style="display: block;float: right; text-decoration: none;"
         href="{$baseUrl}xml.metadata.get?id={$metadataId}">&#160;</a>
    </div>
  </xsl:template>

  <!-- Display links after INSPIRE theme. If there is no INSPIRE
  themes in the record, the link section will not be displayed. -->
  <xsl:template mode="render-field"
                priority="999"
                match="mri:descriptiveKeywords[*/mri:thesaurusName/*/cit:title/* = 'GEMET - INSPIRE themes, version 1.0']">
    <xsl:param name="fieldName"/>

    <xsl:apply-templates mode="render-field" select="mri:MD_Keywords">
      <xsl:with-param name="fieldName" select="$fieldName"/>
    </xsl:apply-templates>

    <xsl:if test="$isTdp">
      <div data-gn-related="md"
           data-types="siblings|associated"
           data-filter="associationType:upstreamData"
           data-title="Upstream data"></div>
    </xsl:if>
  </xsl:template>

  <!-- MedSea data quality section is rendered in a table -->
  <xsl:template mode="render-field"
                match="mdb:dataQualityInfo"
                priority="9999">
    <!-- Only render quality section for a component, not for errors
    that are in the index and rendered by the directive. -->
    <xsl:if test="*/@uuid[not(ends-with(., '#QE'))]">
      <xsl:variable name="cptId" select="*/@uuid"/>
      <div>
        <h3 style="width:100%">
          <xsl:value-of select="*/mdq:scope/*/mcc:levelDescription[1]/*/mcc:other/*"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="*/mdq:scope/*/mcc:levelDescription[2]/*/mcc:other/*"/>
        </h3>

        <xsl:for-each select="*/mdq:scope/*/mcc:extent/*">
          <xsl:copy-of select="gn-fn-render:bbox(
                                xs:double(gex:geographicElement/*/gex:westBoundLongitude/gco:Decimal),
                                xs:double(gex:geographicElement/*/gex:southBoundLatitude/gco:Decimal),
                                xs:double(gex:geographicElement/*/gex:eastBoundLongitude/gco:Decimal),
                                xs:double(gex:geographicElement/*/gex:northBoundLatitude/gco:Decimal))"/>


          <xsl:apply-templates select="gex:temporalElement/*/gex:extent/gml:*/gml:beginPosition"
                               mode="render-field"/>
          <xsl:apply-templates select="gex:temporalElement/*/gex:extent/gml:*/gml:endPosition"
                               mode="render-field"/>

          <xsl:apply-templates select="gex:verticalElement"
                               mode="render-field"/>
        </xsl:for-each>

        <div data-gn-data-quality-measure-renderer="{$metadataId}"
             data-cpt-id="{$cptId}"/>
      </div>
    </xsl:if>
  </xsl:template>
<!--
  <xsl:template mode="render-field"
                match="mdb:dataQualityInfo[position() > 1]"
                priority="9999"/>-->


  <!-- Most of the elements are ... -->
  <xsl:template mode="render-field"
                match="*[gco:CharacterString != '']|*[gco:Integer != '']|
                       *[gco:Decimal != '']|*[gco:Boolean != '']|
                       *[gco:Real != '']|*[gco:Measure != '']|*[gco:Length != '']|
                       *[gco:Distance != '']|*[gco:Angle != '']|*[gco:Scale != '']|
                       *[gco:Record != '']|*[gco:RecordType != '']|
                       *[gco:LocalName != '']|*[lan:PT_FreeText != '']|
                       *[gml:beginPosition != '']|*[gml:endPosition != '']|
                       *[gco:Date != '']|*[gco:DateTime != '']|*[*/@codeListValue]|*[@codeListValue]|
                       gml:beginPosition[. != '']|gml:endPosition[. != '']"
                priority="50">
    <xsl:param name="fieldName" select="''" as="xs:string"/>

    <xsl:variable name="elementName" select="if (@codeListValue) then name(..) else name(.)"/>
    <dl>
      <dt>
        <xsl:value-of select="if ($fieldName)
                                then replace($fieldName, '\*', '')
                                else tr:node-label(tr:create($schema), $elementName, null)"/>
      </dt>
      <dd>
        <xsl:choose>
          <!-- Display the value for simple field eg. gml:beginPosition. -->
          <xsl:when test="count(*) = 0 and not(*/@codeListValue)">
            <xsl:value-of select="text()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="render-value" select="*|*/@codeListValue"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates mode="render-value" select="@*"/>
      </dd>
    </dl>
  </xsl:template>



  <!-- Some elements are only containers so bypass them -->
  <xsl:template mode="render-field"
                match="*[count(mdb:*|mri:*|mcc:*|dqm:*|mco:*|mrc:*|
                        mrs:*|mrl:*|mrd:*|gml:*|gex:*|gfc:*) = 1]"
                priority="50">
    <xsl:param name="fieldName" select="''" as="xs:string"/>

    <xsl:apply-templates mode="render-value" select="@*"/>
    <xsl:apply-templates mode="render-field" select="*">
      <xsl:with-param name="fieldName" select="$fieldName"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- Some major sections are boxed -->
  <xsl:template mode="render-field"
                match="*[name() = $configuration/editor/fieldsWithFieldset/name
    or @gco:isoType = $configuration/editor/fieldsWithFieldset/name]|
      *[$isFlatMode = false() and not(gco:CharacterString)]">

    <div class="entry name">
      <h4>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
        <xsl:apply-templates mode="render-value"
                             select="@*"/>
      </h4>
      <div class="target">
        <xsl:apply-templates mode="render-field" select="*"/>
      </div>
    </div>
  </xsl:template>


  <!-- Bbox is displayed with an overview and the geom displayed on it
  and the coordinates displayed around -->
  <xsl:template mode="render-field"
                match="gex:EX_GeographicBoundingBox[
          gex:westBoundLongitude/gco:Decimal != '']">
    <xsl:copy-of select="gn-fn-render:bbox(
                            xs:double(gex:westBoundLongitude/gco:Decimal),
                            xs:double(gex:southBoundLatitude/gco:Decimal),
                            xs:double(gex:eastBoundLongitude/gco:Decimal),
                            xs:double(gex:northBoundLatitude/gco:Decimal))"/>
  </xsl:template>


  <!-- A contact is displayed with its role as header -->
  <xsl:template mode="render-field"
                match="*[cit:CI_Responsibility]"
                priority="100">

    <xsl:variable name="email">
      <xsl:for-each select="*/cit:party/*/cit:contactInfo/
                                      */cit:address/*/cit:electronicMailAddress[not(gco:nilReason)]">
        <xsl:apply-templates mode="render-value" select="."/>
        <xsl:if test="position() != last()">, </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- Display name is <org name> - <individual name> (<position name> -->
    <xsl:variable name="displayName">
      <xsl:choose>
        <xsl:when
                test="*/cit:party/cit:CI_Organisation/cit:name and
                */cit:CI_Individual/cit:name">
          <!-- Org name may be multilingual -->
          <xsl:apply-templates mode="render-value"
                               select="*/cit:party/cit:CI_Organisation/cit:name"/>
          -
          <xsl:value-of select="*/cit:CI_Individual/cit:name"/>
          <xsl:if test="*/cit:CI_Individual/cit:positionName">
            (<xsl:apply-templates mode="render-value"
                                  select="*/cit:CI_Individual/cit:positionName"/>)
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*/cit:party/cit:CI_Organisation/cit:name|
                                */cit:CI_Individual/cit:name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="gn-contact">
      <h4>
        <i class="fa fa-envelope">&#160;</i>
        <xsl:apply-templates mode="render-value"
                             select="*/cit:role/*/@codeListValue"/>
      </h4>
      <div class="row">
        <div class="col-md-6">
          <!-- Needs improvements as contact/org are more flexible in ISO19115-3 -->
          <address>
            <strong>
              <xsl:choose>
                <xsl:when test="normalize-space($email) != ''">
                  <a href="mailto:{normalize-space($email)}">
                    <xsl:value-of select="$displayName"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$displayName"/>
                </xsl:otherwise>
              </xsl:choose>
            </strong><br/>
            <xsl:for-each select="*//cit:contactInfo/*">
              <xsl:for-each select="cit:address/*/(
                                          cit:deliveryPoint|cit:city|
                                          cit:administrativeArea|cit:postalCode|cit:country)">
                <xsl:if test="normalize-space(.) != ''">
                  <xsl:apply-templates mode="render-value" select="."/><br/>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
          </address>
        </div>
        <div class="col-md-6">
          <xsl:for-each select="*//cit:contactInfo/*">
            <address>
              <xsl:for-each select="cit:phone/*/cit:voice[normalize-space(.) != '']">
                <xsl:variable name="phoneNumber">
                  <xsl:apply-templates mode="render-value" select="."/>
                </xsl:variable>
                <i class="fa fa-phone"></i>
                <a href="tel:{$phoneNumber}">
                  <xsl:value-of select="$phoneNumber"/>
                </a>
              </xsl:for-each>
              <xsl:for-each select="cit:phone/*/cit:facsimile[normalize-space(.) != '']">
                <xsl:variable name="phoneNumber">
                  <xsl:apply-templates mode="render-value" select="."/>
                </xsl:variable>
                <i class="fa fa-fax"></i>
                <a href="tel:{normalize-space($phoneNumber)}">
                  <xsl:value-of select="normalize-space($phoneNumber)"/>
                </a>
              </xsl:for-each>
              <xsl:for-each select="cit:onlineResource/*/cit:linkage[normalize-space(.) != '']">
                <xsl:variable name="linkage">
                  <xsl:apply-templates mode="render-value" select="."/>
                </xsl:variable>
                <i class="fa fa-link"></i>
                <a href="{normalize-space($linkage)}" target="_blank">
                  <xsl:value-of select="if (../cit:name)
                                        then ../cit:name/* else
                                        normalize-space(linkage)"/>
                </a>
              </xsl:for-each>
              <xsl:apply-templates mode="render-field"
                                   select="cit:hoursOfService|cit:contactInstructions"/>
            </address>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- Metadata linkage -->
  <xsl:template mode="render-field"
                match="mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code"
                priority="100">
    <dl>
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <xsl:apply-templates mode="render-value" select="*"/>
        <xsl:apply-templates mode="render-value" select="@*"/>

        <a class="btn btn-link" href="xml.metadata.get?id={$metadataId}" target="_blank">
          <i class="fa fa-file-code-o fa-2x"></i>
          <span data-translate="">metadataInXML</span>
        </a>
      </dd>
    </dl>
  </xsl:template>

  <!-- Linkage -->
  <xsl:template mode="render-field"
                match="*[cit:CI_OnlineResource and */cit:linkage/* != '']"
                priority="100">
    <dl class="gn-link">
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <xsl:variable name="linkDescription">
          <xsl:apply-templates mode="render-value"
                               select="*/cit:description"/>
        </xsl:variable>
        <a href="{*/cit:linkage/*}" target="_blank">
          <xsl:apply-templates mode="render-value"
                               select="*/cit:name"/>
        </a>
        <p>
          <xsl:value-of select="normalize-space($linkDescription)"/>
        </p>
      </dd>
    </dl>
  </xsl:template>

  <!-- Identifier -->
  <xsl:template mode="render-field"
                match="*[(mcc:RS_Identifier or mcc:MD_Identifier) and
                  */mcc:code/gco:CharacterString != '']"
                priority="100">
    <dl class="gn-code">
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>

        <xsl:if test="*/mcc:codeSpace">
        <xsl:apply-templates mode="render-value"
                             select="*/mcc:codeSpace"/>
        /
        </xsl:if>
        <xsl:apply-templates mode="render-value"
                               select="*/mcc:code"/>
        <p>
          <xsl:apply-templates mode="render-field"
                               select="*/mcc:authority"/>
        </p>
      </dd>
    </dl>
  </xsl:template>


  <!-- Display thesaurus name and the list of keywords -->
  <xsl:template mode="render-field"
                match="mri:descriptiveKeywords/*[count(mri:keyword) = 0]" priority="200"/>
  <xsl:template mode="render-field"
                match="mri:descriptiveKeywords/*[mri:thesaurusName/cit:CI_Citation/cit:title]"
                priority="100">
    <xsl:param name="fieldName"/>

    <dl class="gn-keyword">
      <dt>
        <xsl:choose>
          <xsl:when test="$fieldName != ''"><xsl:value-of select="replace($fieldName, '\*', '')"/></xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="render-value"
                                 select="mri:thesaurusName/cit:CI_Citation/cit:title/*"/>
          </xsl:otherwise>
        </xsl:choose>

        <!--<xsl:if test="*/mri:type/*[@codeListValue != '']">
          (<xsl:apply-templates mode="render-value"
                                select="*/mri:type/*/@codeListValue"/>)
        </xsl:if>-->
      </dt>
      <dd>
        <div>
          <ul>
            <li>
              <xsl:apply-templates mode="render-value"
                                   select="mri:keyword/*"/>
            </li>
          </ul>
        </div>
      </dd>
    </dl>
  </xsl:template>


  <xsl:template mode="render-field"
                match="mri:descriptiveKeywords[not(*/mri:thesaurusName/cit:CI_Citation/cit:title)]"
                priority="100">
    <dl class="gn-keyword">
      <dt>
        <xsl:value-of select="$schemaStrings/noThesaurusName"/>
        <xsl:if test="*/mri:type/*[@codeListValue != '']">
          (<xsl:apply-templates mode="render-value"
                                select="*/mri:type/*/@codeListValue"/>)
        </xsl:if>
      </dt>
      <dd>
        <div>
          <ul>
            <li>
              <xsl:apply-templates mode="render-value"
                                   select="*/mri:keyword/*"/>
            </li>
          </ul>
        </div>
      </dd>
    </dl>
  </xsl:template>

  <!-- Display all graphic overviews in one block -->
  <xsl:template mode="render-field"
                match="mri:graphicOverview[1]"
                priority="100">
    <dl>
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <ul>
        <xsl:for-each select="parent::node()/mri:graphicOverview">
          <xsl:variable name="label">
            <xsl:apply-templates mode="localised"
                               select="mcc:MD_BrowseGraphic/mcc:fileDescription"/>
          </xsl:variable>
          <li>
            <img src="{mcc:MD_BrowseGraphic/mcc:fileName/*}"
                 alt="{$label}"
                 class="img-thumbnail"/>
          </li>
        </xsl:for-each>
        </ul>
      </dd>
    </dl>
  </xsl:template>
  <xsl:template mode="render-field"
                match="mcc:graphicOverview[position() > 1]"
                priority="100"/>


  <xsl:template mode="render-field"
                match="mrd:distributionFormat[1]"
                priority="100">
    <dl class="gn-format">
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <ul>
          <xsl:for-each select="parent::node()/mrd:distributionFormat">
            <li>
              <xsl:apply-templates mode="render-value"
                                   select="*/mrd:formatSpecificationCitation/*/
                                    cit:title"/>
              <p>
              <xsl:apply-templates mode="render-field"
                      select="*/(mrd:amendmentNumber|
                              mrd:fileDecompressionTechnique|
                              mrd:medium|
                              mrd:formatDistributor)"/>
              </p>
            </li>
          </xsl:for-each>
        </ul>
      </dd>
    </dl>
  </xsl:template>


  <xsl:template mode="render-field"
                match="mrd:distributionFormat[position() > 1]"
                priority="100"/>

  <!-- Date -->
  <xsl:template mode="render-field"
                match="cit:date|mdb:dateInfo"
                priority="100">
    <dl class="gn-date">
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
        <xsl:if test="*/cit:dateType/*[@codeListValue != '']">
          (<xsl:apply-templates mode="render-value"
                                select="*/cit:dateType/*/@codeListValue"/>)
        </xsl:if>
      </dt>
      <dd>
          <xsl:apply-templates mode="render-value"
                               select="*/cit:date/*"/>
      </dd>
    </dl>
  </xsl:template>


  <!-- Enumeration -->
  <xsl:template mode="render-field"
                match="mri:topicCategory[1]|
                       mex:MD_ObligationCode[1]|
                       msr:MD_PixelOrientationCode[1]|
                       srv:SV_ParameterDirection[1]|
                       reg:RE_AmendmentType[1]"
                priority="100">
    <dl class="gn-date">
      <dt>
        <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <ul>
          <xsl:for-each select="parent::node()/(mri:topicCategory|mex:MD_ObligationCode|
                msr:MD_PixelOrientationCode|srv:SV_ParameterDirection|
                reg:RE_AmendmentType)">
            <li>
            <xsl:apply-templates mode="render-value"
                                 select="*"/>
            </li>
          </xsl:for-each>
        </ul>
      </dd>
    </dl>
  </xsl:template>
  <xsl:template mode="render-field"
                match="mri:topicCategory[position() > 1]|
                       mex:MD_ObligationCode[position() > 1]|
                       msr:MD_PixelOrientationCode[position() > 1]|
                       srv:SV_ParameterDirection[position() > 1]|
                       reg:RE_AmendmentType[position() > 1]"
                priority="100"/>


  <!-- Link to other metadata records -->
  <xsl:template mode="render-field"
                match="*[@uuidref]"
                priority="100">
    <xsl:variable name="nodeName" select="name()"/>

    <!-- Only render the first element of this kind and render a list of
    following siblings. -->
    <xsl:variable name="isFirstOfItsKind"
                  select="count(preceding-sibling::node()[name() = $nodeName]) = 0"/>
    <xsl:if test="$isFirstOfItsKind">
      <dl class="gn-md-associated-resources">
        <dt>
          <xsl:value-of select="tr:node-label(tr:create($schema), name(), null)"/>
        </dt>
        <dd>
          <ul>
            <xsl:for-each select="parent::node()/*[name() = $nodeName]">
              <li><a href="#uuid={@uuidref}" target="_blank">
                <i class="fa fa-link"></i>
                <xsl:value-of select="gn-fn-render:getMetadataTitle(@uuidref, $language)"/>
              </a></li>
            </xsl:for-each>
          </ul>
        </dd>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- Traverse the tree -->
  <xsl:template mode="render-field"
                match="*">
    <xsl:param name="fieldName" select="''" as="xs:string"/>
    <xsl:apply-templates mode="render-field">
      <xsl:with-param name="fieldName" select="$fieldName"/>
    </xsl:apply-templates>
  </xsl:template>







  <!-- ########################## -->
  <!-- Render values for text ... -->
  <xsl:template mode="render-value"
                match="gco:CharacterString|gco:Integer|gco:Decimal|
       gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Angle|
       gco:Scale|gco:Record|gco:RecordType|
       gco:LocalName|gml:beginPosition|gml:endPosition">
    <xsl:choose>
      <xsl:when test="contains(., 'http')">
        <!-- Replace hyperlink in text by an hyperlink -->
        <xsl:variable name="textWithLinks"
                      select="replace(., '([a-z][\w-]+:/{1,3}[^\s()&gt;&lt;]+[^\s`!()\[\]{};:'&apos;&quot;.,&gt;&lt;?«»“”‘’])',
                                    '&lt;a target=''_blank'' href=''$1''&gt;$1&lt;/a&gt;')"/>

        <xsl:if test="$textWithLinks != ''">
          <xsl:copy-of select="saxon:parse(
                          concat('&lt;p&gt;',
                          replace($textWithLinks, '&amp;', '&amp;amp;'),
                          '&lt;/p&gt;'))"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="render-value"
                match="lan:PT_FreeText">
    <xsl:apply-templates mode="localised" select="../node()">
      <xsl:with-param name="langId" select="$language"/>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template mode="render-value"
                match="gco:Distance|gco:Measure">
    <span><xsl:value-of select="."/>&#10;<xsl:value-of select="@uom"/></span>
  </xsl:template>

  <!-- ... Dates - formatting is made on the client side by the directive  -->
  <xsl:template mode="render-value"
                match="gco:Date[matches(., '[0-9]{4}')]">
    <span data-gn-humanize-time="{.}" data-format="YYYY"></span>
  </xsl:template>

  <xsl:template mode="render-value"
                match="gco:Date[matches(., '[0-9]{4}-[0-9]{2}')]">
    <span data-gn-humanize-time="{.}" data-format="MMM YYYY"></span>
  </xsl:template>

  <xsl:template mode="render-value"
                match="gco:Date[matches(., '[0-9]{4}-[0-9]{2}-[0-9]{2}')]">
    <span data-gn-humanize-time="{.}" data-format="DD MMM YYYY"></span>
  </xsl:template>

  <xsl:template mode="render-value"
                match="gco:DateTime[matches(., '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}')]">
    <span data-gn-humanize-time="{.}"><xsl:value-of select="."/></span>
  </xsl:template>

  <xsl:template mode="render-value"
                match="gco:Date|gco:DateTime">
    <span data-gn-humanize-time="{.}"><xsl:value-of select="."/></span>
  </xsl:template>

  <!-- TODO -->
  <xsl:template mode="render-value"
          match="lan:language/gco:CharacterString">
    <!--mri:defaultLocale>-->
    <!--<lan:PT_Locale id="ENG">-->
    <!--<lan:language-->
    <span data-translate=""><xsl:value-of select="."/></span>
  </xsl:template>

  <!-- ... Codelists -->
  <xsl:template mode="render-value"
                match="@codeListValue">
    <xsl:variable name="id" select="."/>
    <xsl:variable name="codelistTranslation"
                  select="tr:codelist-value-label(
                            tr:create($schema),
                            parent::node()/local-name(), $id)"/>
    <xsl:choose>
      <xsl:when test="$codelistTranslation != ''">

        <xsl:variable name="codelistDesc"
                      select="tr:codelist-value-desc(
                            tr:create($schema),
                            parent::node()/local-name(), $id)"/>
        <span title="{$codelistDesc}"><xsl:value-of select="$codelistTranslation"/></span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Enumeration -->
  <xsl:template mode="render-value"
                match="mri:MD_TopicCategoryCode|
                       mex:MD_ObligationCode[1]|
                       msr:MD_PixelOrientationCode[1]|
                       srv:SV_ParameterDirection[1]|
                       reg:RE_AmendmentType">
    <xsl:variable name="id" select="."/>
    <xsl:variable name="codelistTranslation"
                  select="tr:codelist-value-label(
                            tr:create($schema),
                            local-name(), $id)"/>
    <xsl:choose>
      <xsl:when test="$codelistTranslation != ''">

        <xsl:variable name="codelistDesc"
                      select="tr:codelist-value-desc(
                            tr:create($schema),
                            local-name(), $id)"/>
        <span title="{$codelistDesc}"><xsl:value-of select="$codelistTranslation"/></span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="render-value"
                match="@gco:nilReason[. = 'withheld']"
                priority="100">
    <i class="fa fa-lock text-warning" title="{{{{'withheld' | translate}}}}"></i>
  </xsl:template>
  <xsl:template mode="render-value"
                match="@*"/>

  <!-- MedSea specific -->
  <!--<xsl:template mode="render-field" match="mdq:report"/>-->
  <xsl:template mode="render-view" match="tab[@id='medsea-dq']" priority="2"/>

</xsl:stylesheet>
