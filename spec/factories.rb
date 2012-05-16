FactoryGirl.define do

  factory :team, class: Wildcat::Team do
    name          { Forgery.dictionaries[:team_names].sample }
    nickname      { name.split(' ').last }
    abbreviation  { Forgery.dictionaries[:team_abbreviations].sample }
    location      { "#{Forgery(:address).city}, #{Forgery(:address).state_abbrev}" }
    conference    { %w(AFC NFC).sample }
    division      { %w(North South East West).sample }
  end

  factory :game, class: Wildcat::Game do
    label         { "#{Forgery.dictionaries[:team_names].sample.split(' ').last} at #{Forgery.dictionaries[:team_names].sample.split(' ').last}" }
    season        { Forgery(:date).year }
    stadium       { "#{Forgery.dictionaries[:team_names].sample.split(' ').last} #{%w(Field Stadium Park Dome Coliseum).sample}" }
    week          nil
    home_team_id  SecureRandom.random_number(1e2.to_i)
    away_team_id  SecureRandom.random_number(1e2.to_i)
    played_at     nil
  end
end
