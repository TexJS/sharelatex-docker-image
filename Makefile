# Makefile


build-base:
	docker build --force-rm -f Dockerfile-base -t texjs/sharelatex-base .


build-community:
	docker build --no-cache --force-rm -f Dockerfile -t texjs/sharelatex .


PHONY: build-base build-community
