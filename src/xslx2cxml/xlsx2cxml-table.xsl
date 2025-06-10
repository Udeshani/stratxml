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
                xmlns="urn:ISO:std:iso:17469:tech:xsd:PerformancePlanOrReport"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tps="http://www.typefi.com/ContentXML"
                exclude-result-prefixes="#all">

    <xsl:template match="tgroup">
        <xsl:param name="country-code" as="xs:string"/>

        <xsl:variable name="tgroup" select="."/>

        <xsl:variable name="row-count" select="tps:get-row-count(.)" as="xs:integer"/>
        <Name>Model Performance Plan for International Assistance</Name>
        <Description>This is a model performance plan for international assistance based upon the international
            assistance
            codes and descriptions maintained by the U.S. Department of the Treasury
        </Description>
        <OtherInformation>[Submitter's Note: This StratML rendition was compiled from the source by ChatGPT and edited
            in
            the XForm at https://stratml.us/forms2/Part2Form.xml]
        </OtherInformation>
        <StrategicPlanCore>
            <Organization>
                <Name>U.S. Government</Name>
                <Acronym>USG</Acronym>
                <Identifier>_InternationalAidPurposeCode5337e65c-3f06-11f0-813e-b6ae5fbabdf6</Identifier>
                <Description/>
                <Stakeholder StakeholderTypeType="Organization">
                    <Name>U.S. Department of the Treasury</Name>
                    <Description/>
                    <Role>
                        <Name/>
                        <Description/>
                    </Role>
                </Stakeholder>
            </Organization>
            <Vision>
                <Description/>
                <Identifier>_f157cf68-3f11-11f0-8133-747f61babdf6</Identifier>
            </Vision>
            <Mission>
                <Description>To enable categorization of international assistance expenditures</Description>
                <Identifier>_f157d878-3f11-11f0-8133-747f61babdf6</Identifier>
            </Mission>
            <Value>
                <Name/>
                <Description/>
            </Value>
            <xsl:for-each-group select="$tgroup/tbody/row[entry[3] eq $country-code]" group-by="entry[15]">
                <xsl:variable name="goal-name" select="current-group()[1]/entry[16]"/>
                <Goal>

                    <Name>
                        <xsl:value-of select="$goal-name"/>
                    </Name>
                    <Description>test</Description>
                    <Identifier>
                        <xsl:value-of select="'_InternationalAidPurposeCode'||entry[17]"/>
                    </Identifier>
                    <SequenceIndicator/>
                    <Stakeholder>
                        <Name/>
                        <Description/>
                        <Role>
                            <Name/>
                            <Description/>
                        </Role>
                    </Stakeholder>
                    <OtherInformation/>
                 <xsl:apply-templates select="current-group()" mode="section"/>
                </Goal>
            </xsl:for-each-group>
        </StrategicPlanCore>
    </xsl:template>


    <xsl:template match="row" mode="section">
            <xsl:variable name="cur-row" select="."/>
            <Objective>
                <Name>
                    <xsl:value-of select="$goal-name"/>
                </Name>
                <Description>to be filled</Description>
                <Identifier>
                    <xsl:value-of select="'_InternationalAidPurposeCode'||$cur-row/entry[17]"/>
                </Identifier>
                <SequenceIndicator/>
                <Stakeholder>
                    <Name/>
                    <Description/>
                    <Role>
                        <Name/>
                        <Description/>
                    </Role>
                </Stakeholder>
                <OtherInformation/>

                <PerformanceIndicator>
                    <SequenceIndicator/>
                    <MeasurementDimension/>
                    <UnitOfMeasurement></UnitOfMeasurement>
                    <Identifier>
                        <xsl:value-of select="generate-id(.)||."/>
                    </Identifier>
                    <Relationship>
                        <Identifier>
                            <xsl:value-of select="generate-id(.)||'rel'||."/>
                        </Identifier>
                        <ReferentIdentifier/>
                        <Name/>
                        <Description/>
                    </Relationship>


                    <MeasurementInstance>
                        <TargetResult>
                            <StartDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34] || '-01-01'"/>
                            </StartDate>
                            <EndDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34] || '-12-31'"/>
                            </EndDate>
                            <NumberOfUnits>
                                <xsl:value-of
                                        select="if($cur-row/entry[32] eq '18') then $cur-row/entry[35] else ''"/>
                            </NumberOfUnits>
                            <Descriptor>
                                <DescriptorName></DescriptorName>
                                <DescriptorValue></DescriptorValue>
                            </Descriptor>

                            <Description></Description>
                        </TargetResult>

                        <ActualResult>
                            <StartDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34]  || '-01-01'"/>
                            </StartDate>
                            <EndDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34] || '-12-31'"/>
                            </EndDate>
                            <NumberOfUnits>
                                <xsl:value-of
                                        select="if($cur-row/entry[32] eq '1') then $cur-row/entry[35] else ''"/>
                            </NumberOfUnits>
                            <Descriptor>
                                <DescriptorName/>
                                <DescriptorValue></DescriptorValue>
                            </Descriptor>
                            <Description>...</Description>
                        </ActualResult>
                    </MeasurementInstance>
                    <MeasurementInstance>
                        <TargetResult>
                            <StartDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34] || '-01-01'"/>
                            </StartDate>
                            <EndDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34] || '-12-31'"/>
                            </EndDate>
                            <NumberOfUnits>
                                <xsl:value-of
                                        select="if($cur-row/entry[32] eq '18') then $cur-row/entry[36] else ''"/>
                            </NumberOfUnits>
                            <Descriptor>
                                <DescriptorName></DescriptorName>
                                <DescriptorValue></DescriptorValue>
                            </Descriptor>

                            <Description></Description>
                        </TargetResult>

                        <ActualResult>
                            <StartDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34]  || '-01-01'"/>
                            </StartDate>
                            <EndDate>
                                <xsl:value-of
                                        select="$cur-row/entry[34] || '-12-31'"/>
                            </EndDate>
                            <NumberOfUnits>
                                <xsl:value-of
                                        select="if($cur-row/entry[32] eq '1') then $cur-row/entry[36] else ''"/>
                            </NumberOfUnits>
                            <Descriptor>
                                <DescriptorName/>
                                <DescriptorValue></DescriptorValue>
                            </Descriptor>
                            <Description>...</Description>
                        </ActualResult>
                    </MeasurementInstance>

                    <OtherInformation/>
                </PerformanceIndicator>
            </Objective>
    </xsl:template>

    <xsl:template match="tgroup" mode="version1">
        <xsl:param name="partnership" select="element()" tunnel="yes"/>
        <xsl:param name="vision-mission" select="element()" tunnel="yes"/>


        <xsl:variable name="col-count" select="max(tps:get-cell-count(.))" as="xs:integer"/>
        <Name>
            <xsl:value-of
                    select="'Fiscal Year ' || substring-after(tbody/row[5]/entry[1], 'FY') || ' Accountability Report'"/>
        </Name>
        <Description/>
        <OtherInformation/>
        <StrategicPlanCore>
            <Organization>
                <xsl:variable name="org-name" select="$partnership//tbody/row[5]/entry[3]" as="xs:string"/>
                <Name>
                    <xsl:value-of select="$org-name"/>
                </Name>
                <Acronym>
                    <xsl:value-of select="string-join(for $word in tokenize($org-name) return substring($word, 1, 1))"/>
                </Acronym>
                <Identifier>
                    <xsl:value-of select="'SCAgencyCode#' || $partnership//tbody/row[5]/entry[2]"/>
                </Identifier>
                <Description/>

                <xsl:for-each select="$partnership//table/tgroup/tbody/row[position() gt 3][normalize-space(entry[4])]">
                    <Stakeholder StakeholderTypeType="">
                        <Name>
                            <xsl:value-of select="entry[5]"/>
                        </Name>
                        <Description>
                            <xsl:value-of select="entry[4]"/>
                        </Description>
                        <Role>
                            <Name/>
                            <Description>
                                <xsl:value-of select="entry[6]"/>
                            </Description>
                        </Role>
                    </Stakeholder>
                </xsl:for-each>

            </Organization>
            <Vision>
                <Description>
                    <xsl:value-of select="$vision-mission//table/tgroup/tbody/row[13]/entry[1]"/>
                </Description>
                <Identifier>_62e7f810-609e-11ed-94e3-0f9af982ea00</Identifier>
            </Vision>
            <Mission>
                <Description>
                    <xsl:value-of select="$vision-mission//table/tgroup/tbody/row[11]/entry[1]"/>
                </Description>
                <Identifier>_62e7f900-609e-11ed-94e3-0f9af982ea00</Identifier>
            </Mission>
            <Value>
                <Name>Integrity</Name>
                <Description/>
            </Value>
            <Value>
                <Name>Excellence</Name>
                <Description/>
            </Value>
            <Value>
                <Name>Accountability</Name>
                <Description/>
            </Value>
            <Value>
                <Name>Leadership</Name>
                <Description/>
            </Value>
            <xsl:for-each-group select="tbody/row[position() gt 3][normalize-space()]" group-by="entry[5]">
                <Goal>
                    <xsl:variable name="goals" select="tokenize(current-group()[1]/entry[6][1], ' the | in ')"
                                  as="xs:string*"/>

                    <xsl:variable name="modified-goal"
                                  select="upper-case(substring($goals[last()], 1,1)) || substring($goals[last()], 2,string-length($goals[last()]))"
                                  as="xs:string"/>
                    <Name>
                        <xsl:value-of select="replace($modified-goal, '( to | through ).*', '')"/>
                    </Name>
                    <Description>
                        <xsl:apply-templates select="current-group()[1]/entry[6][1]"/>
                    </Description>
                    <SequenceIndicator>
                        <xsl:value-of select="current-group()[1]/entry[5][1]"/>
                    </SequenceIndicator>
                    <Stakeholder>
                        <Name/>
                        <Description/>
                        <Role>
                            <Name/>
                            <Description/>
                        </Role>
                    </Stakeholder>
                    <OtherInformation></OtherInformation>
                    <xsl:for-each-group select="current-group()" group-by="entry[7]">
                        <xsl:variable name="objectives" select="tokenize(current-group()[1]/entry[8][1], ' the | in ')"
                                      as="xs:string*"/>
                        <xsl:variable name="modified-obj"
                                      select="upper-case(substring($objectives[last()], 1,1)) || substring($objectives[last()], 2,string-length($objectives[last()]))"
                                      as="xs:string"/>

                        <Objective>
                            <Name>
                                <xsl:value-of select="replace($modified-obj, '( to | through ).*', '')"/>
                            </Name>
                            <Description>
                                <xsl:apply-templates select="current-group()[1]/entry[8][1]"/>
                            </Description>
                            <SequenceIndicator>
                                <xsl:value-of
                                        select="format-number(xs:double(tps:remove-end-decimal(current-group()[1]/entry[7][1])), '#.#')"/>
                            </SequenceIndicator>
                            <OtherInformation></OtherInformation>
                            <xsl:apply-templates select="current-group()" mode="performance-indicator"/>
                        </Objective>
                    </xsl:for-each-group>
                </Goal>
            </xsl:for-each-group>
        </StrategicPlanCore>
    </xsl:template>


    <xsl:function name="tps:remove-end-decimal" as="xs:string">
        <xsl:param name="value" as="xs:string"/>

        <xsl:sequence select="if (ends-with($value, '.')) then replace($value, '(.*)[?=.]', '$1') else $value"/>
    </xsl:function>


    <xsl:template match="dataValidations"/>


    <xsl:template match="row" mode="performance-indicator">
        <PerformanceIndicator>
            <SequenceIndicator>
                <xsl:apply-templates select="entry[9]"/>
            </SequenceIndicator>
            <MeasurementDimension/>
            <UnitOfMeasurement>
                <xsl:value-of select="entry[14]"/>
            </UnitOfMeasurement>
            <Relationship>
                <Identifier>
                    <xsl:value-of select="'test' || generate-id()"/>
                </Identifier>
                <ReferentIdentifier>[To_be_inserted_by_user]</ReferentIdentifier>
                <Name>Supports Enterprise Objective</Name>
                <Description>
                    <xsl:apply-templates select="entry[4]"/>
                </Description>
            </Relationship>
            <MeasurementInstance>
                <ActualResult>
                    <NumberOfUnits>
                        <xsl:value-of select="replace(tps:get-number-of-units(entry[11]), ',', '')"/>
                    </NumberOfUnits>
                    <Description>
                        <xsl:value-of
                                select="if (entry[11] ne 'N/A') then tps:get-number-of-units(entry[11]) else '[To be determined]'"/>
                    </Description>
                    <StartDate>
                        <xsl:value-of select="tps:get-year(entry[1], true()) || '-07-01'"/>
                    </StartDate>
                    <EndDate>
                        <xsl:value-of select="tps:get-year(entry[1], false()) || '-06-30'"/>
                    </EndDate>
                </ActualResult>
                <TargetResult>
                    <Descriptor>
                        <DescriptorName>Status</DescriptorName>
                        <DescriptorValue>Annual Baseline</DescriptorValue>
                    </Descriptor>
                    <NumberOfUnits>
                        <xsl:value-of select="replace(tps:get-number-of-units(entry[12]), ',', '')"/>
                    </NumberOfUnits>
                    <Description>
                        <xsl:apply-templates select="entry[10]"/>
                    </Description>
                    <StartDate>
                        <xsl:value-of select="tps:get-year(entry[1], true()) || '-07-01'"/>
                    </StartDate>
                    <EndDate>
                        <xsl:value-of select="tps:get-year(entry[1], false()) || '-06-30'"/>
                    </EndDate>
                </TargetResult>
                <ActualResult>
                    <Descriptor>
                        <DescriptorName>Status</DescriptorName>
                        <DescriptorValue>TBD</DescriptorValue>
                    </Descriptor>
                    <Description>[To be determined]</Description>
                    <StartDate>
                        <xsl:value-of select="tps:get-year(entry[1], true()) || '-07-01'"/>
                    </StartDate>
                    <EndDate>
                        <xsl:value-of select="tps:get-year(entry[1], false()) || '-06-30'"/>
                    </EndDate>
                </ActualResult>
            </MeasurementInstance>
        </PerformanceIndicator>
    </xsl:template>


    <xsl:function name="tps:get-year" as="xs:decimal">
        <xsl:param name="coloumn-value" as="xs:string"/>
        <xsl:param name="start-date" as="xs:boolean"/>

        <xsl:variable name="modified-year"
                      select="('FY2023'[not(starts-with($coloumn-value, 'FY20'))], $coloumn-value)[1]" as="xs:string"/>

        <xsl:variable name="year" select="xs:decimal(substring-after($modified-year, 'FY'))" as="xs:decimal"/>

        <xsl:sequence select="if ($start-date) then $year - 1 else $year"/>
    </xsl:function>


    <xsl:function name="tps:get-number-of-units" as="xs:string">
        <xsl:param name="input-value" as="xs:string"/>

        <xsl:variable name="number"
                      select="(replace((substring-before($input-value, ' - ')[contains($input-value, ' - ')], $input-value)[1], '%|th', '')[$input-value ne 'N/A'], '')[1]"
                      as="xs:string"/>
        <xsl:sequence
                select="if (not(matches($number, '\D'))) then format-number(number($number), '##,###') else $number"/>
    </xsl:function>

    <xsl:template match="processing-instruction('cell-format')"/>

</xsl:stylesheet>