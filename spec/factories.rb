FactoryGirl.define do

  factory :team, class: Wildcat::Team do
    name          { ["Baltimore Ravens", "Carolina Panthers"].sample }
    nickname      { name.split(' ').last }
    abbreviation  { ["BAL", "CAR"].sample }
    location      { "#{Forgery(:address).city}, #{Forgery(:address).state_abbrev}" }
    conference    { %w(AFC NFC).sample }
    division      { %w(North South East West).sample }
  end

  factory :game, class: Wildcat::Game do
    label         { "Ravens at Panthers" }
    season        { Forgery(:date).year }
    stadium       { "Bank of America Stadium" }
    week          nil
    home_team_id  SecureRandom.random_number(1e2.to_i)
    away_team_id  SecureRandom.random_number(1e2.to_i)
    played_at     nil
  end
end
