require_relative 'field'

module GF
  class RationalField < Field
    def ord
      Float::INFINITY
    end

    def zero
      new(Rational(0, 1))
    end

    def one
      new(Rational(1, 1))
    end

    def add(x, y)
      super
      new(x.idx + y.idx)
    end

    def mult(x, y)
      super
      new(x.idx * y.idx)
    end

    def minus(x)
      new( -x.idx )
    end

    def inv(x)
      super
      new(1 / x.idx)
    end

    def ==(o)
      RationalField === o
    end
  end
end
