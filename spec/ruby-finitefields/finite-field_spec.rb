require "spec_helper"

RSpec.describe GF do
  it 'has class GF' do
    expect(GF::GF).not_to be nil
    expect(GF::GF.class).to be Class
  end

  describe GF::GF do

  end
end
