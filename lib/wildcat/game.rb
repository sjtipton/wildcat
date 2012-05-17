class Wildcat::Game
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  self.include_root_in_json = false

  ATTRIBUTES = [ :id,
                 :away_team_id,
                 :home_team_id, 
                 :label, 
                 :played_at, 
                 :season,
                 :stadium,
                 :week ]

  attr_accessor *ATTRIBUTES

  validates :away_team_id, :home_team_id, :label, :season, :stadium,
            presence: true

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes
    ATTRIBUTES.inject(ActiveSupport::HashWithIndifferentAccess.new) do |result, key|
      result[key] = read_attribute_for_validation(key)
      result
    end
  end

  def attributes=(attrs)
    attrs.each_pair do |k, v|
      if "#{k}" == "source_id"
        send("#{k}=", v.to_i)
      else
        send("#{k}=", v)
      end
    end
  end

  def read_attribute_for_validation(key)
    send(key)
  end

  def self.find(id)
    request = Typhoeus::Request.new( Wildcat::Config.base_url +
                                      "/games/#{id}?auth_token=#{Wildcat::Config.auth_token}",
                                      { method: :get,
                                      timeout: Wildcat::Config.timeout,
                                      headers: {:Accept => "application/json", "Content-Type" => "application/json"} })

    request.on_complete do |response|
      if response.code == 200
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        yield new(id: parsed[:id],
        away_team_id: parsed[:away_team_id],
        home_team_id: parsed[:home_team_id],
               label: parsed[:label],
           played_at: parsed[:played_at],
              season: parsed[:season],
             stadium: parsed[:stadium],
                week: parsed[:week])
      elsif response.code == 404
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        raise Wildcat::ResourceNotFound.new(*parsed[:errors])
      elsif response.code == 401
        raise Wildcat::UnauthorizedAccess.new
      elsif (500..599).cover? response.code
        raise Wildcat::ServiceUnavailable.new
      else
        raise Wildcat::Error.new(Wildcat::Error::GENERAL_ERROR,
                                { error: response.curl_error_message })
      end
    end

    Wildcat::Config.hydra.queue(request)
  end

  def self.all
    request = Typhoeus::Request.new( Wildcat::Config.base_url +
                                      "/games?auth_token=#{Wildcat::Config.auth_token}",
                                      { method: :get,
                                      timeout: Wildcat::Config.timeout,
                                      headers: {:Accept => "application/json", "Content-Type" => "application/json"} })

    request.on_complete do |response|
      if response.success?
        games = []
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        parsed.each do |result|
          games << new(id: result[:id],
             away_team_id: result[:away_team_id],
             home_team_id: result[:home_team_id],
                    label: result[:label],
                played_at: result[:played_at],
                   season: result[:season],
                  stadium: result[:stadium],
                     week: result[:week])
        end
        yield games
      elsif response.code == 401
        raise Wildcat::UnauthorizedAccess.new
      elsif (500..599).cover? response.code
        raise Wildcat::ServiceUnavailable.new
      else
        raise Wildcat::Error.new(Wildcat::Error::GENERAL_ERROR,
                                { error: response.curl_error_message })
      end
    end

    Wildcat::Config.hydra.queue(request)
  end

  def self.find_by_team(id)
    request = Typhoeus::Request.new( Wildcat::Config.base_url +
                                      "/teams/#{id}/games?auth_token=#{Wildcat::Config.auth_token}",
                                      { method: :get,
                                      timeout: Wildcat::Config.timeout,
                                      headers: {:Accept => "application/json", "Content-Type" => "application/json"} })

    request.on_complete do |response|
      if response.success?
        games = []
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        parsed.each do |result|
          games << new(id: result[:id],
             away_team_id: result[:away_team_id],
             home_team_id: result[:home_team_id],
                    label: result[:label],
                played_at: result[:played_at],
                   season: result[:season],
                  stadium: result[:stadium],
                     week: result[:week])
        end
        yield games
      elsif response.code == 401
        raise Wildcat::UnauthorizedAccess.new
      elsif (500..599).cover? response.code
        raise Wildcat::ServiceUnavailable.new
      else
        raise Wildcat::Error.new(Wildcat::Error::GENERAL_ERROR,
                                { error: response.curl_error_message })
      end
    end

    Wildcat::Config.hydra.queue(request)
  end
end
