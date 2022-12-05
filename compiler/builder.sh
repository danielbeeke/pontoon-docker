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
	docker images | grep -wE "^pontoon-compiler\s" | while read NAME TAG ID REST
	do
		docker rmi ${ID}
	done
}

build() {
	docker build \
		-t pontoon-compiler:${VERSION_COMPILER} .

	docker system prune -f
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
