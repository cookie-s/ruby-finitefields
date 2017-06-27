require_relative 'ring'

module GF
  class EuclidRing < Ring
    class Element < Ring::Element
      def mod(x)
        @ring.mod(self, x)
      end
    end

    def mod(x, y)
      check_same_class(x, y)
    end
  end
end
