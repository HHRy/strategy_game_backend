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

    class MapLoader
      def initialize(map_file_path)
        @file_path = map_file_path
        @raw_map_data = FastJsonparser.load(File.expand_path(map_file_path))
      end

      def valid?
        @valid ||= @raw_map_data[:version] == 1 && @raw_map_data[:format] = '2D'
      end

      def map_width
        @raw_map_data[:width]
      end

      def map_height
        @raw_map_data[:height]
      end

      def water
        @water ||= (@raw_map_data[:waterAreas] || []).collect do |area|
          StrategyGameBackend::Map::Area.new(area, map_width, map_height, :water)
        end
      end

      def resource
        @resource ||= (@raw_map_data[:resourceAreas] || []).collect do |area|
          StrategyGameBackend::Map::Area.new(area, map_width, map_height, :resource)
        end
      end

      def obstacle
        @obstacle ||= (@raw_map_data[:obstacleAreas] || []).collect do |area|
          StrategyGameBackend::Map::Area.new(area, map_width, map_height, :obstacle)
        end
      end

      def terrain_at(x, y)
        return :water if water.any? { |area| area.contains?(x, y) }
        return :obstacle if obstacle.any? { |area| area.contains?(x, y) }
        return :resource if resource.any? { |area| area.contains?(x, y) }

        :land
      end
    end

    class Area
      def initialize(area_data, map_width, map_height, terrain)
        @area_data = area_data
        @map_width = map_width
        @map_height = map_height
        @terrain = terrain
      end

      def contains?(x, y)
        start_x = @area_data[:x]
        start_y = @area_data[:y]
        end_x = start_x + @area_data[:width] - 1
        end_y = start_y + @area_data[:height] - 1

        x >= start_x && x <= end_x && y >= start_y && y <= end_y
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

        @map_loader = StrategyGameBackend::Map::MapLoader.new('/Users/ryan/work/strategy_game_backend/examples/all_passable.rtsmap')

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
        @map_loader.map_width
      end

      def height
        @map_loader.map_height
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

      def move_unit_to(unit, x, y)
        if traversable_by(x,y).include?(Unit.terrain_traversable(unit))
          unit.register_move(x, y)
        end
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

      def lookup_terrain_at(x, y)
        @map_loader.terrain_at(x, y)
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
