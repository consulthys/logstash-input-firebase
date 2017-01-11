Gem::Specification.new do |s|
  s.name          = 'logstash-input-firebase'
  s.version       = '0.1.0'
  s.licenses      = ['Apache License (2.0)']
  s.summary       = 'Reads data from the Firebase realtime database'
  s.homepage      = 'https://github.com/consulthys/logstash-input-firebase'
  s.authors       = ['consulthys', 'val']
  s.email         = 'valentin.crettaz@consulthys.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'rufus-scheduler', "~>3.0.9"
  s.add_runtime_dependency 'rest-firebase', '~> 1.1'
  s.add_development_dependency 'logstash-devutils', '>= 0.0.16'
end
