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
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/2000/svg"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tps="http://www.typefi.com/ContentXML"
                xmlns:e="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart"
                exclude-result-prefixes="#all">


    <xsl:template match="e:drawing">
        <xsl:variable name="r-id" select="@r:id" as="xs:string"/>

        <xsl:variable name="drawing-xml" select="tps:get-worksheet-rels()/rel:Relationships/rel:Relationship[@Id eq $r-id]/@Target" as="xs:string"/>
        <xsl:variable name="chart-xmls" select="tps:get-drawing-rels(substring-after($drawing-xml, 'drawings/'))/rel:Relationships/rel:Relationship/@Target" as="xs:string*"/>

        <xsl:for-each select="$chart-xmls">
            <xsl:variable name="chart-name" select="substring-after(., 'charts/')" as="xs:string"/>

            <xsl:call-template name="result-chart">
                <xsl:with-param name="chart-name" select="$chart-name"/>
            </xsl:call-template>
        </xsl:for-each>

    </xsl:template>


    <xsl:template name="result-chart">
        <xsl:param name="chart-name" select="." as="xs:string"/>

        <xsl:result-document href="{substring-before($chart-name, '.xml')}.svg">
            <xsl:apply-templates select="tps:get-chart-xml($chart-name)/c:chartSpace/c:chart/c:plotArea"/>
        </xsl:result-document>
    </xsl:template>


    <xsl:template match="c:pieChart">
        <xsl:variable name="sum-value" select="xs:decimal(sum(c:ser/c:val/c:numRef/c:numCache/c:pt/c:v))" as="xs:decimal"/>

        <svg viewBox="0 0 400 300">
            <defs>
                <path id="pie-shape-0-90" d="M 54,150 A96,96 0 0,1 150,54 L 150,150 Z" />
                <use href="#pie-shape-0-90" id="pie-shape-90-180" transform="rotate(-90, 150, 150)" />
                <use href="#pie-shape-0-90" id="pie-shape-180-270" transform="rotate(-180, 150, 150)" />
                <use href="#pie-shape-0-90" id="pie-shape-270-360" transform="rotate(-270, 150, 150)" />
            </defs>

            <text x="140" y="40">
                <xsl:value-of select="ancestor::c:chartSpace/c:chart/c:title/c:tx/c:rich/a:p/a:r/a:t" />
            </text>

            <circle cx="150" cy="150" r="96" stroke-width="2" stroke="black" fill="none" />

            <xsl:for-each select="c:ser/c:val/c:numRef/c:numCache/c:pt">
                <xsl:variable name="value" select="c:v" as="xs:decimal"/>
                <xsl:variable name="pt" select="." as="element(c:pt)"/>

                <xsl:variable name="color" select="'#' || tps:get-theme-xml()/a:theme/a:themeElements/a:clrScheme/a:*[local-name() eq tps:get-theme-color(current()/ancestor::c:pieChart, $pt/@idx)]/a:srgbClr/@val" as="xs:string"/>
                <xsl:variable name="rotation" select="xs:decimal(($value + sum(preceding-sibling::c:pt/c:v)) div $sum-value * 360)" as="xs:decimal"/>

                <xsl:variable name="quarters" select="floor($value div $sum-value * 4)" as="xs:decimal"/>

                <defs>
                    <rect id="fill-{position()}" x="0" y="0" width="150" height="150" fill="{$color}" transform="rotate({$rotation - $quarters * 90}, 150, 150)" />
                    <clipPath id="clip0">
                        <path d="M 150,54 A96,96 0 0,1 246,150 L 150,150 Z" />
                    </clipPath>
                    <clipPath id="clip{position()}">
                        <path d="M 150,54 A96,96 0 0,1 246,150 L 150,150 Z" transform="rotate({$rotation}, 150, 150)" />
                    </clipPath>
                </defs>

                <use href="#fill-{position()}" style="clip-path: url(#clip{position() - 1});" />
                <xsl:if test="$quarters &gt; 0">
                    <use href="#pie-shape-0-90" fill="{$color}" transform="rotate({$rotation}, 150, 150)" />
                </xsl:if>
                <xsl:if test="$quarters &gt; 1">
                    <use href="#pie-shape-90-180" fill="{$color}" transform="rotate({$rotation},150, 150)" />
                </xsl:if>
                <xsl:if test="$quarters &gt; 2">
                    <use href="#pie-shape-180-270" fill="{$color}" transform="rotate({$rotation}, 150, 150)" />
                </xsl:if>
                <xsl:if test="$quarters &gt; 3">
                    <use href="#pie-shape-270-360" fill="{$color}" transform="rotate({$rotation}, 150, 150)" />
                </xsl:if>

                <rect x="{300}" y="{position() * 15 - 11}" width="10" height="10" fill="{$color}"/>
                <text x="320" y="{position() * 15 - 1}">
                    <xsl:value-of select="current()/ancestor::c:pieChart/c:ser/c:cat/c:strRef/c:strCache/c:pt[count($pt/preceding-sibling::c:pt) + 1]/c:v" />
                </text>

            </xsl:for-each>
        </svg>
    </xsl:template>


    <xsl:template match="c:barChart">
        <xsl:call-template name="chart">
            <xsl:with-param name="is-line-chart" select="false()"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="c:lineChart">
        <xsl:call-template name="chart">
            <xsl:with-param name="is-line-chart" select="true()"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="chart">
        <xsl:param name="is-line-chart" as="xs:boolean"/>

        <xsl:variable name="max-val" select="xs:decimal(max(c:ser/c:val/c:numRef/c:numCache/c:pt/c:v))" as="xs:decimal"/>
        <xsl:variable name="data-count" select="count(c:ser/c:val/c:numRef/c:numCache/c:pt)" as="xs:integer"/>
        <xsl:variable name="chart-height" select="$max-val + 50" as="xs:decimal"/>

        <svg>
            <g>
                <text x="{$data-count*50}" y="10" font-size="14px" text-anchor="end">
                    <xsl:value-of select="ancestor::c:chart/c:title/c:tx/c:rich/a:p/a:r/a:t"/>
                </text>

                <line id="axis-y" x1="40" y1="{$chart-height}" x2="40" y2="20" style="fill:none;stroke:rgb(0,0,0);stroke-width:2"/>
                <line id="axis-x" x1="40" y1="{$chart-height}" x2="{$data-count*100}" y2="{$chart-height}"  style="fill:none;stroke:rgb(0,0,0);stroke-width:2"/>

                <xsl:for-each select="c:ser/c:val/c:numRef/c:numCache/c:pt">
                    <xsl:variable name="pt" select="." as="element(c:pt)"/>
                    <xsl:variable name="color" select="'#' || tps:get-theme-xml()/a:theme/a:themeElements/a:clrScheme/a:*[local-name() eq tps:get-theme-color(current()/(ancestor::c:lineChart[$is-line-chart], ancestor::c:barChart)[1], $pt/@idx)]/a:srgbClr/@val" as="xs:string"/>

                    <text x="30" y="{$chart-height - c:v}" font-size="12px" text-anchor="end">
                        <xsl:value-of select="c:v"/>
                    </text>
                   
                    <xsl:choose>
                        <xsl:when test="$is-line-chart">
                            <path d="M {50 + (position() - 1)*100},{$chart-height - c:v}
                                     L {50 + (position())*100}, {$chart-height - following-sibling::c:pt/c:v} Z" stroke="{$color}"/>

                        </xsl:when>
                        <xsl:otherwise>
                            <rect x="{40 + (position() - 1)*100}" y="{$chart-height - c:v}" width="50" height="{c:v}" style="fill:{$color};stroke:rgb(0,0,0);stroke-width:0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>

                <xsl:for-each select="c:ser/c:cat/c:strRef/c:strCache/c:pt">
                    <text x="{100 + (position()-1)*100}" y="{$chart-height + 20}" font-size="12px" text-anchor="end">
                        <xsl:value-of select="c:v"/>
                    </text>
                </xsl:for-each>
            </g>
        </svg>

    </xsl:template>

</xsl:stylesheet>