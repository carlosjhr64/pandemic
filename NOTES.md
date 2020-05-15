# Notes

Looping runs will save a report of any improved run in `./cache`.

Loop for Washoe county:

```fish
nice --adjustment=19 pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_washoe \
  --alert_deaths=1 --alert_date=2020-03-29 \
  --population=472000 --contacts=100.0 \
  --travel=250 \
  --halt_alert_days=21 --halt_rsd=1.0 \
  --description=washoe --loop=transmission \
  --seed=(superrandom) --transmission=0.335
```

Loop for Hubei, China:

```fish
nice --adjustment=19 pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_china \
  --alert_deaths=1 --alert_date=2020-01-09 \
  --population=58500000 --contacts=100.0 \
  --travel=1664 \
  --halt_alert_days=21 --halt_rsd=1.0 \
  --description=ch --loop=transmission \
  --seed=(superrandom) --transmission=0.335
```

Loop for Sweden:

```fish
nice --adjustment=19 pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_sweden \
  --alert_deaths=1 --alert_date=2020-03-11 \
  --population=10099265 --contacts=100.0 \
  --travel=105 \
  --halt_alert_days=21 --halt_rsd=1.0 \
  --description=sw --loop=transmission \
  --seed=(superrandom) --transmission=0.335
```

Loop for Italy;

```fish
nice --adjustment=19 pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_italy \
  --alert_deaths=1 --alert_date=2020-02-21 \
  --population=60036000 --contacts=100.0 \
  --travel=173 \
  --halt_alert_days=21 --halt_rsd=1.0 \
  --description=it --loop=transmission \
  --seed=(superrandom) --transmission=0.335
```

Loop for New York:

```fish
nice --adjustment=19 pandemic --recovery=5.59 --lethality=0.0235 \
  --file_deaths=data/deaths_new_york \
  --alert_deaths=1 --alert_date=2020-03-14 \
  --population=19450000 --contacts=100.0 \
  --travel=1458 \
  --halt_alert_days=21 --halt_rsd=1.0 \
  --description=ny --loop=transmission \
  --seed=(superrandom) --transmission=0.335
```
