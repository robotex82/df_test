# This file is used by Rack-based servers to start the application.


GEM_HOME = '/kunden/314975_60439/.gem'
GEM_PATH = '/kunden/314975_60439/.gem:/usr/lib/ruby/gems/1.8'
require ::File.expand_path('../config/environment',  __FILE__)
run DfTest::Application
