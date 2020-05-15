module Pandemic
  class Grid
    attr_reader :width
    def initialize(population: POPULATION)
      ### POPULATION GRID ###
      # Approximately fit population in a square grid
      @width = Math.sqrt(population).round
    end

    def population
      @width*@width
    end

    def key(x, y, w=@width)
      (x % w)*w + (y % w)
    end

    def xy(p, w=@width)
      return p.divmod(w)
    end

    def deltas(p1, p2, w=@width)
      x1,y1 = xy(p1, w)
      x2,y2 = xy(p2, w)
      dx = x2 - x1
      dy = y2 - y1
      return [dx % w, -dx % w].min, [dy % w, -dy % w].min
    end

    def near?(p1, p2, q, w=@width)
      dx,dy = deltas(p1, p2, w)
      dx <= q  and  dy <= q
    end

    def to_s
      sprintf <<-GRID, population, @width
# Grid
    Population: %d
    Width:      %d
      GRID
    end
  end
end
