module Pandemic
  class InfectedDays
    attr_reader :days, :number, :deaths

    def initialize
      @days = @number = @deaths = 0
    end

    def days!
      @days += 1
    end

    def number!
      @number += 1
    end

    def deaths!
      @deaths += 1
    end
  end

  class RunningCount
    attr_reader :cases, :infected, :recovered, :deaths, :days, :max_deaths, :max_infected
    attr_reader :alert_days, :doubling_alert, :alerts
    attr_writer :alert_days, :doubling_alert
    attr_accessor :previous_deaths, :max_deaths, :max_infected
    attr_accessor :date, :color, :max_deaths_date, :max_infected_date

    def initialize
      @cases = @infected = @recovered = @deaths = @days = @max_deaths = @max_infected = 0
      @previous_deaths = @max_deaths = @max_infected = 0
      @alert_days, @doubling_alert, @alerts  =  -1, ALERT_DEATHS, []
    end

    def doubling_alert!
      @doubling_alert *= 2
    end

    def alert_days!
      @alert_days += 1
    end

    def infected!
      @cases += 1
      @infected += 1
    end

    def recovered!
      @infected -= 1
      @recovered += 1
    end

    def deaths!
      @infected -= 1
      @deaths += 1
    end

    def days!
      @days += 1
    end

    def tally_up(cases_hash)
      cases_hash.each_value do |status|
        @cases += 1
        case status
        when 'I'
          @infected += 1
        when 'D'
          @deaths += 1
        when 'R'
          @recovered += 1
        else
          raise "Unrecognizes status: #{status}"
        end
      end
      self
    end
  end
end
