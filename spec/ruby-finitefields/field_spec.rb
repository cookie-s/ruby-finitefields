require "spec_helper"

RSpec.describe GF do
  it 'has class Field' do
    expect(GF::Field).not_to be nil
    expect(GF::Field.class).to be Class
  end

  describe GF::Field do
    before do
      @rational_field = GF::RationalField.new
    end

    describe '#add' do
      it 'fails if two are not on the same field' do
        expect{ @rational_field.add( @rational_field.zero, @rational_field.one )}.not_to raise_error ArgumentError
        expect{ @rational_field.add( @rational_field.one, GF::PrimeField.new(5).one )}.to raise_error ArgumentError
      end

      it 'calcs the sum of two' do
        expect( @rational_field.add( @rational_field.zero, @rational_field.one ).idx ).to eq Rational(1, 1)
        expect( @rational_field.add( @rational_field.one, @rational_field.one ).idx ).to eq Rational(2, 1)
        expect( @rational_field.add( @rational_field.new( Rational(2, 3) ), @rational_field.new( Rational(5, 3) ) ).idx ).to eq Rational(7, 3)
      end
    end

    describe '#mult' do
      it 'fails if two are not on the same field' do
        expect{ @rational_field.mult( @rational_field.zero, @rational_field.one )}.not_to raise_error ArgumentError
        expect{ @rational_field.mult( @rational_field.one, GF::PrimeField.new(5).one )}.to raise_error ArgumentError
      end

      it 'calcs the product of two' do
        expect( @rational_field.mult( @rational_field.zero, @rational_field.one ).idx ).to eq Rational(0, 1)
        expect( @rational_field.mult( @rational_field.one, @rational_field.one ).idx ).to eq Rational(1, 1)
        expect( @rational_field.mult( @rational_field.new( Rational(2, 3) ), @rational_field.new( Rational(5, 3) ) ).idx ).to eq Rational(10, 9)
      end
    end

    describe '#minus' do
      it 'calcs the minus' do
        expect( @rational_field.minus(@rational_field.one).idx ).to eq Rational(-1, 1)
        expect( @rational_field.minus(@rational_field.new( Rational(2, 3) )).idx ).to eq Rational(-2, 3)
      end

      it 'calcs the inverse in addition' do
        expect( @rational_field.add( @rational_field.minus(@rational_field.one), @rational_field.one )).to eq @rational_field.zero
        expect( @rational_field.add( @rational_field.minus(@rational_field.new( Rational(2, 3) )), @rational_field.new( Rational(2, 3) ) )).to eq @rational_field.zero
      end
    end

    describe '#inv' do
      it 'calcs the inverse rational' do
        expect( @rational_field.inv(@rational_field.one).idx ).to eq Rational(1, 1)
        expect( @rational_field.inv(@rational_field.new( Rational(2, 3) )).idx ).to eq Rational(3, 2)
      end

      it 'calcs the inverse in product' do
        expect( @rational_field.mult( @rational_field.inv(@rational_field.one), @rational_field.one )).to eq @rational_field.one
        expect( @rational_field.mult( @rational_field.inv(@rational_field.new( Rational(2, 3) )), @rational_field.new( Rational(2, 3) ) )).to eq @rational_field.one
      end
    end
  end
end
