data/archives:
	./bin/download.sh

data/unzipped: $(wildcard data/archives/*.zip)
	./bin/unzip.sh

data/concatenated: $(wildcard data/unzipped/*)
	./bin/concatenate.sh

sqlitify: $(wildcard data/concatenated/*)
	./bin/lonlatify.sh

lonlatify: $(wildcard data/sqlite/*)
	./bin/lonlatify.sh

datify: $(wildcard data/lonlat/*)
	./bin/datify.sh

#all: data/archives data/unzipped data/concatenated lonlatify datify
