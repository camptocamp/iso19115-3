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

  <!-- Rename the standard name
  <mdb:metadataStandard>
    <cit:CI_Citation>
      <cit:title>
        <gco:CharacterString>ISO 19115-3 - Emodnet Checkpoint</gco:CharacterString>
      </cit:title>
  -->
  <xsl:template match="mdb:metadataStandard/cit:CI_Citation/cit:title/gco:CharacterString[. = 'ISO 19115-3 - MedSea Checkpoint']">
    <xsl:copy>ISO 19115-3 - Emodnet Checkpoint</xsl:copy>
  </xsl:template>
  <xsl:template match="mdb:metadataStandard/cit:CI_Citation/cit:title/gco:CharacterString[. = 'ISO 19115-3 - MedSea Targeted Product']">
    <xsl:copy>ISO 19115-3 - Emodnet Checkpoint - Targeted Product</xsl:copy>
  </xsl:template>


  <!-- # Metadata information -->
  <!-- mdb:MD_Metadata/mdb:contact / force role to pointOfContact -->
  <xsl:template match="mdb:MD_Metadata/mdb:contact/cit:CI_Responsibility/
                        cit:role/cit:CI_RoleCode[@codeListValue != 'pointOfContact']">
    <xsl:copy>
      <xsl:copy-of select="@*[name() != 'codeListValue']"/>
      <xsl:attribute name="codeListValue" select="'pointOfContact'"/>
    </xsl:copy>
  </xsl:template>

  <!-- mdb:MD_Metadata/mdb:contact / add phone number to pointOfContact ?
   Add empty field.
   -->
  <xsl:template match="mdb:MD_Metadata/mdb:contact/cit:CI_Responsibility/cit:party/cit:CI_Organisation/
                        cit:contactInfo/cit:CI_Contact[not(cit:phone)]">
    <xsl:copy>
      <cit:phone>
        <cit:CI_Telephone>
          <cit:number>
            <gco:CharacterString></gco:CharacterString>
          </cit:number>
          <cit:numberType>
            <cit:CI_TelephoneTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_TelephoneTypeCode"
                                      codeListValue="voice"/>
          </cit:numberType>
        </cit:CI_Telephone>
      </cit:phone>
      <xsl:copy-of select="*"/>
    </xsl:copy>
  </xsl:template>


  <!--
  Replace /mdb:MD_Metadata/mdb:identificationInfo/*/mri:credit"/> by
            <mri:pointOfContact>
  -->
  <xsl:template match="mri:credit"/>


  <!-- Validation / Add a /mdb:MD_Metadata/mdb:identificationInfo/*/
                    mri:descriptiveKeywords
                    [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                    'medsea.status')] ?


                           /mdb:MD_Metadata/mdb:identificationInfo/*/
                          mri:descriptiveKeywords
                          [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                          'emodnet-checkpoint.visibility')]

         xpath="/mdb:MD_Metadata/mdb:identificationInfo/*/
                  mri:descriptiveKeywords
                  [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                  'emodnet-checkpoint.policy.visibility')]"/>

                  /mdb:MD_Metadata/mdb:identificationInfo/*/
                  mri:descriptiveKeywords
                  [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                  'emodnet-checkpoint.readyness')]
                    -->
  <xsl:template match="mdb:MD_Metadata/mdb:identificationInfo/mri:MD_DataIdentification">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>

      <xsl:apply-templates
              select="mri:citation|
                mri:abstract|
                mri:purpose|
                mri:credit|
                mri:status|
                mri:pointOfContact"/>

      <!--
      Replace /mdb:MD_Metadata/mdb:identificationInfo/*/mri:credit"/> by
      -->
      <xsl:if test="mri:credit/gco:CharacterString != ''">
        <mri:pointOfContact>
          <cit:CI_Responsibility>
            <cit:role>
              <cit:CI_RoleCode codeList="codeListLocation#CI_RoleCode"
                               codeListValue="edmerp">edmerp</cit:CI_RoleCode>
            </cit:role>
            <cit:party>
              <cit:CI_Organisation>
                <cit:name>
                  <gco:CharacterString>
                    <xsl:value-of select="mri:credit/gco:CharacterString"/>
                  </gco:CharacterString>
                </cit:name>
                <cit:contactInfo>
                  <cit:CI_Contact>
                    <cit:onlineResource>
                      <cit:CI_OnlineResource>
                        <cit:linkage>
                          <gco:CharacterString></gco:CharacterString>
                        </cit:linkage>
                      </cit:CI_OnlineResource>
                    </cit:onlineResource>
                  </cit:CI_Contact>
                </cit:contactInfo>
              </cit:CI_Organisation>
            </cit:party>
          </cit:CI_Responsibility>
        </mri:pointOfContact>
      </xsl:if>

      <xsl:apply-templates
              select="
                mri:spatialRepresentationType|
                mri:spatialResolution|
                mri:temporalResolution|
                mri:topicCategory|
                mri:extent|
                mri:additionalDocumentation|
                mri:processingLevel|
                mri:resourceMaintenance|
                mri:graphicOverview|
                mri:resourceFormat|
                mri:descriptiveKeywords"/>


     <!-- <xsl:apply-templates
              select="mri:descriptiveKeywords[1]/preceding-sibling::node()"/>
      <xsl:apply-templates
              select="mri:descriptiveKeywords"/>-->


      <xsl:if test="count(mri:descriptiveKeywords[contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(), 'medsea.policy.visibility')]) = 0">

        <mri:descriptiveKeywords>
          <mri:MD_Keywords>
            <mri:type>
              <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"
                                      codeListValue="theme"/>
            </mri:type>
            <mri:thesaurusName>
              <cit:CI_Citation>
                <cit:title>
                  <gco:CharacterString>Policy visibility</gco:CharacterString>
                </cit:title>
                <cit:date>
                  <cit:CI_Date>
                    <cit:date>
                      <gco:DateTime>2015-03-20T00:00:00</gco:DateTime>
                    </cit:date>
                    <cit:dateType>
                      <cit:CI_DateTypeCode codeList="codeListLocation#CI_DateTypeCode" codeListValue=""/>
                    </cit:dateType>
                  </cit:CI_Date>
                </cit:date>
                <cit:identifier>
                  <mcc:MD_Identifier>
                    <mcc:code>
                      <gcx:Anchor xlink:href="http://sextant.ifremer.fr/geonetwork/srv/eng/thesaurus.download?ref=local.theme.emodnet-checkpoint.policy.visibility">geonetwork.thesaurus.local.theme.emodnet-checkpoint.policy.visibility</gcx:Anchor>
                    </mcc:code>
                  </mcc:MD_Identifier>
                </cit:identifier>
              </cit:CI_Citation>
            </mri:thesaurusName>
          </mri:MD_Keywords>
        </mri:descriptiveKeywords>
      </xsl:if>
      <xsl:if test="count(mri:descriptiveKeywords[contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(), 'medsea.readyness')]) = 0">
        <mri:descriptiveKeywords>
          <mri:MD_Keywords>
            <mri:type>
              <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"
                                      codeListValue="theme"/>
            </mri:type>
            <mri:thesaurusName>
              <cit:CI_Citation>
                <cit:title>
                  <gco:CharacterString>Readyness</gco:CharacterString>
                </cit:title>
                <cit:date>
                  <cit:CI_Date>
                    <cit:date>
                      <gco:DateTime>2015-03-20T00:00:00</gco:DateTime>
                    </cit:date>
                    <cit:dateType>
                      <cit:CI_DateTypeCode codeList="codeListLocation#CI_DateTypeCode" codeListValue=""/>
                    </cit:dateType>
                  </cit:CI_Date>
                </cit:date>
                <cit:identifier>
                  <mcc:MD_Identifier>
                    <mcc:code>
                      <gcx:Anchor xlink:href="http://sextant.ifremer.fr/geonetwork/srv/eng/thesaurus.download?ref=local.theme.emodnet-checkpoint.readyness">geonetwork.thesaurus.local.theme.emodnet-checkpoint.readyness</gcx:Anchor>
                    </mcc:code>
                  </mcc:MD_Identifier>
                </cit:identifier>
              </cit:CI_Citation>
            </mri:thesaurusName>
          </mri:MD_Keywords>
        </mri:descriptiveKeywords>
      </xsl:if>

      <xsl:if test="count(mri:descriptiveKeywords[contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(), 'medsea.visibility')]) = 0">
        <mri:descriptiveKeywords>
          <mri:MD_Keywords>
            <mri:type>
              <mri:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"
                                      codeListValue="theme"/>
            </mri:type>
            <mri:thesaurusName>
              <cit:CI_Citation>
                <cit:title>
                  <gco:CharacterString>Visibility</gco:CharacterString>
                </cit:title>
                <cit:date>
                  <cit:CI_Date>
                    <cit:date>
                      <gco:DateTime>2015-03-20T00:00:00</gco:DateTime>
                    </cit:date>
                    <cit:dateType>
                      <cit:CI_DateTypeCode codeList="codeListLocation#CI_DateTypeCode" codeListValue=""/>
                    </cit:dateType>
                  </cit:CI_Date>
                </cit:date>
                <cit:identifier>
                  <mcc:MD_Identifier>
                    <mcc:code>
                      <gcx:Anchor xlink:href="http://sextant.ifremer.fr/geonetwork/srv/eng/thesaurus.download?ref=local.theme.emodnet-checkpoint.visibility">geonetwork.thesaurus.local.theme.emodnet-checkpoint.visibility</gcx:Anchor>
                    </mcc:code>
                  </mcc:MD_Identifier>
                </cit:identifier>
              </cit:CI_Citation>
            </mri:thesaurusName>
          </mri:MD_Keywords>
        </mri:descriptiveKeywords>
      </xsl:if>
      <xsl:if test="count(mri:descriptiveKeywords[contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(), 'medsea.status')]) = 0">
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
                      <gco:DateTime>2015-01-29</gco:DateTime>
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
                      <gcx:Anchor xlink:href="http://sextant.ifremer.fr/geonetwork/srv/eng/thesaurus.download?ref=external.theme.emodnet-checkpoint.status">geonetwork.thesaurus.local.theme.emodnet-checkpoint.status</gcx:Anchor>
                    </mcc:code>
                  </mcc:MD_Identifier>
                </cit:identifier>
              </cit:CI_Citation>
            </mri:thesaurusName>
          </mri:MD_Keywords>
        </mri:descriptiveKeywords>
      </xsl:if>

      <xsl:apply-templates
              select="mri:descriptiveKeywords[last()]/following-sibling::node()"/>
      <!--

      <xsl:apply-templates
              select="
                mri:spatialRepresentationType|
                mri:spatialResolution|
                mri:temporalResolution|
                mri:topicCategory|
                mri:extent|
                mri:additionalDocumentation|
                mri:processingLevel|
                mri:resourceMaintenance|
                mri:graphicOverview|
                mri:resourceFormat|
                mri:descriptiveKeywords|
                mri:resourceSpecificUsage|
                mri:resourceConstraints|
                mri:associatedResource|
                mri:defaultLocale|
                mri:otherLocale|
                mri:environmentDescription|
                mri:supplementalInformation
                "/>
      -->
    </xsl:copy>
  </xsl:template>

  <!-- # Characteristics -->
  <!-- Env matrix / Remove unspecified value - keep thesaurus section -->
  <xsl:template match="mdb:MD_Metadata/mdb:identificationInfo/*/
                          mri:descriptiveKeywords[
                            contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/
                                        mcc:code/*/text(),
                                     'medsea.environmental.matrix')]/
                          */mri:keyword[lower-case(gco:CharacterString) = 'unspecified']"/>

  <!-- Availability -->
  <xsl:variable name="map">
    <!-- Easily found / Matching values
/mdb:MD_Metadata/mdb:identificationInfo/*/
                        mri:descriptiveKeywords
                        [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                        'medsea.visibility')]
 # Current:
1.Cited in literature but no information about data access
2.Information upon request to the data provider
3.Information available through social networks, organizations where one should know were data are or in directories such as EDMERP, EDMED...
4.Easy to identify with search engine (using data set name or characteristic category)
5.Identified in reference catalogues (MyOcean, GEOSS, Geoportal...)

 # Expected:
 1.Cited in peer reviewed paper or grey literature but no info on how to access
 2.Information retrieved upon specific request to the data source
 3.Use of social network, community of practices sharing information, portals of organization where no search is organized by an engine
 4.Use of open search engines, searching by name either the data provider or the characteristics
 5.Search via reference catalogue (e.g. MyOcean, GEOSS Geoportal…)

 Only renaming
-->
    <value key="Cited in literature but no information about data access">Cited in peer reviewed paper or grey literature but no info on how to access</value>
    <value key="Information upon request to the data provider">Information retrieved upon specific request to the data source</value>
    <value key="Information available through social networks, organizations where one should know were data are or in directories such as EDMERP, EDMED...">Use of social network, community of practices sharing information, portals of organization where no search is organized by an engine</value>
    <value key="Easy to identify with search engine (using data set name or characteristic category)">Use of open search engines, searching by name either the data provider or the characteristics</value>
    <value key="Identified in reference catalogues (MyOcean, GEOSS, Geoportal...)">Search via reference catalogue (e.g. MyOcean, GEOSS Geoportal…)</value>

    <!-- EU catalogue service
    /mdb:MD_Metadata/mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                            'theme.medsea.service.extent')]
    # Current:
    1.Private
    2.Public international
    3.Public national but not EU service
    4.EU service or DS name if available

    # Expected:
    1.Data sets are not referenced in a catalogue or are referenced in a non public catalogue
    2.The datasets are referenced in a public national catalogue, in an international catalogue service
    3.The datasets are provided through an EU Inspire catalogue service (OGC)

    1 => 1
    2,3 => 2
    4 => 3
    -->
    <value key="Private">Data sets are not referenced in a catalogue or are referenced in a non public catalogue</value>
    <value key="Public international">The datasets are referenced in a public national catalogue, in an international catalogue service</value>
    <value key="Public national but not EU service">The datasets are referenced in a public national catalogue, in an international catalogue service</value>
    <value key="EU service or DS name if available">The datasets are provided through an EU Inspire catalogue service (OGC)</value>



    <!-- Visibility of data policy
    /mdb:MD_Metadata/mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                            'medsea.policy.visibility')]

    # Current:
    1.No information
    2.Difficult to find or to understand but available on request
    3.Well documented and easy to access

    # Expected:
    1.There is no information at all on data policy adopted by data providers
    2.There is information, but details are available only on request
    3.There is detailed information provided to understand data policy
    -->
    <value key="No information">There is no information at all on data policy adopted by data providers</value>
    <value key="Difficult to find or to understand but available on request">There is information, but details are available only on request</value>
    <value key="Well documented and easy to access">There is detailed information provided to understand data policy</value>


    <!--
    Data delivery mechanisms
    /mdb:MD_Metadata/mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:title/gco:CharacterString,
                            'Data delivery mechanism')]

    # Current:
    1.Order form/invoice
    2.On-line downloading services
    3.On-line discovery+viewing + downloading services
    4.On-line discovery + viewing + downloading + advanced services (High resolution viewing,3D viewing services, Processing/Mapping services...)

    # Expected:
    1.No information was found on data delivery mechanisms
    2.Manual process: Order form/invoice is requested
    3.Online downloading services
    4.Online discovery and downloading services
    5.Online discovery + downloading + viewing services (Advanced services)

    1 => 2
    2 => 3
    3 => 4
    4 => 5
    -->
    <value key="Order form/envoice">Manual process: Order form/invoice is requested</value>
    <value key="Order form/invoice">Manual process: Order form/invoice is requested</value>
    <value key="On-line downloading services">Online downloading services</value>
    <value key="On-line discovery+viewing + downloading services">Online discovery and downloading services</value>
    <value key="On-line discovery + viewing + downloading + advanced services (High resolution viewing,3D viewing services, Processing/Mapping services...)">Online discovery + downloading + viewing services (Advanced services)</value>


    <!--
    Readyness
    /mdb:MD_Metadata/mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                            'medsea.readyness')]

    # Current:
    1.Not proprietary and content well described (eg auto descriptive standard format, documentation)
    2.Proprietary but well described
    3.Not proprietary but not well described
    4.Proprietary and not well described
    5.Not documented

    # Expected:
    1.Format not or not well documented
    2.Proprietary format and not well documented
    3.Format not proprietary but content not clearly specified
    4.Format proprietary but content clearly specified
    5.Format not proprietary and content clearly specified (e.g. autodescriptive like ODV, NetCDF CF) or at least with appropriate document describing the content.

    1 => 5
    2 => 4
    3 => 3
    4 => 2
    5 => 1

    -->

    <value key="Not proprietary and content well described (eg auto descriptive standard format, documentation)">Format not proprietary and content clearly specified (e.g. autodescriptive like ODV, NetCDF CF) or at least with appropriate document describing the content.</value>
    <value key="Proprietary but well described">Format proprietary but content clearly specified</value>
    <value key="Not proprietary but not well described">Format not proprietary but content not clearly specified</value>
    <value key="Proprietary and not well described">Proprietary format and not well documented</value>
    <!--Done in a more restricted template <value key="Not documented">Format not or not well documented</value>-->

    <!--
    "Windfarm siting" en "MedSea - CH01 - Windfarm Siting"
    "Marine protected areas" en "MedSea - CH02 - Marine Protected Areas"
    "Oil platform leaks" en "MedSea - CH03 - Oil Platform Leaks"
    "Climate and coastal protection" en "MedSea - CH04 - Climate and Coastal Protection"
    "Fisheries management" en "MedSea - CH05 - Fisheries Management"
    "Marine environment" en "MedSea - CH06 - Marine Environment"
    "River inputs " en "MedSea - CH07 - River Inputs"
    -->

    <value key="Windfarm siting">MedSea - CH01 - Windfarm Siting</value>
    <value key="Marine protected areas">MedSea - CH02 - Marine Protected Areas</value>
    <value key="Oil platform leaks">MedSea - CH03 - Oil Platform Leaks</value>
    <value key="Climate and coastal protection">MedSea - CH04 - Climate and Coastal Protection</value>
    <value key="Fisheries management">MedSea - CH05 - Fisheries Management</value>
    <value key="Marine environment">MedSea - CH06 - Marine Environment</value>
    <value key="River inputs">MedSea - CH07 - River Inputs</value>
  </xsl:variable>

  <xsl:template match="mri:keyword/gco:CharacterString[normalize-space(.) = $map/value/@key]">
    <xsl:variable name="keyword" select="normalize-space(text())"/>
    <xsl:copy>
      <xsl:value-of select="$map/value[@key = $keyword]/text()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="mdb:metadataScope/mdb:MD_MetadataScope/mdb:name/gco:CharacterString[normalize-space(.) = $map/value/@key]">
    <xsl:variable name="keyword" select="normalize-space(text())"/>
    <xsl:copy>
      <xsl:value-of select="$map/value[@key = $keyword]/text()"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Add 'Vertical observation levels (meters > 0 above sea level)'

  <mdb:contentInfo>
    <mrc:MD_CoverageDescription>
      <mrc:attributeDescription>
        <gco:RecordType>observation</gco:RecordType>
      </mrc:attributeDescription>
      <mrc:attributeGroup>
        <mrc:MD_AttributeGroup>
          <mrc:contentType>
            <mrc:MD_CoverageContentTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_CoverageContentTypeCode"
                                            codeListValue="physicalMeasurement"/>
          </mrc:contentType>
          <mrc:attribute>
            <mrc:MD_RangeDimension>
              <mrc:description>
                <gco:CharacterString/>
              </mrc:description>
            </mrc:MD_RangeDimension>
          </mrc:attribute>
        </mrc:MD_AttributeGroup>
      </mrc:attributeGroup>
    </mrc:MD_CoverageDescription>
  </mdb:contentInfo>
  -->
  <xsl:template match="mdb:MD_Metadata[not(mdb:contentInfo)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="mdb:identificationInfo[1]/preceding-sibling::node()"/>
      <xsl:apply-templates select="mdb:identificationInfo"/>
      <mdb:contentInfo>
        <mrc:MD_CoverageDescription>
          <mrc:attributeDescription>
            <gco:RecordType>observation</gco:RecordType>
          </mrc:attributeDescription>
          <mrc:attributeGroup>
            <mrc:MD_AttributeGroup>
              <mrc:contentType>
                <mrc:MD_CoverageContentTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_CoverageContentTypeCode"
                                                codeListValue="physicalMeasurement"/>
              </mrc:contentType>
              <mrc:attribute>
                <mrc:MD_RangeDimension>
                  <mrc:description>
                    <gco:CharacterString/>
                  </mrc:description>
                </mrc:MD_RangeDimension>
              </mrc:attribute>
            </mrc:MD_AttributeGroup>
          </mrc:attributeGroup>
        </mrc:MD_CoverageDescription>
      </mdb:contentInfo>
      <xsl:apply-templates select="mdb:identificationInfo[last()]/following-sibling::node()"/>
    </xsl:copy>
  </xsl:template>


  <!--
  remove format edition / code added by ISO19115-3 migration
  -->
  <xsl:template match="mrd:formatSpecificationCitation/cit:CI_Citation">
    <xsl:copy>
      <xsl:copy-of select="cit:title"/>
    </xsl:copy>
  </xsl:template>


  <!-- More strict match because Not documented is available in different thesaurus. -->
  <xsl:template match="mdb:MD_Metadata/mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                            'medsea.readyness')]/*/mri:keyword/gco:CharacterString[normalize-space(.) = 'Not documented']"
          priority="2">
    <xsl:copy>Format not or not well documented</xsl:copy>
  </xsl:template>


  <!-- Responsiveness
  /mdb:MD_Metadata/mdb:dataQualityInfo/*/
                      mdq:report/mdq:DQ_DomainConsistency[mdq:measure/*/mdq:nameOfMeasure/gco:CharacterString = 'Responsiveness']/
                      mdq:result/mdq:DQ_QuantitativeResult/mdq:value
  # Current:
  1.<option value="&lt;15mn (on-line download)">&lt;15mn (on-line download)</option>
  2.<option value="Less than 3 hours">Less than 3 hours</option>
  3.<option value="Less than 24 hours">Less than 24 hours</option>
  4.<option value="Less than 1 week">Less than 1 week</option>
  5.<option value="More than 1 week">More than 1 week</option>
  6.<option value="Not documented">Not documented</option>

  # Expected:
  1.No information is found on response time
  2.More than 1 week for release
  3.Less or equal to 1 week for release
  4.Online downloading (i.e. a few hours or less) for release

  6 => 1
  5 => 2
  4 => 3
  3 => 3
  2 => 4
  1 => 4
  -->
  <xsl:variable name="responsivenessMap">
    <value key="&lt;15mn (on-line download)">Online downloading (i.e. a few hours or less) for release</value>
    <value key="Less than 3 hours">Online downloading (i.e. a few hours or less) for release</value>
    <value key="Less than 24 hours">Less or equal to 1 week for release</value>
    <value key="Less than 1 week">Less or equal to 1 week for release</value>
    <value key="More than 1 week">More than 1 week for release</value>
    <value key="Not documented">No information is found on response time</value>
  </xsl:variable>

  <xsl:template match="mdb:MD_Metadata/mdb:dataQualityInfo/*/
                      mdq:report/mdq:DQ_DomainConsistency[mdq:measure/*/mdq:nameOfMeasure/gco:CharacterString = 'Responsiveness']/
                      mdq:result/mdq:DQ_QuantitativeResult/mdq:value/gco:Record[normalize-space(.) = $responsivenessMap/value/@key]">
    <xsl:variable name="value" select="normalize-space(text())"/>
    <xsl:copy>
      <xsl:value-of select="$responsivenessMap/value[@key = $value]"/>
    </xsl:copy>
  </xsl:template>

  <!-- Data policy
  /mdb:MD_Metadata/mdb:identificationInfo/*/
                          mri:resourceConstraints/mco:MD_LegalConstraints/mco:otherConstraints
  "Not or not well documented" replace "unknown" or "Not documented"
  -->
  <xsl:template match="mdb:MD_Metadata/mdb:identificationInfo/*/
                          mri:resourceConstraints/mco:MD_LegalConstraints/mco:otherConstraints/gco:CharacterString[normalize-space(.) = 'Not documented']">
    <xsl:copy>Not or not well documented</xsl:copy>
  </xsl:template>

  <!--
       Pricing
   /mdb:MD_Metadata/mdb:identificationInfo/*/
                        mri:resourceConstraints/mco:MD_Constraints/mco:useLimitation
  # Current:
  1.<option value="No charge">No charge</option>
  2.<option value="Distribution cost charge">Distribution cost charge</option>
  3.<option value="Collection cost charge">Collection cost charge</option>
  4.<option value="Commercial cost charge">Commercial cost charge</option>
  5.<option value="Cost charge depends on intended use and category of users">Cost charge depends on intended use and category of users</option>
  6.<option value="Not documented">Not documented</option>


  # Expected:
  1.Not or not well documented
  2.Commercial charge
  3.Distribution charge
  4.Collection charge
  5.Free of charge for academic institutions and uses
  6.Open and Free, No charge
  -->

  <xsl:variable name="chargeMap">
    <value key="No charge">Open and Free, No charge</value>
    <value key="Distribution cost charge">Distribution charge</value>
    <value key="Collection cost charge">Collection charge</value>
    <value key="Commercial cost charge">Commercial charge</value>
    <value key="Cost charge depends on intended use and category of users">Free of charge for academic institutions and uses</value>
    <value key="Not documented">Not or not well documented</value>
  </xsl:variable>
  <xsl:template match="mdb:MD_Metadata/mdb:identificationInfo/*/
                        mri:resourceConstraints/mco:MD_Constraints/mco:useLimitation/gco:CharacterString[normalize-space(.) = $chargeMap/value/@key]">
    <xsl:variable name="value" select="normalize-space(text())"/>
    <xsl:copy>
      <xsl:value-of select="$chargeMap/value[@key = $value]"/>
    </xsl:copy>
  </xsl:template>



  <!--
  Remove /mdb:MD_Metadata/mdb:dataQualityInfo/*/
                      mdq:report/mdq:DQ_DomainConsistency[mdq:measure/*/mdq:nameOfMeasure/gco:CharacterString = 'Reliability']/
                      mdq:result/mdq:DQ_QuantitativeResult/mdq:value

  Remove /mdb:MD_Metadata/mdb:identificationInfo/*/
                            mri:descriptiveKeywords
                            [contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                            'theme.medsea.reliability')]
  -->
  <xsl:template match="mdb:MD_Metadata/mdb:dataQualityInfo/*/
                          mdq:report[mdq:DQ_DomainConsistency/
                            mdq:measure/*/mdq:nameOfMeasure/gco:CharacterString = 'Reliability']|
                       mdb:MD_Metadata/mdb:identificationInfo/*/
                          mri:descriptiveKeywords[
                            contains(*/mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*/text(),
                              'theme.medsea.reliability')]"/>


  <xsl:template match="mri:thesaurusName/cit:CI_Citation/cit:identifier/*/mcc:code/*[contains(@xlink:href, 'medsea.')]">
    <xsl:copy>
      <xsl:attribute name="xlink:href">
        <xsl:value-of select="replace(@xlink:href, 'medsea.', 'emodnet-checkpoint.')"/>
      </xsl:attribute>
      <xsl:value-of select="replace(., 'medsea.', 'emodnet-checkpoint.')"/>
    </xsl:copy>
  </xsl:template>


  <!-- Add /mdb:MD_Metadata/mdb:identificationInfo/*/mri:citation/*/cit:alternateTitle
  use to store medseaTitle
  -->
  <xsl:template match="mdb:identificationInfo/mri:MD_DataIdentification/mri:citation/cit:CI_Citation[not(cit:alternateTitle)]">
    <xsl:copy>
      <xsl:apply-templates select="cit:title"/>
      <cit:alternateTitle>
        <gco:CharacterString></gco:CharacterString>
      </cit:alternateTitle>
      <xsl:apply-templates select="cit:title/following-sibling::node()"/>
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