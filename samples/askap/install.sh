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

download_and_extract "https://cloudstor.aarnet.edu.au/plus/s/KO5jutEkg3UffmU/download" askap-SS-1100.tar.gz
