#!/bin/bash
CGO_ENABLED=0 go build -v -trimpath -ldflags='-d -w' -buildvcs=auto .

