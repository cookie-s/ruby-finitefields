require 'prime'
require_relative 'field'
require_relative 'prime-field'
require_relative 'poly'

module GF
  class GF < Field
    attr_reader :ord, :base, :exp, :generator

    def initialize(base = 2, exp = 8, generator = nil)
      raise ArgumentError, "generator must be poly of PrimeField(#{base})" unless PrimeField === generator.poly.field && generator.poly.field.ord == base
      raise ArgumentError, "degree of generator must be #{exp+1}" unless generator.deg == exp+1

      @base = base
      @exp  = exp
      @ord = base**exp
      @org_field = PrimeField.new( base )
      @poly = Poly.new( @org_field )
      @generator = generator
      @alpha = []
      @alpha << @poly.zero
      @alpha << @poly.one
      @alpha << @poly.x
      (@ord - 3).times do
        @alpha << (@alpha[-1] * @poly.x)
      end

      raise ArgumentError, "generator is not primitive" unless @alpha.uniq.size == @ord
    end

    def zero
      new(0)
    end

    def one
      new(1)
    end

    def x
      new(2)
    end

    def add(x, y)
      check_same_class(x,y)
      p @alpha[x.idx] + @alpha[y.idx]
      new(@alpha.index( @alpha[x.idx] + @alpha[y.idx] ))
    end
    def mult(x, y)
      check_same_class(x,y)
      new(@alpha.index( @alpha[x.idx] * @alpha[y.idx] ))
    end

    def minus(x)
      new(@alpha.index( - @alpha[x.idx] ))
    end
    def inv(x)
      super
      new(@alpha.index( @alpha[x.idx].inv ))
    end

    def ==(o)
      GF === o && self.ord == o.ord && self.generator == o.generator
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
