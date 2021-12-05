# frozen_string_literal: true

require 'zip'

module Procreate
  module Swatches
    #
    # The class that handles the parsing of a +.swatches+ file to
    # an instance of {Procreate::Swatches::Wrapper}.
    #
    class Parser
      include CallableClass
      include ColorsHelper

      # @!method self.call
      #   Creates a new instance of {Procreate::Swatches::Parser} and calls {#call}
      #   Dynamically included by using {https://github.com/laurentzziu/callable_class CallableClass} gem.

      # @!attribute [r] wrapper
      #   @return [Procreate::Swatches::Wrapper]
      attr_reader :wrapper

      # @!attribute [r] file_path
      #   @return [String] The path of the +.swatches+ file
      attr_reader :file_path

      #
      # Initialize a new instance of {Procreate::Swatches::Parser}
      #
      # @param [String] file_path The path of the +.swatches+ file
      #
      # @raise [Procreate::Swatches::Errors::InvalidPath] Error raised when the provided path is invalid
      # @raise [Procreate::Swatches::Errors::InvalidFormat] Error raised when the provided path contains a file with an invalid format (accepted format: +.swatches+)
      #
      def initialize(file_path)
        @file_path = file_path

        validate!
      end

      #
      # Process the provided +.swatches+ file and wrap the content in
      # a {Procreate::Swatches::Wrapper}
      #
      # @return [Procreate::Swatches::Wrapper] A wrapper instance for the +.swatches+ file
      #
      def call
        unzip
        wrap_colors
      end

      private

      def unzip
        zip_file = Zip::File.open(@file_path)
        entry = zip_file.glob(SWATCHES_FILE_NAME).first
        raw_content = entry.get_input_stream.read
        @content = JSON.parse(raw_content).first
      end

      def wrap_colors
        name = @content['name']
        colors = @content['swatches']

        colors = colors.compact.map do |color|
          string = to_chroma_hsv(color)
          Chroma::Color.new(string)
        end

        @wrapper = Wrapper.new(name, colors)
      end

      SWATCHES_FILE_REGEXP = /\.swatches\z/.freeze

      def validate!
        raise(Errors::InvalidPath) unless file_path.present? && File.exist?(file_path) && File.file?(file_path)

        raise(Errors::InvalidFormat) unless file_path.match(SWATCHES_FILE_REGEXP).present?
      end
    end
  end
end
