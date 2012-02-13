Factory.define :user do |user|
    user.first_name            "Pierre"
    user.last_name             "Lasante"
    user.email                 "plasante@email.com"
    user.password              "179317"
    user.password_confirmation "179317"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :examination do |examination|
  examination.study    "KNEE"
  examination.name     "Anonymized"
  examination.voltage  "120"
  examination.current  "10"
  examination.exposure "1"
end