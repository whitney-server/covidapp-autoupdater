#!/bin/bash

# Step 2: Query Msyql for the latest data.
LAST_DATE=$(mysql -s -h 127.0.0.1 -ukr_covid -pcovid123 -P3306 < step2-query.sql)

echo ${LAST_DATE}

