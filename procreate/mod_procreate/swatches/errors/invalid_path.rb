# frozen_string_literal: true

module Procreate
  module Swatches
    module Errors
      # Exception raised when the specified path is invalid.
      class InvalidPath < StandardError
        MESSAGE = 'Invalid file path specified.'

        def message
          MESSAGE
        end
      end
    end
  end
end
