#   $ gnuplot -p ./gnuplot/all.gnu
# or
#   $ gnuplot
#   gnuplot> load 'gnuplot/all.gnu'
set title 'Washoe Forecast'
set key top left box
set grid xtics y2tics
set y2label 'Deaths'
set logscale y2; set y2tics (8,16,32,64,128,256,512,1024,2048,4096)
set xlabel 'Date'
set xtics ('Apr' 3, 'May' 33, 'Jun' 64, 'Jul' 94, 'Aug' 125)
f(x,s) = x - s
plot \
  'cache/washoe/22-84_9_40.run'   using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:9, C:40'   axis x1y2,\
  'cache/washoe/22-84_10_50.run'  using (f($1,31)):2 with lines              lc 'green'  title 'D:22, T:10, C:50'  axis x1y2,\
  'cache/washoe/22-84_11_60.run'  using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:11, C:60'  axis x1y2,\
  'cache/washoe/22-84_12_70.run'  using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:12, C:70'  axis x1y2,\
  'cache/washoe/22-84_13_80.run'  using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:13, C:80'  axis x1y2,\
  'cache/washoe/22-84_14_90.run'  using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:14, C:90'  axis x1y2,\
  'cache/washoe/22-84_15_95.run'  using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:15, C:95'  axis x1y2,\
  'cache/washoe/22-84_17_105.run' using (f($1,31)):2 with lines              lc 'yellow' title 'D:22, T:17, C:105' axis x1y2,\
  'cache/washoe/0-84_16_100.run'  using (f($1,31)):2 with lines              lc 'blue'   title 'D:0, T:16, C:100'  axis x1y2,\
  'data/deaths_washoe'            using 1            with points pointtype 1 lc 'black'  title 'Actual'            axis x1y2
