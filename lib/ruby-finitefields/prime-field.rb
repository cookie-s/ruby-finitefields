require 'prime'
require_relative 'field'

module GF
  class PrimeField < Field
    attr_reader :ord

    def initialize(ord)
      raise ArgumentError, "#{ord} is not prime." unless Prime.prime? ord
      @ord = ord
    end

    def zero
      new(0)
    end

    def one
      new(1)
    end

    def add(x, y)
      super
      new((x.idx + y.idx) % @ord)
    end

    def mult(x, y)
      super
      new((x.idx * y.idx) % @ord)
    end

    def minus(x)
      new((@ord - x.idx) % @ord)
    end

    def inv(x)
      super
      # Fermat
      new(x.idx) ** (@ord-2)
    end

    def ==(o)
      PrimeField === o && self.ord == o.ord
    end

    def new(idx)
      super(idx % @ord)
    end

    def to_s
      inspect
    end

    def inspect
      "GF(#{ord})"
    end
  end
end
