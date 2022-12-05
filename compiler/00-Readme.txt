NodeJS versions
===============

Since newer alpine images always keep track of the latest package, there is an issue when
something depends on an older package version. MIS GUI depends on nodejs v12.8.0.

This link shows how to solve this in alpine:
https://medium.com/geekculture/how-to-install-a-specific-node-js-version-in-an-alpine-docker-image-3edc1c2c64be
