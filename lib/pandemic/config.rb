module Pandemic
  VERSION = '2.34.200518'
  OPTIONS ||= HelpParser[VERSION, <<-HELP]
Usage:

  #{File.basename $PROGRAM_NAME} [:options+]

Options:

  --file_deaths=FILE    \tData
  --seed=HEXADECIMAL    \tRandom
  --population=INTEGER  \tGrid

  --transmission=FLOAT  \tVirus
  --recovery=FLOAT
  --lethality=FLOAT

  --travel=INTEGER      \tBehavior
  --contacts=FLOAT

  --halt_days=INTEGER   \tHalting
  --halt_deaths=INTEGER
  --halt_cases=INTEGER
  --halt_date=DATE
  --halt_color=COLOR
  --halt_alert_days=INTEGER
  --halt_rsd=FLOAT

  --alert_deaths=INTEGER\tAlert
  --alert_date=DATE

  --loop                \tLooping
  --description=DESCRIPTION
  --delta=DELTA

  -i --inspect          \tInspection
  -t --trials

  --save=DESCRIPTION    \tSave run
  --load=DESCRIPTION    \tLoad run

Types:

  FILE        /^(\\/?\\w[.\\-\\w]*\\w)+$/
  HEXADECIMAL /^\\h+$/
  FLOAT       /^\\d+\\.\\d+$/
  DELTA       /^0\\.\\d+$/
  DATE        /^\\d\\d\\d\\d-\\d\\d-\\d\\d$/
  INTEGER     /^((\\d{1,3}(_\\d{3})+)|(\\d+))$/
  COLOR       /^[a-z]+$/
  DESCRIPTION /^\\w+$/

