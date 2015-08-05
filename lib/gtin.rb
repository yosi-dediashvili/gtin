require 'gtin/version'

# TODO: document
# :nodoc:
module Gtin
  def self.checksum(str)
    return nil if str.empty?
    str.reverse.split.map.with_index do |x, i|
      x.to_i * 3**(i & 1)
    end.reduce(:+).modulo(10).to_s
  end

  def self.from_upc_e(str)
    return nil unless str.length == 8
    case str[6]
    when '0'..'2'
      str[0..2] << str[6] << '0' * 4 << str[3..6]
    when '3'
      str[0..3] << '0' * 5 << str[4..6]
    when '4'
      str[0..4] << '0' * 5 << str[5..6]
    when '5'..'9'
      str[0..5] << '0' * 4 << str[6..7]
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
            when /\d{5}[^0]0{4}[5-9]\d/
              self[1..5] << self[10]
            when /\d{4}[^0]0{5}\d{2}/
              self[1..4] << self[10] << '4'
            when /\d{3}[0-2]0{4}\d{4}/
              self[1..2] << self[8..10] << self[3]
            when /\d{3}[3-9]0{5}\d{3}/
              self[1..3] << self[9..10] << '3'
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
