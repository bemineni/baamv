# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)



# Lets add all the Countries that we support

Country.delete_all
State.delete_all

CONFIG="./baamvConfig/"

File.open( CONFIG + "Countries.txt") do |countryfile|
   while(line = countryfile.gets)
      code,country=line.chomp.split("|")
      cobj = Country.create(:name => country, :code => code)

#     We inserted the country now lets add the related states or provinces for this country
      statefilename = CONFIG + code + ".txt"
      if File.file?(statefilename) then
          File.open( statefilename ) do |statefile|
              while(sline = statefile.gets )
                statecode,state = sline.chomp.split("|")
                cobj.states.create!(:name => state, :code => statecode)
              end
          end
      end

   end
end






