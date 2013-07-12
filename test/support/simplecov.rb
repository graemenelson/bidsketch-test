if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start do
    add_filter "/config/"
    add_filter "/test/"  
    #add_filter "/features/"
    add_filter "/db/"
  end
end