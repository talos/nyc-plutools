source bin/utils.sh

info 'Downloading PLUTO data to `data`'
mkdir -p logs data/archives
for release in 02a 03c 04c 05d 06c 07c 09v1 09v2 10v1 10v2 11v1 11v2 12v1 12v2 13v1 13v2 14v1; do
  if [ -e data/archives/${release}.zip ]; then
    info "Already downloaded PLUTO $release"
  else
    info "Downloading PLUTO $release"
    wget -o logs/$release.log -O data/archives/$release.zip \
      "http://www.nyc.gov/html/dcp/download/bytes/nyc_pluto_$release.zip" &
  fi
done

info 'Waiting for downloads to complete.'
wait
