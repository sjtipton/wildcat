module HydraSpecHelper

  def stub_hydra
    hydra = Typhoeus::Hydra.new(max_concurrency: 20)
    Wildcat::Config.stub(:hydra) { hydra }
  end

  def stub_for_team_index(teams)
    Wildcat::Config.hydra.stub(:get,
                          "#{Wildcat::Config.base_url}/teams?" +
                          "auth_token=#{Wildcat::Config.auth_token}").
                          and_return(Typhoeus::Response.new({ code: 200,
                                                              headers: "",
                                                              body: teams.to_json,
                                                              time: 0.3 }))
  end

  def stub_for_game_index(games, opts={})
    opts.symbolize_keys!
    params = opts.reject { |k,v| v.blank? }
    query_params = { auth_token: Wildcat::Config.auth_token }.merge(params).to_param

    Wildcat::Config.hydra.stub(:get,
                          "#{Wildcat::Config.base_url}/games?#{query_params}").
                          and_return(Typhoeus::Response.new({ code: 200,
                                                              headers: "",
                                                              body: games.to_json,
                                                              time: 0.3 }))
  end

  def stub_for_team_game_index(games)
    Wildcat::Config.hydra.stub(:get,
                          "#{Wildcat::Config.base_url}/teams/#{games.first.home_team_id}" +
                          "/games?auth_token=#{Wildcat::Config.auth_token}").
                          and_return(Typhoeus::Response.new({ code: 200,
                                                              headers: "",
                                                              body: games.to_json,
                                                              time: 0.3 }))
  end

  def stub_for_show_team(team)
    Wildcat::Config.hydra.stub(:get,
                          "#{Wildcat::Config.base_url}/teams/#{team.id}?" +
                          "auth_token=#{Wildcat::Config.auth_token}").
                          and_return(Typhoeus::Response.new({ code: 200,
                                                              headers: "",
                                                              body: team.to_json,
                                                              time: 0.3 }))
  end

  def stub_for_show_game(game)
    Wildcat::Config.hydra.stub(:get,
                          "#{Wildcat::Config.base_url}/games/#{game.id}?" +
                          "auth_token=#{Wildcat::Config.auth_token}").
                          and_return(Typhoeus::Response.new({ code: 200,
                                                              headers: "",
                                                              body: game.to_json,
                                                              time: 0.3 }))
  end

  def stub_for_get_url(url, response_hash)
    response = Typhoeus::Response.new(response_hash.merge(headers: "", time: 0.3))
    Wildcat::Config.hydra.stub(:get, url).and_return(response)
  end

  def clear_get_stubs
    Wildcat::Config.hydra.clear_stubs
  end
end
