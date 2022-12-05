#!/bin/bash

. ../versions.env

set -e

usage() {
	N=$(basename $0)
cat << __USAGE__
usage: ${N} cmd
  cmd:
    clean	- Remove all images
    build	- Rebuild all images
    all		- Clean and build all images
    save	- Save image to a tar file
    full	- Clean, build and save all images

__USAGE__
	exit 1
}

clean() {
	docker images | grep -wE "^pontoon-builder\s" | while read NAME TAG ID REST
	do
		docker rmi ${ID}
	done

	docker system prune -f
}

build() {
	rm -rf work
	mkdir -pv work

	docker run -ti --rm  -v $(pwd)/work:/work -v $(pwd)/00-buildall.sh:/usr/local/bin/buildall.sh -w /work -h builder pontoon-compiler:${VERSION_COMPILER} bash buildall.sh

	cp -v server.env work/pontoon/docker/config/server.env
	(cd work/pontoon
	docker compose build --build-arg USER_ID=1000 --build-arg GROUP_ID=1000 server
	)

	(cd work/pontoon/docker/postgres
	docker  build -f Dockerfile -t local/postgresql .
	)
}

save() {
	echo "Nothing to save."
}

CMD=$1

case "${CMD}" in
	clean ) clean
		exit 0
		;;
	build ) build
		;;
	save ) save
		;;
	all ) clean && build
		;;
	full ) clean && build && save
		;;
	* )	usage
		;;
esac

exit 0
