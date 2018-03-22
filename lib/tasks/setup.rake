# frozen_string_literal: true
require 'csv'
desc "Ensure that code is not running in production environment"
task :not_production do
  if Rails.env.production? && ENV["DELETE_PRODUCTION_DATA"].blank?
    puts ""
    puts "*" * 50
    puts "Deleting production data is not allowed. "
    puts "If you really want to delete all production data and populate sample data then "
    puts "you can execute following command."
    puts "DELETE_PRODUCTION_DATA=1 rake setup_sample_data"
    puts " "
    puts "If you are using heroku then execute command as shown below"
    puts "heroku run rake setup_sample_data DELETE_PRODUCTION_DATA=1 -a app_name"
    puts "*" * 50
    puts ""
    throw :error
  end
end

desc "Sets up the project by running migration and populating sample data"
task setup: [:environment, :not_production, "db:drop", "db:create", "db:migrate"] do
  ["setup_sample_data"].each { |cmd| system "rake #{cmd}" }
end

def delete_all_records_from_all_tables
  ActiveRecord::Base.connection.schema_cache.clear!

  Dir.glob(Rails.root + "app/models/*.rb").each { |file| require file }

  ApplicationRecord.descendants.each do |klass|
    klass.reset_column_information
    klass.delete_all
  end
end

desc "Deletes all records and populates sample data"
task setup_sample_data: [:environment, :not_production] do
  delete_all_records_from_all_tables

  create_user email: "sam@example.com"
  import_data
  puts "sample data was added successfully"
end

def create_user(options = {})
  user_attributes = { email: "sam@example.com",
                      password: "welcome",
                      first_name: "Sam",
                      last_name: "Smith",
                      role: "super_admin" }
  attributes = user_attributes.merge options
  User.create! attributes
end

def import_data
csv_text = File.read("/home/pvsukale/wheel/lib/tasks/final-data.csv")
csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
csv.each do |row|
  if !Branch.exists?(:name => row['branch'])
  
   puts row['branch']
   branch = Branch.create!(name: row['branch'])
  end


  if !College.exists?(:name => row['name'])
    puts row['name']
    college = College.create!(name: row['name'] , naac: rand(1..8))
   end
   

   if !Cutoff.exists?(college: college, branch: branch)
    r_college = College.find_by(name: row['name'])
    r_branch = Branch.find_by(name: row['branch'] )
    score_string = row['rank'].split(" ")
    rank  = score_string[0].to_i
    cutoff = Cutoff.create!(college: r_college, branch: r_branch, rank: rank)
   end
  end
   csv.each do |row|
  
    branch = Branch.find_by(name: row['branch'])
    college = College.find_by(name: row['name'])
    cutoff = Cutoff.find_by(college: college, branch: branch)
    max_rank_cutoff = Cutoff.where(branch: branch).maximum("rank")
    current_cutoff = Cutoff.find_by(branch: branch, college: college)
    current_rank = current_cutoff.rank
    current_rank = current_rank.to_f
    max_rank_cutoff = max_rank_cutoff.to_f
    total_colleges = College.count
    below_current = College.where("naac < ?", college.naac).count
    naac_percetile = ( below_current.to_f / total_colleges.to_f ) * 100
    
    if max_rank_cutoff != current_rank
    final_score = ( (max_rank_cutoff - current_rank) / max_rank_cutoff  ) * 100
    else
    final_score = 1
    end
    ultimate_score =  ( final_score ** 0.5 )    * ( naac_percetile ** 0.5 )
    puts final_score
    Score.create!(college: college , branch: branch, rankk_percentile: final_score, naac_percetile: naac_percetile , final_score: ultimate_score , rank: cutoff.rank )
   end
end

  
 



  
