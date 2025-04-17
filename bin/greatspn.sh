#!/bin/zsh

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <path_to_netname> <working_dir> <precision>"
    echo "where the files <path_to_netname>.net and <path_to_netname>.def exists"
    echo "<working_dir> points to an empty directory where the intermediate files will be stored"
    echo "Use the greatspn gui to generate the .net and the .def file out of a PNPRO file"
    exit 1
fi

next_step() {
  if [ -n "$TIMEPOINT" ]; then
    echo "Time elapsed: $(echo "$(date +%s.%N) - $TIMEPOINT" | bc) seconds."
  fi
  echo "-------------------------------------------------------------------------------"
  TIMEPOINT=$(date +%s.%N)
}

# fail on first error
set -e

SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
GREATSPN_DIR="$SCRIPT_DIR"
echo "GREATSPN_DIR: $GREATSPN_DIR"

NET_NAME=$(basename $1)
echo "Net Name : $NET_NAME"

mkdir -p $2
cp $1.net $2
cp $1.def $2
cd $2
echo "Working directory: $(pwd)"

next_step
echo "Computing reachability graph"
$GREATSPN_DIR/WNRG $NET_NAME -m
next_step
echo "Conversion into a Markov Chain"
$GREATSPN_DIR/swn_stndrd $NET_NAME
next_step
echo "Computing steady state probabilities"
$GREATSPN_DIR/swn_ggsc $NET_NAME -e$2 -i10000
echo "Done computing steady state probabilities"
next_step

if [ -f "$NET_NAME.epd" ]; then
  echo "copy result vector" # only necessary in older GreatSPN versions
  cp "$NET_NAME.epd" "$NET_NAME.mpd"
  next_step
fi

echo "postprocess result (step 1)"
$GREATSPN_DIR/swn_gst_prep $NET_NAME
next_step
echo "postprocess result (step 2)"
$GREATSPN_DIR/swn_gst_stndrd $NET_NAME -append "$NET_NAME.sta"
next_step

echo "Showing results for all places:"
$GREATSPN_DIR/showtpd $NET_NAME | grep E
