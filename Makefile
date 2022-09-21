
CWD:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DEPS = ${CWD}/deps
BUILD = ${CWD}/build
SRC = ${CWD}/src
ARCH = $(shell uname -m | sed s/arm64/aarch64/)
OS = $(shell uname -s  | sed s/Darwin/macos/ | sed s/Linux/linux/)
ZIG_PKG = --main-pkg-path ${CWD}
ZIG_OPT = -OReleaseFast

all: test


export PATH := ${BUILD}/zig:$(PATH)

###
# Zig
###

ZIG_VERSION = 0.10.0-dev.3978+4fd4c733d
ZIG_TARBALL = ${DEPS}/zig-${OS}-${ARCH}-${ZIG_VERSION}.tar.xz
ZIG_URL = https://ziglang.org/builds/zig-${OS}-${ARCH}-${ZIG_VERSION}.tar.xz

${ZIG_TARBALL}:
	mkdir -p ${DEPS}
	curl -L ${ZIG_URL} -o ${ZIG_TARBALL}

${BUILD}/zig/.${ZIG_VERSION}: ${ZIG_TARBALL}
	rm -rf ${BUILD}/zig
	mkdir -p ${BUILD}/zig
	tar xf ${ZIG_TARBALL} -C ${BUILD}/zig --strip-components=1
	touch ${BUILD}/zig/.${ZIG_VERSION}

zig: ${BUILD}/zig/.${ZIG_VERSION}
.PHONEY: zig

###
# Ziglyph
###

ZIGLYPH_VERSION = 21bc9f5d6c309e9b332c7e0abb642dada1e15417
ZIGLYPH_REPO = https://github.com/jecolon/ziglyph.git

${DEPS}/ziglyph:
	mkdir -p ${DEPS}
	cd ${DEPS} && git clone ${ZIGLYPH_REPO} ziglyph

${BUILD}/ziglyph/.${ZIGLYPH_VERSION}: ${DEPS}/ziglyph
	rm -rf ${BUILD}/ziglyph
	mkdir -p ${BUILD}
	cd ${DEPS}/ziglyph && git pull
	git clone ${DEPS}/ziglyph ${BUILD}/ziglyph
	cd ${BUILD}/ziglyph && git checkout ${ZIGLYPH_VERSION}
	touch ${BUILD}/ziglyph/.${ZIGLYPH_VERSION}

ziglyph: ${BUILD}/ziglyph/.${ZIGLYPH_VERSION}
.PHONEY: zyglyph

###
# Zigstr
###


ZIGSTR_VERSION = 0cb36c3e8b2c38b6c8628c2ea2df44b06eb657b6
ZIGSTR_REPO = https://github.com/jecolon/zigstr.git

${DEPS}/zigstr:
	mkdir -p ${DEPS}
	cd ${DEPS} && git clone ${ZIGSTR_REPO} zigstr

${BUILD}/zigstr/.${ZIGSTR_VERSION}: ${DEPS}/zigstr
	rm -rf ${BUILD}/zigstr
	mkdir -p ${BUILD}
	cd ${DEPS}/zigstr && git pull
	git clone ${DEPS}/zigstr ${BUILD}/zigstr
	cd ${BUILD}/zigstr && git checkout ${ZIGSTR_VERSION}
	touch ${BUILD}/zigstr/.${ZIGSTR_VERSION}

zigstr: ${BUILD}/zigstr/.${ZIGSTR_VERSION}
.PHONEY: zigstr


test: zig zigstr ziglyph
	zig build-exe ${ZIG_PKG} ${OPT} ${SRC}/test.zig
	./test

test1: zig zigstr ziglyph
	zig test ${ZIG_PKG} ${ZIG_OPT} ${SRC}/test.zig

clean:
	rm -rf ${BUILD}

clean-all: clean
	rm -rf ${DEPS}