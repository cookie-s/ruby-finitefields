# TODO: add tests

module GF
  class Ring
    class Element
      attr_reader :idx, :ring

      def initialize(ring, idx)
        @ring = ring
        @idx = idx
      end

      def inspect
        "#<Ring::Element: ring=#{@ring.inspect}, idx=#{@idx}>"
      end

      def ==(o)
        self.ring == o.ring && self.idx == o.idx
      end

      def -@
        @field.minus(self)
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

      def **(n)
        x = self
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

    def new(idx)
      Element.new(self, idx)
    end

    def ==(o)
    end

    private
    def check_same_class(x, y)
      raise ArgumentError, "ring are not same" unless x.ring == y.ring
    end
  end
end
