# encoding: UTF-8

# Stdlib infrastructure
require 'pathname'
require 'rake'
require 'timeout'
require 'yaml'
require 'fileutils'

# Non stdlib infrastructure
require 'procto'
require 'anima'
require 'concord'
require 'adamantium'

# Wrapped tools
require 'flay'
require 'rspec'
require 'rspec/its'
require 'simplecov'

module Central
  # The devtools namespace
  module Devtools
    ROOT = Pathname.new(__FILE__).parent.parent.parent.freeze
    PROJECT_ROOT = Pathname.pwd.freeze
    SHARED_PATH = ROOT.join('shared').freeze
    SHARED_SPEC_PATH = SHARED_PATH.join('spec').freeze
    DEFAULT_CONFIG_PATH = ROOT.join('default/config').freeze
    RAKE_FILES_GLOB = ROOT.join('shared/tasks/**/*.rake').to_s.freeze
    LIB_DIRECTORY_NAME = 'lib'.freeze
    SPEC_DIRECTORY_NAME = 'spec'.freeze
    RAKE_FILE_NAME = 'Rakefile'.freeze
    SHARED_SPEC_PATTERN = '{shared,support}/**/*.rb'.freeze
    UNIT_TEST_PATH_REGEXP = %r{\bspec/unit/}
    DEFAULT_CONFIG_DIR_NAME = 'config'.freeze

    private_constant(*constants(false))

    # Abort with message when a metric violation occurs.
    #
    # @param [String] message
    # @return [undefined]
    # @api private
    def self.notify_metric_violation(message)
      abort(message)
    end

    # Initialize project and load tasks. This should *only* be called from an
    # $application_root/Rakefile.
    #
    # @return [self]
    # @api public
    def self.init
      Project::Initializer::Rake.call
      self
    end

    # Return devtools root path.
    #
    # @return [Pathname]
    # @api private
    def self.root
      ROOT
    end

    # Return project.
    #
    # @return [Project]
    # @api private
    def self.project
      PROJECT
    end
  end
end

require_relative 'devtools/config'
require_relative 'devtools/project'
require_relative 'devtools/project/initializer'
require_relative 'devtools/project/initializer/rake'
require_relative 'devtools/project/initializer/rspec'
require_relative 'devtools/flay'
require_relative 'devtools/rake/flay'

module Central
  # Self initialization
  module Devtools
    PROJECT = Project.new(PROJECT_ROOT)
  end
end
