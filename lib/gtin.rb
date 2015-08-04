require 'gtin/version'

# TODO: document
# :nodoc:
module Gtin
  def gtin?
    !match(/\d+/).nil?
  end
end

# :nodoc:
class String
  include Gtin
end
