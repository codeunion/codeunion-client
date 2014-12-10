require 'minitest/autorun'

class TestCodunionConfigFeature < MiniTest::Test
  def config(option)
    `bin/codeunion-config --#{option}`
  end

  def test_setting_a_value
    config('unset test.value')
    config('set test.value "new_value"')
    actual = config('get test.value').strip()
    assert_equal "new_value", actual
    config('unset test.value')
  end
end
