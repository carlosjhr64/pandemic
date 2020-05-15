module Pandemic
  class Trace
    attr_reader :analysis, :halt, :iterator
    def initialize(halt: HALT)
      # Properties
      @halt = halt
      # Loop variables
      @tally = @analysis = nil
    end

    def to_s
      <<-TRACE
# Trace
    Halt: {#{@halt.map{|k,v|"#{k}: #{v || '-'}"}.join(', ')}}
      TRACE
    end

    def statistics?
      @tally.deaths >= MIN_DEATHS_RUN or @tally.alert_days >= MIN_ALERT_DAYS_RUN
    end

    def continue?
      return false  if $INTERUPTED
      return false  if @halt.any? do |key, target|
        target and case key
        when :rsd
          statistics? and rsd=@analysis.rsd and rsd >= target
        when :color
          @tally.color == target
        else
          value=@tally.method(key).call and value >= target
        end
      end
      true
    end

    def trace
      row = [
        @tally.days, @tally.deaths, @tally.cases, @tally.recovered, @tally.infected,
        @analysis.sum, @analysis.rsd || 0.0,
        (@tally.date)? @tally.date.strftime('%Y-%b-%d') : '-' ]
      if $stdout.tty?
        line = sprintf("Day: %d  Dead: %d  Cases: %d  Recovered: %d  Infected: %d  ErrorSum: %d  RSD: %f  Date: %s", *row)
        puts line.colorize(@analysis.color)
      else
        puts row.join(' '); $stdout.flush
      end
    end

    def append_alert
      alerts = @tally.alerts
      alerts.push([@tally.date, @tally.deaths])
      if alerts.length > 1
        a2,a1  =  alerts[-2],alerts[-1]
        if a2[1] < a1[1]
          interval_days = (a1[0] - a2[0]).to_i
          growth_factor = a1[1]/a2[1].to_f
          doubling_days = interval_days*Math.log(2)/Math.log(growth_factor)
          alerts.last.push(doubling_days)
          puts "Doubling Days: #{doubling_days.round(1)}".colorize(:cyan)  if $stdout.tty?
        end
      end
    end

    def tallies
      deaths = @tally.deaths - @tally.previous_deaths
      @tally.previous_deaths = @tally.deaths
      if @tally.deaths >= ALERT_DEATHS
        @tally.alert_days!
        @tally.date = ALERT_DATE + @tally.alert_days
        if @tally.deaths >= @tally.doubling_alert
          @tally.doubling_alert! # next alert
          append_alert
        end
        if actual = DEATHS_DATA[@tally.alert_days]
          @analysis.add(actual, @tally.deaths)
        end
      end
      if deaths > @tally.max_deaths
        @tally.max_deaths = deaths
        @tally.max_deaths_date = @tally.date
      end
      if @tally.infected > @tally.max_infected
        @tally.max_infected = @tally.infected
        @tally.max_infected_date = @tally.date
      end
    end

    def reset(tally, analysis=ErrorAnalysis.new)
      @tally, @analysis  =  tally, analysis
      unless $stdout.tty?
        puts '# Day, Dead, Cases, Recovered, Infected, Sum Of Errors, RSD, Date'
      end
    end

    def run
      tallies
      trace
      continue?
    end
  end
end
