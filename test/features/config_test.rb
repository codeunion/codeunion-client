require "minitest/autorun"

# Verify setting, getting, and unsetting config values end to end.
class TestCodunionConfigFeature < MiniTest::Test
  def config(option)
    `bin/codeunion-config --#{option}`
  end

  def test_setting_a_value
    config("unset test.value")
    config("set test.value 'new_value'")
    actual = config("get test.value").strip()
    assert_equal "new_value", actual
    config("unset test.value")
  end

  def test_unsetting_a_value
    config("set test.value 'new_value'")
    config("set test.other 'brother'")
    config("unset test.value")
    actual = config("get test.value").strip()
    assert_equal "", actual

    actual = config("get test.other").strip()
    assert_equal "brother", actual
  end
end
