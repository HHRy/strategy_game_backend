# frozen_string_literal: true
require 'concurrent'

require_relative 'strategy_game_backend/version'
require_relative 'strategy_game_backend/behaviours'

module StrategyGameBackend
  class GeneralError < StandardError; end
end
