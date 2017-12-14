#!/bin/bash
# This script tests the current source code against the dev environment which
# has all of the dependencies installed.
set -e
script_dir=$(dirname $0)
pushd $script_dir/..

docker build --tag status-im .

docker run -i \
    --rm=true \
    -v `pwd`:/home/developer/status \
    status-im \
    bash <<EOF
set -e
./re-natal use-figwheel
lein test-cljs
lein prod-build
EOF

popd
