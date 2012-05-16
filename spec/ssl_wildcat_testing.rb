require 'rubygems'
require 'typhoeus'
require 'json'
require 'ap'
require 'wildcat'
require 'test/unit'

class SslWildcatTest < Test::Unit::TestCase

  def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
  end

  def red(text); colorize(text, "\e[31m"); end
  def green(text); colorize(text, "\e[32m"); end

  def message(response, resource=nil)
    if response.code == 200
      green("OK on #{resource}")
    else
      red("FAIL on #{resource}")
    end
  end

  HYDRA = Typhoeus::Hydra.new(max_concurrency: 20)
  Wildcat::Config.hydra = HYDRA
  Wildcat::Config.host = "pro-football-api.herokuapp.com"
  Wildcat::Config.auth_token = "YLXgq4vhppyyous1Pp47"
  Wildcat::Config.timeout = 10000

  def test_team_show
    show_team_request = Typhoeus::Request.new("https://#{Wildcat::Config.host}/api/v1/" +
                                        "teams/1?auth_token=#{Wildcat::Config.auth_token}",
                                        { method: :get,
                                         timeout: Wildcat::Config.timeout,
                                         headers: {:Accept => "application/json", "Content-Type" => "application/json"} })
    show_team_request.on_complete do |response|
      assert response.code == 200, message(response, "team show")
    end
    Wildcat::Config.hydra.queue(show_team_request)
    Wildcat::Config.hydra.run
  end

  def test_team_index
    teams_index_request = Typhoeus::Request.new("https://#{Wildcat::Config.host}/api/v1/" +
                                        "teams?auth_token=#{Wildcat::Config.auth_token}",
                                        { method: :get,
                                         timeout: Wildcat::Config.timeout,
                                         headers: {:Accept => "application/json", "Content-Type" => "application/json"} })
    teams_index_request.on_complete do |response|
      assert response.code == 200, message(response, "teams index")
    end
    Wildcat::Config.hydra.queue(teams_index_request)
    Wildcat::Config.hydra.run
  end

  def test_game_show
    show_game_request = Typhoeus::Request.new("https://#{Wildcat::Config.host}/api/v1/" +
                                        "games/234?auth_token=#{Wildcat::Config.auth_token}",
                                        { method: :get,
                                         timeout: Wildcat::Config.timeout,
                                         headers: {:Accept => "application/json", "Content-Type" => "application/json"} })
    show_game_request.on_complete do |response|
      assert response.code == 200, message(response, "game show")
    end
    Wildcat::Config.hydra.queue(show_game_request)
    Wildcat::Config.hydra.run
  end

  def test_games_index
    games_index_request = Typhoeus::Request.new("https://#{Wildcat::Config.host}/api/v1/" +
                                        "games?auth_token=#{Wildcat::Config.auth_token}",
                                        { method: :get,
                                         timeout: Wildcat::Config.timeout,
                                         headers: {:Accept => "application/json", "Content-Type" => "application/json"} })
    games_index_request.on_complete do |response|
      assert response.code == 200, message(response, "games index")
    end
    Wildcat::Config.hydra.queue(employers_index_request)
    Wildcat::Config.hydra.run
  end

  def test_schedule
    schedule_request = Typhoeus::Request.new("https://#{Wildcat::Config.host}/api/v1/" +
                                        "schedule?auth_token=#{Wildcat::Config.auth_token}",
                                        { method: :get,
                                         timeout: Wildcat::Config.timeout,
                                         headers: {:Accept => "application/json", "Content-Type" => "application/json"} })
    schedule_request.on_complete do |response|
      assert response.code == 200, message(response, "schedule")
    end
    Wildcat::Config.hydra.queue(schedule_request)
    Wildcat::Config.hydra.run
  end
end
