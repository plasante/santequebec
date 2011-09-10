namespace :db do
  desc "Fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:first_name => "Pierre",
                         :last_name  => "Lasante",
                         :email      => "plasante@email.com",
                         :password   => "123456",
                         :password_confirmation => "123456")
    admin.toggle!(:admin)
    99.times do |n|
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      email      = "example-#{n+1}@example.org"
      password   = "password"
      User.create!(:first_name => first_name,
                   :last_name  => last_name,
                   :email      => email,
                   :password   => password,
                   :password_confirmation => password)
    end
  end
end
