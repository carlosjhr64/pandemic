module Pandemic
  class Iterator
    attr_reader :virus, :grid, :behavior
    attr_accessor :seed
    attr_reader :cases, :tally, :rng
    def initialize(virus: Virus.new, grid: Grid.new, behavior: Behavior.new, seed: SEED)
      @virus    = virus
      @grid     = grid
      @behavior = behavior
      @seed     = (seed=='0')?  Random.new_seed : seed.to_i(16)
      # Loop variables:
      @tally = @rng = @updates = @cases = nil
    end

    def to_s
      <<-ITERATOR.chomp
# Iterator
    Seed: #{@seed.to_s(16)}

#{@virus}
#{@grid}
#{@behavior}
      ITERATOR
    end

    def transmitted(x, y)
      t = @behavior.travel
      a = x + @rng.rand(t) - @rng.rand(t)
      b = y + @rng.rand(t) - @rng.rand(t)
      ab = @grid.key(a,b)
      unless @updates.key?(ab) or @cases.key?(ab)  # if not a case yet
        @tally.infected!
        @updates[ab] = 'I'  # new infection
      end
    end

    # I'm reframing contact transmisson as a Poisson Process.
    # The expected number of succesful transmissions(per day here):
    #   r = @behavior.contacts*@virus.transmission
    # The probability  of one transmission:
    #   p
    # Then:
    #   r = p + p*p + p*p*p + ...
    # Remember that:
    #   1 + p + p*p + p*p*p + ... = 1/(1-p)
    # So:
    #   1 + r = 1/(1-p)
    #   (1+r)*(1-p) = 1
    #   1 - p = 1/(1+r)
    #   p = 1 - 1/(1+r)
    def contacting(xy)
      x,y = @grid.xy(xy)
      p = 1 - 1/(1 + @behavior.contacts*@virus.transmission)
      while @rng.rand < p
        transmitted(x, y)
      end
    end

    def infected_run(xy)
      if @rng.rand < @virus.recovery
        @tally.recovered!
        @updates[xy] = 'R'  # recovered
      elsif @rng.rand < @virus.lethality
        @tally.deaths!
        @updates[xy] = 'D'  # dead
      else
        contacting(xy)
      end
    end

    def run(cases, tally, rng=nil, seed: @seed)
      @cases, @tally  =  cases, tally
      @rng = rng || Random.new(seed)
      @updates = {} # new cases and updates
      loop do
        @updates.clear
        @tally.days!
        @cases.each do |xy, status|
          infected_run(xy)  if status == 'I'
        end
        @updates.each{|xy, status| @cases[xy] = status}
        break unless yield
        break if @tally.infected < 1
      end
    end
  end
end
