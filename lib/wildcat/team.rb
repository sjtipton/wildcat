class Wildcat::Team
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  self.include_root_in_json = false

  ATTRIBUTES = [ :id,
                 :name,
                 :nickname, 
                 :abbreviation, 
                 :location, 
                 :conference,
                 :division ]

  attr_accessor *ATTRIBUTES

  validates :name, :nickname, :abbreviation, :location, :conference, :division,
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
                                      "/teams/#{id}?auth_token=#{Wildcat::Config.auth_token}",
                                      { method: :get,
                                      timeout: Wildcat::Config.timeout,
                                      headers: {:Accept => "application/json", "Content-Type" => "application/json"} })

    request.on_complete do |response|
      if response.code == 200
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        yield new(id: parsed[:id],
                name: parsed[:name],
            nickname: parsed[:nickname],
        abbreviation: parsed[:abbreviation],
            location: parsed[:location],
          conference: parsed[:conference],
            division: parsed[:division])
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
                                      "/teams?auth_token=#{Wildcat::Config.auth_token}",
                                      { method: :get,
                                      timeout: Wildcat::Config.timeout,
                                      headers: {:Accept => "application/json", "Content-Type" => "application/json"} })

    request.on_complete do |response|
      if response.success?
        teams = []
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        parsed.each do |result|
          teams << new(id: result[:id],
                     name: result[:name],
                 nickname: result[:nickname],
             abbreviation: result[:abbreviation],
                 location: result[:location],
               conference: result[:conference],
                 division: result[:division])
        end
        yield teams
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
