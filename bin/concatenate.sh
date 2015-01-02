#!/bin/bash -e

source bin/utils.sh

info 'Concatenating borough PLUTO data in `./data/unzipped`'
mkdir -p data/concatenated
for release in data/unzipped/*/; do
  base=$(basename $release)
  if [ ! -e data/concatenated/$base.csv ]; then
    info "Concatenating $release into data/concatenated/$base.csv"

    # Add headers to 'all' file
    LC_ALL=C LANG=C \
      ls $release*.csv $release*.CSV $release*.txt $release*.TXT 2>/dev/null | \
      tail -n 1 | \
      xargs head -n 1 | \
      sed -E 's/ +/ /g' \
      > data/concatenated/$base.csv

    # Pipe in data
    LC_ALL=C LANG=C \
      ls $release*.csv $release*.CSV $release*.txt $release*.TXT 2>/dev/null | \
      xargs tail -q -n +2 | \
      sed 's/[^[:print:]]//g' | \
      sed -E 's/ +/ /g' \
      >> data/concatenated/$base.csv

    #rm $release*.csv $release*.CSV $release*.txt $release*.TXT
  else
    info "Release $base already exists at data/concatenated/$base.csv"
  fi
done
