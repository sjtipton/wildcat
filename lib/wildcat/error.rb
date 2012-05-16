module Wildcat
  class Error < StandardError
    attr_reader :status, :message, :errors

    HTTP_BAD_REQUEST         = 400
    HTTP_UNAUTHORIZED        = 401
    HTTP_RESOURCE_NOT_FOUND  = 404
    HTTP_SERVICE_UNAVAILABLE = 503

    UNAUTHORIZED_ERROR_MESSAGE   =  { error: "Invalid authentication token." }
    SERVICE_DOWN_ERROR_MESSAGE   =  { error: "We're sorry but something went wrong." }
    BAD_URI_ERROR_MESSAGE        =  { error: "Routing error. Please check request uri" }

    BAD_REQUEST         = [HTTP_BAD_REQUEST, "Validation failure"]
    RESOURCE_NOT_FOUND  = [HTTP_RESOURCE_NOT_FOUND, "Resource not found"]
    UNAUTHORIZED        = [HTTP_UNAUTHORIZED, "You need to sign in or sign up before continuing."]
    SERVICE_UNAVAILABLE = [HTTP_SERVICE_UNAVAILABLE, "Service unavailable."]
    GENERAL_ERROR       = [0, "Unknown error."]

    def initialize(info, *args)
      @status, msg = *info
      @message = sprintf(msg, *args)
      @errors = *args
      super(@message)
    end

    def to_json(options = nil)
      Yajl::Encoder.encode({:code => @status, :description => @message, :errors => @errors})
    end
  end

  class UnauthorizedAccess < Error

    def initialize
      super(UNAUTHORIZED, UNAUTHORIZED_ERROR_MESSAGE)
    end
  end

  class ServiceUnavailable < Error

    def initialize
      super(SERVICE_UNAVAILABLE, SERVICE_DOWN_ERROR_MESSAGE)
    end
  end

  class ResourceNotFound < Error

    def initialize(*args)
      super(RESOURCE_NOT_FOUND, *args)
    end
  end
end
