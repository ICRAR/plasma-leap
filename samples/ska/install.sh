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
        mkdir -p "$2"
        gsutil -m cp -r "$1" "$2" || fail "failed to download $2 from $1"
        tar -C "$directory" -xf "$2" || (fail "failed to extract $output" && rm -rf $output)
    else
        echo "$output already exists"
    fi
}


download_and_extract "gs://ska1-simulation-data/ska1-low/direction_dependent_sims_SP-1056/SKA_LOW_SIM_short_EoR0_ionosphere_on_GLEAM.MS/*" SKA_LOW_SIM_short_EoR0_ionosphere_on_GLEAM.MS
