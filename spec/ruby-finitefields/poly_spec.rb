require "spec_helper"

RSpec.describe GF do
  it 'has class Poly' do
    expect(GF::Poly).not_to be nil
    expect(GF::Poly.class).to be Class
  end

  describe GF::Poly do
  end
end
