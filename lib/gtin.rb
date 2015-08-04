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

  def gtin?
    [
      _only_digits?,
      _correct_length?,
      _checksum?
    ].all?
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
