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
                exclude-result-prefixes="#all">

    <xsl:template match="e:v" mode="xslx-to-cals">
        <xsl:variable name="style-index" select="ancestor::e:c/@s" as="xs:integer?"/>
        <xsl:variable name="is-shared-string" select="parent::e:c/@t eq 's'" as="xs:boolean?"/>

        <xsl:choose>
            <xsl:when test="$is-shared-string">
                <xsl:value-of select="tps:get-shared-string(xs:integer(. + 1))"/>
             </xsl:when>
            <xsl:when test="tps:get-cellxfs($style-index)/@applyNumberFormat eq '1' and tps:get-cellxfs($style-index)/@numFmtId ne '0'">
                <xsl:variable name="num-formats" select="tokenize(replace(tps:get-number-format($style-index), '&quot;', ''), ';')" as="xs:string*"/>
                <xsl:variable name="section-count" select="count($num-formats)" as="xs:integer"/>

                <xsl:choose>
                    <xsl:when test="$is-shared-string">
                        <xsl:value-of select="tps:get-shared-string(xs:integer(. + 1))"/>
                    </xsl:when>
                    <xsl:when test="$num-formats[1] eq 'mm/dd/yy' and (. castable as xs:date)">
                        <xsl:value-of select="format-date(., $num-formats[1])"/>
                    </xsl:when>
                    <xsl:when test="$num-formats[1] eq 'mm/dd/yy'">
                        <xsl:value-of select="format-date(tps:get-date-from-the-serial-no(.), '[M01]/[D01]/[Y01]')"/>
                    </xsl:when>
                    <xsl:when test="$num-formats[1] eq 'mm-dd-yy'">
                        <xsl:value-of select="format-date(tps:get-date-from-the-serial-no(.), '[M01]-[D01]-[Y01]')"/>
                    </xsl:when>
                    <xsl:when test="matches($num-formats[1], 'hh:mm|h:mm:ss') and (. castable as xs:time)">
                        <xsl:value-of select="format-time(xs:time(.),$num-formats[1])"/>
                    </xsl:when>
                    <xsl:when test="matches($num-formats[1], 'h:mm|hh:mm|h:mm:ss') and not(. castable as xs:time)">
                        <xsl:value-of select="tps:get-time-from-the-value(xs:decimal(number(.)), $num-formats[1])"/>
                    </xsl:when>
                    <xsl:when test="$num-formats[1] eq '0.00E+00'">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:when test="$num-formats[1] eq 'ddd' and not(. castable as xs:date)">
                        <xsl:value-of select="format-date(tps:get-date-from-the-serial-no(.), '[FNn, *-3]')"/>
                    </xsl:when>
                    <!--Conditional formatting-->
                    <xsl:when test="$section-count eq 4 and (. > 0)">
                        <xsl:value-of select="format-number(., $num-formats[1])"/>
                    </xsl:when>
                    <xsl:when test="$section-count eq 4 and (. &lt; 0)">
                        <xsl:value-of select="format-number(., $num-formats[2])"/>
                    </xsl:when>
                    <xsl:when test="$section-count eq 4 and (. = 0)">
                        <xsl:value-of select="format-number(., $num-formats[3])"/>
                    </xsl:when>
                    <xsl:when test="$section-count eq 2 and (. &gt;= 0)">
                        <xsl:value-of select="format-number(., $num-formats[1])"/>
                    </xsl:when>
                    <xsl:when test="$section-count eq 2 and (. &lt; 0)">
                        <xsl:value-of select="format-number(., $num-formats[2])"/>
                    </xsl:when>
                    <!--Number format-->
                    <xsl:when test="$num-formats[1] ne '@'">
                        <xsl:value-of select="format-number(., $num-formats[1])"/>
                    </xsl:when>

                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="e:t">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="e:f"/>

</xsl:stylesheet>