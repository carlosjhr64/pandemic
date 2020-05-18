#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'Washoe Forecast: Phase 1'
set key top left
set grid
set xlabel 'Date'
set ylabel 'Deaths'
set xtics ("Apr" 3, "May" 33, "Jun" 64, "Jul" 94, "Aug" 125)
set logscale y; set ytics (8,16,32,64,128,256,512,1024,2048,4096)
f(x,s) = x - s
plot \
  'cache/washoe/22-84_9_40.run'     using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/22-84_10_50.run'    using (f($1,31)):2 with lines              lc 'green',  \
  'cache/washoe/22-84_11_60.run'    using (f($1,31)):2 with lines              lc 'yellow', \
  'cache/washoe/0-84_16_100.run'    using (f($1,31)):2 with lines              lc 'blue',   \
  'cache/washoe/phase1_250_133.run' using (f($1,31)):2 with lines              lc 'red',    \
  'cache/washoe/phase1_250_90.run'  using (f($1,31)):2 with lines              lc 'red',    \
  'cache/washoe/phase1_16_100.run'  using (f($1,31)):2 with lines              lc 'red',    \
  'data/deaths_washoe'              using 1            with points pointtype 1 lc 'blue'
