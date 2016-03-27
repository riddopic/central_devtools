
# Central::Devtools

Shared Rake tasks for Central Machine projects.

## Installation

Add the gem to your Gemfile's development section.

```ruby
group :development, :test do
  gem 'central-devtools'
end
```

And then run `bundle install`.

## Usage

Add the following to your Rakefile:

```
require 'central/devtools'
Central::Devtools.load_tasks
```

If you're running a Rails app, include the above lines after you load your application's tasks (e.g. `MyApp::Application.load_tasks`).

## RSpec support

If you're using RSpec and want to have access to our common setup just adjust
`spec/spec_helper.rb` to include

```ruby
require 'central/devtools/spec_helper'
```
