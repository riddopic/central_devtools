# encoding: UTF-8

namespace :metrics do
  desc 'Check with code style guide'
  task :rubocop do
    require 'rubocop'
    config = Central::Devtools.project.rubocop
    begin
      exit_status = RuboCop::CLI.new.run(%W(--config #{config.config_file}))
      fail 'Rubocop not successful' unless exit_status.zero?
    rescue Encoding::CompatibilityError => exception
      Central::Devtools.notify_metric_violation exception.message
    end
  end
end
