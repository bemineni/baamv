require 'csv'
namespace :util  do
	desc "Rake task to clean all the database records"
	task :clean_database => :environment do 
		ActiveRecord::Base.establish_connection
		%w(ad_listings users messages cities photos categories listing_payments payments professions specialties states).each do |table|
           ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table}") rescue ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
		end
	end
	desc "Rake task to clean individual table"
	task :clean_table, [:table_name] => :environment do |t,args|
		ActiveRecord::Base.establish_connection
		ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{args[:table_name]}") rescue ActiveRecord::Base.connection.execute("DELETE FROM #{args[:table_name]}")
	end	
end