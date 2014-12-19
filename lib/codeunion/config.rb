require "yaml"

module CodeUnion
  # Manages CodeUnion configuration data
  class Config
    DEFAULT_CONFIG_FILE = File.join(Dir.home, ".codeunion", "config")

    def self.load(config_file_path = DEFAULT_CONFIG_FILE)
      CodeUnion::Config.new(FileAdapter.new(config_file_path))
    end

    def initialize(config_file)
      @file = config_file
      @config = Hash(config_file)
      @config.default_proc = proc { |h, k| h[k] = {} }
    end

    def set(dotted_key, value)
      @config = set_dotted(@config, dotted_key, value)
      self
    end

    def unset(dotted_key)
      @config = unset_dotted(@config, dotted_key)
      self
    end

    def get(dotted_key)
      get_dotted(@config, dotted_key)
    end

    def to_hash
      @config.dup
    end

    alias_method :to_h, :to_hash

    def write
      @file.write(to_hash)
    end

    private

    def set_dotted(config, dotted_key, value)
      return value if dotted_key.nil?

      key, sub_key = extract_subkey(dotted_key)

      config.merge({ key => set_dotted(config[key], sub_key, value) })
    end

    def unset_dotted(config, dotted_key)
      key, sub_key = extract_subkey(dotted_key)
      if sub_key
        unset_dotted(config[key], sub_key)
        config.delete(key) if config[key].empty?
      else
        config.delete(key)
      end
    end

    def get_dotted(config, dotted_key)
      key, sub_key = extract_subkey(dotted_key)

      if sub_key
        get_dotted(config[key], sub_key)
      else
        config[key]
      end
    end

    def extract_subkey(dotted_key)
      dotted_key.split(".", 2)
    end

    # Reads and writes YAML to the FileSystem
    class FileAdapter
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def write(data)
        ensure_exists!
        write_fearlessly(data)
      end

      def to_hash
        ensure_exists!
        YAML.load_file(file_path).dup
      end

      alias_method :to_h, :to_hash

      private

      def write_fearlessly(data)
        File.open(file_path, "w") do |f|
          f.write YAML.dump(Hash(data))
        end
      end

      def ensure_exists!
        config_dir = File.dirname(file_path)
        FileUtils.mkdir(config_dir) unless Dir.exist?(config_dir)
        write_fearlessly({}) unless File.exist?(file_path)
      end
    end
  end
end
