#!/bin/sh
set -e

alias large_echo='{ set +x; } 2> /dev/null; f(){ echo "#\n#\n# $1\n#\n#"; set -x; }; f'

PY_VER=3.7.5

large_echo "Check OpenSSL installation path and CWD"
if brew ls --versions openssl > /dev/null; then
    OPENSSL_ROOT="$(brew --prefix openssl)"
    echo $OPENSSL_ROOT
else
    echo "Please install OpenSSL with brew: 'brew install openssl'"
    exit 1
fi
CURRENT_DIR="$PWD"
echo $CURRENT_DIR

large_echo "Download and uncompress Python $PY_VER source"
wget "https://www.python.org/ftp/python/$PY_VER/Python-$PY_VER.tgz"
tar -zxvf "Python-$PY_VER.tgz" &> /dev/null

cd "Python-$PY_VER"
large_echo "Configure Python"
./configure MACOSX_DEPLOYMENT_TARGET=10.11 CPPFLAGS="-I$OPENSSL_ROOT/include" LDFLAGS="-L$OPENSSL_ROOT/lib" --with-openssl="$OPENSSL_ROOT" --prefix="$CURRENT_DIR/python"
large_echo "Build Python"
make altinstall
