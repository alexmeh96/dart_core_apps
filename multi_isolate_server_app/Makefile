SHELL=/bin/bash
SRC=bin
BUILD=build
ENTRY_FILE=main.dart
NATIVE_NAME=app

.PHONY: all run clean crete_native run_native

all: run

run:
	dart run ${SRC}/${ENTRY_FILE}

crete_native: ${BUILD} ${BUILD}/${NATIVE_NAME}

run_native:  crete_native
	${BUILD}/${NATIVE_NAME}

clean:
	rm -rf ${BUILD}

${BUILD}:
	mkdir ${BUILD}

${BUILD}/${NATIVE_NAME}: ${SRC}/*
	dart compile exe ${SRC}/${ENTRY_FILE} -o ${BUILD}/${NATIVE_NAME}	
