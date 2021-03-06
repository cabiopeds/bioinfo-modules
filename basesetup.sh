#!/bin/sh
#!/usr/local/bin/bash

PROG="SETME"
VERSION="SETME"
URL="SETME"
DESCRIPTION=""
SHORT=""
AUTOCOPY="1"
CUSTOM_MODFILE="0"
MODFILE_EXTRA=""

. $1

if [ ! -e .git ]; then
    echo "Run me from the root application directory"
    exit 1
fi

MODAPPSDIR=$(pwd)
cd $(dirname $1)

if [ -e build ]; then
    echo "$PROG-$VERSION/build already exists!"
    exit 1


    if [ "$PROG" == "SETME" ]; then
        echo "SETUP THE FILE FIRST"
        exit 1
    fi

fi

echo "Building $PROG-$VERSION"

mkdir build
mkdir -p bin
mkdir -p man/man1

cd build

build
echo "Done"
cd ..

if [ "$AUTOCOPY" == "1" ]; then

if [ $(uname) == "FreeBSD" ]; then 
    find build -perm +u+x -not -type d -exec cp \{\} bin \;
else
    find build -perm /u+x -not -type d -exec cp \{\} bin \;
fi
find build -name '*.1' -exec cp \{\} man/man1 \;
fi

cd $MODAPPSDIR
mkdir -p modulefiles/$PROG

if [ "$CUSTOM_MODFILE" == "0" ]; then
cat <<EOF > modulefiles/$PROG/$VERSION
#%Module1.0#####################################################################
#
## $PROG-$VERSION
##
proc ModulesHelp { } {
    global version

    puts stderr "\t$SHORT"
    puts stderr "\n\tVersion \$version\n"
}

module-whatis "
$DESCRIPTION
"

conflict $PROG

# for Tcl script use only
set version "$VERSION"
$MODFILE_EXTRA
prepend-path PATH $MODAPPSDIR/$PROG/$PROG-$VERSION/bin
prepend-path MANPATH $MODAPPSDIR/$PROG/$PROG-$VERSION/man

if [ module-info mode load ] {
        puts stderr "$PROG version \$version loaded."
}

if [ module-info mode switch2 ] {
        puts stderr "$PROG version \$version loaded."
}

if [ module-info mode remove ] {
        puts stderr "$PROG version \$version unloaded."
}
EOF
else
custom_modfile
fi
