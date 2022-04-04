#!/bin/bash

set -e

SCRIPTPATH=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
CMAKE_OPTS="$1"

cd "$SCRIPTPATH/.."

if [[ ! -d rz_libyara ]]; then
	git clone https://github.com/rizinorg/rz-libyara.git --depth 1 rz_libyara
    git -C rz_libyara submodule init
    git -C rz_libyara submodule update
fi

cd rz_libyara
rm -rf build || sleep 0
mkdir build && cd build
meson --buildtype=release "$@" ..
ninja
ninja install

cd cutter-plugin
mkdir build && cd build
cmake -G Ninja $CMAKE_OPTS ..
ninja
ninja install
