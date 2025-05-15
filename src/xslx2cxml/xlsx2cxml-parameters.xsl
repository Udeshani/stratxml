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
                xmlns:excel="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                exclude-result-prefixes="#all">


    <xsl:param name="output_dir"        as="xs:string"/>
    <xsl:param name="debug"             as="xs:boolean" select="false()"/>
    <xsl:param name="sheet_ui_name"             as="xs:string" select="'HistoricalMonthly Performance'"/>
    <xsl:param name="footer_rows" as="xs:integer" select="0"/>
    <xsl:param name="header_rows" as="xs:integer" select="0"/>
    <xsl:param name="preferred_width" as="xs:integer" select="100"/>

</xsl:stylesheet>