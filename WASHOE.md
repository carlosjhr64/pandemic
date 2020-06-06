# Washoe county

Mitigations in Washoe county follows as per the state of Nevada.
See Wikipedia's [COVID-19 pandemic in Nevada](https://en.wikipedia.org/wiki/COVID-19_pandemic_in_Nevada) article.

## State of emergency

Nevada declares a state of emergency on 2020-03-20, and
first death occurs four days later.
Note that the initial days of the simulation runs while lockdowns begins.

### Varied travel

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

### New loop

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

My best run:

```fish
# RSD: 0.123250
# Day: 31 (Mar 29)
pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=100.0 \
  --travel=16 \
  --halt_alert_days=46 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339
```

I saved this run upto alert day 21:

```fish
pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=100.0 \
  --travel=16 \
  --halt_alert_days=21 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339 --save=washoe21
```

### Varied contacts and travel

Then varied the travel and contacts parameters from that point:

```fish
pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=90.0 \
  --travel=14 \
  --halt_alert_days=84 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339 --load=washoe21 > cache/washoe/22-84_14_90.run
```

What these runs look like:

![Washoe Forecast](img/washoe_forecast.png)

## Phase one

On 2020-05-09,
Nevada entered phase 1 of relaxing restrictions imposed by the state of emergency which
included reopening restaurants.
Saving current trend upto phase 1:

```fish
pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=50.0 \
  --travel=10 \
  --halt_date=2020-05-09 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339 --load=washoe21 --save=washoe_phase_1
```

### Varied contacts, travel, and lethality

```fish
pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=100.0 \
  --travel=16 \
  --halt_alert_days=168 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339 \
  --load=washoe_phase_1 > cache/washoe/phase1_16_100.run
```

The three runs in pink:
what I think New York saw translated here(travel 250, contacts 133, lethality 0.0235),
what I initially fitted translated(travel 250, contacts 90, lethality 0.0235), and
the reviewed initial best fit(travel 16, contacts 100, lethality 0.0235).

As it looks as though phase 1 as yet to show any upward trend in Washoe county,
I've added a couple of runs where maybe new treatments have lowered lethality by a factor of 0.71.
Two two runs in cyan:
the reviewed initial best fit with less lethality(travel 16, contacts 100, lethality 0.0167), and
the previous trend but with less lethality(travel 10, contacts 50, lethality 0.0167).

![Washoe Phase One Forecast](img/washoe_forecast_phase1.png)

Note that this is based on an IFR of 0.39%,
which for the county's population means about 1841(`0.0039*472000`) lives at risk.

## Phase two

On 2020-05-29, Nevada entered phase 2 which included reopening bars.
Saving current trend upto phase 2:

```fish
pandemic --recovery=5.59 --lethality=0.0167 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=50.0 \
  --travel=10 \
  --halt_date=2020-05-29 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339 --load=washoe_phase_1 --save=washoe_phase_2
```

Run with travel and contacts 30% higher than current trend:

```fish
pandemic --recovery=5.59 --lethality=0.0167 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=65.0 \
  --travel=13 \
  --halt_alert_days=168 \
  --seed=45199385e37ae79b67e92134a9f1e076 --transmission=0.339 \
  --load=washoe_phase_2 > cache/washoe/phase2_13_65_167.run
```

![Washoe Phase Two Forecast](img/washoe_forecast_phase2.png)
