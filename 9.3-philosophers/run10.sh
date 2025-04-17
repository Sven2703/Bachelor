#!/bin/bash

echo "Switching working directory"

# cd to the directory where the script lies in
cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd

echo "Start benchmarking variant with deadlock."
date
python3 ../scripts/run.py -t evts -r results_dl -f inv_dl10.json

echo "Start benchmarking variant without deadlock"
date
python3 ../scripts/run.py -t stationary -r results_dlfix -f inv_dlfix10.json

echo "Starting postprocessing of results "
python3 ../scripts/postprocess.py -t evts -r results_dl -l 10
python3 ../scripts/postprocess.py -t stationary -r results_dlfix -l 10

cp results_dl/plots/wallclock-time-texpgf-scatter.csv  latex/philosophers-dl.csv
cp results_dlfix/plots/wallclock-time-texpgf-scatter.csv  latex/philosophers-dlfix.csv




echo "Generating LaTex file."
cd latex
pdflatex --interaction=nonstopmode --halt-on-error plots.tex
cd ..

echo "----------------------------------------------"
echo "Output files: "
realpath results_dl/tables/wallclock-time.html 
realpath results_dlfix/tables/wallclock-time.html 
realpath latex/plots.pdf
echo "----------------------------------------------"
echo "Data for bar chart in Fig 10:"
grep Result results_dlfix/logs/storm.sparse.classic-gmres-topo.1e-06.philosophers-dlfix.propertyphilosophers-dlfix.8.props.8.log   
echo "----------------------------------------------"
echo "Finished benchmarking."
date
