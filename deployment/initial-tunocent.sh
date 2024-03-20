#!/bin/bash

CONTENT_REPO=${CONTENT_REPO:-https://gitlab.oeaw.ac.at/acdh-ch/TUNOCENT/tunocent-content.git}
CONTENT_BRANCH=${CONTENT_BRANCH:-master}
source ./$(dirname $0)/initial.sh