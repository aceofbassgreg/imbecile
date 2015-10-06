lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)


Gem::Specification.new do |spec|
  spec.name          = 'imbecile'
  spec.date          = Date.today.to_s
  spec.authors       = ['Greg']
  spec.email         = ['gregory.kenenitz@gmail.com']
  spec.summary       = %q{Songs! Meaning!}
  spec.description   = %q{Let's all talk about what these songs mean, am I right?}
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.version       = 0.0.1

  spec.add_dependency 'json'
end