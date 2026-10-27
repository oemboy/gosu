#!/usr/bin/env bash
set -Eeuo pipefail -x
FAKEGIT_GO_REVISION="$(grep -oEm1 "[0-9][0-9.+a-z-]+" version.go)"
grep <<<"$FAKEGIT_GO_REVISION" -E "^[0-9]+[.][0-9]+\$"
FAKEGIT_GO_SEMVER="v${FAKEGIT_GO_REVISION}.0"
export FAKEGIT_GO_REVISION FAKEGIT_GO_SEMVER
eval "go build $BUILD_FLAGS -o /go/bin/gosu-$ARCH" github.com/tianon/gosu
if go version -m "/go/bin/gosu-$ARCH" |& tee "/proc/$$/fd/1" | grep "(devel)" >&2; then
  exit 1
fi
file "/go/bin/gosu-$ARCH"
if arch-test "$ARCH"; then
  try() {
    for ((i = 0; i < 30; i++)); do if timeout 1s "$@"; then return 0; fi; done
    return 1
  }
  try "/go/bin/gosu-$ARCH" --version
  try "/go/bin/gosu-$ARCH" nobody id
  try "/go/bin/gosu-$ARCH" nobody ls -l /proc/self/fd
fi

