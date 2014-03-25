module ApplicationHelper
  # Class variables
  @@semesterString = ""
  @@choice = 201501
  @@headers = Array.new(18)
  @@records = Array.new(18){Array.new}
  @@numRecords = 0
  @@nilReturn = "\"\""
  @@recordsPerTable = 40
  
  # Return a formatted semester string
  def getSemester(choice)
    # Clear variables    
	year = 0
    semester = ""
    fullSemesterTitle = ""
	
	# if there is input, set class variable
	if choice.nil? == false
      @@choice = choice.to_i
    end
        
    # First four digits = year
    year = @@choice/100;
    
    # Last digit = semester
    if @@choice % year == 1
      semester = "Fall Semester"
      year = year - 1
    elsif @@choice % year == 2
      semester = "Spring Semester"
    elsif @@choice % year == 3
      semester = "Summer Intersession"
    elsif @@choice % year == 4
      semester = "First Summer Term"
    elsif @@choice % year == 5
      semester = "Second Summer Term"
    elsif @@choice % year == 6
      semester = "Graduate Summer Term"
    elsif @@choice % year == 7
      semester = "Full Summer Term"
    else
      semester = "Error"
    end
    
    # Combine semester and year for full title
    fullSemesterTitle = semester + " " + year.to_s
    return fullSemesterTitle
  end # End getSemester
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Concord University List of Courses"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end # end full_title
  
  # Returns the formatted scraped content from the Concord website.
  def scrape_site(choice)
    #@@choice = choice
	# Clear the array
    @@records = Array.new(18){Array.new}
    # Loop variables
	i = 0
    j = 0
    x = 0
    y = 0
	
	# Setup the target website
    agent = Mechanize.new
    data = agent.get('https://apps.concord.edu/schedules/seatstaken.php')
    select_list = data.form_with(:action => '/schedules/seatstaken.php')
 
	# The choice value is nil, enter a default value, otherwise use the user's choice
    if @@choice.inspect == "nil"
      select_list.field_with(:name =>"term").value = 201501
    else
      select_list.field_with(:name =>"term").value = @@choice
    end
    
	# Grab raw data from website (with the selected semester)
    data = agent.submit(select_list)
    rows = data.search("td")
    @@numRecords = (rows.length/18)-(rows.length/900)-1
    
    # Populate headers and row arrays.
	# The first 17 values are headers. Subsequent sets of 17 values each create records.
	# Every 918 values (17 columns * 54 rows) the headers repeat, and so are ignored.
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
    
    # Add HTML formatting to headers
    formatted_headers = "<tr class='table_header'>"
    for element in @@headers
      formatted_headers += "<td>" + element + "</td>"
    end
    formatted_headers += "</tr>"
   
    # Add HTML formatting to records
    counter = 0
    formatted_records = ""
    @@records.each_with_index do |row|
      formatted_records += "<tr>"
      row.each_with_index do |column|
	formatted_records += "<td>"+ column + "</td>"
      end
      formatted_records += "</tr>"
      counter += 1
      if counter % @@recordsPerTable == 0
	formatted_records = formatted_records + formatted_headers
      end
    end
    formatted_records += "</table>"
    
    # Combine HTML formatted headers to HTML formatted records.
    formatted_final = "<table>"
    formatted_final = formatted_final + formatted_headers + formatted_records
    return formatted_final
  end # end scrape_site
  
  def search(crn, subj, crs, sec, title, ch, max, enr, avail, wl, days, stime, etime, bldgroom, wk, instructor, ef, starts, searchType)
     # Loop variables
	 x = 0
	 # String to hold the value that is passed when a text form is returned with no value.
	 nilString = "\"\""
	 
	 # Add HTML formatting to headers.
     formatted_headers = "<table><tr class='table_header'>"
		for element in @@headers
			formatted_headers += "<td>" + element + "</td>"
		end #end for
    formatted_headers += "</tr>"
    
	# Searches through records for matches and then adds HTML formatting.
	formatted_records = ""
	# Inclusive search. Returns records that match ANY of the search criteria.
	# If ANY of the columns in the record matches the search criteria for that 
	# column AND the criteria for that column is not nil AND the column's value is not nil
	# the record is selected and HTML formatting is added.
    if searchType == "0"
      while x < @@numRecords
	if @@records[x][0] == crn && crn.inspect != @@nilReturn && @@records[x][0].inspect != @@nilReturn ||
	    @@records[x][1].downcase.index(subj.downcase) != nil && subj.inspect != @@nilReturn && @@records[x][1].inspect != @@nilReturn ||
	    @@records[x][2].downcase.index(crs.downcase) != nil && crs.inspect != @@nilReturn && @@records[x][2].inspect != @@nilReturn ||
	    @@records[x][3].downcase.index(sec.downcase) != nil && sec.inspect != @@nilReturn && @@records[x][3].inspect != @@nilReturn ||
	    @@records[x][4].downcase.index(title.downcase) != nil && title.inspect != @@nilReturn && @@records[x][4].inspect != @@nilReturn ||
	    @@records[x][5] == ch && ch.inspect != @@nilReturn && @@records[x][5].inspect != @@nilReturn ||
	    @@records[x][6] == max && max.inspect != @@nilReturn && @@records[x][6].inspect != @@nilReturn ||
	    @@records[x][7] == enr && enr.inspect != @@nilReturn && @@records[x][7].inspect != @@nilReturn ||
	    @@records[x][8] == avail && avail.inspect != @@nilReturn && @@records[x][8].inspect != @@nilReturn ||
	    @@records[x][9] == wl && wl.inspect != @@nilReturn && @@records[x][9].inspect != @@nilReturn ||
	    @@records[x][10].downcase.index(days.downcase) != nil && @@records[x][10].inspect != @@nilReturn && days.inspect != @@nilReturn ||
	    @@records[x][11].downcase.index(stime.downcase) != nil && @@records[x][11].inspect != @@nilReturn && stime.inspect != @@nilReturn ||
	    @@records[x][12].downcase.index(etime.downcase) != nil && etime.inspect != @@nilReturn && @@records[x][12].inspect != @@nilReturn ||
	    @@records[x][13].downcase.index(bldgroom.downcase) != nil && bldgroom.inspect != @@nilReturn && @@records[x][13].inspect != @@nilReturn ||
	    @@records[x][14].downcase.index(wk.downcase) != nil && wk.inspect != @@nilReturn && @@records[x][14].inspect != @@nilReturn ||
	    @@records[x][15].downcase.index(instructor.downcase) != nil && instructor.inspect != @@nilReturn && @@records[x][15].inspect != @@nilReturn ||
	    @@records[x][16].downcase.index(ef.downcase) != nil && ef.inspect != @@nilReturn && @@records[x][16].inspect != @@nilReturn ||
	    @@records[x][17].downcase.index(starts.downcase) != nil && starts.inspect != @@nilReturn && @@records[x][17].inspect != @@nilReturn
	  formatted_records += "<tr>"
	  for column in @@records[x]
	    formatted_records += "<td>"+ column + "</td>"
	  end #end for
	  formatted_records += "</tr>"
	end # end if
	x+=1
      end # end while
    elsif searchType == "1"
      while x < @@numRecords
		# Exclusive search. Returns records that match ALL of the search criteria.
		# If ALL of the columns in the record match the search criteria for that column
		# AND the criteria for that record is not nil the record is sleected and HTML formatting is added.
		if (@@records[x][0] == crn || crn.inspect == @@nilReturn) &&
		(@@records[x][1].downcase.index(subj.downcase) != nil || subj.inspect == @@nilReturn) &&
		(@@records[x][2].downcase.index(crs.downcase) != nil || crs.inspect == @@nilReturn) &&
		(@@records[x][3].downcase.index(sec.downcase) != nil || sec.inspect == @@nilReturn) &&
		(@@records[x][4].downcase.index(title.downcase) != nil || title.inspect == @@nilReturn) &&
		(@@records[x][5] == ch || ch.inspect == @@nilReturn) &&
		(@@records[x][6] == max || max.inspect == @@nilReturn) &&
		(@@records[x][7] == enr || enr.inspect == @@nilReturn) &&
		(@@records[x][8] == avail || avail.inspect == @@nilReturn) &&
		(@@records[x][9] == wl || wl.inspect == @@nilReturn) &&
		(@@records[x][10].downcase.index(days.downcase) != nil || days.inspect == @@nilReturn) &&
		(@@records[x][11].downcase.index(stime.downcase) != nil || stime.inspect == @@nilReturn) &&
		(@@records[x][12].downcase.index(etime.downcase) != nil || etime.inspect == @@nilReturn) &&
		(@@records[x][13].downcase.index(bldgroom.downcase) != nil || bldgroom.inspect == @@nilReturn) &&
		(@@records[x][14].downcase.index(wk.downcase) != nil || wk.inspect == @@nilReturn) &&
		(@@records[x][15].downcase.index(instructor.downcase) != nil || instructor.inspect == @@nilReturn) &&
		(@@records[x][16].downcase.index(ef.downcase) != nil || ef.inspect == @@nilReturn) &&
		(@@records[x][17].downcase.index(starts.downcase) != nil || starts.inspect == @@nilReturn)
		formatted_records += "<tr>"
		for column in @@records[x]
		formatted_records += "<td>"+ column + "</td>"
		end #end for
		formatted_records += "</tr>"
		end # end if
		x+=1
      end # end while
    else
      #nothing
    end
  
  # Close out the table tag and add HTML formatted headers to HTML formatted records.
  formatted_records += "</table>"
  formatted_final = formatted_headers + formatted_records
  
  # Return an error message if no results are found. Else return the results.
  if formatted_records == "</table>"
    return "No records found that match your search."
  else
    return formatted_final
  end
end #end method

end