Exclusive:

  loop save
  HELP
  HelpParser.int?   :population, :travel, :alert_deaths
  HelpParser.int?   :halt_days, :halt_deaths, :halt_cases, :halt_alert_days
  HelpParser.float? :transmission, :recovery, :lethality, :contacts, :delta, :halt_rsd

  # Cache
  DESCRIPTION  = OPTIONS.description || 'run'
  if SAVE=OPTIONS.save and File.exist? "cache/#{SAVE}"
    $stderr.puts "cache/#{SAVE} exist."
    exit 64
  end
  if LOAD=OPTIONS.load and not File.exist? "cache/#{LOAD}"
    $stderr.puts "cache/#{LOAD} does not exist."
    exit 64
  end

  # Data
  DEATHS_FILE  = OPTIONS.file_deaths || 'data/deaths_china'
  DEATHS_DATA  = File.readlines(DEATHS_FILE).select{|_|!_.match /^#/}.map{|_|_.split.first.to_i}

  # Population
  POPULATION   = OPTIONS.population?    || 58_500_000 # Hubei's population(default)

  # Virus
  TRANSMISSION = (OPTIONS.transmission? || 0.36000)/100.0   # chance of transmission per contact
  RECOVERY     = (OPTIONS.recovery?     || 5.59000)/100.0   # chance of infected recovery per cycle
  LETHALITY    = (OPTIONS.lethality?    || 0.02350)/100.0   # chance of infected death per cycle (if not recovered)
  TRIALS       = 25_000

  # Behavior
  CONTACTS     = OPTIONS.contacts?      || 100.0
  TRAVEL       = OPTIONS.travel?        || 1664

  # Halting
  HALT = {}
  HALT[:date]   = (_=OPTIONS.halt_date)? Date.parse(_) : nil
  HALT[:days]   = OPTIONS.halt_days?
  HALT[:deaths] = OPTIONS.halt_deaths?
  HALT[:cases]  = OPTIONS.halt_cases?
  HALT[:color]  = (_=OPTIONS.halt_color)? _.to_sym : nil
  HALT[:alert_days] = OPTIONS.halt_alert_days?
  HALT[:rsd]    = OPTIONS.halt_rsd?

  # Alert
  ALERT_DEATHS = OPTIONS.alert_deaths?  || 1
  ALERT_DATE   = Date.parse(OPTIONS.alert_date || '2020-01-09')

  # Loop
  LOOP         = OPTIONS.loop
  DELTA        = OPTIONS.delta? || 1.0e-05

  # Loop, minimum tally.deaths and tally.alert_days for statistics
  MIN_DEATHS_RUN     = 25
  MIN_ALERT_DAYS_RUN = 25
  HALT_RSD           = OPTIONS.halt_rsd? || 1.0

  # Color thresholds
  GREEN        = 1
  BLUE         = 3
  RED          = 9

  # Random
  SEED         = OPTIONS.seed || '983dad045d8b266615b1794d34d7f7e1'
  SEEDS        = ['1c4e02a0c9bb938d73c7fd87e277abd4', #  1
                  '9f092754bebd7d2c3daf60322b1ea690', #  2
                  '7b230a957b6d6ecb742111f66959851e', #  3
                  '93405523c266ff9408d37719e9f6371c', #  4
                  '6e150539304ba52681aa9888de4e2e25', #  5
                  '193975d640e4242174be326245430806', #  6
                  '971ea0ea340bad6909a1dbc016f8ad89', #  7
                  '991dcb3cf001e333e71c5076945206be', #  8
                  'b417c424c993da25a4f27e8d9cc161ba', #  9
                  'eb0ee77d331c013309f6f8b5dc9fcbad', # 10
                  '0716a407f0ff95ce39c49c0a20a2e36b', # 11
                  'c118527a399ba2ab675a51377cae5053', # 12
                  'fcd872bdbff87ad6aed2819c35b23916', # 13
                  'e4a60e99f34337679d886b98d54259d7', # 14
                  '8d699dcd8ff06c0e0cbe6e068e133c55', # 15
                  '8af78a49399884e3155d472f1ff1b797', # 16
                  'c48873febc3cd8f6762b10a29b2785c3', # 17
                  '2c112e2f92e80707be9b0f474a7403b5', # 18
                  'b94f013ce5da8ad9efd7f2c2a59b77f3', # 19
                  '997a3f070f7f0630d9c0548e5778ba7a', # 20
                  '1aaf7631e8ad6dbdffc65f8b0ad9f0c5', # 21
                  '53471034b9b7cface5457eb5f4d3b8f2', # 22
                  'a325b2e0e832cc368cfb93a2c3410bbf', # 23
                  '1cad95c0b45c746497379f7d7671b41f', # 24
                  'cbbbecfd771f1cfdfea47c2943693327', # 25
                  '0b581233d843850e1ad06f92ba5b0b08', # 26
                  'cdacc4803d6cd0368b5adeccd208aab4', # 27
                  'a427ba72cba036d39e68e74928e1c55b', # 28
                  '39315a36b99def205f274868132d2813', # 29
                  '5ddf4db18d171ceb8ec232611f3293ba', # 30
                  '63b46082c34bafb7ae0cb6219f32f0aa', # 31
                  'af797e90d1bfb2f891c85083c162c6da', # 32
                  '3860e4161bce4713b7c933cdb2c5dabb', # 33
                  '6be951bbdc9e14fa76910d04c1c88eab', # 34
                  'e9dd6a78486b0e4999ff0299211a503c', # 35
                  '72cfd62abe30602d3a378fab02d67b22', # 36
                  '5f6c2254891d47b9388254ab2b122182', # 37
                  'd34f0e12e6c75fd5a5a817909001f1a8', # 38
                  '25ef64bc4aa5bc7a891e4ed6a0013a5f', # 39
                  '07d50c6a4a4cc12886cef596cf6683ef', # 40
                  '3fb35693c3ff585c87cc1cc352e8efd7', # 41
                  'bfb5ff91e8a018d53470dc89df91d143', # 42
                  '50ed67c6078c7e8bcccc00691ee7ec95', # 43
                  '6511ca3bdd512e04f2ebfbaea9e15238', # 44
                  '02de9ac730a1de6b6c47d8a100b9a6d4', # 45
                  'db84c07c992e4a92fb10b6edd40ce01d', # 46
                  '8de2a73cb017065329e79f2c283bd20a', # 47
                  'dae26ffc816be992db42c4e5fd5db9e3', # 48
                  'dcc1c2cc2f09c1bbaf44ce1af692146e', # 49
                  '02139a117d39e3f33d9b8179df62ba38', # 50
                  'd3de372054f14fce2485b5a5f5d2dfc5', # 51
                  '438405f6ce9da2bdc6404503aa71310e', # 52
                  '063c3681b348655a611cfd3e8c4c3541', # 53
                  '278fe91394ea5bd85cf30a957ebfc920', # 54
                  '58c3e2317600be88828d4767ae4b3de4', # 55
                  'a77cc58d33b41a073bb9a8b7bc6c766f', # 56
                  '6e4ddadfbb0e3ca97ba9c5a354947613', # 57
                  '86d78a9d77ea6b7771d37558e1206ac9', # 58
                  '61868cc49e25f7e4aa61ba9f2a2a5a6a', # 59
                  '209df1b2a1a5004717cd4b5998a83db5', # 60
                  '5e2a2abc9d5428882e24bef8d801fe5e', # 61
                  'd4630b0043be22d6ce51b70e61810aa0', # 62
                  '259efb38cd0cbfee08ceb752b6f6a992', # 63
                  'b0cb4c237b679bfcd85131c7eec3e29d', # 64
                  '29619384a8642601253a4aea7368a12f', # 65
                  'cd510705ea8db26d6ed5521f24ac148f', # 66
                  '7639430c1860fc66bd378577e15f7d74', # 67
                  '4371c829009950f7440e9eaaec912da1', # 68
                  '4cf2844aaf95ee8eb4ad8d958f0c4d33', # 69
                  'c69a38931caf131f96072bc525e5192e', # 70
                  'e9badd984ac7ed97cbea984b75675991', # 71
                  'a233eb7b762c5f732ebea425eef0ba40', # 72
                  '227004ba924961f7754425a11de79864', # 73
                  '26c5de78e4c4b1d0686d26218012797e', # 74
                  '3677dce50af1c6cc63f13596f506b7cb', # 75
                  'c96b36bd1c83371e2fe9e019ad8d0b92', # 76
                  '5023e85e95f498c06df59391406ec7e4', # 77
                  'c2328451414d4c8d75495247d5381317', # 78
                  '6aa7d3e98adf5e4cafadb2f55cb74d42', # 79
                  '37518ad1a235351cee9ca0568da93f4f', # 80
                  '2b5f63d2a0f21f9e5d85709452f08bf1', # 81
                  '676277553b6badbc7d08c7c8dca44b70', # 82
                  '03e0221eb230f68290f4a575f404bc43', # 83
                  'b2daebc0275cc7016cae014dbe08c533', # 84
                  'eab660e65e3c99b60dac61abd6d3cadb', # 85
                  'fa95bc26d3847be4319e35bf0433f1ca', # 86
                  'ca58326ec0d3be6d127e90b33fd70627', # 87
                  'bb407cfc22fb6a1c2cd1c8ea9719b174', # 88
                  '22a48176f1f7182be3066f08279c0591', # 89
                  'a648c554921bd86aa8d1e313f3e0d44f', # 90
                  'aa244a22c345b0fc890c53fdd221a381', # 91
                  'f9a0fd576cee9366253670816aac64a5', # 92
                  'fa71dc0fbd37b3525c202af27f5349f2', # 93
                  'c5f475c372aa6943eee37fdd9ebe8286', # 94
                  '87ad58635994f7b6df1a5041671f34b8', # 95
                  '37a6bb04dbd1f26d7c476fcceb3c2b2e', # 96
                  'bb0a259c009cf4d67eff7a876d6517d5', # 97
                  '3318badfdc72e2eb4ed9827acd652982', # 98
                  '5b74b78be0f9c0622c35c8ae59aba8ef', # 99
                  '6d5d0b9d509e257d2da1e1026b6aa0ce'] # 100

  $INTERUPTED = false
end
