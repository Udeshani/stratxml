<!--
# =============================================================================
# Copyright © 2021 - 2022 Typefi Systems. All rights reserved.
#
# Unless required by applicable law or agreed to in writing, software
# is distributed on an "as is" basis, without warranties or conditions
# of any kind, either express or implied.
# =============================================================================
-->
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tps="http://www.typefi.com/ContentXML"
                xmlns:e="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
                exclude-result-prefixes="#all">


    <xsl:variable name="style.file" select="tps:get-input-file('xl/styles.xml')" as="document-node()"/>
    <xsl:variable name="worksheet"  select="tps:get-input-file('xl/worksheets/'|| $sheet_ui_name)" as="document-node()"/>
   <!-- <xsl:variable name="partnerships"  select="tps:get-input-file('xl/worksheets/sheet4.xml')" as="document-node()"/>
    <xsl:variable name="budget"  select="tps:get-input-file('xl/worksheets/sheet9.xml')" as="document-node()"/>
    <xsl:variable name="vision-mission"  select="tps:get-input-file('xl/worksheets/sheet12.xml')" as="document-node()"/>
-->
    <xsl:variable name="sharedstring.table"  select="tps:get-input-file('xl/sharedStrings.xml')" as="document-node()"/>
    <xsl:variable name="worksheet.rels" select="tps:get-input-file('xl/worksheets/_rels/sheet1.xml')" as="document-node()"/>
    <xsl:variable name="workbook" select="tps:get-input-file('xl/workbook.xml')"  as="document-node()"/>

    <xsl:variable name="sheet.name" select="substring-after(tps:get-workbook-rels()/rel:Relationships/rel:Relationship[@Id = $workbook//e:sheet[@name = $sheet_ui_name]/@r:id]/@Target, '/')" as="xs:string?"/>
    <xsl:variable name="style.sheet" select="tps:get-stylesheet()" as="element(e:styleSheet)"/>
    <xsl:variable name="cell.range" select="$worksheet//e:dimension/@ref" as="xs:string?"/>
    <xsl:variable name="cols" select="$worksheet/e:cols" as="element(e:cols)?"/>

    <xsl:variable name="goals" as="map(xs:string, xs:string)">
        <xsl:map>
            <xsl:map-entry key="'Education'" select="'Advance education'"/>
            <xsl:map-entry key="'HealthandPopulation'" select="'Advance population policies/programs and health'"/>
            <xsl:map-entry key="'Agriculture'" select="'Advance agriculture and Agricultural policy and administrative management'"/>
            <xsl:map-entry key="'Humanitarian'" select="'Advance measures to co-ordinate the assessment and safe delivery of humanitarian aid'"/>
            <xsl:map-entry key="'Other'" select="'Environmental policy and administrative management and the multisector aid'"/>
            <xsl:map-entry key="'Governance'" select="'Advance technical co-operation provided to parliament, government ministries, law enforcement agencies and the judiciary to assist review and reform of the security system to improve democratic governance and civilian control'"/>
            <xsl:map-entry key="'Infrastructure'" select="'Advance other social infrastructure and services'"/>
            <xsl:map-entry key="'EconomicGrowth'" select="'Economic Development Planning'"/>
            <xsl:map-entry key="'AdministrativeCosts'" select="'Administrative costs such as Program Design and Learning'"/>
        </xsl:map>
    </xsl:variable>

    <xsl:variable name="format.codes" as="map(xs:integer, xs:string)">
        <xsl:map>
            <xsl:map-entry key="1" select="'0'"/>
            <xsl:map-entry key="2" select="'0.00'"/>
            <xsl:map-entry key="3" select="'#,##0'"/>
            <xsl:map-entry key="4" select="'#,##0.00'"/>
            <xsl:map-entry key="9" select="'0%'"/>
            <xsl:map-entry key="10" select="'0.00%'"/>
            <xsl:map-entry key="11" select="'0.00E+00'"/>
            <xsl:map-entry key="12" select="'# ?/?'"/>
            <xsl:map-entry key="13" select="'# ??/??'"/>
            <xsl:map-entry key="14" select="'mm-dd-yy'"/>
            <xsl:map-entry key="15" select="'d-mmm-yy'"/>
            <xsl:map-entry key="16" select="'d-mmm'"/>
            <xsl:map-entry key="17" select="'mmm-yy'"/>
            <xsl:map-entry key="18" select="'h:mm AM/PM'"/>
            <xsl:map-entry key="19" select="'h:mm:ss AM/PM'"/>
            <xsl:map-entry key="20" select="'h:mm'"/>
            <xsl:map-entry key="21" select="'h:mm:ss'"/>
            <xsl:map-entry key="22" select="'m/d/yy h:mm'"/>
            <xsl:map-entry key="37" select="'#,##0 ;(#,##0)'"/>
            <xsl:map-entry key="38" select="'#,##0 ;[Red](#,##0)'"/>
            <xsl:map-entry key="39" select="'#,##0.00;(#,##0.00)'"/>
            <xsl:map-entry key="40" select="'#,##0.00;[Red](#,##0.00)'"/>
            <xsl:map-entry key="45" select="'mm:ss'"/>
            <xsl:map-entry key="46" select="'[h]:mm:ss'"/>
            <xsl:map-entry key="47" select="'mmss.0'"/>
            <xsl:map-entry key="48" select="'##0.0E+0'"/>
            <xsl:map-entry key="49" select="'@'"/>
        </xsl:map>
    </xsl:variable>

</xsl:stylesheet>