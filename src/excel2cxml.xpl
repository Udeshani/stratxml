<p:declare-step version="3.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:pxp="http://exproc.org/proposed/steps"
                xmlns:p="http://www.w3.org/ns/xproc"
                name="main">

    <p:input port="param" kind="parameter"/>

    <p:output port="result" primary="true" sequence="true">
        <p:pipe port="result" step="secondary-storage"/>
    </p:output>


    <p:declare-step type="pxp:unzip">
        <p:output port="result"/>
        <p:option name="href" required="true"/>
        <p:option name="file"/>
        <p:option name="content-type"/>
        <p:option name="charset"/>
    </p:declare-step>


    <p:variable name="input.file.path" select="replace(/c:param-set/c:param[@name eq 'input']/@value, '\\', '/')">
        <p:pipe step="main" port="param"/>
    </p:variable>


    <p:variable name="stylesheet.file.path" select="replace(/c:param-set/c:param[@name eq 'xsl']/@value, '\\', '/')">
        <p:pipe step="main" port="param"/>
    </p:variable>


    <p:variable name="output.file.name" select="/c:param-set/c:param[@name eq 'output']/@value">
        <p:pipe step="main" port="param"/>
    </p:variable>


    <p:load name="load-stylesheet">
        <p:with-option name="href" select="$stylesheet.file.path"/>
    </p:load>


    <pxp:unzip name="unzip-excel-file">
        <p:with-option name="href" select="$input.file.path"/>
    </pxp:unzip>


    <p:for-each name="iterate-zip-directory">
        <p:iteration-source select="/c:zipfile/c:file[ends-with(@name, '.xml') or ends-with(@name, '.rels')]">
            <p:pipe step="unzip-excel-file" port="result"/>
        </p:iteration-source>

        <p:output port="result">
            <p:pipe step="unzipped-xml-files" port="result"/>
        </p:output>

        <p:variable name="unzipped-file-subpath" select="/c:file/@name"/>

        <pxp:unzip>
            <p:with-option name="href" select="$input.file.path"/>
            <p:with-option name="file" select="$unzipped-file-subpath"/>
        </pxp:unzip>

        <p:add-attribute name="unzipped-xml-files" attribute-name="xml:base" match="/*">
            <p:with-option name="attribute-value" select="$unzipped-file-subpath"/>
        </p:add-attribute>
    </p:for-each>


    <p:xslt name="apply-transform" template-name="main">
        <p:input port="stylesheet">
            <p:pipe step="load-stylesheet" port="result"/>
        </p:input>


        <p:input port="source">
            <p:pipe step="iterate-zip-directory" port="result"/>
        </p:input>

        <p:input port="parameters">
            <p:inline>
                <c:param-set>
                    <c:param name="sheet_ui_name" value="sheet1.xml"/>
                    <c:param name="debug" value="true"/>
                </c:param-set>
            </p:inline>
        </p:input>

    </p:xslt>
    

    <p:store>
        <p:with-option name="href" select="$output.file.name"/>
    </p:store>
    

    <p:for-each name="secondary-storage">
        <p:iteration-source select=".">
            <p:pipe port="secondary" step="apply-transform"/>
        </p:iteration-source>

        <p:output port="result">
            <p:pipe port="result" step="store"/>
        </p:output>

        <p:store name="store">
            <p:with-option name="href" select="document-uri(.)"/>
        </p:store>
    </p:for-each>

</p:declare-step>