#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title '60 Days From First Death'
set xlabel 'Days'
set ylabel 'Deaths'
set key bottom right
set logscale y
plot[0:66] \
	'data/deaths_worldwide'             with points pointtype  4 lc 'gray',\
        'cache/transmission/ch.run' using 2 with lines               lc 'black',\
	'data/deaths_china'                 with points pointtype  4 lc 'black',\
        'cache/transmission/it.run' using 2 with lines               lc 'dark-green',\
	'data/deaths_italy'                 with points pointtype  1 lc 'dark-green',\
        'cache/transmission/ny.run' using 2 with lines               lc 'red',\
	'data/deaths_new_york'              with points pointtype  1 lc 'red',\
        'cache/transmission/sw.run' using 2 with lines               lc 'blue',\
	'data/deaths_sweden'                with points pointtype  1 lc 'blue',\
        'cache/transmission/washoe.run' using 2 with lines           lc 'orange',\
	'data/deaths_washoe'        using 1 with points pointtype  1 lc 'orange',\
