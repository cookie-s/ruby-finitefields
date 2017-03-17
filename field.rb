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
    raise ZeroDivisionError if x == zero
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
