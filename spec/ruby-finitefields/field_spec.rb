require "spec_helper"

RSpec.describe GF do
  it 'has class Field' do
    expect(GF::Field).not_to be nil
    expect(GF::Field.class).to be Class
  end

  describe GF::Field do
  end
end
