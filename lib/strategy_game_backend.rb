# frozen_string_literal: true

require 'concurrent'
require 'fast_jsonparser'

require_relative 'strategy_game_backend/version'
require_relative 'strategy_game_backend/behaviours'
require_relative 'strategy_game_backend/map'

module StrategyGameBackend
  class GeneralError < StandardError; end
end
