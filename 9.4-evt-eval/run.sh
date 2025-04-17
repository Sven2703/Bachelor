#!/bin/bash

echo "Switching working directory"

# cd to the directory where the script lies in
cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

echo "Starting benchmarking."
date
python3 ../scripts/run.py -t evts -r results -f inv.json

echo "Starting postprocessing of results "
python3 ../scripts/postprocess.py -t evts -r results -l 1800 --compare
cp results/plots/wallclock-time-INC-relative-error-max-norm-value-quantile.csv latex/evt-quantile.csv
cp results/plots/wallclock-time-INC-relative-error-max-norm-value-texpgf-scatter.csv latex/evt-scatter.csv
cp results/plots/relative-error-max-norm-value-texpgf-scatter.csv latex/evt-reldiff.csv



echo "Generating LaTex file."
cd latex
pdflatex --interaction=nonstopmode --halt-on-error plots.tex
cd ..

echo "----------------------------------------------"
echo "Output files: "
realpath results/tables/wallclock-time.html 
realpath latex/plots.pdf
echo "----------------------------------------------"

echo "Finished benchmarking."
date
