<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">

  <!-- MEDSEA / Use thesaurus local.theme.emodnet-checkpoint.challenges
  to populate the field gmd:hierarchyLevelName.
                            -->
  <xsl:template mode="mode-iso19115-3" priority="20000"
                match="mdb:metadataScope/mdb:MD_MetadataScope/mdb:name[
                            contains($metadata/mdb:metadataStandard/*/cit:title/gco:CharacterString,
                                     'MedSea Checkpoint') or
                            contains($metadata/mdb:metadataStandard/*/cit:title/gco:CharacterString,
                                     'MedSea Targeted Product')]">
    <div class="form-group gn-field"
         id="gn-el-11">
      <label for="gn-field-11" class="col-sm-2 control-label">
        <xsl:value-of select="$strings/challenge"/>
      </label>
      <div class="col-sm-9 gn-value">
        <input class="form-control" value="{gco:CharacterString}"
               name="_{gco:CharacterString/gn:element/@ref}"
               data-gn-keyword-picker=""
               data-thesaurus-key="local.theme.emodnet-checkpoint.challenges"
               data-gn-field-tooltip="iso19115-3|mdb:metadataScope||/mdb:MD_Metadata/mdb:metadataScope"
               type="text"/>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
