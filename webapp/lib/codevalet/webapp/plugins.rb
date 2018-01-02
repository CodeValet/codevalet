require 'yaml'

require 'hashie'

module CodeValet
  module WebApp
    # Simple object wrapping the plugins.yaml for exposure within the web app
    class Plugins
      PLUGINS_FILE = File.expand_path(File.dirname(__FILE__) + '/../../../plugins.yaml')

      # Load and return the raw plugin data from +plugins.yaml+
      #
      # @return [Hash] deserialized representation of +plugins.yaml+
      def self.data
        @@plugin_data ||= YAML.load(File.read(PLUGINS_FILE))
      end


      # Load and return the essential list of plugins and their repositories
      #
      # @return [Hash]
      def self.essential
        return self.data['essential']
      end

      # Delete the singleton's internal state.
      def self.clear!
        @@plugin_data = nil
      end
    end
  end
end
