#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'Washoe: varied travel'
set xlabel 'Days'
set ylabel 'Deaths'
set key bottom right
set logscale y
plot[0:66] \
        'cache/washoe-travel/washoe8.run'   using 2 with lines               lc 'yellow',\
        'cache/washoe-travel/washoe16.run'  using 2 with lines               lc 'yellow',\
        'cache/washoe-travel/washoe32.run'  using 2 with lines               lc 'yellow',\
        'cache/washoe-travel/washoe64.run'  using 2 with lines               lc 'yellow',\
        'cache/washoe-travel/washoe128.run' using 2 with lines               lc 'yellow',\
        'cache/washoe-travel/washoe250.run' using 2 with lines               lc 'green',\
	'data/deaths_washoe'                using 1 with points pointtype  1 lc 'blue'
