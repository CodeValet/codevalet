require 'yaml'

require 'hashie'

module CodeValet
  module WebApp
    # Simple object wrapping the monkeys.txt for exposure within the web app
    class Monkeys
      MONKEYS_FILE = File.expand_path(File.dirname(__FILE__) + '/../../../monkeys.txt')

      def self.data
        @@monkeys_data ||= File.readlines(MONKEYS_FILE).map(&:chomp).sort
      end

      # Delete the singleton's internal state.
      def self.clear!
        @@monkeys_data = nil
      end
    end
  end
end
