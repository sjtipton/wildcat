class Wildcat::Config
  class << self
    attr_accessor :host, :hydra, :auth_token, :timeout, :protocol, :api_version

    def base_url
      "#{self.protocol}://#{self.host}/#{self.api_version}"
    end
  end
end
