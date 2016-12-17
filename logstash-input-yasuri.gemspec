Gem::Specification.new do |s|
  s.name = 'logstash-input-yasuri'
  s.version         = '5.0.5'
  s.licenses = ['Apache License (2.0)']
  s.summary = "Web scraping input plugin for logstash."
  s.description     = "Web scraping input plugin for logstash."
  s.authors = ["tac0x2a"]
  s.email = 'tac@tac42.net'
  s.homepage = "https://github.com/tac0x2a/logstash-input-yasuri"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', '~> 2'
  s.add_runtime_dependency 'stud', '>= 0.0.22'
  s.add_runtime_dependency 'yasuri', '~> 1.9'
  s.add_runtime_dependency 'rufus-scheduler', '>= 0'
  s.add_development_dependency 'logstash-devutils', '>= 0.0.16'
  s.add_development_dependency 'logstash-codec-plain'
  s.add_development_dependency 'fuubar', '>= 2.2.0'
end
