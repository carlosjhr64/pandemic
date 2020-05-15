#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'China: varied contacts'
set xlabel 'Days'
set ylabel 'Deaths'
set key bottom right
set logscale y
f(x) = x - 28
plot \
        'cache/ch-contacts/ch15.run'     using (f($1)):2 with lines              lc 'blue',\
        'cache/ch-contacts/ch15_100.run' using (f($1)):2 with lines              lc 'green',\
        'cache/ch-contacts/ch15_75.run'  using (f($1)):2 with lines              lc 'yellow',\
        'cache/ch-contacts/ch15_50.run'  using (f($1)):2 with lines              lc 'yellow',\
        'cache/ch-contacts/ch15_25.run'  using (f($1)):2 with lines              lc 'yellow',\
 	'data/deaths_china'                              with points pointtype 1 lc 'blue',\
