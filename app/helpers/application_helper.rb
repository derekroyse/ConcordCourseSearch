module ApplicationHelper
  require 'mysql'
  
  # Class variables
  @@choice = 201501
  @@headers = ['CRN', 'SUBJ', 'CRS', 'SEC', 'TITLE', 'CH', 'MAX', 'ENR',
               'AVAIL', 'WL', 'DAYS', 'STIME', 'ETIME', 'BLDG/ROOM', 'WK', 
               'INSTRUCTOR', 'EF', 'STARTS']
  @@conversion = Array.new(18)
  @@numRecords = 0
  @@nilReturn = "\"\""
  @@recordsPerTable = 54
  @@currentArray = [['Fall Semester 2014', 201501], ['Second Summer Term 2014', 201405 ], 
                    ['First Summer Term 2014', 201404], ['Summer Intersession 2014', 201403], 
                    ['Spring Semester 2014', 201402]]
  @@semesterArray = [['Select a Semester', 201501], 	  ['Fall Semester 2014', 201501],
		    ['Second Summer Term 2014', 201405 ], ['First Summer Term 2014', 201404],  
		    ['Summer Intersession 2014', 201403], ['Spring Semester 2014', 201402],  
		    ['Fall Semester 2013', 201401], 	  ['Graduate Summer Term 2013', 201306],  
		    ['Second Summer Term 2013', 201305],  ['First Summer Term 2013', 201304], 
		    ['Summer Intersession 2013', 201303], ['Spring Semester 2013', 201302],  
		    ['Fall Semester 2012', 201301],	  ['Full Summer Term 2012', 201207],
		    ['Graduate Summer Term 2012', 201206],['Second Summer Term 2012', 201205], 
		    ['First Summer Term 2012', 201204],   ['Summer Intersession 2012', 201203],
		    ['Spring Semester 2012', 201202],     ['Fall Semester 2011', 201201],  
		    ['Full Summer Term 2011', 201107],	  ['Graduate Summer Term 2011', 201106],  
		    ['Second Summer Term 2011', 201105],  ['First Summer Term 2011', 201104],  
		    ['Summer Intersession 2011', 201103], ['Spring Semester 2011', 201102],  
		    ['Fall Semester 2010', 201101],  	  ['Full Summer Term 2010', 201007], 
		    ['Graduate Summer Term 2010', 201006],['Second Summer Term 2010', 201005],  
		    ['First Summer Term 2010', 201004],   ['Summer Intersession 2010', 201003],  
		    ['Spring Semester 2010', 201002],     ['Fall Semester 2009', 201001],  
		    ['Full Summer Term 2009', 200907],	  ['Graduate Summer Term 2009', 200906],  
		    ['Second Summer Term 2009', 200905],  ['First Summer Term 2009', 200904],  
		    ['Summer Intersession 2009', 200903], ['Spring Semester 2009', 200902], 
		    ['Fall Semester 2008', 200901],	  ['Beckley Summer Term 2008', 200807],  
		    ['Graduate Summer Term 2008', 200806],['Second Summer Term 2008', 200805],  
		    ['First Summer Term 2008', 200804],   ['Summer Intersession 2008', 200803],  
		    ['Spring Semester 2008', 200802],	  ['Fall Semester 2007', 200801], 
		    ['Graduate Summer Term 2007', 200706],['Second Summer Term 2007', 200705],  
		    ['First Summer Term 2007', 200704],   ['Summer Intersession 2007', 200703],  
		    ['Spring Semester 2007', 200702],     ['Fall Semester 2006', 200701],  
		    ['Graduate Summer Term 2006', 200606],['Second Summer Term 2006', 200605],  
		    ['First Summer Term 2006', 200604],   ['Summer Intersession 2006', 200603],  
		    ['Spring Semester 2006', 200602],  	  ['Fall Semester 2005', 200601],  
		    ['Graduate Summer Term 2005', 200506],['Second Summer Term 2005', 200505],  
		    ['First Summer Term 2005', 200504],	  ['Summer Intersession 2005', 200503],  
		    ['Spring Semester 2005', 200502], 	  ['Fall Semester 2004', 200501],  
		    ['Graduate Summer Term 2004', 200406],['Second Summer Term 2004', 200405],  
		    ['First Summer Term 2004', 200404],   ['Summer Intersession 2004', 200403],  
		    ['Spring Semester 2004', 200402],     ['Fall Semester 2003', 200401],  
		    ['Second Summer Term 2003', 200305],  ['First Summer Term 2003', 200304],  
		    ['Summer Intersession 2003', 200303], ['Spring Semester 2003', 200302],  
		    ['Fall Semester 2002', 200301],	  ['Second Summer Term 2002', 200205],  
		    ['First Summer Term 2002', 200204],   ['Summer Intersession 2002', 200203],  
		    ['Spring Semester 2002', 200202],	  ['Fall Semester 2001', 200201],  
		    ['Second Summer Term 2001', 200105],  ['First Summer Term 2001', 200104],  
		    ['Summer Intersession 2001', 200103], ['Spring Semester 2001', 200102],  
		    ['Fall Semester 2000', 200101],  	  ['Second Summer Term 2000', 200005],  
		    ['First Summer Term 2000', 200004],	  ['Summer Intersession 2000', 200003],  
		    ['Spring Semester 2000', 200002],     ['Fall Semester 1999', 200001]]
  
  def getSemesterArray()
    return @@semesterArray
  end
   
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

  # Scrape Concord's website for class data on all semesters.
  def get_data()
    # Connect to database.
    #dbconfig = YAML::load_file('config/database.yml')["development"]
	dbconfig = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
    connection = Mysql2::Client.new(:host => dbconfig['host'], :username => dbconfig['username'], 
                                    :password => dbconfig['password'], :database => dbconfig['database'])

    # Setup the target website
    agent = Mechanize.new
    agent.read_timeout=60
    data = agent.get('https://apps.concord.edu/schedules/seatstaken.php')
    select_list = data.form_with(:action => '/schedules/seatstaken.php')
 
  begin
     # Grab raw data from website for each semester in the semester array.
    @@semesterArray.each do |row|
      # Loop variable.
      i = 0
      
      # Get data.
      select_list.field_with(:name =>"term").value = row[1]
      data = agent.submit(select_list)
      rows = data.search("td")
      @@numRecords = (rows.length/18)-(rows.length/900)-1
   
      # Drop old table and create new table.
      queryString = "DROP TABLE IF EXISTS SEMESTER" + row[1].to_s
      connection.query(queryString)
      queryString = "CREATE TABLE IF NOT EXISTS \ SEMESTER" + row[1].to_s + "(
                      CRN INT PRIMARY KEY, SUBJ VARCHAR(5), CRS VARCHAR(5),	
                      SEC VARCHAR(5), TITLE VARCHAR(50), CH INT,	
                      MAX INT, ENR INT, AVAIL INT, WL INT, DAYS VARCHAR(10), 
                      STIME VARCHAR(5), ETIME VARCHAR(5), ROOM VARCHAR(20), 
                      WK INT, INSTRUCTOR VARCHAR(20), EF VARCHAR(10), STARTSON VARCHAR(20))"
      connection.query(queryString)
      
    # Insert rows of data into database
    while i < rows.length
      if i < 46
	i += 1
      elsif (i-28) % 918 <= 17
	i += 1
      else
	x = 0
	while x < 18
	  if rows[i+x] == nil
	    @@conversion[i+x] = "ERROR!"
	  else
	    @@conversion[i+x] = rows[i+x].text.gsub(/[']/, "\\\\\'")
	  end
	  x+=1
	end
	    queryString3 = "INSERT IGNORE INTO SEMESTER" + row[1].to_s + "(CRN, SUBJ, CRS, SEC, TITLE, CH, MAX, ENR,
			    AVAIL, WL, DAYS, STIME, ETIME, ROOM, WK, INSTRUCTOR, EF, STARTSON)
	                    VALUES(" + @@conversion[i] + ",'" + @@conversion[i+1] + "','" + 
			    @@conversion[i+2] + "','" +	@@conversion[i+3] + "','" + 
			    @@conversion[i+4] + "'," + @@conversion[i+5] + "," + 
			    @@conversion[i+6] + "," + @@conversion[i+7] + "," + 
			    @@conversion[i+8] + "," + @@conversion[i+9] + ",'" + 
			    @@conversion[i+10] + "','" + @@conversion[i+11] + "','" + 
			    @@conversion[i+12] + "','" + @@conversion[i+13] + "'," + 
			    @@conversion[i+14] + ",'" + @@conversion[i+15] + "','" + 
			    @@conversion[i+16] + "','" + @@conversion[i+17] + "')"
	    connection.query(queryString3)
	  i+=17
      end # end if/else
      i+=1
    end # end while
  end # end semester loop
  rescue Mysql::Error => e
    #nothing
  ensure
    connection.close if connection
  end # end begin/rescue
   
  end # end get_data function
  
  # Query database and return data on a selected semester.
  def query_data()
  
    begin    
      dbconfig = YAML::load_file('config/database.yml')["development"]
      connection = Mysql2::Client.new(:host => dbconfig['host'], :username => dbconfig['username'], 
                                      :password => dbconfig['password'], :database => dbconfig['database'])
      queryString = "SELECT * FROM SEMESTER" + @@choice.to_s 
      rs = connection.query(queryString)
    
     rescue Mysql::Error => e
       #nothing
     ensure
       connection.close if connection
     end
    
     return rs
  end

  def clean_input(array)
    i = 0
    while i < array.length
      if array[i].inspect == @@nilReturn
	array[i] = -99
      end
      i+=1
    end #end loop
      
    return array
  end # end clean_input method

  def search_query(inputArray)
    
    # Clean array to prevent SQL injection and other bad input.
    cleanArray = clean_input(inputArray)
    
    begin
      # Connect to database.
      dbconfig = YAML::load_file('config/database.yml')["development"]
      connection = Mysql2::Client.new(:host => dbconfig['host'], 
                                      :username => dbconfig['username'], 
				      :password => dbconfig['password'], 
                                      :database => dbconfig['database'])
      # Inclusive Search
      # Maybe do a conditional here: if search = exclusive, a string is set to 
      # "AND", if inclusive it's set to "OR" then build the queryString with 
      # the string variable in place and just change the string based on the user's input.
      choiceString = @@choice.to_s
      queryString = "SELECT * 
		      FROM SEMESTER#{choiceString} 
		      WHERE CRN = #{cleanArray[0]}
		      OR SUBJ = '#{cleanArray[1]}' 
		      OR CRS = '#{cleanArray[2]}' 
		      OR SEC = '#{cleanArray[3]}' 
		      OR TITLE = '#{cleanArray[4]}' 
		      OR CH = #{cleanArray[5]} 
		      OR MAX = #{cleanArray[6]}
		      OR ENR = #{cleanArray[7]} 
		      OR AVAIL = #{cleanArray[8]} 
		      OR WL = #{cleanArray[9]}
		      OR DAYS = '#{cleanArray[10]}' 
		      OR STIME = '#{cleanArray[11]} 
		      OR ETIME = '#{cleanArray[12]}
		      OR ROOM = '#{cleanArray[13]}' 
		      OR WK = #{cleanArray[14]} 
		      OR INSTRUCTOR = '#{cleanArray[15]}'
		      OR EF = '#{cleanArray[16]}' 
		      OR STARTSON = '#{cleanArray[17]}'"
      rs = connection.query(queryString)
    rescue Mysql::Error => e
      # nothing
    ensure
      connection.close if connection
    end # end rescue/ensure
     
     return rs
    
  end # end search_query method
  
  def print_header()
	formatted_headers = "<tr class='table_header'>"
		for element in @@headers
			formatted_headers += "<td>" + element + "</td>"
		end #end for
	formatted_headers += "</tr>"
    return formatted_headers
  end
  
  # DEPRECATED
  def search(crn, subj, crs, sec, title, ch, max, enr, avail, wl, days, stime, etime, bldgroom, wk, instructor, ef, starts, searchType)
	# Loop variables
	x = 0
	 
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

end #end module
