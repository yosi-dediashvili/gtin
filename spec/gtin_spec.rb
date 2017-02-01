require 'spec_helper'

describe Gtin do
  before(:all) do
    @valid_gtin = %w(
      1234567891019
      5012345678900
      012345678905
      308891234123
      603675101876
      877565007023
      20123451
    )
    @valid_upc_e = {
      '00123457' => '001234000057',
      '08787337' => '087800000737',
      '878733'   => '087800000737',
      '079999'   => '007999000097',
      '0783491'  => '007834000091'
    }
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

    context 'when given a UPC-E string' do
      it 'validates a proper UPC-E' do
        @valid_upc_e.each do |k, v|
          expect(Gtin.valid_upc_e? k).to be_truthy
        end
      end

      it 'validates a proper UPC-E format' do
        @valid_upc_e.each do |k, v|
          expect(Gtin.valid_upc_e_format? k).to be_truthy
        end
      end

      it 'validates a proper UPC-E format with invalid check-digit' do
        expect(Gtin.valid_upc_e_format? "2012345").to be_truthy
      end

      it 'rejects a proper UPC-E format with invalid check digit' do
        expect(Gtin.valid_upc_e? "2012345").to be_falsy
      end

      it 'can create a GTIN' do
        @valid_upc_e.each do |k, v|
          expect(Gtin.from_upc_e k).to eq v
        end
      end

      it 'rejects invalid UPC-E strings' do
        %w( 000004 ).each do |v|
          expect { Gtin.from_upc_e v}.to raise_error(ArgumentError)
        end
      end
    end
  end

  context 'instance' do
    it 'validates a proper GTIN' do
      @valid_gtin.each do |g|
        expect(g.gtin?).to be true
      end
    end

    it 'knows its check digit' do
      @valid_gtin.each do |g|
        expect(g.check_digit).to eq g[-1]
      end
    end

    it 'rejects improper strings' do
      %w(
        012345678A
        0123456
      ).each { |x| expect(x.gtin?).to be false }
      expect(''.gtin?).to be false
    end

    context 'when converting among representations' do
      context 'UPC-E' do
        it 'converts between representations' do
          expect('001234000057'.to_upc_e).to eq '00123457'
        end

        it "doesn't make erroneous UPC-E symbols" do
          @valid_gtin.each do |e|
            expect { e.to_upc_e }.to raise_error RuntimeError, "Cannot convert #{e} to UPC-E"
          end
        end
      end

      context '.to_gtin_XX' do
        before(:context) do
          @gtin_length = [8, 12, 13, 14]
        end

        it 'pads out the required number of zeroes' do
          @gtin_length.each do |l|
            raw = '20123451'
            expect(raw.send(:"to_gtin_#{l}")).to eq raw.rjust(l, '0')
          end
        end

        it 'fails when the length is too long' do
          @gtin_length.each do |l|
            @valid_gtin.select { |g| g.length > l }.each do |g|
              expect { g.send(:"to_gtin_#{l}") }.to raise_error RuntimeError
            end
          end
        end

        it 'defaults to calling .to_gtin_14' do
          @valid_gtin.each do |g|
            expect(g.to_gtin). to eq g.to_gtin_14
          end
        end
      end
    end
  end
end
