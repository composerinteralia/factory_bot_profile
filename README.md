# FactoryBotProfile

FactoryBotProfile identifies expensive factories and heavy [factory\_bot][] usage.
Use this information to speed up your test suite!

[factory\_bot]: https://github.com/thoughtbot/factory_bot

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add factory_bot_profile

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install factory_bot_profile

## Usage

The primary API for using this library is to wrap the code you want to profile
with the `.reporting` method:

```rb
require "factory_bot_profile"

FactoryBotProfile.reporting do
  # Code that uses factory_bot
end
```

This will profile every call to factory\_bot inside the block, and then print
the results to stdout after the code inside the block finishes.

If you need more control over where to start and stop profiling, and when to
report the results, use the `.subscribe` and `.report` methods:

```rb
subscription = FactoryBotProfile.subscribe

# Code that uses factory_bot

subscription.unsubscribe
FactoryBotProfile.report(subscription.stats)
```

## Why not FactoryProf?

[FactoryProf][] is another fantastic tool for profiling factories, and it
includes a really neat flamegraph feature that this library doesn't have (at
least not yet). So why did I write this library?

FactoryProf profiles factories by monkey patching factory\_bot. It's also part
of the larger [TestProf][] library, which includes a number of other monkey
patches, and it's difficult to load FactoryProf without bringing in other parts
of the library as well. These monkey patches can make it difficult to add
FactoryProf to an application.

FactoryBotProfile, on the other hand, uses factory\_bot's built-in
[instrumentation][] to build the profile. My hope is that using built-in
factory\_bot features, and avoiding monkey patches or private APIs should make
this library fairly stable.

[FactoryProf]: https://test-prof.evilmartians.io/#/profilers/factory_prof?id=factoryprof
[TestProf]: https://test-prof.evilmartians.io/
[instrumentation]: https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#activesupport-instrumentation

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/composerinteralia/factory_bot_profile. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/composerinteralia/factory_bot_profile/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FactoryBotProfile project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/composerinteralia/factory_bot_profile/blob/main/CODE_OF_CONDUCT.md).
