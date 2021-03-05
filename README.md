VICAV Web Page
==============

A map-based web application for the VICAV project.

Set up a local instance
-----------------------

### Prerequisites

* Java LTS ([Oracle](https://www.oracle.com/java/technologies/javase-downloads.html),
  [Azul](https://www.azul.com/downloads/zulu-community/?version=java-11-lts&package=jdk),
  or others) (11 at the moment)
* [Node LTS](https://nodejs.org/) (14 at the moment)
* git ([for Windows](https://gitforwindows.org/), shipped with other OSes)
* This git repository needs to be cloned inside a [BaseX ZIP-file distribution](https://basex.org/download/)
  (9.5 at the moment)

### Setup

* unzip BaseX*.zip (for example in your home folder)
* in `<basexhome>/webapp` git clone this repository,
  please do not change the name `vicav-app`
* start a bash in `<basexhome>/webapp/vicav-app`
* run `./deployment/initial.sh`

This will clone [vicav-content](https://github.com/acdh-oeaw/vicav-content)
into `<basexhome>`.
