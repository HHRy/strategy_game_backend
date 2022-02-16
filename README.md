# StrategyGameBackend

[![CircleCI](https://circleci.com/gh/HHRy/strategy_game_backend/tree/main.svg?style=svg)](https://circleci.com/gh/HHRy/strategy_game_backend/tree/main)

This is an as-yet un-named toy engine to allow you to play C&C style RTS
games with bots or other players. It needs [simdjson][4] to work. On macOS
you can get it using `brew install simdjson`.

This part of the project focuses on maintaining game state, handling movement,
and coordinating actions.

There will need to be a separate project that's a frontend to this to allow any
games to be actually playable.

There will probably also need to be a separate map builder tool.

Planned supported features:

  - Different unit types (land, air, and sea)
  - Different building types
  - Different factions
  - Faction specific units
  - Maps with Resources and obstacles and basic terrain
  - Bot v Player
  - Bot v Bot
  - Player v Player
  - Fog of war
  - Technology tree(s) (maybe)

The initial map format and everything else will be assuming 2 dimentions, like
the original C&C games.

In the `examples` directory, there are files in `rtsmap`, `rtsbuilding`, and
`rtsunit` formats which the engine will load to build the game world.
They describe the important parts of the items for the engine to track things,
so don't include any information about rendering or any assets.

This is totally a toy project for fun. If you come accross it, feel free to help
out. It'll be released as a gem when I think it's done enough to be useful.

The idea is that there will be two layers to a map, one for ground / sea based
units, and one for air based units. Their positions will be tracked, and overall
obstacles and areas where there is sea, obstacles, and resources will be defined.

I'm making up the format for the Map as I go along, while I work out how to process
and represent it.

Pathfinding is done using [Quentin18/pathfinding.rb][1] for now, and concurrent
tasks are being handled by [ruby-concurrency/concurrent-ruby][2]. JSON parsing
is handled by [simdjson][4] and [anilmaurya/fast_jsonparser][3]

Map coordinates assume that 0,0 is the top left. Although I guess that's immaterial
since this isn't going to really render a map.

Movement rules are going to be simple:

  - No two units of the same type can occupy the same location
  - No unit can enter a "obstacle" area
  - Only sea and air units can travel over water
  - Sea units can't travel on land
  - Units can't occupy the same space as buildings.

Building rules are likewise going to be simple:

  - Nothing can be built on "resource" or "obstacle" areas
  - Buildings can only be built on land

Combat will work as:

  - Each weapon has a range, rate of fire, and damage
  - Enemy units within rage of a given unit will be fired upon
  - There won't be any splash damage just now


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HHRy/strategy_game_backend. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/HHEy/strategy_game_backend/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StrategyGameBackend project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/strategy_game_backend/blob/master/CODE_OF_CONDUCT.md).

[1]: https://github.com/Quentin18/pathfinding.rb
[2]: https://github.com/ruby-concurrency/concurrent-ruby
[3]: https://github.com/anilmaurya/fast_jsonparser
[4]: https://github.com/simdjson/simdjson
