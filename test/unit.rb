test_dir = File.dirname(File.expand_path(__FILE__))

Dir["#{test_dir}/unit/**/*_test.rb"].each do |f|
  require f
end
