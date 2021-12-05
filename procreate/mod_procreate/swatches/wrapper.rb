# frozen_string_literal: true

module Procreate
  module Swatches
    #
    # Wrapper class for the name and colors of a +.swatches+ file.
    #
    class Wrapper
      include ColorsHelper

      # @!attribute name
      #   @return [String] Name of the swatches palette
      attr_accessor :name
      # @!attribute [w] colors
      #   @return [Array<Chroma::Color, String>] Colors array
      attr_writer :colors

      # The default name, used in case a custom name is not provided
      DEFAULT_SWATCHES_NAME = 'My beautiful palette'

      #
      # Initialize a new instance of {Procreate::Swatches::Wrapper}
      #
      # @param [String] name Name of the swatches palette
      # @param [Array<Chroma::Color, String>] colors Colors array. Each color will be converted to a {https://github.com/jfairbank/chroma Chroma::Color} instance.
      #
      def initialize(name, colors)
        @name = name.present? ? name : DEFAULT_SWATCHES_NAME

        @colors ||= []
        Array(colors).each { |color| add_color(color) }
      end

      #
      # Add a new color to the colors array.
      # It will be converted to a {https://github.com/jfairbank/chroma Chroma::Color} instance.
      #
      # @param [Chroma::Color, String] color Color in a supported format.
      #
      # @return [Array<Chroma::Color>] The current colors available in the wrapper.
      #
      def <<(color)
        add_color(color)
      end

      alias push <<

      #
      # Remove the last color from the colors array.
      #
      # @return [Array<Chroma::Color>] The current colors available in the wrapper.
      #
      def pop
        @colors.pop
      end

      # Available formats to return the colors as. These types are supported by {https://github.com/jfairbank/chroma Chroma::Color}
      AVAILABLE_COLOR_FORMATS = %i[hsv hsl hex hex8 rgb name].freeze

      #
      # Returns the list of available color formats a color
      # can be retrieved into.
      #
      # @return [Array<Symbol>] The list of available formats a color can be retrived into.
      #
      def available_color_formats
        AVAILABLE_COLOR_FORMATS
      end

      #
      # Attribute reader for colors.
      # It supports returning the colors in different formats.
      # If not format is provided, an array of {https://github.com/jfairbank/chroma Chroma::Color}s is returned.
      # If an invalid format is provided, it will fallback to the default format.
      #
      # @param [String, Symbol] format Format to return the colors array in.
      #
      # @return [Array<Chroma::Color>] Return an array of {https://github.com/jfairbank/chroma Chroma::Color} when no format is provided. This is the default option.
      # @return [Array<String>] Return an array of +Strings+, in the specified format.
      #
      def colors(format: nil)
        format = format.to_sym unless format.nil?
        format = nil unless format.in?(AVAILABLE_COLOR_FORMATS)

        return @colors if format.nil?

        @colors.map do |color|
          color.send("to_#{format}")
        end
      end

      #
      # Convert the wrapper to the JSON format needed to create a
      # +.swatches+ file.
      # A maximum of 30 ({Procreate::Swatches::ColorsHelper::SWATCHES_MAX_SIZE}) colors is returned.
      # This is a limitation of Procreate.
      #
      # @return [String] Wrapper content, in JSON format.
      #
      def to_json(*_args)
        [
          {
            name: @name,
            swatches: colors_to_json
          }
        ].to_json
      end

      alias to_swatches to_json
      alias to_procreate to_json

      #
      # Export the wrapper to a +.swatches+ file
      #
      # @param [<Type>] options All options suported by {Procreate::Swatches::Exporter#initialize}
      #
      # @return [String] swatches_path Path of the exported +.swatches+ file
      #
      def to_file(options = {})
        Exporter.call(self, options)
      end

      alias export to_file

      # @todo Check if the colors array is the same (regardless of order)
      #
      # Wrapper file comparison.
      # It check for the same class, name and colors array
      #
      # @param [Procreate::Swatches::Wrapper] other Another wrapper instance
      #
      # @return [Boolean] The wrappers are equal
      #
      def ==(other)
        other.is_a?(self.class) && name == other.name && colors == other.colors
      end

      private

      def add_color(color)
        result = prepare_color_for_push(color)

        @colors << [color[0], result] unless color.nil?

        @colors
      end

      def colors_to_json
        @colors.first(SWATCHES_MAX_SIZE).map do |color|
          to_swatches_json(color)
        end
      end
    end
  end
end
