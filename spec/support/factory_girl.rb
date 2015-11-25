RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end
