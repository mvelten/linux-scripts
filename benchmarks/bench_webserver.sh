#!/bin/bash

command -v ab >/dev/null 2>&1 || { echo >&2 "ab from Apache utils is required.  Aborting."; exit 1; }
command -v gnuplot >/dev/null 2>&1 || { echo >&2 "gnuplot is required.  Aborting."; exit 1; }

if [[ $# != 3 ]]
then
	echo -e "\n$0 <number of requests> <number of concurrency> <URL1> "
	echo -e "\nExample: $0 100 10 http://www.google.com/ \n"
	exit 1
fi

MYDATE=`date +%Y%m%d%H%M%S`
OUTFILE="graph_${1}_${2}_${MYDATE}.jpg"

# Benchmark!
ab -n${1} -c${2} -g "gnuplot_${MYDATE}.out" "${3}" || exit 1

####
## Create gnuplot script
## taken from http://www.bradlanders.com/2013/04/15/apache-bench-and-gnuplot-youre-probably-doing-it-wrong/
####

cat << EOF > plotme
# Let's output to a jpeg file
set terminal jpeg size 1280,720
# This sets the aspect ratio of the graph
set size 1, 1
# The file we'll write to
set output "${OUTFILE}"
# The graph title
set title "Benchmark ${3}"
# Where to place the legend/key
set key left top
# Draw gridlines oriented on the y axis
set grid y
# Specify that the x-series data is time data
set xdata time
# Specify the *input* format of the time data
set timefmt "%s"
# Specify the *output* format for the x-axis tick labels
set format x "%S"
# Label the x-axis
set xlabel 'seconds'
# Label the y-axis
set ylabel "response time (ms)"
# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'
# Plot the data
plot "gnuplot_${MYDATE}.out" every ::2 using 2:5 title 'response time' with points
exit
EOF

# Plot!
gnuplot plotme || exit 1

echo -e "\n Success! Result image is: ${OUTFILE}"

# clean up
rm plotme

exit 0

