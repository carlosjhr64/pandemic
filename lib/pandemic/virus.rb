module Pandemic
  class Virus
    attr_accessor :transmission, :recovery, :lethality
    def initialize(transmission: TRANSMISSION, recovery: RECOVERY, lethality: LETHALITY)
      ### Virus Model ###
      # These are the modelling variation parameters.
      @transmission = transmission   # chance of transmission per contact
      @recovery     = recovery       # chance of infected recovery per cycle
      @lethality    = lethality      # chance of infected death per cycle
    end

    def trials_tally(trials=TRIALS, tally=InfectedDays.new, seeds: SEEDS)
      $stderr.puts "Emergent properties trials(may take some time)...."
      seeds.each do |seed|
        rng = Random.new seed.to_i(16)
        trials.times do
          tally.number!
          infected = true
          while infected
            tally.days!
            if rng.rand < @recovery
              infected = false
            elsif rng.rand < @lethality
              infected = false
              tally.deaths!
            end
          end
        end
      end
      tally
    end

    def trials(contacts=100.0)
      tally = trials_tally
      fatality_rate = (100*tally.deaths)/tally.number.to_f
      recovery_days = tally.days/tally.number.to_f
      r0 = recovery_days*@transmission*contacts
      sprintf <<-TRIALS, fatality_rate, recovery_days, r0
# Virus Trials
    Fatality Rate:       %.2f\%
    Infectuous Days:     %.1f
    Reproduction Number: %.2f
      TRIALS
    end

    def to_s
      sprintf <<-VIRUS, 100*@transmission, 100*@recovery, 100*@lethality
# Virus
    Transmission: %.3f
    Recovery:     %.2f
    Lethality:    %.4f
      VIRUS
    end
  end
end
