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
        <xsl:param name="country-code" as="xs:integer"/>

        <xsl:variable name="tgroup" select="."/>

        <xsl:variable name="row-count" select="tps:get-row-count(.)" as="xs:integer"/>
        <Name>Human Freedom Report</Name>
        <Description>This is a performance report based upon the Human Freedom Index published annually by  the Cato Institute and the Fraser Institute.</Description>
        <OtherInformation/>
        <StrategicPlanCore>
            <Organization>
                <xsl:variable name="cur-row" select="$country-code"/>
                <Name>
                    <xsl:value-of select="$tgroup/tbody/row[$cur-row]/entry[3]"/>
                </Name>
                <Acronym>
                    <xsl:value-of select="$tgroup/tbody/row[$cur-row]/entry[2]"/>
                </Acronym>
                <Identifier>
                    <xsl:value-of select="generate-id($tgroup/tbody/row[$cur-row])"/>
                </Identifier>
                <Description>
                    <xsl:value-of select="$tgroup/tbody/row[$cur-row]/entry[4]"/>
                </Description>
                <Stakeholder>
                    <Name/>
                    <Description/>
                    <Role>
                        <Name/>
                        <Description/>
                    </Role>
                </Stakeholder>
            </Organization>

            <Vision>
                <Description>Personal and economic freedoms are recognized, protected, and enhanced, leading to
                    greater human flourishing and prosperity
                </Description>
                <Identifier>_44c3ed00-c544-11ef-b53f-543581babdf6</Identifier>
            </Vision>
            <Mission>
                <Description>To advance human freedom in our nation by providing comprehensive, empirical
                    measurements of personal and economic freedom, enabling evidence-based policy decisions and
                    reforms that enhance individual liberty
                </Description>
                <Identifier>_44c3f1ce-c544-11ef-b53f</Identifier>
            </Mission>
            <Value>
                <Name>Liberty</Name>
                <Description>Individual freedom and autonomy in personal and economic choices</Description>
            </Value>
            <Value>
                <Name>Rule of Law</Name>
                <Description>Consistent, fair, and transparent application of laws and regulations</Description>
            </Value>
            <Value>
                <Name>Empiricism</Name>
                <Description>Evidence-based measurement and analysis for objective assessment</Description>
            </Value>
            <Value>
                <Name>Transparency</Name>
                <Description>Open and accessible information about freedom metrics and
                    methodologies
                </Description>
            </Value>
            <Value>
                <Name>Objectivity</Name>
                <Description>Unbiased evaluation of freedom indicators</Description>
            </Value>
            <Value>
                <Name>Accountability</Name>
                <Description>Responsibility of institutions to protect and enhance freedom</Description>
            </Value>
            <Value>
                <Name>Progress</Name>
                <Description>Continuous improvement in the state of human freedom</Description>
            </Value>
            <xsl:for-each select="(5, 73)">
                <xsl:variable name="goal-no" select="."/>
                <xsl:variable name="end" select="if($goal-no eq 5) then 73 else count($tgroup/tbody/row[1]/entry)"/>
                <Goal>

                    <Name>
                        <xsl:value-of select="$tgroup/tbody/row[1]/entry[$goal-no]"/>
                    </Name>
                    <Description>Foster, measure, and report on human freedom</Description>
                    <Identifier>
                        <xsl:value-of select="generate-id($tgroup/tbody/row[1]/entry[$goal-no])"/>
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
                    <xsl:for-each
                            select="$tgroup/tbody/row[1]/entry[position() gt $goal-no and position() lt $end][matches(.,'^[A-Z]\s')]">
                        <xsl:variable name="column-no" select="count(preceding-sibling::entry) + 1" as="xs:integer"/>
                        <xsl:variable name="letter" select="tokenize(., ' ')[1]"/>
                        <Objective>
                            <Name>
                                <xsl:value-of select="replace(replace(replace(replace(replace(., '^[A-Z]\s', ''), 'Size of Government', 'Government'), '-- Without Gender Adjustment', ''), 'Sound Money', 'Money'), 'Freedom to trade internationally', 'Trade')"/>
                            </Name>
                            <Description>Legal systems operate with integrity, impartiality, and protection of
                                fundamental
                                rights.
                            </Description>
                            <Identifier>
                                <xsl:value-of select="generate-id(.)||$column-no"/>
                            </Identifier>
                            <SequenceIndicator>
                                <xsl:value-of select="tokenize(., ' ')[1]"/>
                            </SequenceIndicator>
                            <Stakeholder>
                                <Name/>
                                <Description/>
                                <Role>
                                    <Name/>
                                    <Description/>
                                </Role>
                            </Stakeholder>
                            <OtherInformation/>
                            <xsl:for-each
                                    select="$tgroup/tbody/row[1]/entry[position() gt  $goal-no and position() lt $column-no][normalize-space()][matches(., '^'||$letter)]"><!--2 to $row-count-->
                                <xsl:variable name="category"
                                              select="string-join(tokenize(., ' ')[position() gt 1], ' ')"/>
                                <PerformanceIndicator>
                                    <xsl:variable name="col-no" select="count(preceding-sibling::entry) + 1"
                                                  as="xs:integer"/>
                                    <SequenceIndicator>
                                        <xsl:value-of select="tokenize(., ' ')[1]"/>
                                    </SequenceIndicator>
                                    <MeasurementDimension>
                                        <xsl:value-of select="$category"/>
                                    </MeasurementDimension>
                                    <UnitOfMeasurement>Score</UnitOfMeasurement>
                                    <Identifier>
                                        <xsl:value-of select="generate-id(.)||$col-no"/>
                                    </Identifier>
                                    <Relationship>
                                        <Identifier>
                                            <xsl:value-of select="generate-id(.)||'rel'||$col-no"/>
                                        </Identifier>
                                        <ReferentIdentifier/>
                                        <Name/>
                                        <Description/>
                                    </Relationship>

                                    <xsl:for-each
                                            select="$tgroup/tbody/row[normalize-space(entry[3]) eq normalize-space($tgroup/tbody/row[$country-code]/entry[3])]">
                                        <xsl:variable name="row-no" select="count(preceding-sibling::row) +1"/>
                                        <MeasurementInstance>
                                            <TargetResult>
                                                <StartDate>
                                                    <xsl:value-of
                                                            select="$tgroup/tbody/row[$row-no]/entry[1] || '-01-01'"/>
                                                </StartDate>
                                                <EndDate>
                                                    <xsl:value-of
                                                            select="$tgroup/tbody/row[$row-no]/entry[1] || '-12-31'"/>
                                                </EndDate>
                                                <NumberOfUnits>
                                                    <xsl:value-of
                                                            select="format-number(sum(for $i in $tgroup/tbody/row[normalize-space(entry[1]) eq normalize-space($tgroup/tbody/row[$row-no]/entry[1])]/entry[$goal-no] return (number($i)[normalize-space($i)],0)[1]) div count($tgroup/tbody/row[normalize-space(entry[1]) eq normalize-space($tgroup/tbody/row[$row-no]/entry[1])]), '#.00')"/>
                                                </NumberOfUnits>
                                                <Descriptor>
                                                    <DescriptorName>Status</DescriptorName>
                                                    <DescriptorValue>Annual Baseline</DescriptorValue>
                                                </Descriptor>

                                                <Description><xsl:value-of select="$category"/>: International Average
                                                </Description>
                                            </TargetResult>

                                            <ActualResult>
                                                <StartDate>
                                                    <xsl:value-of
                                                            select="$tgroup/tbody/row[$row-no]/entry[1] || '-01-01'"/>
                                                </StartDate>
                                                <EndDate>
                                                    <xsl:value-of
                                                            select="$tgroup/tbody/row[$row-no]/entry[1] || '-12-31'"/>
                                                </EndDate>
                                                <NumberOfUnits>
                                                    <xsl:value-of select="$tgroup/tbody/row[$row-no]/entry[$col-no]"/>
                                                </NumberOfUnits>
                                                <Descriptor>
                                                    <DescriptorName/>
                                                    <DescriptorValue></DescriptorValue>
                                                </Descriptor>
                                                <Description>...</Description>
                                            </ActualResult>
                                        </MeasurementInstance>
                                    </xsl:for-each>

                                    <OtherInformation/>
                                </PerformanceIndicator>
                            </xsl:for-each>
                        </Objective>
                    </xsl:for-each>
                </Goal>
            </xsl:for-each>
        </StrategicPlanCore>
    </xsl:template>


    <xsl:template match="tgroup" mode="version1">
        <xsl:param name="partnership" select="element()" tunnel="yes"/>
        <xsl:param name="vision-mission" select="element()" tunnel="yes"/>


        <xsl:variable name="col-count" select="max(tps:get-cell-count(.))" as="xs:integer"/>
        <Name>
            <xsl:value-of select="'Fiscal Year ' || substring-after(tbody/row[5]/entry[1], 'FY') || ' Accountability Report'"/>
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
                    <xsl:variable name="goals" select="tokenize(current-group()[1]/entry[6][1], ' the | in ')" as="xs:string*"/>

                    <xsl:variable name="modified-goal" select="upper-case(substring($goals[last()], 1,1)) || substring($goals[last()], 2,string-length($goals[last()]))" as="xs:string"/>
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
                        <xsl:variable name="objectives" select="tokenize(current-group()[1]/entry[8][1], ' the | in ')" as="xs:string*"/>
                        <xsl:variable name="modified-obj" select="upper-case(substring($objectives[last()], 1,1)) || substring($objectives[last()], 2,string-length($objectives[last()]))" as="xs:string"/>

                        <Objective>
                            <Name>
                                <xsl:value-of select="replace($modified-obj, '( to | through ).*', '')"/>
                            </Name>
                            <Description>
                                <xsl:apply-templates select="current-group()[1]/entry[8][1]"/>
                            </Description>
                            <SequenceIndicator>
                                <xsl:value-of select="format-number(xs:double(tps:remove-end-decimal(current-group()[1]/entry[7][1])), '#.#')"/>
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
                        <xsl:value-of select="if (entry[11] ne 'N/A') then tps:get-number-of-units(entry[11]) else '[To be determined]'"/>
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

        <xsl:variable name="modified-year" select="('FY2023'[not(starts-with($coloumn-value, 'FY20'))], $coloumn-value)[1]" as="xs:string"/>

        <xsl:variable name="year" select="xs:decimal(substring-after($modified-year, 'FY'))" as="xs:decimal"/>

        <xsl:sequence select="if ($start-date) then $year - 1 else $year"/>
    </xsl:function>


    <xsl:function name="tps:get-number-of-units" as="xs:string">
        <xsl:param name="input-value" as="xs:string"/>

        <xsl:variable name="number" select="(replace((substring-before($input-value, ' - ')[contains($input-value, ' - ')], $input-value)[1], '%|th', '')[$input-value ne 'N/A'], '')[1]" as="xs:string"/>
        <xsl:sequence select="if (not(matches($number, '\D'))) then format-number(number($number), '##,###') else $number"/>
    </xsl:function>

    <xsl:template match="processing-instruction('cell-format')"/>

</xsl:stylesheet>