source bin/utils.sh

info 'Downloading PLUTO data to `data`'
mkdir -p logs data
for release in 02a 03c 04c 05d 06c 07c 09v1 09v2 10v1 10v2 11v1 11v2 12v1 12v2 13v1 13v2 14v1; do
  if [ -e data/${release}.zip ]; then
    info "Already downloaded PLUTO $release"
  else
    info "Downloading PLUTO $release"
    wget -o logs/$release.log -O data/$release.zip \
      "http://www.nyc.gov/html/dcp/download/bytes/nyc_pluto_$release.zip" &
  fi
done

info 'Waiting for downloads to complete.'
wait

info 'Unzipping PLUTO data in `./data`'
for archive in data/*.zip; do
  base=$(basename $archive .zip)
  mkdir -p data/$base
  unzip -n -d data/$base $archive
done

info 'Concatenating borough PLUTO data in `./data`'
for release in data/*/; do
  base=$(basename $release)
  if [ ! -e data/$base.csv ]; then
    info "Concatenating $release into data/$base.csv"

    # Add headers to 'all' file
    ls $release*.csv $release*.CSV $release*.txt $release*.TXT 2>/dev/null | \
      head -n 1 | \
      xargs head -n 1 | \
      tr -d '\r' \
      > data/$base.csv

    # Pipe in data
    ls $release*.csv $release*.CSV $release*.txt $release*.TXT 2>/dev/null | \
      xargs tail -q -n +2 | \
      tr -d '\r' \
      >> data/$base.csv
  fi
done
