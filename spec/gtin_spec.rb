require 'spec_helper'

describe Gtin do
  before(:all) do
    @valid_gtin = '603675101876'
  end

  it 'has a version number' do
    expect(Gtin::VERSION).not_to be nil
  end

  it 'is included by String' do
    expect(String.include? Gtin).to be true
  end

  context 'library functions' do
    it 'can calculate a checksum' do
      expect(Gtin.checksum @valid_gtin[0..-2]).to eq @valid_gtin[-1]
    end
  end

  context 'instance' do
    it 'validates a proper GTIN' do
      expect(@valid_gtin.gtin?).to be true
    end

    it 'rejects improper strings' do
      expect('012345678A'.gtin?).to be false # oops! a letter!
      expect('0123456'.gtin?).to be false # wrong length
      expect(''.gtin?).to be false
    end
  end
end
