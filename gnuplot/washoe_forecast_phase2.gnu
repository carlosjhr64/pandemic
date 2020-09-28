#   $ gnuplot -p ./gnuplot/washoe_forecast_phase2.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/washoe_forecast_phase2.gnu'
set title 'Washoe Forecast: Phase 2'
set key top left box
set grid xtics y2tics
set y2label 'Deaths'
set logscale y2
set y2tics mirror (1,2,4,6,9,12,16,20,25,30,36,42,49,56,64,72,81,90,100,121,144,169,196,240,289,342,400)
set xlabel 'Date'
set xtics ('Apr' 3, 'May' 33, 'Jun' 64, 'Jul' 94, 'Aug' 125, 'Sep' 156, 'Oct' 187, 'Nov' 217, 'Dec' 247, 'Jan' 278)
f(x,s) = x - s
plot \
  'cache/washoe/22-84_10_50.run'\
    using (f($1,31)):2 with lines   lc 'dark-green' title 'D:22, T:10, C:50 L:235'  axis x1y2,\
  'cache/washoe/phase1_10_50_167.run'\
    using (f($1,31)):2 with lines   lc 'cyan'       title 'D:42, T:10, C:50 L:167'  axis x1y2,\
  'cache/washoe/phase2_13_65_167.run'\
    using (f($1,31)):2 with lines   lc 'pink'       title 'D:62, T:13, C:65 L:167'  axis x1y2,\
  'data/deaths_washoe'\
    using 1 with points pointtype 1 lc 'black'      title 'Actual'                  axis x1y2
