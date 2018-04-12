# Makefile

all: build-base build-community

build-base:
	docker build -f Dockerfile-base -t texjs/sharelatex-base .


build-community:
	docker build -f Dockerfile -t texjs/sharelatex .


PHONY: build-base build-community
