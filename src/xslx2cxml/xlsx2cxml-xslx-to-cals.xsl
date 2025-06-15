<!--
# =============================================================================
# Copyright © 2021 - 2022 Typefi Systems. All rights reserved.
#
# Unless required by applicable law or agreed to in writing, software
# is distributed on an "as is" basis, without warranties or conditions
# of any kind, either express or implied.
# =============================================================================
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:e="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                xmlns:tps="http://www.typefi.com/ContentXML"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0"
                exclude-result-prefixes="#all">

    <xsl:variable name="border.types" select="('bottom', 'top', 'left', 'right')" as="xs:string*"/>

    <xsl:mode name="xslx-to-cals" on-no-match="shallow-copy"/>

    <xsl:template match="e:sheetProtection | e:extLst | e:dataValidations" mode="xslx-to-cals"/>


    <xsl:template match="e:sheetData" mode="xslx-to-cals">
        <xsl:variable name="row-count" select="count(e:row)" as="xs:integer"/>
        <xsl:variable name="col-count" select="max(e:row/count(e:c))" as="xs:integer"/>
        <xsl:variable name="default-col-width" select="tps:get-default-column-width(.)" as="xs:decimal"/>
        <xsl:variable name="total-width" select="(tps:get-total-col-width($default-col-width)[$cols], $default-col-width*$col-count)[1]" as="xs:decimal"/>

        <table>
            <tgroup>
                <xsl:for-each select="1 to $col-count">
                    <xsl:variable name="col-width" select="xs:decimal(($cols/e:col[number(@min) le current() and number(@max) ge current()]/@width, $default-col-width)[1])" as="xs:decimal?"/>
                    <xsl:variable name="width-prop" select="xs:decimal($col-width div $total-width)" as="xs:decimal?"/>

                    <colspec colname="{.}" colwidth="{format-number($width-prop, '0.00%')}"/>
                </xsl:for-each>

                <xsl:if test="$header_rows gt 0">
                    <thead>
                        <xsl:apply-templates select="e:row[position() = 1 to $header_rows]" mode="#current"/>
                    </thead>
                </xsl:if>
                <tbody>
                    <xsl:apply-templates select="e:row[position() = $header_rows + 1 to $row-count - $footer_rows]" mode="#current"/>
                </tbody>
                <xsl:if test="$footer_rows gt 0">
                    <tfoot>
                        <xsl:apply-templates select="e:row[position() = ($row-count - $footer_rows + 1) to $row-count]" mode="#current"/>
                    </tfoot>
                </xsl:if>
            </tgroup>
        </table>

    </xsl:template>


    <xsl:template match="e:row" mode="xslx-to-cals">
        <xsl:if test="not(@hidden eq '1')">
            <row>
                <xsl:apply-templates mode="#current"/>
            </row>
        </xsl:if>
    </xsl:template>


    <xsl:template match="e:c" mode="xslx-to-cals">
        <xsl:variable name="prev-r" select="replace(preceding-sibling::e:c[1]/@r, '\d', '')" as="xs:string?"/>
        <xsl:variable name="cur-r" select="replace(@r, '\d', '')" as="xs:string?"/>
        <xsl:variable name="cur-col"
                      select="substring($cur-r, if (string-length($cur-r) eq 1) then 1 else string-length($cur-r), 1)"
                      as="xs:string"/>
        <xsl:variable name="prev-col"
                      select="if ($prev-r) then substring($prev-r, if(string-length($prev-r) eq 1) then 1 else string-length($prev-r), 1) else $cur-col"
                      as="xs:string"/>

        <xsl:variable name="difference" select="string-to-codepoints($cur-col) - string-to-codepoints($prev-col)"
                      as="xs:integer"/>

        <xsl:for-each select="1 to (if($difference ge 0) then $difference - 1 else $difference + 25)">
            <entry type="normal">
                <xsl:attribute name="align" select="'left'"/>
                <xsl:attribute name="valign" select="'bottom'"/>
            </entry>
        </xsl:for-each>

        <entry type="normal">
            <xsl:call-template name="namest"/>
            <xsl:call-template name="nameend"/>
            <xsl:attribute name="align" select="'left'"/>
            <xsl:attribute name="valign" select="'bottom'"/>

            <xsl:apply-templates mode="#current"/>
        </entry>

    </xsl:template>


    <xsl:template match="e:cell-format"/>


    <xsl:template match="e:style"/>


    <xsl:template name="namest">
        <xsl:attribute name="namest">
            <xsl:value-of select="count(preceding-sibling::e:c) + 1"/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template name="nameend">
        <xsl:variable name="merge-cells" select="sum(tps:get-merged-cell-count(@r))" as="xs:integer"/>

        <xsl:attribute name="nameend">
            <xsl:value-of select="$merge-cells + count(preceding-sibling::e:c) + 1"/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="@s" mode="xslx-to-cals">
        <xsl:variable name="style-index" select="." as="xs:integer?"/>

        <xsl:variable name="background-color" select="tps:get-background-color($style-index)" as="xs:string?"/>
        <xsl:variable name="foreground-color" select="tps:get-foreground-color($style-index)" as="xs:string?"/>

        <xsl:choose>
            <xsl:when test="tps:is-cell-formatted($style-index) or $background-color or $foreground-color">
                <xsl:processing-instruction name="cell-format">
                    <xsl:if test="$background-color">
                        <xsl:text>background-color:</xsl:text>
                        <xsl:value-of select="$background-color"/>
                        <xsl:text>; </xsl:text>
                    </xsl:if>

                    <xsl:if test="$foreground-color">
                        <xsl:text>foreground-color:</xsl:text>
                        <xsl:value-of select="$foreground-color"/>
                        <xsl:text>; </xsl:text>
                    </xsl:if>

                    <xsl:for-each select="$border.types">
                        <xsl:variable name="border-style" select="tps:get-border-style($style-index, .)" as="xs:string?"/>
                        <xsl:variable name="fill-pattern" select="tps:get-pattern-fill-type($style-index)" as="xs:string?"/>

                        <xsl:if test="$border-style != ('none', '')">
                            <xsl:text expand-text="yes">border-{.}:</xsl:text>
                            <xsl:value-of select="$border-style"/>

                            <xsl:if test="$fill-pattern ne 'none'">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$fill-pattern"/>
                            </xsl:if>
                            <xsl:text>; </xsl:text>
                        </xsl:if>

                    </xsl:for-each>
                </xsl:processing-instruction>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="e:c[not(normalize-space())][tps:is-cell-merged(@r)]" priority="10" mode="xslx-to-cals"/>


    <xsl:template match="e:oddFooter" mode="xslx-to-cals"/>


    <xsl:function name="tps:is-cell-formatted" as="xs:boolean">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:variable name="border-style" as="xs:string?" select="$border.types!tps:get-border-style($style-index, .)=>string-join()"/>

        <xsl:sequence select="$border-style != ''"/>
    </xsl:function>
</xsl:stylesheet>