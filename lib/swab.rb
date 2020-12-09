require 'mechanize'
require "swab/parser"
require "swab/version"

module Swab
  class Error < StandardError; end
  
  
  def self.swab(url, user, pass, months, recent, spinner)
    parser = Parser.new(url)
    
    spinner.update(title: 'Logging in' ) if spinner
    parser.login(user, pass )

    if recent
      spinner.update(title: 'Setting most recent checkbox' ) if spinner
      parser.set_most_recent
    else
      spinner.update(title: 'Setting date range' ) if spinner
      parser.set_date_range(months)
    end

    
    spinner.update(title: 'Scraping' ) if spinner
    data = parser.parse { |page| spinner.update(title: "Scaping page #{page+1}") }
#     puts data
  end
end
