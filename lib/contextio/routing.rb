module ContextIO
  module Routing
    def get(path, options)

      path_array = path.split('/')

      required_keys = path_array.select do |path_element|
        path_element[0] == ':'
      end.map do |path_element|
        path_element.gsub(':', '').to_sym
      end

      required_keys += Array(options[:required])

      define_method(options[:as] || path) do |opts = {}|
        unless required_keys.all? { |key| opts.has_key?(key) }
          raise ArgumentError, "Missing required key. Must have: #{required_keys.join(', ')}"
        end

        opts = opts.merge(options[:options]) if options[:options]

        ContextIO::API.get(self.token, )
      end
    end
  end
end
