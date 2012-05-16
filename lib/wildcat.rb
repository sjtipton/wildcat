module Wildcat
  require 'yajl/json_gem'
  require 'active_support/core_ext/hash'
  require 'active_support/core_ext/object'
  require 'active_model'
  require 'typhoeus'

  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require 'wildcat/version.rb'
  require 'wildcat/config.rb'
  require 'wildcat/team.rb'
  require 'wildcat/game.rb'
  require 'wildcat/error.rb'
end
