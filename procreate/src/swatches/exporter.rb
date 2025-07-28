# frozen_string_literal: true

require 'tempfile'
require 'zip'

module Procreate
  module Swatches
    #
    # The class that handles the export of a {Procreate::Swatches::Wrapper} to a
    # +.swatches+ file.
    #
    class Exporter
      include CallableClass

      # @!method self.call
      #   Creates a new instance of {Procreate::Swatches::Exporter} and calls {#call}
      #   Dynamically included by using {https://github.com/laurentzziu/callable_class CallableClass} gem.

      # An instance of {Procreate::Swatches::Wrapper}
      attr_accessor :wrapper
      # The computed path of the +.swatches+ file, after the file was exported.
      attr_reader :swatches_path

      #
      # Initialize a new {Exporter}
      #
      # @param [Procreate::Swatches::Wrapper] wrapper Wrapper instance
      # @param [Hash] options Options for exporting the wrapper
      # @option options [String] :export_directory ('Dir.pwd') The export directory for the +.swatches+ file
      # @option options [String] :file_name ('Wrapper#name') Custom file name for the exported +.swatches+ file. If none is provided, the +name+ of the +wrapper+ instance is used
      #
      def initialize(wrapper, options = {})
        @wrapper = wrapper
        parse_options(options)
      end

      # Exports the +.swatches+ file.
      #
      # @return [String] swatches_path Path of the exported +.swatches+ file
      def call
        zip_content!

        swatches_path
      end

      alias export call

      # @!attribute [r] options
      # Export options
      # @return [Hash] Export options
      def options
        parse_options(@options)
      end

      # @!attribute [w] options
      # Export options
      # @return [Hash] Export options
      def options=(hash)
        parse_options(hash)
      end

      # Permitted options. Any other key will be discarded.
      PERMITTED_OPTIONS = %i[export_directory file_name].freeze

      private

      DEFAULT_OPTIONS = {
        export_directory: Dir.pwd
      }.freeze

      def parse_options(options)
        @options = DEFAULT_OPTIONS.merge(
          options.symbolize_keys.slice(*PERMITTED_OPTIONS)
        )
      end

      def create_temp_swatches_file!
        json_content = wrapper.to_json
        temp_file = Tempfile.new(wrapper.name)
        temp_file << json_content
        temp_file.rewind
        temp_file.path
      end

      def zip_content!
        temp_file = create_temp_swatches_file!
        filename = generate_unique_filename

        # Delete the file if it exists to avoid conflicts
        File.delete(filename) if File.exist?(filename)

        Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
          zipfile.add(SWATCHES_FILE_NAME, temp_file)
        end
      end

      # http://myprogrammingblog.com/2015/01/05/how-to-ensure-that-filename-is-always-unique-ruby/
      #
      # Function generates uniq file name from the String passed to it
      # based on extension and basename
      #
      # @return [String] generated file name
      def generate_unique_filename
        name = options[:file_name] || wrapper.name
        # TODO: Sanitize the file name

        filename = "#{name}.swatches"

        related_files = related_file_indexes(filename)

        filename = if related_files.present?
                     "#{name}-#{related_files.max + 1}#{SWATCHES_EXTENSION}"
                   else
                     "#{name}#{SWATCHES_EXTENSION}"
        end

        @swatches_path = File.join(options[:export_directory], filename)
      end

      SWATCHES_EXTENSION = '.swatches'

      def related_file_indexes(file_name)
        name = File.basename(file_name, SWATCHES_EXTENSION)

        existing_swatches_files(file_name).map do |file|
          file.split('-').last.to_i if File.basename(file).include?(name) && File.extname(file) == SWATCHES_EXTENSION
        end.compact
      end

      def existing_swatches_files(file_name)
        Dir[Pathname.new(File.dirname(file_name)).join('*')]
      end
    end
  end
end
