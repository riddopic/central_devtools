# encoding: UTF-8

module Central
  module Devtools
    # Abstract base class of tool configuration
    class Config
      include Adamantium::Flat, AbstractType, Concord.new(:config_dir)

      # Represent no configuration
      DEFAULT_CONFIG = {}.freeze

      # Simple named type check representation
      class TypeCheck
        # Type check against expected class
        include Concord.new(:name, :allowed_classes)

        FORMAT_ERROR = '%<name>s: Got instance of %<got>s expected %<allowed>s'.freeze
        CLASS_DELIM  = ','.freeze

        # Check value for instance of expected class
        #
        # @param [Object] value
        # @return [Object]
        def call(value)
          klass = value.class

          unless allowed_classes.any?(&klass.method(:equal?))
            fail TypeError, FORMAT_ERROR % {
              name: name,
              got: klass,
              allowed: allowed_classes.join(CLASS_DELIM)
            }
          end

          value
        end
      end

      private_constant(*constants(false))

      # Error raised on type errors
      TypeError = Class.new(RuntimeError)

      # Declare an attribute
      #
      # @param [Symbol] name
      # @param [Array<Class>] classes
      # @return [self]
      # @api private
      def self.attribute(name, classes, **options)
        default = [options.fetch(:default)] if options.key?(:default)
        type_check = TypeCheck.new(name, classes)
        key = name.to_s

        define_method(name) do
          type_check.call(raw.fetch(key, *default))
        end
      end
      private_class_method :attribute

      # Return config path
      #
      # @return [String]
      # @api private
      def config_file
        config_dir.join(self.class::FILE)
      end
      memoize :config_file

      private

      # Return raw data
      #
      # @return [Hash]
      # @api private
      def raw
        yaml_config || DEFAULT_CONFIG
      end
      memoize :raw

      # Return the raw config data from a yaml file
      #
      # @return [Hash]
      #   returned if the yaml file is found
      # @return [nil]
      #   returned if the yaml file is not found
      # @api private
      def yaml_config
        IceNine.deep_freeze(YAML.load_file(config_file)) if config_file.file?
      end

      # Rubocop configuration
      class Rubocop < self
        FILE = 'rubocop.yml'.freeze
      end

      # Reek configuration
      class Reek < self
        FILE = 'reek.yml'.freeze
      end

      # Flay configuration
      class Flay < self
        FILE = 'flay.yml'.freeze
        DEFAULT_LIB_DIRS = %w(lib).freeze
        DEFAULT_EXCLUDES = %w().freeze

        attribute :total_score, Fixnum
        attribute :threshold, Fixnum
        attribute :lib_dirs, Array, default: DEFAULT_LIB_DIRS
        attribute :excludes, Array, default: DEFAULT_EXCLUDES
      end

      # Yardstick configuration
      class Yardstick < self
        FILE = 'yardstick.yml'.freeze
        OPTIONS = %w(
          threshold
          rules
          verbose
          path
          require_exact_threshold
        ).freeze

        # Options hash that Yardstick understands
        #
        # @return [Hash]
        # @api private
        def options
          OPTIONS.each_with_object({}) do |name, hash|
            hash[name] = raw.fetch(name, nil)
          end
        end
      end

      # Flog configuration
      class Flog < self
        FILE = 'flog.yml'.freeze
        DEFAULT_LIB_DIRS = %w(lib).freeze

        attribute :total_score, Float
        attribute :threshold, Float
        attribute :lib_dirs, Array, default: DEFAULT_LIB_DIRS
      end

      # Mutant configuration
      class Mutant < self
        FILE = 'mutant.yml'.freeze
        DEFAULT_NAME = ''.freeze
        DEFAULT_STRATEGY = 'rspec'.freeze
        DEFAULT_COVERAGE = '1/1'.freeze

        attribute :name, String, default: DEFAULT_NAME
        attribute :strategy, String, default: DEFAULT_STRATEGY
        attribute :zombify, [TrueClass, FalseClass], default: false
        attribute :since, [String, NilClass], default: nil
        attribute :ignore_subjects, Array, default: []
        attribute :expect_coverage, String, default: DEFAULT_COVERAGE
        attribute :namespace, String
      end

      # Devtools configuration
      class Devtools < self
        FILE = 'devtools.yml'.freeze
        DEFAULT_UNIT_TEST_TIMEOUT = 0.1

        attribute :unit_test_timeout, Float, default: DEFAULT_UNIT_TEST_TIMEOUT
      end

      # Container configuration
      class Container < self
        FILE = 'container.yml'.freeze
        OPTIONS = %w(
          prefix
          component
          build_tag
          from_image
          from_version
        ).freeze

        # Options hash for the container
        #
        # @return [Hash]
        # @api private
        def options
          OPTIONS.each_with_object({}) do |name, hash|
            hash[name] = raw.fetch(name, nil)
          end
        end

        attribute :prefix, String, default: nil
        attribute :component, String, default: nil
        attribute :build_tag, String, default: nil
        attribute :from_image, String, default: nil
        attribute :from_version, String, default: nil
      end
    end
  end
end
