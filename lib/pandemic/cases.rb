module Pandemic
  class Cases
    NAUGHT = "\u0000"

    def initialize(size)
      @string = NAUGHT*size
      @array  = []
    end

    def length
      @array.length
    end

    def capacity
      @string.length
    end

    def key?(index)
      @string[index] != NAUGHT
    end

    def [](index)
      ((_=@string[index])==NAUGHT)? nil : _
    end

    def each
      @array.each{|index| yield(index, @string[index])}
    end

    def each_value
      @array.each{|index| yield @string[index]}
    end

    def []=(index, status)
      @array.push(index)  if status == 'I'
      @string[index] = status
    end

    def populate_with(hash)
      hash.each{|index, status| self[index] = status}
      self
    end

    def close
      # TODO: when DBM
    end
  end
end
