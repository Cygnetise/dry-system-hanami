# frozen_string_literal: true

module Dry
  module System
    module Hanami
      module Resolver
        PROJECT_NAME = ::Hanami::Environment.new.project_name
        LIB_FOLDER = 'lib'.freeze
        DEFAULT_RESOLVER = ->(k) { k.new }

        def register_folder!(folder, resolver: DEFAULT_RESOLVER, ignore: [], memoize: false)
          regexp = ignore.any? ? Regexp.new(/^#{LIB_FOLDER}\/#{folder}\/(#{ignore.join("|")})/) : nil
          all_files_in_folder(folder).each do |file|
            next if regexp && file.match?(regexp)

            register_file(file, resolver, memoize)
          end
        end

        def register_file!(file, resolver: DEFAULT_RESOLVER, memoize: false)
          register_file(find_file(file), resolver, memoize)
        end

        private

        def find_file(file)
          Dir.chdir(::Hanami.root) do
            Dir.glob("lib/#{file}.rb")
               .map! { |file_name| file_name.sub('.rb', '').to_s }.first
          end
        end

        def all_files_in_folder(folder)
          Dir.chdir(::Hanami.root) do
            Dir.glob("#{LIB_FOLDER}/#{folder}/**/*.rb")
               .map! { |file_name| file_name.sub('.rb', '').to_s }
          end
        end

        def register_file(file, resolver, memoize)
          register_name = file.sub(LIB_FOLDER + '/', '').sub(PROJECT_NAME + '/', '').tr('/', '.').sub(/_repository\z/, '')
          register(register_name, memoize: memoize) { load! file, resolver }
        end

        def load!(path, resolver)
          load_file!(path)

          unnecessary_part = extract_unnecessary_part(path)
          right_path = path.sub(LIB_FOLDER + '/', '').sub(unnecessary_part, '')

          resolver.call(Object.const_get(Inflecto.camelize(right_path)))
        end

        def load_file!(path)
          require_relative "#{::Hanami.root}/#{path}"
        end

        def extract_unnecessary_part(path)
          case path
          when %r{#{PROJECT_NAME}\/repositories\/(?:(?!helpers))}
            "#{PROJECT_NAME}/repositories/"
          when %r{#{PROJECT_NAME}\/entities\/}
            "#{PROJECT_NAME}/entities/"
          else
            PROJECT_NAME
          end
        end
      end
    end
  end
end
