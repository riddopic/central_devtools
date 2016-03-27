# encoding: UTF-8

namespace :metrics do
  namespace :yardstick do
    require 'yardstick/rake/measurement'
    require 'yardstick/rake/verify'

    options = Central::Devtools.project.yardstick.options

    if options['threshold']
      Yardstick::Rake::Measurement.new(:measure, options)
      Yardstick::Rake::Verify.new(:verify, options)
    end
  end
end
