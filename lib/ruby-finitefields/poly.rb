module GF
  class Poly
    class Element
      attr_reader :poly, :coeff, :deg

      def initialize( poly, coeff )
        nonzero_coeff_pos = coeff.each_with_index.reject{|x, i| x == poly.field.zero}.map{|x, i| i}
        @deg = nonzero_coeff_pos.size == 0 ? -1 : nonzero_coeff_pos.max
        @poly = poly
        @coeff = coeff[0,deg+1]
      end

      def to_s
        @coeff.each_with_index.map{|x, i| x.to_s + ('x'*i)}.join("+")
      end

      def inspect
        "#<Poly::Element: poly: #{@poly.inspect}, coeff: #{@coeff.inspect}>"
      end

      def ==(o)
        self.poly == o.poly && self.coeff == o.coeff
      end

      def +(o)
        @poly.add(self, o)
      end

      def -(o)
        @poly.add(self, @poly.minus(o))
      end

      def **(n)
        x = self
        res = @poly.one
        while n > 0
          res *= x if n.odd?
          x*=x
          n/=2
        end
        res
      end
    end

    attr_reader :field

    def initialize( field )
      @field = field
    end

    def new( coeff )
      Element.new(self, coeff)
    end

    def zero
      new([])
    end

    def one
      new([@field.one])
    end

    def x
      new([@field.zero, @field.one])
    end

    def add(x, y)
      check_same_class(x, y)
      deg = [x.deg, y.deg].max

      coeff = [@field.zero]*(deg+1)
      coeff = coeff.zip( x.coeff ).map{|xc, yc| xc + (yc || @field.zero)}
      coeff = coeff.zip( y.coeff ).map{|xc, yc| xc + (yc || @field.zero)}
      new(coeff)
    end

    def mult(x, y)
      check_same_class(x, y)
      deg = [x.deg, y.deg].any?{|d| d == -1} ? -1 : x.deg + y.deg

      coeff = [@field.zero]*(deg+1)
      (0..x.deg).each do |xi|
        (0..y.deg).each do |yi|
          coeff[xi+yi] += (x.coeff[xi])*(y.coeff[yi])
        end
      end
      new(coeff)
    end

    def minus(x)
      coeff = x.coeff.map{|co| @field.minus(co)}
      new(coeff)
    end

    def ==(o)
      self.field == o.field
    end

    private
    def check_same_class(x, y)
      raise ArgumentError, "fields are not same." unless x.poly == y.poly
    end
  end
end
