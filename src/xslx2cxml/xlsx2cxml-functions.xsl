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

    <xsl:function name="tps:get-cell-count" as="xs:integer">
        <xsl:param name="tgroup" as="element(tgroup)"/>

        <xsl:sequence select="max($tgroup/descendant::row/count(entry))"/>
    </xsl:function>

    <xsl:function name="tps:get-row-count" as="xs:integer">
        <xsl:param name="tgroup" as="element(tgroup)"/>

        <xsl:sequence select="count($tgroup/descendant::row)"/>
    </xsl:function>

    <xsl:function name="tps:get-shared-string" as="xs:string">
        <xsl:param name="si-no" as="xs:integer"/>

        <xsl:sequence select="tps:get-sharedstring-table()/e:si[$si-no]/(e:t, e:r/e:t)[1]"/>
    </xsl:function>


    <!--
    In order to fill the namend we need to identify the number of merged cells
    -->
    <xsl:function name="tps:get-merged-cell-count" as="xs:integer*">
        <xsl:param name="cell" as="xs:string"/>

        <xsl:variable name="merge-cells" select="$worksheet/e:worksheet/e:mergeCells/e:mergeCell" as="element(e:mergeCell)*"/>

        <xsl:for-each select="$merge-cells">
            <xsl:variable name="ref" select="@ref" as="xs:string"/>
            <xsl:sequence select="if (tps:is-within-cell-range($cell, $ref)) then tps:get-cell-range-cell-count(@ref) else 0"/>
        </xsl:for-each>
    </xsl:function>


    <!--
    This function returns a collection of boolean values, if at lease one of them is true() that means that cell is merged.
    <-->
    <xsl:function name="tps:is-cell-merged" as="xs:boolean">
        <xsl:param name="cell" as="xs:string"/>

        <xsl:variable name="merge-cells" select="$worksheet/e:worksheet/e:mergeCells/e:mergeCell" as="element(e:mergeCell)*"/>

        <xsl:sequence select="some $c in $merge-cells satisfies tps:is-within-cell-range($cell, $c/@ref)"/>
    </xsl:function>


    <xsl:function name="tps:get-cell-range-cell-count" as="xs:integer">
        <xsl:param name="cell-range" as="xs:string"/>
        <xsl:variable name="cell-range-map" select="tps:get-parsed-cell-range($cell-range)" as="map(xs:string, xs:string)"/>

        <xsl:variable name="first-cell" select="$cell-range-map('first-cell')" as="xs:string"/>
        <xsl:variable name="last-cell" select="$cell-range-map('last-cell')" as="xs:string"/>
        <xsl:variable name="first-col" select="$cell-range-map('first-col')" as="xs:string"/>
        <xsl:variable name="last-col" select="$cell-range-map('last-col')" as="xs:string"/>

        <xsl:choose>
            <xsl:when test="count(string-to-codepoints($last-col)) gt 1">
                <xsl:sequence select="xs:integer(sum(string-to-codepoints($last-col)) - sum(string-to-codepoints($first-col)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="xs:integer(string-to-codepoints($last-col) - string-to-codepoints($first-col))"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>


    <xsl:function name="tps:is-within-cell-range" as="xs:boolean">
        <xsl:param name="cur-cell" as="xs:string"/>
        <xsl:param name="cell-range" as="xs:string"/>

        <xsl:variable name="cell-range-map" select="tps:get-parsed-cell-range($cell-range)" as="map(xs:string, xs:string)"/>
        <xsl:variable name="col" select="replace($cur-cell, '\d', '')" as="xs:string"/>
        <xsl:variable name="row" select="xs:decimal(replace($cur-cell, '[A-Z]', ''))" as="xs:decimal"/>

        <xsl:variable name="first-cell" select="$cell-range-map('first-cell')" as="xs:string"/>
        <xsl:variable name="last-cell" select="$cell-range-map('last-cell')" as="xs:string"/>
        <xsl:variable name="first-col" select="$cell-range-map('first-col')" as="xs:string"/>
        <xsl:variable name="last-col" select="$cell-range-map('last-col')" as="xs:string"/>

        <xsl:variable name="first-row" select="xs:decimal(replace($first-cell, '[A-Z]', ''))" as="xs:decimal"/>
        <xsl:variable name="last-row" select="xs:decimal(replace($last-cell, '[A-Z]', ''))" as="xs:decimal"/>

        <xsl:sequence select="$row ge $first-row and $row le $last-row and $col ge $first-col and $col le $last-col"/>
    </xsl:function>


    <xsl:function name="tps:get-parsed-cell-range" as="map(xs:string, xs:string)">
        <xsl:param name="cell-range" as="xs:string"/>

        <xsl:variable name="cells" select="$cell-range => tokenize(':')" as="xs:string+"/>

        <xsl:variable name="first-cell" select="$cells[1]" as="xs:string"/>
        <xsl:variable name="last-cell" select="$cells[2]" as="xs:string"/>
        <xsl:variable name="first-col" select="replace($first-cell, '\d', '')" as="xs:string"/>
        <xsl:variable name="last-col" select="replace($last-cell, '\d', '')" as="xs:string"/>

        <xsl:sequence>
            <xsl:map>
                <xsl:map-entry key="'first-cell'" select="$first-cell"/>
                <xsl:map-entry key="'last-cell'" select="$last-cell"/>
                <xsl:map-entry key="'first-col'" select="$first-col"/>
                <xsl:map-entry key="'last-col'" select="$last-col"/>
            </xsl:map>
        </xsl:sequence>
    </xsl:function>


    <xsl:function name="tps:get-default-column-width" as="xs:decimal">
        <xsl:param name="sheet-data" as="element(e:sheetData)"/>

        <xsl:variable name="col-width" select="$sheet-data/parent::e:worksheet/e:sheetFormatPr/(@baseColWidth, @defaultColWidth)[1]" as="xs:string?"/>

        <xsl:value-of select="(xs:decimal($col-width), 8)[1]"/>
    </xsl:function>


    <xsl:function name="tps:get-total-col-width" as="xs:decimal?">
        <xsl:param name="default-col-width" as="xs:decimal"/>

        <xsl:iterate select="$cols/e:col">
            <xsl:param name="total" as="xs:decimal" select="0"/>
            <xsl:param name="next-min" as="xs:decimal" select="0"/>

            <xsl:on-completion>
                <xsl:sequence select="$total"/>
            </xsl:on-completion>

            <xsl:variable name="cur-width" select="xs:decimal(@width * (@max - @min + 1))" as="xs:decimal"/>
            <xsl:variable name="default-col-width-total" select="xs:decimal(if($next-min != @min and $next-min != 0)
                                                                            then  $default-col-width * (@min - $next-min) else 0)"
                          as="xs:decimal"/>
            <xsl:variable name="new-total" as="xs:decimal">
                <xsl:sequence select="$total + $default-col-width-total + $cur-width"/>
            </xsl:variable>

            <xsl:next-iteration>
                <xsl:with-param name="total" select="$new-total"/>
                <xsl:with-param name="next-min" select="xs:decimal(@max + 1)"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:function>


    <xsl:function name="tps:get-date-from-the-serial-no" as="xs:date">
        <xsl:param name="serial-no" as="xs:decimal"/>

        <xsl:variable name="base-date" select="xs:date('1899-12-30')" as="xs:date"/>

        <xsl:sequence select="$base-date + floor($serial-no) * xs:dayTimeDuration('P1D')"/>

    </xsl:function>


    <xsl:function name="tps:get-time-from-the-value" as="xs:string">
        <xsl:param name="value" as="xs:decimal"/>
        <xsl:param name="format" as="xs:string"/>

        <xsl:variable name="time" select="24*$value" as="xs:double"/>

        <xsl:sequence select="format-number(floor($time), '00') || ':' || format-number(round(($time mod 1)*60), '00') || (if($format eq 'h:mm:ss') then '00' else '')"/>
    </xsl:function>


    <xsl:function name="tps:is-hidden-column" as="xs:boolean">
        <xsl:param name="cur-col" as="xs:integer"/>

        <xsl:sequence select="exists($cols/e:col[number(@min) le $cur-col and number(@max) ge $cur-col]/@hidden)"/>
    </xsl:function>
    
    
    <!--  xml:base="xl/worksheets/sheet1.xml" -->
    <xsl:function name="tps:get-input-file" as="document-node()?">
        <xsl:param name="file-name" as="xs:string"/>
        
        <xsl:sequence select="collection()[*/base-uri() eq $file-name]"/>
    </xsl:function>
    
</xsl:stylesheet>