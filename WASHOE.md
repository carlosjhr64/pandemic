# Washoe county

I varied the travel parameter to try to fit Washoe's data better.

```fish
pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=100.0 \
  --travel=250 \
  --halt_alert_days=63 \
  --transmission=0.301 --seed=7f39a11326339bd8029ba41368f72bef > cache/washoe-travel/washoe250.run
```

What those runs look like:

![Washoe county varied travels](img/washoe_travels.png)

My original estimate for the travel parameter(250) was way too high.
A travel of 16 looks better.
A travel of 16 equates to a grid of 1024 people, `(16*2)**2`, and
I can't equate this to any regional/geographic restrictions.
Nevada did declare a state of emergency mid March, so
the spread has been under imposed restrictions
([see timeline for Nevada](https://en.wikipedia.org/wiki/COVID-19_pandemic_in_Nevada#Timeline)).
I will note that people here where I live have been taking health guidelines seriously...
I see people wear face masks and keeping their distance.


New loop search based on travel 16 fitting 46 days after first death:

```fish
nice --adjustment=19 pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=100.0 \
  --travel=16 \
  --halt_alert_days=46 --halt_rsd=1.0 \
  --description=washoe --loop=transmission \
  --seed=(superrandom) --transmission=0.637
```
