source bin/utils.sh

info 'Unzipping PLUTO data in `./data`'
mkdir -p data/unzipped
for archive in data/archives/*.zip; do
  base=$(basename $archive .zip)
  mkdir -p data/unzipped/$base
  unzip -n -d data/unzipped/$base $archive
  rm $archive
done
