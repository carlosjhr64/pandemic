module Pandemic
  class Loop
    attr_reader :trace, :iterator
    attr_accessor :looping, :description
    def initialize(trace: Trace.new, iterator: Iterator.new, looping: LOOP, description: DESCRIPTION)
      @trace, @iterator, @looping, @description = trace, iterator, looping, description
    end

    def to_s
      <<-LOOP.chomp
# Loop
    Looping:     #{@looping || '-'}
    Description: #{@description || '-'}

#{@trace}
#{@iterator}
      LOOP
    end

    def report(out=$stdout)
      tally = @iterator.tally
      out.puts <<-CONFIG
# Configuration
  File:         #{DEATHS_FILE}
  Alert Deaths: #{ALERT_DEATHS}
  Alert Date:   #{ALERT_DATE}

      CONFIG
      out.puts self.to_s
      out.puts
      out.puts '# Doubling'
      if tally.alerts.length > 1
        out.puts '| Date | Deaths | Doubling Days |'
        out.puts '| :--- | -----: | ------------: |'
        tally.alerts.each do |date, deaths, doubling_days|
          out.print "| #{date.strftime('%b %d')} | #{deaths} "
          if doubling_days
            out.puts "| #{doubling_days.round(1)} |"
          else
            out.puts '| - |'
          end
        end
        out.puts
      end
      p,c,i,r,d = @iterator.grid.population,tally.cases,tally.infected,tally.recovered,tally.deaths
      md,mi = tally.max_deaths,tally.max_infected
      mdd,mid = tally.max_deaths_date,tally.max_infected_date
      mdd = (mdd)? mdd.strftime('%b %d') : '-'
      mid = (mid)? mid.strftime('%b %d') : '-'
      date = (_=tally.date)? _.strftime('%b %d') : '-'
      q = Math.log(p+1)
      f = lambda{|a|360*Math.log(a+1)/q}
      e = @trace.analysis
      out.printf <<-REPORT, date, c,f[c], i,f[i], r,f[r], d,f[d], mdd,md,f[md], mid,mi,f[mi]
# Tallies(%s)
    Cases:     %d, %.0f°
    Infected:  %d, %.0f°
    Recovered: %d, %.0f°
    Deaths:    %d, %.0f°

# Daily Peaks
    Deaths(%s):     %d, %.0f°
    Infections(%s): %d, %.0f°

      REPORT
      if @trace.statistics?
        out.printf <<-ERRORS, e.n, e.sum, e.rsd
# Errors
    N:   %d
    Sum: %d
    RSD: %.6f

        ERRORS
      end
      # TODO:
      #   if @mitigation
      #     out.puts <<-MITIGATION
      # # Mitigation
      #   * Date:     #{@mitigation_date}
      #   * Contacts: #{@mitigation}
      #     MITIGATION
      #   end
    end

    def cache_report
      fn = "cache/#{@description}-#{@looping}-#{$$}.rpt"
      File.open(fn, 'w'){|_| report _}
    end

    def save
      dir = "cache/#{@description}"
      Dir.mkdir dir
      File.open("#{dir}/cases", 'w'){|_|Marshal.dump @iterator.cases, _}
      File.open("#{dir}/tally", 'w'){|_|Marshal.dump @iterator.tally, _}
      File.open("#{dir}/rng", 'w'){|_|Marshal.dump @iterator.rng, _}
      File.open("#{dir}/analysis", 'w'){|_|Marshal.dump @trace.analysis, _}
    end

    DEFAULT_CASES = {0 => 'I'}.freeze
    def setup
      cases = tally = analysis = rng = nil
      if OPTIONS.load?
        dir      = "cache/#{@description}"
        File.open("#{dir}/rng", 'r'){|_|rng = Marshal.load _}
        unless SEED == (_=rng.seed.to_s(16))
          $stderr.puts "Seed for #{description} is #{_}"; exit 65
        end
        File.open("#{dir}/tally", 'r'){|_|tally = Marshal.load _}
        unless ALERT_DATE == (_=tally.date-tally.alert_days)
          $stderr.puts "Alert Date for #{description} is #{_}"; exit 65
        end
        File.open("#{dir}/cases", 'r'){|_|cases = Marshal.load _}
        unless @iterator.grid.population == (_=cases.capacity)
          $stderr.puts "Population for #{@description} is #{_}."; exit 65
        end
        File.open("#{dir}/analysis", 'r'){|_|analysis = Marshal.load _}
      else
        cases    = Cases.new(@iterator.grid.population).populate_with(DEFAULT_CASES)
        tally    = RunningCount.new.tally_up(cases)
        analysis = ErrorAnalysis.new
        #rng     = nil
      end
      begin
        yield cases, tally, analysis, rng
      rescue
        $stderr.puts $!
        $stderr.puts $!.backtrace
        exit 1
      ensure
        cases.close
      end
    end

    def run
      @rsd, count  =  HALT_RSD, 0
      loop do
        GC.start
        count += 1
        $stderr.puts "### COUNT: #{count} ###".colorize(:yellow)
        setup do |cases, tally, analysis, rng|
          start_time = Time.now
          @trace.reset(tally, analysis)
          @iterator.run(cases, tally, rng){ @trace.run }
          $stderr.puts "### ELAPSED: #{Time.now - start_time} ####".colorize(:yellow)
          report
          if @looping
            unless $INTERUPTED
              cache_report  if @trace.statistics? and better!
              variation
            end
          else
            save  if OPTIONS.save?
          end
        end
        break if $INTERUPTED
        break unless @looping
      end
    end

    def reseeding
      # Here I'm xor'ing three "random" seeds, because why not?  :))
      @iterator.seed = (SEEDS[rand(SEEDS.length)].to_i(16) ^ SEED.to_i(16) ^ Random.new_seed)
    end

    def variation
      case @looping
      when 'transmission'
        @iterator.virus.transmission += (@trace.analysis.sum > 0)? -DELTA : DELTA
        reseeding
      when 'travel'
        @iterator.behavior.travel -= 1 # Just assume we started high, and blindly go down to 1.
        $INTERUPTED = true unless @iterator.behavior.travel > 0
      else
        # TODO: this should be caught earlier
        raise "Unrecognize/Unimplemented variation parameter: #{@looping}"
      end
    end

    def better!
      if (s=@trace.analysis.rsd) < @rsd
        @rsd = s
        $stderr.puts "### NEW BEST RSD: #{@rsd} ###".colorize(:yellow)
        return true
      end
      false
    end
  end
end
