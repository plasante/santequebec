namespace :db do
  desc "Fill the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_examinations
  end
end

def make_users
  admin = User.create!(:first_name => "Pierre",
                       :last_name  => "Lasante",
                       :email      => "plasante@admin.com",
                       :password   => "123456",
                       :password_confirmation => "123456")
  admin.toggle!(:admin)
  User.create!(:first_name => "Pierrot",
               :last_name  => "Lasante",
               :email      => "pierrot@email.com",
               :password   => "123456",
               :password_confirmation => "123456")
  98.times do |n|
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

def make_examinations
  33.times do
    Examination.create!(:study    => "KNEE",
                        :name     => Faker::Name.name,
                        :voltage  => "120",
                        :current  => "10",
                        :exposure => "1")
  end
end