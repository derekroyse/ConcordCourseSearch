module ApplicationHelper
  @@choice = 201402
  @@headers = Array.new(18)
  @@records = Array.new(18){Array.new}
  @@numRecords = 0
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
  def scrape_site(choice)
    @@choice = choice
    i = 0
    j = 0
    x = 0
    y = 0

    agent = Mechanize.new
    data = agent.get('https://apps.concord.edu/schedules/seatstaken.php')
    select_list = data.form_with(:action => '/schedules/seatstaken.php')
 
    if @@choice.inspect == "nil"
      select_list.field_with(:name =>"term").value = 201402
    else
      select_list.field_with(:name =>"term").value = @@choice
    end
    
    data = agent.submit(select_list)
    rows = data.search("td")
    @@numRecords = (rows.length/18)-(rows.length/900)-1
    
    # Populate headers and row data.
    while i < rows.length
      if i < 18
	@@headers[i] = rows[i].text
	i+=1
      elsif i % 918 <= 17
	i+=1
      else
	while y < 18
	  (@@records[x] ||= [])[y] = rows[i].text
	  y+=1
	  i+=1
	end #end while
	x+=1
	y=0
      end # end if/else
    end # end while
    
    formatted_headers = "<table><tr class='table_header'>"
    for element in @@headers
      formatted_headers += "<td>" + element + "</td>"
    end
    formatted_headers += "</tr>"
   
    formatted_records = ""
    @@records.each_with_index do |row, xi|
      formatted_records += "<tr>"
      row.each_with_index do |column, yi|
	formatted_records += "<td>"+ column + "</td>"
      end
      formatted_records += "</tr>"
    end 
    formatted_records += "</table>"
    
    formatted_final = formatted_headers + formatted_records
    
    #return formatted_final
  end # end scrape_site
  
  def search(crn, subj, crs)

     x = 0
     formatted_headers = "<table><tr class='table_header'>"
         for element in @@headers
	  formatted_headers += "<td>" + element + "</td>"
	 end #end for
    formatted_headers += "</tr>"
    formatted_records = ""
    
     while x < @@numRecords
      if @@records[x][0].index(crn) != nil ||
	 @@records[x][1].index(subj) != nil ||
	 @@records[x][2].index(crs) != nil 
	#&& @@records[x][3].index(SEC) != nil &&
#	@@records[x][4].index(TITLE) != nil && @@records[x][5].index(CH) != nil &&
#	@@records[x][6].index(MAX) != nil && @@records[x][7].index(ENR) != nil && 
#	@@records[x][8].index(AVAIL) != nil && @@records[x][9].index(WL) != nil &&
#	@@records[x][10].index(DAYS) != nil && @@records[x][11].index(STIME) != nil &&
#	@@records[x][12].index(ETIME) != nil &&	@@records[x][13].index(BLDGROOM) != nil &&
#	@@records[x][14].index(WK) != nil && @@records[x][15].index(INSTRUCTOR) != nil &&
#	@@records[x][16].index(EF) != nil && @@records[x][17].index(STARTS) != nil &&
	formatted_records += "<tr>"
	  for column in @@records[x]
	    formatted_records += "<td>"+ column + "</td>"
	  end #end for
	formatted_records += "</tr>"
      end # end if
      x+=1
  end # end while
  formatted_records += "</table>"
  formatted_final = formatted_headers + formatted_records
end #end method

end
