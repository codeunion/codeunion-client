require "codeunion/command/base"
require "codeunion/config"
require "fileutils"

module CodeUnion
  module Command
    # The bulit-in `codeunion config` command
    class Config < Base
      CONFIG_DIR  = File.join(Dir.home, ".codeunion")
      CONFIG_FILE = File.join(CONFIG_DIR, "config")

      def run
        ensure_config_exists!

        case args.length
        when 1
          puts config.get(*args)
        when 2
          config.set(*args)
        end

        save_config!
      end

      private

      def config
        @config ||= CodeUnion::Config.new(YAML.load_file(CONFIG_FILE))
      end

      def ensure_config_exists!
        FileUtils.mkdir(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
        write_config_data({}) unless File.exist?(CONFIG_FILE)
      end

      def save_config!
        write_config_data(config)
      end

      def write_config_data(data)
        File.open(CONFIG_FILE, "w") do |f|
          f.write YAML.dump(Hash(data))
        end
      end
    end
  end
end
