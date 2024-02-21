# frozen_string_literal: true

module Procreate
  module Swatches
    #
    # Errors used for {Procreate::Swatches}
    #
    module Errors
      # Exception raised when the provided file format is invalid.
      class InvalidFormat < StandardError
        MESSAGE = 'Invalid file format specified. Accepted file format: `.swatches`.'

        def message
          MESSAGE
        end
      end
    end
  end
end
