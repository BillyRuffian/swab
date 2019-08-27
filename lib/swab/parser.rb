module Swab

  class Parser
    def initialize(url)
      @base_url = url
      @mech = Mechanize.new
    end
    
    def login(username, password)
      login_page = @mech.get(@base_url)
      @page = login_page.form_with(name: 'aspnetForm') do |f|
        f.field_with(id: 'ctl00_content_login_UserName').value = username
        f.field_with(id: 'ctl00_content_login_Password').value = password
      end.click_button
    end
    
    def parse(data = [], count = 0)
      puts "iteration #{count}"
      table = @page.search('table#ctl00_content_BookingStatus1_dynamicTable')
      new_data = table.search('tr')[1..-1].map do |tr|
        tr.search('td')[1..-1].map(&:text).map{ |s| s.gsub( "\u00A0", "" ) }
      end
      
      data = data + new_data
            
      form = @page.form_with(name: 'aspnetForm')
      form['__EVENTTARGET'] = 'ctl00$content$BookingStatus1'
      form['__EVENTARGUMENT'] = "goToPage_#{count + 2}"
      if !new_data.empty?
        @page = form.submit
        data = parse(data, count + 1)
      end
      data
    end

  end

end