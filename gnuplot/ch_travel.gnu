#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'China: varied travel'
set xlabel 'Days'
set ylabel 'Deaths'
set key bottom right
set logscale y
plot[0:66] \
        'cache/ch-travel/ch64.run'   using 2 with lines               lc 'yellow',\
        'cache/ch-travel/ch128.run'  using 2 with lines               lc 'yellow',\
        'cache/ch-travel/ch256.run'  using 2 with lines               lc 'yellow',\
        'cache/ch-travel/ch512.run'  using 2 with lines               lc 'yellow',\
        'cache/ch-travel/ch1024.run' using 2 with lines               lc 'yellow',\
        'cache/ch-travel/ch1664.run' using 2 with lines               lc 'green',\
	'data/deaths_china'                with points pointtype  1 lc 'blue',\
