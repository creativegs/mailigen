require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'

  add_group 'All', 'lib/'
end unless ENV['COV'] == 'false'
