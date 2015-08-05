require 'gtin/version'
require 'gtin/mixin'

# TODO: document
module Gtin
  def self.checksum(str)
    return nil if str.empty? || str.length > 17
    (10 - str.reverse.split('').map.with_index do |x, i|
      x.to_i * 3**((i + 1) & 1) # magic from @hobberwickey
    end.reduce(:+).modulo(10)).modulo(10).to_s
  end

  def self.from_upc_e(str)
    str.match(/^0??(\d{6})(\d?)$/) do |m|
      return nil if m.nil?
      s, c = m[1..2]
      e = case s[5]
          when '0'..'2'
            s[0..1] << s[5] << '0' * 4 << s[2..4]
          when '3'
            s[0..2] << '0' * 5 << s[3..4]
          when '4'
            s[0..3] << '0' * 5 << s[4]
          when '5'..'9'
            s[0..4] << '0' * 4 << s[5]
          end
      gtin = '0' << e << (c.empty? ? Gtin.checksum(e) : c)
      Gtin.valid_upc_e?(s) && gtin.gtin? || fail(ArgumentError, 'invalid UPC-E')
      gtin
    end
  end

  def self.valid_upc_e?(str)
    # from GS1 General Specification
    # Fig. 7.10-1
    #
    # http://www.gs1.org/
    a = str.split('').map(&:to_i)
    case a[5]
    when 0..2
      true
    when 3
      a[2] > 2
    when 4
      a[3] > 0
    when 5..9
      !(a[0] > 0 || a[1] == 0 || a[1] > 7) || a[4] > 0
    else
      false
    end
  end

  def check_digit
    self[-1]
  end

  def gtin?
    !match(/\d+/).nil? &&
      [8, 12, 13, 14].include?(length) &&
      Gtin.checksum(self[0..-2].to_s) == self[-1]
  end

  def to_upc_e
    core =  case self
            when /^\d{5}[^0]0{4}[5-9]\d$/
              self[1..5] << self[10]
            when /^\d{4}[^0]0{5}\d{2}$/
              self[1..4] << self[10] << '4'
            when /^\d{3}[0-2]0{4}\d{4}$/
              self[1..2] << self[8..10] << self[3]
            when /^\d{3}[3-9]0{5}\d{3}$/
              self[1..3] << self[9..10] << '3'
            else fail "Cannot convert #{self} to UPC-E"
            end
    almost = '0' << core
    almost << check_digit
  end

  [8, 12, 13, 14].each do |l|
    define_method(:"to_gtin_#{l}") do
      fail 'Not a GTIN' unless gtin?
      fail "#{self} is too long" if length > l
      rjust(l, '0')
    end
  end

  def to_gtin
    to_gtin_14
  end
end
