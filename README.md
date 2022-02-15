# StrategyGameBackend

[![CircleCI](https://circleci.com/gh/HHRy/strategy_game_backend/tree/main.svg?style=svg)](https://circleci.com/gh/HHRy/strategy_game_backend/tree/main)

This is an as-yet un-named toy engine to allow you to play C&C style RTS
games with bots or other players.

This part of the project focuses on maintaining game state, handling movement,
and coordinating actions.

There will need to be a separate project that's a frontend to this to allow any
games to be actually playable.

Planned supported features:

  - Different unit types (land, air, and sea)
  - Different building types (land, sea)
  - Different factions
  - Faction specific units
  - Maps with Resources
  - Bot v Player
  - Bot v Bot
  - Player v Player
  - Fog of war
  - Technology tree(s) (maybe)

The initial map format and everything else will be assuming 2 dimentions, like
the original C&C games. Maybe once that's figured out, I'll make a 3D version.

In the `examples` directory, there are files in `rtsmap` and `rtsunit` formats
which the engine will load to build the game world. They describe the important
parts of the items for the engine to track things, so don't include any
information about rendering or any assets.

This is totally a toy project for fun. If you come accross it, feel free to help
out. It'll be released as a gem when I think it's done enough to be useful.

## Usage

TODO: Not sure yet

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HHRy/strategy_game_backend. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/strategy_game_backend/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StrategyGameBackend project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/strategy_game_backend/blob/master/CODE_OF_CONDUCT.md).
