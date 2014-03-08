namespace :data do
  desc "generate lots of data to test views"
  task :dev_seeds, [:user_count, :posts_per_user, :state , :city] => :environment do |t, args|
    user_count = args[:user_count].nil? ? 10 : args[:user_count].to_i
    posts_per_user = args[:posts_per_user].nil? ? 10 : args[:posts_per_user].to_i

    #open file
    path = File.expand_path('./lib/mocktext.txt')
    File.open(path) do |f|

      user_count.times do |user_num|
        userstate = State.first(order: "RAND()")
        usercity = userstate.cities.first(order: "RAND()")
        user = User.create(name: "Bob#{user_num} Bobson", email: "test#{user_num}@test.com", password: "test", password_confirmation: "test", 
                           city_id: usercity.id , state_id: userstate.id )
        user.activate!
        
        posts_per_user.times do |post_num|
          category = Category.first(conditions: "parent_id IS NOT NULL", order: "RAND()")
          state = State.find_by_name args[:state]
          state = State.first(order: "RAND()") if state.nil?
          city = state.cities.find_by_name args[:city]
          city = state.cities.first(order: "RAND()") if city.nil?
             
          today = Date.current

          #get post content
          para, line, countpara = "", "", 0

          while line = f.gets
            para += line

            countpara += 1 if line == "\n" 
            
            break if countpara == 2     
          end
          if line == nil
            #go to beginning of file if we run out of content
            f.rewind
          end
          puts category.name

          params = {
            title: "#{category.name} #{post_num}", 
            content: para, 
            category_id: category.id, 
            event_start: today + 1.months, 
            event_end: today + 2.months, 
            listing_end_date: today + 2.months,
            city_id: city.id,
            state_id: state.id
          }
          if category.has_profession
            profession = Profession.first(order: "RAND()")
            params[:profession_root_id] = profession.id
          end
          if category.has_specialty
            specialty = Specialty.first(order: "RAND()")
            params[:specialty_id] = specialty.id
          end
          listing = user.ad_listings.create(params)
          listing.pay!
        end
      end
    end
  end
  
  task :clean => :environment do
    ActiveRecord::Base.establish_connection
    %w(users ad_listings).each do |table|
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table}") rescue ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
    end
  end
end