#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'Sweden: varied travel'
set xlabel 'Days'
set ylabel 'Deaths'
set key bottom right
set logscale y
plot[0:66] \
        'cache/sw-travel/sw32.run'  using 2 with lines               lc 'yellow',\
        'cache/sw-travel/sw64.run'  using 2 with lines               lc 'yellow',\
        'cache/sw-travel/sw128.run' using 2 with lines               lc 'yellow',\
        'cache/sw-travel/sw105.run' using 2 with lines               lc 'green',\
	'data/deaths_sweden'                with points pointtype  1 lc 'blue',\
