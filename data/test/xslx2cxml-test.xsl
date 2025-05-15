<!--
# =============================================================================
# Copyright © 2021 Typefi Systems. All rights reserved.
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
                xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:excel="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                exclude-result-prefixes="#all">

    <xsl:include href="../../src/xslx2cxml.xsl"/>

    <!-- Suppress excessive messages -->
    <xsl:template name="generated-document-info">
        <xsl:param name="filename" as="xs:string"/>
    </xsl:template>

    <xsl:template name="result-chart">
        <xsl:param name="chart-name" select="." as="xs:string"/>

        <xsl:apply-templates select="tps:get-chart-xml($chart-name)//c:plotArea">
            <xsl:with-param name="chart-name" select="substring-before($chart-name, '.xml')" as="xs:string" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>


    <!-- This function is used for abstraction of unit tests although document[$n] would also be a short syntax -->
    <xsl:function name="tps:get-document" as="element(document)?">
        <xsl:param name="cxml-documents"       as="document-node()"/>

        <xsl:sequence select="$cxml-documents/document"/>
    </xsl:function>


    <xsl:function name="tps:get-sections" as="element(tps:section)*">
        <xsl:param name="cxml-documents"       as="document-node()"/>

        <xsl:sequence select="tps:get-document($cxml-documents)/tps:content/tps:section"/>
    </xsl:function>


    <xsl:function name="tps:get-align" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="'left'"/>
    </xsl:function>


    <xsl:function name="tps:get-valign" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="'right'"/>
    </xsl:function>


    <xsl:function name="tps:get-rotation" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="'90'"/>
    </xsl:function>


    <xsl:function name="tps:get-font" as="element(excel:font)?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:if test="$style-index">
            <xsl:sequence>
                <excel:font>
                    <excel:u/>
                    <excel:b/>
                    <excel:sz val="10"/>
                    <excel:color rgb="FFFF0000"/>
                    <excel:name val="Times New Roman"/>
                    <excel:family val="1"/>
                </excel:font>
            </xsl:sequence>
        </xsl:if>
    </xsl:function>


    <xsl:function name="tps:get-border-style" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>
        <xsl:param name="type" as="xs:string"/>

        <xsl:choose>
            <xsl:when test="$type eq 'left'">
                <xsl:sequence select="'thin'"/>
            </xsl:when>
            <xsl:when test="$type eq 'right'">
                <xsl:sequence select="'thin'"/>
            </xsl:when>
            <xsl:when test="$type eq 'bottom'">
                <xsl:sequence select="'medium'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>


    <xsl:function name="tps:get-background-color" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="'FF00FF'"/>
    </xsl:function>


    <xsl:function name="tps:get-pattern-fill-type" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="'solid'"/>
    </xsl:function>


    <xsl:function name="tps:get-number-format" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="if ($style-index) then '0.000%' else ''"/>
    </xsl:function>


    <xsl:function name="tps:get-sharedstring-table" as="element(excel:sst)">
        <xsl:sequence>
            <excel:sst count="11" uniqueCount="11">
                <excel:si>
                    <excel:t>x</excel:t>
                </excel:si>
                <excel:si>
                    <excel:t>y</excel:t>
                </excel:si>
                <excel:si>
                    <excel:t>z</excel:t>
                </excel:si>
            </excel:sst>
        </xsl:sequence>
    </xsl:function>


    <xsl:function name="tps:get-shared-string" as="xs:string">
        <xsl:param name="si-no" as="xs:integer"/>

        <xsl:sequence select="tps:get-sharedstring-table()/excel:si[$si-no]/excel:t"/>
    </xsl:function>


    <xsl:function name="tps:get-worksheet" as="document-node()">
        <xsl:sequence>
            <xsl:document>
                <excel:worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                           xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                           xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac"
                           xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">
                            <excel:dimension ref="A1:C9"/>
                    <excel:sheetViews>
                        <excel:sheetView tabSelected="1" showRuler="0" workbookViewId="0">
                            <excel:pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/>
                            <excel:election pane="bottomLeft" activeCell="C10" sqref="C10"/>
                        </excel:sheetView>
                    </excel:sheetViews>
                    <excel:sheetFormatPr baseColWidth="10" defaultRowHeight="16" x14ac:dyDescent="0.2"/>
                    <excel:sheetData>
                        <excel:row r="1" spans="1:3" ht="21" thickBot="1" x14ac:dyDescent="0.3">
                            <excel:c r="A1" s="2" t="s">
                                <v>0</v>
                            </excel:c>
                            <excel:c r="B1" s="2" t="s">
                                <v>1</v>
                            </excel:c>
                            <excel:c r="C1" s="2" t="s">
                                <v>2</v>
                            </excel:c>
                        </excel:row>
                    </excel:sheetData>
                    <excel:mergeCells count="3">
                        <excel:mergeCell ref="A7:C7"/>
                        <excel:mergeCell ref="A8:B8"/>
                        <excel:mergeCell ref="B9:C9"/>
                    </excel:mergeCells>
                    <excel:pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>
                    <excel:pageSetup paperSize="9" orientation="portrait" horizontalDpi="0" verticalDpi="0"/>
                </excel:worksheet>
            </xsl:document>
        </xsl:sequence>
    </xsl:function>


    <xsl:function name="tps:get-theme-xml" as="document-node()?">
        <xsl:sequence>
            <xsl:document>
                <a:theme name="Office Theme">
                    <a:themeElements>
                        <a:accent1>
                            <a:srgbClr val="4472C4"/>
                        </a:accent1>
                    </a:themeElements>
                </a:theme>
            </xsl:document>
        </xsl:sequence>
    </xsl:function>

</xsl:stylesheet>