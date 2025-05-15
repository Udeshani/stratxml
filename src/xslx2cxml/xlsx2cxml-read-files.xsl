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
                xmlns:e="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                xmlns:tps="http://www.typefi.com/ContentXML"
                exclude-result-prefixes="#all">


    <xsl:function name="tps:get-worksheet" as="document-node()">
        <xsl:sequence select="$worksheet"/>
    </xsl:function>


    <xsl:function name="tps:get-stylesheet" as="element(e:styleSheet)">

        <xsl:sequence select="$style.file/e:styleSheet"/>
    </xsl:function>


    <xsl:function name="tps:get-sharedstring-table" as="element(e:sst)">
        <xsl:sequence select="$sharedstring.table/e:sst"/>
    </xsl:function>


    <xsl:function name="tps:get-workbook-rels" as="document-node()">
        <xsl:sequence select="tps:get-input-file('xl/_rels/workbook.xml.rels')"/>
    </xsl:function>


    <xsl:function name="tps:get-worksheet-rels" as="document-node()">

        <xsl:sequence select="tps:get-input-file('xl/worksheets/_rels/' || $sheet_ui_name || '.rels')"/>
    </xsl:function>


    <xsl:function name="tps:get-drawing-rels" as="document-node()">
        <xsl:param name="drawing" as="xs:string"/>

        <xsl:sequence select="tps:get-input-file('xl/drawings/_rels/' || $drawing || '.rels')"/>
    </xsl:function>


    <xsl:function name="tps:get-chart-xml" as="document-node()?">
        <xsl:param name="filename" as="xs:string"/>

        <xsl:sequence select="tps:get-input-file('xl/charts/' || $filename)"/>
    </xsl:function>


    <xsl:function name="tps:get-theme-xml" as="document-node()?">
        <xsl:sequence select="tps:get-input-file('xl/theme/theme1.xml')"/>
    </xsl:function>

</xsl:stylesheet>