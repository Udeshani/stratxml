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
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" omit-xml-declaration="no"/>

    <xsl:template name="main">
        <xsl:call-template name="parameters-info"/>

        <xsl:call-template name="cxml-documents">
            <xsl:with-param name="main-content" select="$worksheet/element()"/>
<!--            <xsl:with-param name="partnership" select="$partnerships/element()"/>-->
        </xsl:call-template>

    </xsl:template>


    <!-- Entry point for unit-tests -->
    <xsl:template name="cxml-documents" as="element()*">
        <xsl:param name="main-content" as="element()?"/>
<!--        <xsl:param name="partnership" as="element()?"/>-->

        <xsl:variable name="cals-table-main" as="document-node()">
            <xsl:document>
                <xsl:apply-templates select="$main-content" mode="xslx-to-cals"/>
            </xsl:document>
        </xsl:variable>

       <!-- <xsl:variable name="cals-table-partnership" as="document-node()">
            <xsl:document>
                <xsl:apply-templates select="$partnership" mode="xslx-to-cals"/>
            </xsl:document>
        </xsl:variable>-->


<!--        <xsl:result-document href="final/codes.xml">-->
<!--                <xsl:copy-of select="$cals-table-main"/>-->

<!--        </xsl:result-document>-->

        <xsl:call-template name="cxml-documents-content">
            <xsl:with-param name="main-content" select="$cals-table-main/element()" tunnel="yes"/>
<!--            <xsl:with-param name="partnership" select="$cals-table-partnership/element()" tunnel="yes"/>-->
<!--            <xsl:with-param name="vision-mission" select="$vision-mission/element()" tunnel="yes"/>-->
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="cxml-documents-content">
        <xsl:param name="main-content" as="element()"  tunnel="yes"/>

        <xsl:variable name="single-quote"><xsl:text>'</xsl:text></xsl:variable>

<!--        <xsl:result-document href="sitemap.xml">-->
<!--            <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">-->
<!--                <xsl:for-each select="2 to 166">-->
<!--                    <xsl:variable name="cur-row" select="."/>-->
<!--                        <url><loc><xsl:value-of select="'https://stratml.us/gaya/HFI/'||replace(replace(replace($main-content//tgroup/tbody/row[$cur-row]/entry[3], ' ', '_'), ',|\.', ''), $single-quote ,'')||'.xml'"/></loc></url>-->
<!--                </xsl:for-each>-->
<!--            </urlset>-->
<!--        </xsl:result-document>-->

<!--        <xsl:for-each select="distinct-values($main-content//tgroup/tbody/row/entry[3])[2]">-->
            <xsl:variable name="cur-country" select="$main-content//tgroup/tbody/row[2]/entry[3]"/>
<xsl:message select="$cur-country"/>

<!--            <xsl:variable name="filename" select="replace(replace(replace($main-content//tgroup/tbody/row[$cur-row]/entry[3], ' ', '_'), ',|\.', ''), $single-quote ,'')"/>-->

            <xsl:result-document href="final/{$cur-country}.xml">
                <xsl:processing-instruction name="xml-stylesheet">
                    <xsl:text>type="text/xsl" href="part2stratml.xsl"</xsl:text>
                </xsl:processing-instruction>

                <PerformancePlanOrReport xmlns="urn:ISO:std:iso:17469:tech:xsd:PerformancePlanOrReport"
                                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                                         xsi:schemaLocation="urn:ISO:std:iso:17469:tech:xsd:PerformancePlanOrReport http://stratml.us/references/PerformancePlanOrReport20160216.xsd"
                                         Type="Performance_Plan">
                    <xsl:apply-templates select="$main-content">
                        <xsl:with-param name="country-code" select="$cur-country"/>
                    </xsl:apply-templates>

                    <AdministrativeInformation>
                        <Identifier>_27225d7e-b49a-11ee-b03e-6de190babdf6</Identifier>
                        <StartDate>2022-07-01</StartDate>
                        <EndDate>2023-06-30</EndDate>
                        <PublicationDate>2025-02-21</PublicationDate>
                        <Source>https://www.cato.org/sites/cato.org/files/human-freedom-index-files/human-freedom-index-data-2024.xlsx</Source>
                    </AdministrativeInformation>
                    <Submitter>
                        <Identifier>_a7d59218-8c4d-11ed-92e4-ebdb7ababdf6</Identifier>
                        <GivenName>Owen</GivenName>
                        <Surname>Ambur</Surname>
                        <PhoneNumber/>
                        <EmailAddress>Owen.Ambur@verizon.net</EmailAddress>
                    </Submitter>
                </PerformancePlanOrReport>
            </xsl:result-document>

<!--        </xsl:for-each>-->

        <Submitter>
            <Identifier>_a7d59218-8c4d-11ed-92e4-ebdb7ababdf6</Identifier>
            <GivenName>Owen</GivenName>
            <Surname>Ambur</Surname>
            <PhoneNumber/>
            <EmailAddress>Owen.Ambur@verizon.net</EmailAddress>
        </Submitter>
    </xsl:template>


    <xsl:template name="parameters-info" expand-text="yes">
        <xsl:message>Parameters</xsl:message>
        <xsl:message>Debug mode: {$debug}</xsl:message>
    </xsl:template>

</xsl:stylesheet>