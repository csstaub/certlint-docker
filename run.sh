#!/bin/bash

cd /certlint
ruby -I lib bin/certlint "$@" || echo "error"
