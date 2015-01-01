source bin/utils.sh

info 'Concatenating borough PLUTO data in `./data/unzipped`'
mkdir -p data/concatenated
for release in data/unzipped/*/; do
  base=$(basename $release)
  if [ ! -e data/concatenated/$base.csv ]; then
    info "Concatenating $release into data/concatenated/$base.csv"

    # Add headers to 'all' file
    LANG="CP-1252" \
      ls $release*.csv $release*.CSV $release*.txt $release*.TXT 2>/dev/null | \
      head -n 1 | \
      xargs head -n 1 | \
      tr -d '\r' | \
      sed -E 's/ +/ /g' | \
      sed -E 's/," "/,/g' \
      > data/concatenated/$base.csv

    # Pipe in data
    LANG="CP-1252" \
      ls $release*.csv $release*.CSV $release*.txt $release*.TXT 2>/dev/null | \
      xargs tail -q -n +2 | \
      tr -d '\r' | \
      sed -E 's/ +/ /g' | \
      sed -E 's/," "/,/g' \
      >> data/concatenated/$base.csv

    rm $release*.csv $release*.CSV $release*.txt $release*.TXT
  else
    info "Release $base already exists at data/concatenated/$base.csv"
  fi
done
