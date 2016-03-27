# encoding: UTF-8

namespace :metrics do
  require 'flay'

  project = Central::Devtools.project
  config = project.flay

  desc 'Measure code duplication'
  task :flay do
    threshold = config.threshold
    total_score = config.total_score

    Central::Devtools::Rake::Flay.call(
      threshold: threshold,
      total_score: total_score,
      lib_dirs: config.lib_dirs,
      excludes: config.excludes
    )
  end
end
