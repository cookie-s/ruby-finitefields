require "spec_helper"

RSpec.describe GF do
  it 'has class Poly' do
    expect(GF::Poly).not_to be nil
    expect(GF::Poly.class).to be Class
  end

  describe GF::Poly do
    context 'rational-field polynominal' do
      before do
        @rf  = GF::RationalField.new
        @poly = GF::Poly.new( @rf )
        @_0  = @poly.zero
        @_1  = @poly.one
        @_x  = @poly.x
        @_xx = @poly.mult(@_x,@_x)
      end

      describe '#zero' do
        it 'is neutral element in addition' do
          expect(@poly.add( @_0,  @_0 )).to eq @_0
          expect(@poly.add( @_0,  @_1 )).to eq @_1
          expect(@poly.add( @_0,  @_x )).to eq @_x
          expect(@poly.add( @_0, @_xx )).to eq @_xx
        end

        it 'makes self when multiplyed anything' do
          expect(@poly.mult( @_0, @_0 )).to eq @_0
          expect(@poly.mult( @_0, @_1 )).to eq @_0
          expect(@poly.mult( @_0, @_x )).to eq @_0
        end
      end

      describe '#one' do
        it 'is neutral element in product' do
          expect(@poly.mult( @_1,  @_0 )).to eq @_0
          expect(@poly.mult( @_1,  @_1 )).to eq @_1
          expect(@poly.mult( @_1,  @_x )).to eq @_x
          expect(@poly.mult( @_1, @_xx )).to eq @_xx
        end

        it 'is not zero' do
          expect(@_1 == @_0).to be false
        end
      end

      describe '#add' do
        it '1 + 1 == 2' do
          expect(@poly.add(  @_1, @_1 )).to eq @poly.new([@rf.new(2)])
        end

        it '1 + x == 1 + x' do
          expect(@poly.add(  @_1, @_x )).to eq @poly.new([@rf.new(1), @rf.new(1)])
        end

        it 'x + x == 2x' do
          expect(@poly.add(  @_x, @_x )).to eq @poly.new([@rf.new(0), @rf.new(2)])
        end

        it 'x^2 + x == x + x^2' do
          expect(@poly.add( @_xx, @_x )).to eq @poly.new([@rf.new(0), @rf.new(1), @rf.new(1)])
        end

        it 'x^2 + 1 == 1 + x^2' do
          expect(@poly.add( @_xx, @_1 )).to eq @poly.new([@rf.new(1), @rf.new(0), @rf.new(1)])
        end
      end

      describe '#mult' do
        before do
          @_x_1  = @poly.add(  @_1, @_x)
          @_2x_1 = @poly.add(@_x_1, @_x)
        end

        it '1 * 1 == 1' do
          expect(@poly.mult(   @_1,    @_1 )).to eq @poly.new([@rf.new(1)])
        end

        it '1 * x == x' do
          expect(@poly.mult(   @_1,    @_x )).to eq @poly.new([@rf.new(0), @rf.new(1)])
        end

        it 'x * x == x^2' do
          expect(@poly.mult(   @_x,    @_x )).to eq @poly.new([@rf.new(0), @rf.new(0), @rf.new(1)])
        end

        it '(1+x)x == x + x^2' do
          expect(@poly.mult(  @_x_1,   @_x )).to eq @poly.new([@rf.new(0), @rf.new(1), @rf.new(1)])
        end

        it '(1+x)(1+x) == 1 + 2x + x^x' do
          expect(@poly.mult(  @_x_1, @_x_1 )).to eq @poly.new([@rf.new(1), @rf.new(2), @rf.new(1)])
        end

        it '(1+2x)(1+x) == 1 + 3x + 2x^2' do
          expect(@poly.mult( @_2x_1, @_x_1 )).to eq @poly.new([@rf.new(1), @rf.new(3), @rf.new(2)])
        end
      end
    end
  end
end
