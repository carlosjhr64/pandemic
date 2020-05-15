module Pandemic
  class ErrorAnalysis
    attr_reader :sum, :color
    def initialize
      @sum = @n = 0
      @sum2 = 0.0
      @color = nil
    end

    def n
      @n
    end

    def sum
      @sum
    end

    # Relative Standard Deviation
    def rsd
      return nil  if @n < 2
      Math.sqrt(@sum2/(@n-1))
    end

    def add(x0, x1)
      r =  Math.log(x1.to_f/x0.to_f).abs;  @sum2 += r*r
      max = Math.sqrt([x0, x1].max)
      e = x1 - x0;  @sum += e;  abs = e.abs
      if abs <= (GREEN*max).ceil
        @color = :green
      elsif abs <= (BLUE*max).ceil
        @color = :blue
      elsif abs >= (RED*max).ceil
        @color = :red
      else
        @color = :yellow
      end
      @n += 1
    end
  end
end
