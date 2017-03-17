module GF
  class Poly
    class Element
      attr_reader :field, :coeff, :deg

      def initialize( field, coeff )
        nonzero_coeff_pos = coeff.each_with_index.reject{|x, i| x == field.zero}.map{|x, i| i}
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
end
