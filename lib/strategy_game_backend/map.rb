# frozen_string_literal: true

module StrategyGameBackend
  module Map
    class << self
      # Gets a map object for the specified game that can be used to
      # interrogate state.
      def fetch_for_game(game_uuid = nil) # Allow this to be nil for now.
        StrategyGameBackend::Map::Overall.new(game_uuid)
      end
    end

    class Overall
      attr_reader :visible, :explored

      def initialize(game_uuid)
        @game_uuid = game_uuid
        @explored = Concurrent::Array.new
        @visible = Concurrent::Array.new
        @fow_timeout = 3
        @game = {}

        # Check every FOW timeout period so we can determine if something is visible to
        # the player or not.
        @make_fow_invisible_task = Concurrent::TimerTask.new(execution_interval: @fow_timeout) do
          @explored.each do |coordinates|
            @visible.delete(coordinates) if @visible.include?(coordinates) && !@game.player_units_at?(coordinates) && !@game.coordinates_within_sight?(coordinates)
          end
        end

        @make_fow_invisible_task.execute
      end

      def width
        1920
      end

      def height
        1080
      end

      def within?(x, y)
        x <= width && y <= height
      end

      def visible?(x, y)
        @visible.include?("#{x},#{y}")
      end

      def explored?(x, y)
        @explored.include?("#{x},#{y}")
      end

      def mark_visible(x, y)
        @visible.push("#{x},#{y}")
      end

      def mark_explored(x, y)
        @explored.push("#{x},#{y}")
      end

      # We only want to return actual traversable unit types when the terrain has
      # been explored by the player, so if it is not explored yet, we'll return
      # all options, and we will use the path finding when moving to determine where
      # we have to stop.
      def traversable_by(x, y)
        if explored?(x, y)
          if within_water_area?(x, y)
            %i[sea air]
          elsif within_obstacle_area?(x, y)
            [:air]
          else
            %i[land air]
          end
        else
          %i[land sea air]
        end
      end

      def within_water_area?(x, y)
        lookup_terrain_at(x, y) == :water
      end

      def within_obstacle_area?(x, y)
        lookup_terrain_at(x, y) == :obstacle
      end

      def lookup_terrain_at(_x, _y)
        :land
      end

      def state_at_coordinates(x, y)
        {
          visible: visible?(x, y),
          explored: explored?(x, y),
          traversable_by: traversable_by(x, y)
        }
      end
    end
  end
end
