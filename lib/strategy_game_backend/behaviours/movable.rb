# frozen_string_literal: true

module StrategyGameBackend
  module Behaviours
    module Movable
      class Error < StandardError; end

      # Used to initialize an object with a location.
      def set_current_position(x, y)
        move(x, y, true)
      end

      # Returns the current position of the movable thing as an array of [x, y].
      def position
        raise StrategyGameBackend::Behaviours::Movable::Error, 'position is not set' if @x.nil? && @y.nil?

        [@x, @y]
      end

      # Sets the position of the movable thing to the given x and y coordinates if
      # it is possible to move there. This might be implemented differently in other
      # movable things, since things need to take time to move.
      #
      # The default implementation is effectively teleporting, which is not ideal.
      def move(x, y, force_move: false)
        raise StrategyGameBackend::Behaviours::Movable::Error, "Cannot move to #{x}, #{y}" if force_move || can_move_to?(x, y)

        @x = x
        @y = y
      end

      # We can only move if we have a starting position. Different movable things might
      # implement this differently, for example, if there are too many units nearby.
      def can_move?
        !@x.nil? && !@y.nil?
      end

      # Determines if the position requested to move to is valid. This will
      # behave differently in movable things, but the default implementation just
      # checks if the position is within the map.
      def can_move_to?(x, y)
        coordinates_within_map?(x, y)
      end

      private

      # Checks the map to see if the provided coordinates are within its
      # bounds. TODO: This should be handled with the other map stuff.
      def coordinates_within_map?(x, y)
        # x < map.width && y < map.height &&
        x >= 0 && y >= 0
      end
    end
  end
end
