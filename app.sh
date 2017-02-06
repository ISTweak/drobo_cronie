### RSYNC ###
_build_cronie() {
local VERSION="1.4.12"
local FOLDER="cronie${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="https://git.fedorahosted.org/cgit/cronie.git/snapshot/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"

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

