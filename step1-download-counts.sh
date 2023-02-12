#!/bin/bash

# Step 1: Use wget to download the last month's covid counts from the nytimes's Github.

wget -O ./tmp/latestCounts.csv http://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv
