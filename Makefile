
CWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DEPS = ${CWD}/deps
BUILD = ${CWD}/build
ARCH = $(shell uname -m | sed s/arm64/aarch64/)
OS = $(shell uname -s  | sed s/Darwin/macos/ | sed s/Linux/linux/)

all: ${BUILD}/zig/zig


export PATH := ${BUILD}/zig:$(PATH)

ZIG_VERSION = 0.10.0-dev.3978+4fd4c733d
ZIG_TARBALL = ${DEPS}/zig-${OS}-${ARCH}-${ZIG_VERSION}.tar.xz
ZIG_URL = https://ziglang.org/builds/zig-${OS}-${ARCH}-${ZIG_VERSION}.tar.xz

${ZIG_TARBALL}:
	mkdir -p ${DEPS}
	curl -L ${ZIG_URL} -o ${ZIG_TARBALL}

${BUILD}/zig/zig: ${ZIG_TARBALL}
	rm -rf ${BUILD}/zig
	mkdir -p ${BUILD}/zig
	tar xf ${ZIG_TARBALL} -C ${BUILD}/zig --strip-components=1

clean:
	rm -rf ${BUILD}

clean-all: clean
	rm -rf ${DEPS}