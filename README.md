VICAV Web Page
==============

A map-based web application for the VICAV project.

Set up a local instance
-----------------------

### Prerequisites

* Java LTS ([Oracle](https://www.oracle.com/java/technologies/javase-downloads.html),
  [Azul](https://www.azul.com/downloads/zulu-community/?version=java-11-lts&package=jdk),
  or others) (17 at the moment)
* [Node LTS](https://nodejs.org/) (18 at the moment)
* git ([for Windows](https://gitforwindows.org/), shipped with other OSes)
* curl for downloading [Saxon HE](https://www.saxonica.com/download/java.xml)
  (10.3 at the moment, curl is included with git for windows)
* This git repository needs to be cloned inside a [BaseX ZIP-file distribution](https://files.basex.org/releases/9.7.3/)
  (please use 9.7.3 at the moment, version 10.x will be supported soon)

### Setup

* unzip BaseX*.zip (for example in your home folder)
  `<basexhome>` is the directory containing `BaseX.jar` and the `bin`, `lib` and
  `webapp` directory (`basex` after unpacking the BaseX*.zip file, but you should
  probably rename it)
* in `<basexhome>/webapp` git clone [this repository](https://github.com/acdh-oeaw/vicav-app.git),
  please do not change the name `vicav-app`
* start a bash in `<basexhome>/webapp/vicav-app`
* run `./deployment/initial.sh`

This will clone [vicav-content](https://github.com/acdh-oeaw/vicav-content)
into `<basexhome>`.

### Update data and web page code

In `<basexhome>` execute `./redeploy.sh`


Then if


### Tests

3 types of tests:
* XSPEC for unit testing the XSL transformations in ./xslt,
* XUnit for testing basex API endpoint outputs
* Cypress for end-to-end testing of the frontend features

Test data is located in ./fixtures.
Before running tests locally, you have to setup your test environment with the fixtures.

Tests are automatically executed upon a git push on Gitlab.
See https://gitlab.com/acdh-oeaw/vicav/vicav-app/-/pipelines.

To run tests locally you need to tell the scripts where to find BaseX using the CYPRESS_BASEX_ROOT environment variable.
E.g.:
```powershell
$env:CYPRESS_BASEX_ROOT="<basexhome>"
npm run test
```

#### XSpec

Installation: Download xspec from https://github.com/xspec/xspec
Running a test file:
1a. Windows: `<xspechome>/bin/xspec.sh FILENAME`
1b. Linux, mac: run `<xspechome>/bin/xspec.sh FILENAME`

#### Run xUnit:

Running a test file:
Run `<basexhome>/bin/basex -t FILENAME`

#### Run cypress

Installation:
* install nodejs and npm
* run `npm install`

Running tests:
Either open the GUI with `npm run cypress:open` or run them on command line with `npm run cypress:run`.