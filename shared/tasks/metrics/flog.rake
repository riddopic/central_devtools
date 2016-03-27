# encoding: UTF-8

namespace :metrics do
  require 'flog'
  require 'flog_cli'

  project = Central::Devtools.project
  config = project.flog

  desc 'Measure code complexity'
  task :flog do
    threshold = config.threshold.to_f.round(1)
    flog = Flog.new
    flog.flog(*FlogCLI.expand_dirs_to_files(config.lib_dirs))

    totals = flog.totals.select { |name, _score| name[-5, 5] != '#none' }
             .map { |name, score| [name, score.round(1)] }
             .sort_by { |_name, score| score }

    if totals.any?
      max = totals.last[1]
      unless max >= threshold
        Central::Devtools.notify_metric_violation "Adjust flog score down to #{max}"
      end
    end

    bad_methods = totals.select { |_name, score| score > threshold }
    if bad_methods.any?
      bad_methods.reverse_each do |name, score|
        printf "%8.1f: %s\n", score, name
      end

      Central::Devtools.notify_metric_violation(
        "#{bad_methods.size} methods have a flog complexity > #{threshold}"
      )
    end
  end
end
