FactoryGirl.define do
  factory :user do
    login 'squid'
    email 'squidlover@bhalash.com'
    nicename 'Squid Lover'
    password 'squidloverhothot'
    password_confirmation 'squidloverhothot'
  end
end
