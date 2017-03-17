require 'prime'

class Field
  class Element
    attr_reader :idx, :field

    def initialize(field, idx)
      raise ArgumentError, "#{field} is not field." unless Field === field

      @field = field
      @idx = idx
    end

    def inspect
      "#<Field::Element: field=#{@field.inspect}, idx=#{@idx}>"
    end

    def ==(o)
      self.field == o.field && self.idx == o.idx
    end

    def -@(x)
      @field.minus(x)
    end

    def +(x)
      @field.add(self, x)
    end

    def -(x)
      @field.add(self, @field.minus(x))
    end

    def *(x)
      @field.mult(self, x)
    end

    def /(x)
      @field.mult(self, @field.inv(x))
    end

    def inv
      @field.inv(self)
    end

    def **(n)
      res = @field.one
      while n > 0
        res *= x if n.odd?
        x*=x
        n/=2
      end
      res
    end
  end

  def ord
  end

  def zero
  end
  def one
  end

  def add(x, y)
    check_same_class(x,y)
  end
  def mult(x, y)
    check_same_class(x,y)
  end

  def minus(x)
  end
  def inv(x)
    raise ZeroDivisionError if x === zero
  end

  def new(idx)
    Element.new(self, idx)
  end

  def ==(o)
  end

  private
  def check_same_class(x, y)
    raise ArgumentError, "fields are not same" unless x.field === y.field
  end
end

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
    new(x.idx) ** (@ord-1)
  end
end

class Poly
  class Element
    attr_reader :field, :coeff, :deg

    def initialize( field, coeff )
      nonzero_coeff_pos = coeff.each_with_index.reject{|x, i| x == @field.zero}.map{|x, i| i}
      @deg = nonzero_coeff_pos.size == 0 ? -1 : nonzero_coeff_pos.max
      @field = field
      @coeff = coeff[0,deg+1]
    end

    def to_s
      @coeff.each_with_index.map{|x, i| x.to_s + ('x'*i)}.join("+")
    end

    def inspect
      "#<Poly::Element: field: #{@field.inspect}, coeff: #{@coeff.inspect}>"
    end
  end

  def initialize( field )
    @field = field
  end

  def new( coeff )
    Element.new(@field, coeff[0,deg+1])
  end

  def zero
    new(@field, [])
  end

  def one
    new(@field, [@field.one])
  end

  def x
    new(@field, [@field.zero, @field.one])
  end

  def add(x, y)
    check_same_class(x, y)
    deg = [x.deg, y.deg].max

    res = new(@field, [@field.zero]*(deg+1))
    res = new(@field, res.coeff.zip( x.coeff ).map{|xc, yc| xc + yc})
    res = new(@field, res.coeff.zip( y.coeff ).map{|xc, yc| xc + yc})
  end

  def mult(x, y)
    check_same_class(x, y)
    deg = [x.deg, y.deg].any?{|d| d == -1} ? -1 : x.deg * y.deg

    coeff = [@field.zero]*(deg+1)
    (0..x.deg).each do |xi|
      (0..y.deg).each do |yi|
        coeff[xi+yi] += (x.coeff[xi])*(y.coeff[yi])
      end
    end
    new(@field, coeff)
  end

  private
  def check_same_class
    raise ArgumentError, "fields are not same." unless x.field == y.field
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
