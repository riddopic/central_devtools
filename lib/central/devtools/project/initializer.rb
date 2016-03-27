# encoding: UTF-8

module Central
  module Devtools
    class Project
      # Base class for project initializers
      class Initializer
        include AbstractType
        abstract_singleton_method :call
      end
    end
  end
end
