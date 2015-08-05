require 'gtin/version'

# TODO: document
# :nodoc:
module Gtin
  def self.checksum(str)
    return nil if str.empty? || str.length > 17
    (10 - str.reverse.split('').map.with_index do |x, i|
      x.to_i * 3**((i + 1) & 1) # magic from @hobberwickey
    end.reduce(:+).modulo(10)).to_s
  end

  def self.from_upc_e(str)
    str.match(/^0?(\d{6})(\d?)$/) do |m|
      return nil if m.nil?
      s, c = m[1..2]
      expanded =  case s[5]
                  when '0'..'2'
                    s[0..1] << s[5] << '0' * 4 << s[2..4]
                  when '3'
                    s[0..2] << '0' * 5 << s[3..4]
                  when '4'
                    s[0..3] << '0' * 5 << s[4]
                  when '5'..'9'
                    s[0..4] << '0' * 4 << s[5]
                  end
      return '0' << expanded << c || Gtin.checksum(expanded)
    end
  end

  def checksum
    self[-1]
  end

  def gtin?
    [
      _only_digits?,
      _correct_length?,
      _checksum?
    ].all?
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
            else return nil
            end
    almost = '0' << core
    almost << checksum
  end

  def _only_digits?
    !match(/\d+/).nil?
  end

  def _correct_length?
    [8, 12, 13, 14, 17, 18].include? length
  end

  def _checksum?
    Gtin.checksum(self[0..-2].to_s) == self[-1]
  end
end

# :nodoc:
class String
  include Gtin
end
