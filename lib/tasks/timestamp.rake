namespace :util  do
	desc "Add deployment timestamp"
	task :generate_timestamp => :environment do
		File.open('./config/initializers/timestamp.rb','w') do |f|
			f << "Medicsbay::Application.config.deployment_datetime = '#{Time.now.strftime("%Y-%b-%d %H:%M:%S")}'";
			f.close
		end
	end
end
	
