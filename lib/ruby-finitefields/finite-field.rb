require 'prime'
require_relative 'field'
require_relative 'poly'

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
  end

  class GF < Field
    attr_reader :ord, :base, :exp, :generator

    def initialize(base = 2, exp = 8, generator = nil)
      raise ArgumentError, "generator must be poly of PrimeField(#{base})" unless PrimeField === generator.field && generator.field.ord == base
      raise ArgumentError, "degree of generator must be #{exp}" unless generator.deg == exp

      @base = base
      @exp  = exp
      @ord = base**exp
      @org_field = PrimeField.new( base )
      @poly = Poly.new( @org_field )
      @generator = generator
      @alpha = []
      @alpha << [@poly.zero]
      @alpha << [@poly.one]
      @alpha << [@poly.x]
      (@ord - 3).times do
        @alpha << @alpha[-1] * @poly.x
      end

      raise ArgumentError, "generator is not primitive" unless @alpha.uniq.size == @ord
    end

    def zero
      new(self, 0)
    end

    def one
      new(self, 1)
    end

    def x
      new(self, 2)
    end

    def add(x, y)
      check_same_class(x,y)
      new(self, @alpha.index( @alpha[x] + @alpha[y] ))
    end
    def mult(x, y)
      check_same_class(x,y)
      new(self, @alpha.index( @alpha[x] * @alpha[y] ))
    end

    def minus(x)
      new(self, @alpha.index( - @alpha[x] ))
    end
    def inv(x)
      super
      new(self, @alpha.index( @alpha[x].inv ))
    end

    def ==(o)
      GF === o && self.ord == o.ord && self.generator == o.generator
    end
  end
end
