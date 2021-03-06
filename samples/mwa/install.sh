 
#!/bin/bash
#
# ICRAR - International Centre for Radio Astronomy Research
# (c) UWA - The University of Western Australia, 2018
# Copyright by UWA (in the framework of the ICRAR)
# All rights reserved
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307  USA
#

fail() {
	echo -e "$@" 1>&2
	exit 1
}

download_and_extract() {
    directory=`dirname "$2"`
    [ -d "$directory" ] || mkdir "$directory"

    # if extracted folder exists then assume cache is correct
    output="${2%.*.*}.ms"
    if [ ! -d $output ]; then
        echo "Downloading and extracting $2"
        wget -nv "$1" -O "$2" || fail "failed to download $2 from $1"
        tar -C "$directory" -xf "$2" || (fail "failed to extract $output" && rm -rf $output)
    else
        echo "$output already exists"
    fi
}

download_and_extract "https://cloudstor.aarnet.edu.au/plus/s/Eb65Nqy66hUE2tO/download" 1197638568-split.tar.gz
