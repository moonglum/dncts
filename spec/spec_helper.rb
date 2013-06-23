RSpec.configure do |configuration|
  configuration.expect_with :rspec do |c|
    c.syntax = :expect
  end

  configuration.mock_with :rspec do |c|
    c.syntax = :expect
  end
end
