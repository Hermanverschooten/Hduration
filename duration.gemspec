# -*- encoding: utf-8 -*-
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'hduration/version'

Gem::Specification.new do |gem|
  gem.name          = "duration"
  gem.version       = Hduration::VERSION
  gem.authors       = ["Herman verschooten","Paul Gibler", "Patrick Robertson"]
  gem.email         = %q{paul.gibler@gmail.com, patrick.robertson@velir.com, Herman@verschooten.net}
  gem.description   = %q{This is a fork of the duration gem hosted on RubyForge.com, which is used to calculate time intervals.}
  gem.summary       = %q{This is a fork of the duration gem hosted on RubyForge.com, which is used to calculate time intervals.}
  gem.homepage      = "https://github.com/Hermanverschooten/duration"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
