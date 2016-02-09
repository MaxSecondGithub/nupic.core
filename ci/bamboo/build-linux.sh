#!/bin/bash
set -o errexit
set -o xtrace

# Environment defaults w/ defaults
${USER:=docker}
export USER

${CC:="gcc"}
export CC

if [ "${CC}" = "clang" ]; then
    ${CXX:=clang++}
    COMPILER_PACKAGES="clang-3.4"
else
    ${CXX:=g++}
    COMPILER_PACKAGES="${CC} ${CXX}"
fi
export CXX

# Install OS dependencies, assuming stock ubuntu:latest
apt-get update
apt-get install -y \
    curl \
    wget \
    git-core \
    ${COMPILER_PACKAGES} \
    cmake \
    python \
    python2.7 \
    python2.7-dev \
    zlib1g-dev \
    bzip2 \
    libyaml-dev \
    libyaml-0-2
wget https://bootstrap.pypa.io/get-pip.py -O - | python
pip install --upgrade setuptools
pip install wheel

# Install nupic.core dependencies
pip install \
    --cache-dir /usr/local/src/nupic.core/pip-cache \
    --build /usr/local/src/nupic.core/pip-build \
    --no-clean \
    pycapnp==0.5.5 \
    -r bindings/py/requirements.txt

# Build installable python packages
python setup.py bdist bdist_dumb bdist_wheel sdist
