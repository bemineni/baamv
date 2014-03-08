require 'csv'
namespace :util  do
	desc "Rake task to generate cities from the google Adwords csv list https://developers.google.com/adwords/api/docs/appendix/geotargeting."
	task :generate_cities_csv  do
    if(File.file?("./cities.csv"))
    	puts "Please see that the cities csv file is there in the current directory"
    	return
    end
    puts "Starting to read CSV"
    refdirectory = File.dirname(__FILE__)
    filehash = {}
    CSV.foreach(File.expand_path('../../db/data_files/US/US.csv',refdirectory), headers: :first_row) do |line|
    	filehash[line['Name'].strip] = File.open(File.expand_path('../../db/data_files/US/'+ line['StateCode'].strip + '.csv',refdirectory),'w') 
        filehash[line['Name'].strip] << "Name\n"
    	
    end
    CSV.foreach(File.expand_path('./cities.csv',refdirectory), headers: :first_row) do |cityline|
    	cityname,state,country=cityline['Canonical Name'].chomp.split(",")
    	cityname1,add1,state1,country1=cityline['Canonical Name'].chomp.split(",")
    	if country1
    		state = state1
    	end
    	puts cityline['Canonical Name']
    	filetowrite = filehash[state.strip]
    	if filetowrite
          filetowrite << '"' + cityline['Name'].strip + '"'+ "\n"
        else
        	puts "Unable to find state for " +  state.strip
    	end
    end

	end
end
