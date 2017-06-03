require_relative 'ring'

module GF
  class Field < Ring
    class Element < Ring::Element
      attr_reader :idx, :field
      alias_method :field, :ring

      def initialize(field, idx)
        raise ArgumentError, "#{field} is not field." unless Field === field
        super
      end

      def inspect
        "#<Field::Element: field=#{self.field.inspect}, idx=#{@idx}>"
      end

      def ==(o)
        self.field == o.field && self.idx == o.idx
      end

      def /(x)
        self.field.mult(self, self.field.inv(x))
      end

      def inv
        self.field.inv(self)
      end
    end

    def ord
    end

    def zero
    end
    def one
    end

    def add(x, y)
      check_same_class(x, y)
    end
    def mult(x, y)
      check_same_class(x, y)
    end

    def minus(x)
    end
    def inv(x)
      raise ZeroDivisionError if x == zero
    end

    def new(idx)
      Field::Element.new(self, idx)
    end

    def ==(o)
    end

    private
    def check_same_class(x, y)
      raise ArgumentError, "fields are not same" unless x.field == y.field
    end
  end
end
