require "spec_helper"

RSpec.describe GF do
  it 'has class GF' do
    expect(GF::GF).not_to be nil
    expect(GF::GF.class).to be Class
  end

  describe GF::GF do
    before do
      @pf2 = GF::PrimeField.new(2)
      @_0 = @pf2.zero
      @_1 = @pf2.one
      @po2 = GF::Poly.new(@pf2)

      @gen1 = @po2.new([@_1,@_0,@_0,@_0,@_1,@_1,@_1,@_0,@_1])
      @gf256 = GF::GF.new(2, 8, @gen1)
    end

    describe 'initialization' do
      it 'fails when generator\'s field\'s order and base does not match' do
        expect{ GF::GF.new(3, 8, @gen1) }.to raise_error ArgumentError
      end

      it 'fails when generator\'s degree and exp does not match' do
        expect{ GF::GF.new(2, 9, @gen1) }.to raise_error ArgumentError
      end

      it 'fails when generator does not make base**exp order field' do
        expect{ GF::GF.new(2, 8, @po2.new([@_1,@_0,@_0,@_0,@_0,@_0,@_0,@_0,@_0,@_0])) }.to raise_error ArgumentError
        expect{ GF::GF.new(2, 8, @po2.new([@_1,@_0,@_0,@_0,@_0,@_0,@_0,@_0,@_1,@_0])) }.to raise_error ArgumentError
      end
    end

    describe '#==' do
        # TODO
    end

    describe '#zero' do
      it 'returns zero, that is neutral-elem in addition' do
        expect( @gf256.zero + @gf256.new(2) ).to eq @gf256.new(2)
        expect( @gf256.zero + @gf256.new(5) ).to eq @gf256.new(5)
        expect( @gf256.zero + @gf256.zero ).to eq @gf256.zero
        expect( @gf256.zero + @gf256.one ).to eq @gf256.one
      end

      it 'returns zero, that makes self when multiplyed anything' do
        expect( @gf256.zero * @gf256.zero ).to eq @gf256.zero
        expect( @gf256.zero * @gf256.one ).to eq @gf256.zero
        expect( @gf256.zero * @gf256.new(2) ).to eq @gf256.zero
        expect( @gf256.zero * @gf256.new(5) ).to eq @gf256.zero
      end
    end

    describe '#one' do
      it 'returns one, that is neutral-elem in multiplication' do
        expect( @gf256.one * @gf256.new(2) ).to eq @gf256.new(2)
        expect( @gf256.one * @gf256.new(5) ).to eq @gf256.new(5)
        expect( @gf256.one * @gf256.zero ).to eq @gf256.zero
        expect( @gf256.one * @gf256.one ).to eq @gf256.one
      end
    end

    describe '#add' do
      it '1 + 1 = 0' do
        expect( @gf256.from_poly(0b1) + @gf256.from_poly(0b1) ).to eq @gf256.from_poly(0b0)
      end
      it '(x+1) + x = 1' do
        expect( @gf256.from_poly(0b11) + @gf256.from_poly(0b01) ).to eq @gf256.from_poly(0b10)
      end
      it '(xx+1) + (x+1) = xx+x' do
        expect( @gf256.from_poly(0b0101) + @gf256.from_poly(0b0011) ).to eq @gf256.from_poly(0b0110)
      end
    end

    describe '#mult' do
      it 'x * x = xx' do
        expect( @gf256.from_poly(0b0010) * @gf256.from_poly(0b0010) ).to eq @gf256.from_poly(0b0100)
      end
      it '(x+1) * x = xx+x' do
        expect( @gf256.from_poly(0b0011) * @gf256.from_poly(0b0010) ).to eq @gf256.from_poly(0b0110)
      end
      it '(x+1) * (xx+x+1) = xxx+1' do
        expect( @gf256.from_poly(0b0011) * @gf256.from_poly(0b0111) ).to eq @gf256.from_poly(0b1001)
      end
    end

    describe '#minus' do
      it 'returns inverse in addition' do
        expect( @gf256.zero + (-@gf256.zero) ).to eq @gf256.zero
        expect( @gf256.one + (-@gf256.one) ).to eq @gf256.zero
        expect( @gf256.from_poly(0b1100) + (-@gf256.from_poly(0b1100)) ).to eq @gf256.zero
        expect( @gf256.from_poly(0b10100011) + (-@gf256.from_poly(0b10100011)) ).to eq @gf256.zero
      end

      it '-x = x' do
        expect( -(@gf256.from_poly(0b0010)) ).to eq @gf256.from_poly(0b0010)
      end
      it '-(xx+1) = xx+1' do
        expect( -(@gf256.from_poly(0b0101)) ).to eq @gf256.from_poly(0b0101)
      end
    end

    describe '#inv' do
      it 'returns inverse in multiplication' do
        expect( @gf256.one.inv * @gf256.one ).to eq @gf256.one
        expect( @gf256.new(2).inv * @gf256.new(2) ).to eq @gf256.one
        expect( @gf256.new(5).inv * @gf256.new(5) ).to eq @gf256.one
        expect( @gf256.new(7).inv * @gf256.new(7) ).to eq @gf256.one
        expect( @gf256.new(50).inv * @gf256.new(50) ).to eq @gf256.one
        expect( @gf256.new(100).inv * @gf256.new(100) ).to eq @gf256.one
      end

      it '2^-1 = 4 mod 7' do
        expect( @gf256.from_poly(0b1100).inv ).to eq @gf256.from_poly(0b1000100)
      end

      it 'fails because zero has no inverse' do
        expect{ @gf256.zero.inv }.to raise_error ZeroDivisionError
      end
    end
  end
end
