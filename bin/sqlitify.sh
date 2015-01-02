#!/bin/bash -e

source bin/utils.sh

info 'Converting PLUTO data in `./data/concatenated` to sqlite'
mkdir -p data/sqlite
pushd data/concatenated
for release in *.csv; do
  base=$(basename $release .csv)
  if [ ! -e ../sqlite/$base.db ]; then
    info "Converting $release to sqlite..."
    ../../bin/csv2sqlite3.py -z 3 $release
    mv $base.db ../sqlite/
    mv $base.sql ../sqlite/
  else
    info "Already converted $release to sqlite."
  fi
done
popd
