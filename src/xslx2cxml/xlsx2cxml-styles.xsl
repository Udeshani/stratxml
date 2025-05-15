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
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart"
                exclude-result-prefixes="#all">


    <xsl:function name="tps:get-theme-color" as="xs:string">
        <xsl:param name="context" as="element()"/>
        <xsl:param name="idx" as="xs:integer"/>

        <xsl:sequence select="$context/(c:ser/c:dPt[c:idx/@val = $idx] | c:ser)/c:spPr//a:solidFill/a:schemeClr/@val[starts-with(., 'accent')]"/>
    </xsl:function>


    <xsl:function name="tps:get-number-format" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:variable name="numberformat-id" select="tps:get-cellxfs($style-index)/@numFmtId" as="xs:integer?"/>

        <xsl:sequence select="($style.sheet/e:numFmts/e:numFmt[@numFmtId = $numberformat-id]/@formatCode[. ne ''], $format.codes($numberformat-id))[1]"/>
    </xsl:function>


    <xsl:function name="tps:get-border-style" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>
        <xsl:param name="type" as="xs:string"/>

        <xsl:variable name="border-id" select="tps:get-cellxfs($style-index)/@borderId" as="xs:integer?"/>

        <xsl:sequence select="$style.sheet/e:borders/e:border[$border-id + 1]/*[local-name() eq $type]/@style"/>
    </xsl:function>


    <xsl:function name="tps:get-pattern-fill" as="element(e:patternFill)">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:variable name="fill-id" select="tps:get-cellxfs($style-index)/@fillId" as="xs:integer?"/>

        <xsl:sequence select="$style.sheet/e:fills/e:fill[$fill-id + 1]/e:patternFill"/>
    </xsl:function>


    <xsl:function name="tps:get-pattern-fill-type" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="tps:get-pattern-fill($style-index)/@patternType"/>
    </xsl:function>


    <xsl:function name="tps:get-background-color" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="tps:get-pattern-fill($style-index)/e:fgColor/@rgb"/>
    </xsl:function>


    <xsl:function name="tps:get-cellxfs" as="element(e:xf)?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="$style.sheet/e:cellXfs/e:xf[$style-index + 1]"/>
    </xsl:function>


    <xsl:function name="tps:get-align" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="tps:get-cellxfs($style-index)/e:alignment/@horizontal"/>
    </xsl:function>


    <xsl:function name="tps:get-rotation" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="tps:get-cellxfs($style-index)/e:alignment/@textRotation"/>
    </xsl:function>


    <xsl:function name="tps:get-valign" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="tps:get-cellxfs($style-index)/e:alignment/@verticle"/>
    </xsl:function>


    <xsl:function name="tps:get-font" as="element(e:font)?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:variable name="font-id" select="tps:get-cellxfs($style-index)/@fontId" as="xs:integer?"/>
        <xsl:sequence select="$style.sheet/e:fonts/e:font[$font-id + 1]"/>
    </xsl:function>


    <xsl:function name="tps:get-foreground-color" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:sequence select="tps:get-font($style-index)/e:color/@rgb"/>
    </xsl:function>


    <xsl:function name="tps:get-style" as="xs:string?">
        <xsl:param name="style-index" as="xs:integer?"/>

        <xsl:variable name="font" select="tps:get-font($style-index)" as="element(e:font)?"/>

        <xsl:variable name="styles" as="xs:string*">
            <xsl:if test="$font[e:b]">
                <xsl:sequence select="'bold'"/>
            </xsl:if>
            <xsl:if test="$font[e:i]">
                <xsl:sequence select="'italic'"/>
            </xsl:if>
            <xsl:if test="$font[e:u]">
                <xsl:sequence select="'underline'"/>
            </xsl:if>
            <xsl:if test="$font/e:vertAlign/@val">
                <xsl:sequence select="$font/e:vertAlign/@val"/>
            </xsl:if>
            <xsl:if test="$font[e:strike]">
                <xsl:sequence select="'strikethrough'"/>
            </xsl:if>
        </xsl:variable>

        <xsl:sequence select="string-join($styles, '-')"/>
    </xsl:function>

</xsl:stylesheet>