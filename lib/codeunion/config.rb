require "yaml"

module CodeUnion
  # A class to manage CodeUnion configuration data
  class Config
    def initialize(config_data)
      @config = Hash(config_data.dup)
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

    private

    def set_dotted(config, dotted_key, value)
      return value if dotted_key.nil?

      key, sub_key = extract_subkey(dotted_key)

      config.merge(key => set_dotted(config[key], sub_key, value))
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
  end
end
