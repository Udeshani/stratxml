#!/usr/bin/env groovy
import groovy.io.FileType
import groovy.transform.Field

@Field final ATTRIBUTE_XSPEC_DIR = "xspec.dir"
@Field final ATTRIBUTE_RECURSIVE = "recursive"
@Field final XSPEC_EXTENSION = ".xspec"
ant = new AntBuilder(project, getFirstTarget())

def getFirstTarget() {
    project.targets.elements().nextElement()
}

def collectSuiteFiles(File dir, boolean recursive) {
    def result = []

    def addSuiteFileToResult = { it ->
        if (it.name.endsWith(XSPEC_EXTENSION)) {
            result << it
        }
    }

    if (recursive) {
        dir.eachFileRecurse(FileType.FILES, { it ->
            addSuiteFileToResult(it)
        })
    } else {
        dir.eachFile(FileType.FILES, { it ->
            addSuiteFileToResult(it)
        })
    }
    result
}

def getSuiteName(File file) {
    file.name.replaceFirst(~/$XSPEC_EXTENSION$/, '')
}

def getSortedSuiteFiles(File dir, boolean recursive) {
    def suiteFiles = collectSuiteFiles(dir, recursive)
    suiteFiles.sort { a, b ->
        getSuiteName(a) <=> getSuiteName(b)
    }
}

def runTestsFromDir(File dir, boolean recursive) {
    def catalogFile = ant.project.properties['catalog.file']

    def suiteFiles = getSortedSuiteFiles(dir, recursive)
    suiteFiles.each { it ->
        ant.xspec('xspec.xml': it.canonicalPath, 'catalog.xml': catalogFile)
    }
}

def recursive = attributes.get(ATTRIBUTE_RECURSIVE)?.toBoolean()
if (recursive == null) recursive = false

def dirAttr = attributes.get(ATTRIBUTE_XSPEC_DIR)
if (dirAttr == null) {
    ant.fail("Test directory (@$ATTRIBUTE_XSPEC_DIR) wasn't specified")
}

def dir = new File(dirAttr)

if (dir.exists() && dir.isDirectory()) {
    runTestsFromDir(dir, recursive)
}
