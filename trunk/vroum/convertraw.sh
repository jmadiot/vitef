#!/bin/bash

cat $1 | sed 's/\([-0-9\.][-0-9\.]*\) \([-0-9\.][-0-9\.]*\) \([-0-9\.][-0-9\.]*\) /glVertex3f(\1, \2, \3);\n/g'
