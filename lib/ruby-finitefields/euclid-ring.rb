require_relative 'ring'

module GF
  class EuclidRing < Ring
    class Element < Ring::Element
      def divmod(x)
        @ring.divmod(x, y)
      end
    end

    def divmod(x, y)
      check_same_class(x, y)
    end
  end
end
