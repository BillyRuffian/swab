require "logger"

module Swab

  class Parser
    attr_accessor :page
    
    def initialize(url)
    
      @log = Logger.new STDOUT
      @log.level = Logger::DEBUG
      @base_url = url
      @mech = Mechanize.new # { |a| a.log = @log }
    end
    
    def login(username, password)
      login_page = @mech.get(@base_url)
      @page = login_page.form_with(name: 'aspnetForm') do |f|
        f.field_with(id: 'ctl00_content_login_UserName').value = username
        f.field_with(id: 'ctl00_content_login_Password').value = password
      end.click_button
    end
    
    def set_date_range(days)
      start_date = Date.today
      end_date = start_date + days - 1
      
      form = @page.form_with(name: 'aspnetForm')
      form.add_field!('ctl00$ToolkitScriptManager1', 'ctl00$content$BookingStatusUpdatePanel|ctl00$content$BookingStatus1$cmdSubmitPrint')
      form.add_field!('ctl00$content$BookingStatus1$cmdSubmitPrint', 'Filter')
      form.add_field!('__EVENTARGUMENT', '')
      form.add_field!('__EVENTTARGET', '')
      form['ctl00$content$BookingStatus1$mListDateOptions'] = 'DateRange'
      form['ctl00$content$BookingStatus1$StartDate'] = start_date.strftime '%d-%b-%y'
      form['ctl00$content$BookingStatus1$EndDate'] = end_date.strftime '%d-%b-%y'
      @page = form.submit
    end
    
    def parse(data = [], count = 0)
      table = @page.search('table#ctl00_content_BookingStatus1_dynamicTable')
      new_data = table.search('tr')[1..-1].map do |tr|
        tr.search('td')[1..-1].map(&:text).map{ |s| s.gsub( "\u00A0", "" ) }
      end
      
      data = data + new_data
      
      yield(count) if block_given?
            
      form = @page.form_with(name: 'aspnetForm')
      form['__EVENTTARGET'] = 'ctl00$content$BookingStatus1'
      form['__EVENTARGUMENT'] = "goToPage_#{count + 2}"
      if !new_data.empty?
        @page = form.submit
        data = parse(data, count + 1, &Proc.new)
      end
      data
    end

  end

end