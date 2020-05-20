#!/bin/bash

for fil in logs/*
do
    echo "latency for "$fil" at "`date -r $fil`
    awk -F'/' '{ printf (/^rtt/? ""$5" ":"") }' $fil
    echo ""
done

