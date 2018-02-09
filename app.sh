### RSYNC ###
_build_cronie() {
local VERSION="1.5.1"
local FOLDER="cronie-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="https://github.com/cronie-crond/cronie/archive/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/cronie-${FOLDER}"

patch -u src/popen.c < ../../src/popen.patch

#autoconf
autoreconf --install
./configure --host="${HOST}" --prefix="${DEST}" 
make
make install
popd
}

### BUILD ###
_build() {
  _build_cronie
  _package
}

