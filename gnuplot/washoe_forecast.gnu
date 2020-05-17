#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'Washoe Forecast'
set grid
set xlabel 'Date'
set ylabel 'Deaths'
set key bottom right
set xtics ("Apr" 3, "May" 33, "Jun" 64, "Jul" 94, "Aug" 125)
set logscale y; set ytics (8,16,32,64,128,256)
f(x,s) = x - s
plot \
  'cache/washoe/22-84_9_40.run'  using (f($1,31)):2 with lines               lc 'yellow', \
  'cache/washoe/22-84_10_50.run'  using (f($1,31)):2 with lines              lc 'green',  \
  'cache/washoe/22-84_11_60.run'  using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/22-84_12_70.run'  using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/22-84_13_80.run'  using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/22-84_14_90.run'  using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/22-84_15_95.run'  using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/22-84_17_105.run' using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/0-84_16_100.run'  using (f($1,31)):2 with lines              lc 'blue',   \
  'data/deaths_washoe'            using 1            with points pointtype 1 lc 'blue'
