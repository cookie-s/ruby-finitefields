require_relative 'euclid-ring'

module GF
  class Poly < EuclidRing
    class Element < EuclidRing::Element
      attr_reader :coeff, :deg
      alias_method :coeff, :idx
      alias_method :poly, :ring

      def initialize( _poly, _coeff )
        nonzero_coeff_pos = _coeff.each_with_index.reject{|x, i| x == _poly.field.zero}.map{|x, i| i}
        @deg = nonzero_coeff_pos.size == 0 ? -1 : nonzero_coeff_pos.max
        _coeff = _coeff[0,deg+1]
        super(_poly, _coeff)
      end

      def eval( val )
        coeff.each_with_index.inject(poly.field.zero){|s,(c,i)| s+c*(val**i)}
      end

      def to_s
        coeff.each_with_index.map{|x, i| x.to_s + ('x'*i)}.join("+")
      end

      def inspect
        "#<Poly::Element: poly: #{poly.inspect}, coeff: #{coeff.inspect}>"
      end
    end

    attr_reader :field

    def initialize( field )
      @field = field
    end

    def new( coeff )
      Poly::Element.new(self, coeff)
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

    def mod(x, y)
      #TODO: add test
      (x.deg+1).times do |i|
        j = x.deg - i
        yy = y * (j.times.map{self.x}.inject(self.one,&:*))
        next if x.deg < yy.deg
        yc = x.coeff.zip(yy.coeff).map{|x,y| (y ? y : self.field.zero)}

        xc = x.coeff.reverse
        yc = yc.reverse
        if !yc.empty? && yc[0].idx != 0
          x -= (xc[0].idx/yc[0].idx).times.map{yy}.inject(self.zero,&:+)
          # x -= yy * new([@field.new(xc[0].idx / yc[0].idx)])
        end
      end
      x
    end

    def ==(o)
      self.field == o.field
    end
  end
end
