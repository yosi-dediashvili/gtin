require 'spec_helper'

describe Gtin do
  before(:all) do
    @valid_gtin = %w(
      603675101876
      376104250021234569
      877565007023
    )
    @valid_upc_e = {
      '00123457' => '001234000057',
      '08787337' => '087800000737'
    }
    @invalid_upc_e = %w( 123456 )
  end

  it 'has a version number' do
    expect(Gtin::VERSION).not_to be nil
  end

  it 'is included by String' do
    expect(String.include? Gtin).to be true
  end

  context 'module' do
    it 'can calculate a checksum' do
      @valid_gtin.each do |g|
        expect(Gtin.checksum g[0..-2]).to eq g[-1]
      end
    end

    it 'can create a GTIN from a UPC-E' do
      @valid_upc_e.each do |k, v|
        expect(Gtin.from_upc_e k).to eq v
      end
    end
  end

  context 'instance' do
    it 'validates a proper GTIN' do
      @valid_gtin.each do |g|
        expect(g.gtin?).to be true
      end
    end

    it 'knows its checksum' do
      @valid_gtin.each do |g|
        expect(g.checksum).to eq g[-1]
      end
    end

    it 'rejects improper strings' do
      expect('012345678A'.gtin?).to be false # oops! a letter!
      expect('0123456'.gtin?).to be false # wrong length
      expect(''.gtin?).to be false
    end

    it 'converts between representations' do
      expect('001234000057'.to_upc_e).to eq '00123457'
    end

    it "doesn't make erroneous UPC-E symbols" do
      expect('')
    end
  end
end
