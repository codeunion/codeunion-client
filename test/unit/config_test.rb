lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "lib")
$LOAD_PATH.unshift(lib_dir)

require "securerandom"
require "minitest/autorun"
require "codeunion/config"

module CodeUnion
  # Set, Get, and Unset config variables from a real config file.
  class ConfigTest < MiniTest::Test
    def fixture(name)
      File.join(File.dirname(File.expand_path(__FILE__)), "fixtures", name)
    end

    def test_getting_a_value_from_config
      config = Config.load(fixture("sample_config"))
      assert_equal("baz", config.get("foo.bear"))
    end

    def test_setting_a_value_in_a_config
      config = Config.load(fixture("sample_config"))
      config.set("foo.bear", "banana")
      assert_equal("banana", config.get("foo.bear"))
    end

    def test_writing_a_config_file
      File.delete(fixture("mutable_config")) if File.exist?(fixture("mutable_config"))
      config = Config.load(fixture("mutable_config"))
      value = SecureRandom.hex(6)
      key = SecureRandom.hex(6)
      config.set(key, value)
      config.write

      reloaded_config = Config.load(fixture("mutable_config"))

      assert_equal(value, reloaded_config.get(key))
    end
  end
end
