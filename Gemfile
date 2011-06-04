source :gemcutter

gem "rails", "3.0.7"

gem "fastercsv", :platforms => :ruby_18
gem "rack", "~>1.2.1"
gem "rake", "~>0.8.0"
gem "authlogic"
gem "tabular", ">0.0.5"
gem "hoptoad_notifier"
gem "mysql2", "<0.3.0"
gem "pdf-reader", :require => "pdf/reader"
gem "Ascii85", :require => "ascii85"
gem "prawn"
gem "prawn-core", :require => "prawn/core"
gem "vestal_versions", :git => "git://github.com/laserlemon/vestal_versions"
gem "newrelic_rpm"
gem "will_paginate", "~> 3.0.beta"

group :development do
  gem "compass"
  gem "rb-fsevent"
end

group :test do
  gem "ansi"
  gem "mocha"
  gem "minitest"
  gem "selenium-webdriver"
  gem "timecop"
  gem "turn", :git => "https://github.com/yalab/turn.git"
end

group :acceptance do
  gem "selenium-webdriver"
end

group :production do
  gem "SyslogLogger", :require => "syslog_logger"
  gem "unicorn"
end
