require "spec_helper"

RSpec.describe GF do
  it 'has class PrimeField' do
    expect(GF::PrimeField).not_to be nil
    expect(GF::PrimeField.class).to be Class
  end

  describe GF::PrimeField do
    before do
      @field_seven = GF::PrimeField.new( 7 )
    end

    describe 'initialization' do
      it 'fails when trying make non-prime order field' do
        expect{ GF::PrimeField.new( 31 * 23 ) }.to raise_error ArgumentError
      end

      it 'makes the given order field' do
        expect( GF::PrimeField.new( 7 ).ord ).to be 7
      end
    end

    describe '#==' do
      it 'returns true if two fields are exactly same' do
        expect( @field_seven == @field_seven ).to be true
      end

      it 'returns true if two fields have same order' do
        expect( @field_seven == GF::PrimeField.new(7) ).to be true
        expect( GF::PrimeField.new(41) == GF::PrimeField.new(41) ).to be true
        expect( GF::PrimeField.new(41) == GF::PrimeField.new(37) ).to be false
      end
    end

    describe '#zero' do
      it 'returns zero, that is neutral-elem in addition' do
        expect( @field_seven.zero + @field_seven.new(2) ).to eq @field_seven.new(2)
        expect( @field_seven.zero + @field_seven.new(5) ).to eq @field_seven.new(5)
        expect( @field_seven.zero + @field_seven.zero ).to eq @field_seven.zero
        expect( @field_seven.zero + @field_seven.one ).to eq @field_seven.one
      end

      it 'returns zero, that makes self when multiplyed anything' do
        expect( @field_seven.zero * @field_seven.zero ).to eq @field_seven.zero
        expect( @field_seven.zero * @field_seven.one ).to eq @field_seven.zero
        expect( @field_seven.zero * @field_seven.new(2) ).to eq @field_seven.zero
        expect( @field_seven.zero * @field_seven.new(5) ).to eq @field_seven.zero
      end
    end

    describe '#one' do
      it 'returns one, that is neutral-elem in multiplication' do
        expect( @field_seven.one * @field_seven.new(2) ).to eq @field_seven.new(2)
        expect( @field_seven.one * @field_seven.new(5) ).to eq @field_seven.new(5)
        expect( @field_seven.one * @field_seven.zero ).to eq @field_seven.zero
        expect( @field_seven.one * @field_seven.one ).to eq @field_seven.one
      end
    end

    describe '#add' do
      it '2 + 3 = 5 mod 7' do
        expect( @field_seven.new(2) + @field_seven.new(3) ).to eq @field_seven.new(5)
      end
      it '2 + 6 = 1 mod 7' do
        expect( @field_seven.new(2) + @field_seven.new(6) ).to eq @field_seven.new(1)
      end
      it '2 + 5 = 0 mod 7' do
        expect( @field_seven.new(2) + @field_seven.new(5) ).to eq @field_seven.new(0)
      end
    end

    describe '#mult' do
      it '2 * 3 = 6 mod 7' do
        expect( @field_seven.new(2) * @field_seven.new(3) ).to eq @field_seven.new(6)
      end
      it '2 * 6 = 5 mod 7' do
        expect( @field_seven.new(2) * @field_seven.new(6) ).to eq @field_seven.new(5)
      end
      it '2 * 4 = 1 mod 7' do
        expect( @field_seven.new(2) * @field_seven.new(4) ).to eq @field_seven.new(1)
      end
    end

    describe '#minus' do
      it 'returns inverse in addition' do
        expect( @field_seven.zero + (-@field_seven.zero) ).to eq @field_seven.zero
        expect( @field_seven.one + (-@field_seven.one) ).to eq @field_seven.zero
        expect( @field_seven.new(2) + (-@field_seven.new(2)) ).to eq @field_seven.zero
        expect( @field_seven.new(5) + (-@field_seven.new(5)) ).to eq @field_seven.zero
      end

      it '-2 = 5 mod 7' do
        expect( -(@field_seven.new(2)) ).to eq @field_seven.new(5)
      end
      it '-4 = 3 mod 7' do
        expect( -(@field_seven.new(4)) ).to eq @field_seven.new(3)
      end
    end

    describe '#inv' do
      it 'returns inverse in multiplication' do
        expect( @field_seven.one.inv * @field_seven.one ).to eq @field_seven.one
        expect( @field_seven.new(2).inv * @field_seven.new(2) ).to eq @field_seven.one
        expect( @field_seven.new(5).inv * @field_seven.new(5) ).to eq @field_seven.one
      end

      it '2^-1 = 4 mod 7' do
        expect( @field_seven.new(2).inv ).to eq @field_seven.new(4)
      end

      it 'fails because zero has no inverse' do
        expect{ @field_seven.zero.inv }.to raise_error ZeroDivisionError
      end
    end
  end
end
