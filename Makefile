data/archives:
	./bin/download.sh

data/unzipped: $(wildcard data/archives/*.zip)
	./bin/unzip.sh

data/concatenated: $(wildcard data/unzipped/*)
	./bin/concatenate.sh

lonlatify: $(wildcard data/concatenated/*)
	./bin/lonlatify.sh

datify:
	./bin/datify.sh

#all: data/archives data/unzipped data/concatenated lonlatify datify
