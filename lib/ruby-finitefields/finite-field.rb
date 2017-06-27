require 'prime'
require_relative 'field'
require_relative 'prime-field'
require_relative 'poly'

module GF
  class GF < Field
    attr_reader :ord, :base, :exp, :generator

    def initialize(base = 2, exp = 8, generator = nil)
      # TODO delete
      generator = generator || Poly.new( PrimeField.new(2) ).new( [1,1,1,0,1,1,0,1,1].map{|x| x==0 ? PrimeField.new(2).zero : PrimeField.new(2).one} )

      raise ArgumentError, "generator must be poly of PrimeField(#{base})" unless PrimeField === generator.poly.field && generator.poly.field.ord == base
      raise ArgumentError, "degree of generator must be #{exp}" unless generator.deg == exp

      @base = base
      @exp  = exp
      @ord = base**exp
      @org_field = PrimeField.new( base )
      @poly = Poly.new( @org_field )
      @generator = generator
      @alpha = []
      @alpha << @poly.zero
      @alpha << @poly.one
      @alpha << @poly.x.mod( @generator )
      (@ord - 3).times do
        @alpha << (@alpha[-1] * @poly.x).mod( @generator )
      end

      # TODO uniq checker doesn't work
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
      new(@alpha.index( (@alpha[x.idx] + @alpha[y.idx]).mod(@generator) ))
    end
    def mult(x, y)
      check_same_class(x,y)
      new(@alpha.index( (@alpha[x.idx] * @alpha[y.idx]).mod(@generator) ))
    end

    def minus(x)
      new(@alpha.index( - @alpha[x.idx] ))
    end

    def inv(x)
      raise ZeroDivisionError if x == self.zero
      new(((@ord-1) - (x.idx-1)) % (@ord-1) + 1)
    end

    def ==(o)
      GF === o && self.ord == o.ord && self.generator == o.generator
    end

    def new(idx)
      super(idx % @ord)
    end

    def from_poly(poly)
      # TODO test
      # TODO
      new @alpha.index( @poly.new( poly.to_s(@base).reverse.chars.map{|c| c.to_i(@base)}.map{|idx| @org_field.new(idx)} ) )
    end

    def to_poly(idx)
      # TODO test
      # TODO
      @alpha[idx]
    end

    def to_s
      inspect
    end

    def inspect
      "GF(#{ord})"
    end
  end
end
