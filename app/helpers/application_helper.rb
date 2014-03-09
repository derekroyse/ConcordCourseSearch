module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end # end full_title
  
  # Returns content from a scraped page.
  def scrape_site
    choice = 201402
    i = 0
    j = 0
    x = 0
    y = 0
    headers = Array.new(18)
    records = Array.new(18){Array.new}
    agent = Mechanize.new
    data = agent.get('https://apps.concord.edu/schedules/seatstaken.php')
    select_list = data.form_with(:action => '/schedules/seatstaken.php')
    select_list.field_with(:name =>"term").option_with(:value => '201402').click
    
    data = agent.submit(select_list)
    rows = data.search("td")
    numRecords = (rows.length/18)-(rows.length/900)-1
    
    # Populate headers and row data.
    while i < rows.length
      if i < 18
	headers[i] = rows[i].text
	i+=1
      elsif i % 918 <= 17
	i+=1
      else
	while y < 18
	  (records[x] ||= [])[y] = rows[i].text
	  y+=1
	  i+=1
	end #end while
	x+=1
	y=0
      end # end if/else
    end # end while
    
    formatted_headers = "<table><tr class='table_header'>"
    for element in headers
      formatted_headers += "<td>" + element + "</td>"
    end
    formatted_headers += "</tr>"
   
    formatted_records = ""
    records.each_with_index do |row, xi|
      formatted_records += "<tr>"
      row.each_with_index do |column, yi|
	formatted_records += "<td>"+ column + "</td>"
      end
      formatted_records += "</tr>"
    end 
    formatted_records += "</table>"
    
    formatted_final = formatted_headers + formatted_records
  
    return formatted_final
    
  end # end scrape_site
end #end module
