#!/bin/bash

# read a path from the user
read_path_to_binary() {
  read -e -p "> " INPUT_BINARY_PATH
  INPUT_BINARY_PATH="${INPUT_BINARY_PATH/#\~/$HOME}"
  echo $INPUT_BINARY_PATH
}

# cd to the directory where the script lies in
cd "$( dirname "${BASH_SOURCE[0]}" )"

echo "This script will ask for paths to the respective tools binaries and creates symlinks in $(pwd)/bin"
echo "If you just press enter instead of providing a path, no new symlink will be created".
read -p "Press enter to continue"

echo "Make sure Storm is installed."
echo "For our experiments, we used commit 0b1cae2a94f06984f3cf4cecf5a5090e9bc71a56 which is slightly newer than version 1.9.0"
echo "Other (newer) probably work, too."
echo ""

echo "Enter a path to the storm binary (e.g., ~/storm/build/bin/storm)"
read_path_to_binary
if [ -n "$INPUT_BINARY_PATH" ]; then
  ln -sf $INPUT_BINARY_PATH bin/storm
fi
./bin/storm --version

echo ""
echo "Enter a path to the PRISM binary (e.g., ~/prism/prism/bin/prism)"
read_path_to_binary
if [ -n "$INPUT_BINARY_PATH" ]; then
  ln -sf $INPUT_BINARY_PATH bin/prism
fi
./bin/prism --version

echo ""
echo "Enter a path to the SDS binary (e.g., ~/sds/build/sds/bin/stationary-distribution-sampling)"
read_path_to_binary
if [ -n "$INPUT_BINARY_PATH" ]; then
  ln -sf $INPUT_BINARY_PATH bin/sds
fi
./bin/sds --version

echo ""
echo "Enter a path to the greatspn binary directory (e.g., greatspn/opt/greatspn/lib/app/portable_greatspn/bin)"
read_path_to_binary
for BINARYNAME in WNRG swn_stndrd swn_ggsc swn_gst_prep swn_gst_stndrd showtpd; do
  if [ -n "$INPUT_BINARY_PATH" ]; then
    ln -sf $INPUT_BINARY_PATH/$BINARYNAME bin/$BINARYNAME
  fi
    ./bin/$BINARYNAME
done
echo "Note: If you see \"Error: no net name !\" in the output above, the installation for greatspn was successful.."

echo ""
while true; do
    read -p "Do you wish to install python requirements numpy and ijson (needed for postprocessing)? [y/n] " yn
    case $yn in
        [Yy]* ) pip3 install numpy ijson; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y (yes) or n (no).";;
    esac
done

echo "Installation done."
