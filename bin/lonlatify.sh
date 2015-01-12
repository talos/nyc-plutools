#!/bin/bash

source bin/utils.sh

info 'Adding lonlat to sqlite data in `./data/sqlite`'

mkdir -p data/lonlat
for release in data/sqlite/*.db; do
  table=$(basename $release .db)

  if [ ! -e data/lonlat/$table.csv ]; then
    info "Adding lonlat to $release..."

    # Print header
    printf 'lon	lat	' > data/lonlat/$table.csv
    echo '
.headers on
.mode tabs
SELECT * FROM `'$table'`
LIMIT 1;
    ' | sqlite3 $release \
    | head -n 1 \
    >> data/lonlat/$table.csv

    # Print rest of data
    echo '
.headers off
.mode tabs
SELECT
  CASE XCoord WHEN " " THEN "#" ELSE XCoord END,
    YCoord, "##END##", *
  FROM `'$table'`;' \
    | sqlite3 $release \
    | proj -I +proj=lcc +lat_1=41.03333333333333 +lat_2=40.66666666666666 +lat_0=40.16666666666666 +lon_0=-74 +x_0=300000.0000000001 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs -f "%.9f" \
    | sed -E 's/[[:space:]]+##END##//' \
    | sed 's/^#/	/' \
    | sed 's/ 	/	/g' \
    | sed 's/ $//g' \
    >> data/lonlat/$table.csv

  else
    info "Already added lonlat to $release"
  fi
done
