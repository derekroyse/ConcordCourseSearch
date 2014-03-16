module ApplicationHelper
  @@choice = 201501
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
      select_list.field_with(:name =>"term").value = 201501
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
    
    return formatted_final
  end # end scrape_site
  
  def search(crn, subj, crs, sec, title, ch, max, enr, avail, wl, days, stime, etime, bldgroom, wk, instructor, ef, starts)

     x = 0
     formatted_headers = "<table><tr class='table_header'>"
         for element in @@headers
	  formatted_headers += "<td>" + element + "</td>"
	 end #end for
    formatted_headers += "</tr>"
    formatted_records = ""
    
     while x < @@numRecords
      if  @@records[x][0] == crn && crn.inspect != "\"\"" && @@records[x][0].inspect != "\"\"" || 
	  @@records[x][1].downcase.index(subj.downcase) != nil && subj.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][2].downcase.index(crs.downcase) != nil && crs.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][3].downcase.index(sec.downcase) != nil && sec.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][4].downcase.index(title.downcase) != nil  && title.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][5] == ch && ch.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][6] == max && max.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][7] == enr && enr.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][8] == avail && avail.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][9] == wl && wl.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][10].downcase.index(days.downcase) != nil && @@records[x][0].inspect != "\"\""   && days.inspect != "\"\"" || 
	  @@records[x][11].downcase.index(stime.downcase) != nil && @@records[x][0].inspect != "\"\""  && stime.inspect != "\"\"" ||
	  @@records[x][12].downcase.index(etime.downcase) != nil && etime.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][13].downcase.index(bldgroom.downcase) != nil && bldgroom.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][14].downcase.index(wk.downcase) != nil 	&& wk.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][15].downcase.index(instructor.downcase) != nil && instructor.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  ||
	  @@records[x][16].downcase.index(ef.downcase) != nil 	 && ef.inspect != "\"\"" && @@records[x][0].inspect != "\"\""  || 
	  @@records[x][17].downcase.index(starts.downcase) != nil && starts.inspect != "\"\"" && @@records[x][0].inspect != "\"\"" 
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
  
  if formatted_records == "</table>"
    return "No records found that match your search."
  else
    return formatted_final
  end
end #end method

end
