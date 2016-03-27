# encoding: UTF-8

module Central
  module Devtools
    class Project
      class Initializer
        # Imports all devtools rake tasks into a project
        class Rake < self
          include AbstractType

          # Initialize rake tasks
          #
          # @return [undefined]
          # @api rpivate
          def self.call
            FileList.glob(RAKE_FILES_GLOB).each(&::Rake.application.method(:add_import))
            self
          end
        end
      end
    end
  end
end
