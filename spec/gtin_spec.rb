require 'spec_helper'

describe Gtin do
  context 'setup' do
    it 'has a version number' do
      expect(Gtin::VERSION).not_to be nil
    end

    it 'is included by String' do
      expect(String.include? Gtin).to be true
    end
  end

  context 'validation' do
    it 'accepts a valid UPC-A' do
      valid = '603675101876'
      expect(valid.gtin?).to be true
    end

    it 'rejects an invalid UPC-A' do
      invalid = ''
      expect(invalid.gtin?).to be false
    end
  end
end
