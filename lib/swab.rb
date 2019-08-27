require 'mechanize'
require "swab/parser"
require "swab/version"

module Swab
  class Error < StandardError; end
  
  
  def self.swab(url, user, pass)
    parser = Parser.new(url)
    parser.login(user, pass )
    data = parser.parse
#     puts data
  end
end
