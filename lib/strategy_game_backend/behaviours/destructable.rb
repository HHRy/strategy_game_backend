module StrategyGameBackend
  module Behaviours
    module Destructable
      class Error < StandardError; end

      # The current primary health value
      def health
        @primary_health <= 0 ? 0 : @primary_health
      end

      # Sets the initial values of the various health types for the destructable.
      def set_initial_health(primary_health, secondary_health = 0, tertiary_health = 0)
        @primary_health, @secondary_health, @tertiary_health = [primary_health, secondary_health, tertiary_health].map(&:to_i)
        @initial_primary_health, @initial_secondary_health, @initial_tertiary_health = [primary_health, secondary_health, tertiary_health].map(&:to_i)
      end
      
      # Destructable things are only destructable if they are not
      # already destroyed.
      def destructable?
        !destroyed?
      end

      # When destructable things take damage, the default behaviour
      # is to deplete the health starting from tertiary and going down
      # to primary.    
      #
      # In the future, I want to have things with a base health, an armour
      # value, and also a shield value, which is why there is space for
      # 3 here and the default behaviour is kinda dumb.
      def take_damage(amount)
        raise StrategyGameBackend::Behaviours::Destructable::Error.new("#{self.class.name} has not had its health called. Missing set_initial_health ?") if @primary_health.nil?

        @tertiary_health -= amount
        if @tertiary_health < 0
          @secondary_health -= @tertiary_health.abs
        end
        if @secondary_health < 0
          @primary_health -= @secondary_health.abs
        end
      end

      # When the destructable has zero primary health, it is destroyed.
      def destroyed?
        raise StrategyGameBackend::Behaviours::Destructable::Error.new("#{self.class.name} has not had its health called. Missing set_initial_health ?") if @primary_health.nil?

        @primary_health <= 0
      end

      # To keep things pretty dumb and simple; I assume that all destructable 
      # things are repairable if their current primary health is less than
      # their initial primary health.
      def repairable?
        raise StrategyGameBackend::Behaviours::Destructable::Error.new("#{self.class.name} has not had its health called. Missing set_initial_health ?") if @primary_health.nil?

        @primary_health < @initial_primary_health
      end

      # Repairs the destuctable thing by increasing the primary health by the
      # amount specified. It will limit at initial primary health.
      def repair(amount)
        raise StrategyGameBackend::Behaviours::Destructable::Error.new("#{self.class.name} has not had its health called. Missing set_initial_health ?") if @primary_health.nil?

        @primary_health += amount
        @primary_health = @initial_primary_health if @primary_health > @initial_primary_health
      end
    end
  end
end
