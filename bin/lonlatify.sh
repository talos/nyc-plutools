#!/bin/bash

# Usage ./process.sh </path/to/plutofile>

table=$(basename $1 .db)

# Print header
printf 'lon	lat	'
echo '
.headers on
.mode tabs
SELECT * FROM `'$table'`
LIMIT 1;
' | sqlite3 $1 \
| head -n 1

# Print rest of data
echo '
.headers off
.mode tabs
SELECT
  CASE XCoord WHEN " " THEN "#" ELSE XCoord END,
    YCoord, "##END##", *
  FROM `'$table'`;' \
| sqlite3 $1 \
| proj -I +proj=lcc +lat_1=41.03333333333333 +lat_2=40.66666666666666 +lat_0=40.16666666666666 +lon_0=-74 +x_0=300000.0000000001 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs -f "%.9f" \
| sed -E 's/[[:space:]]+##END##//' \
| sed 's/^#/	/' \
| sed 's/ 	/	/g' \
| sed 's/ $//g'
