Gem::Specification.new do |s|
  s.name        = 'ale_ruby_interface'
  s.version     = '0.0.1'
  s.date        = '2018-03-14'
  s.summary     = "A ruby version of the arcade learning environment interface."
  s.description = "This directly implements a ruby version of the arcade learning environment interface."
  s.authors     = ["Byron Bai"]
  s.email       = 'byron.bai@aol.com'
  s.files       = ["lib/ale_ruby_interface.rb", "lib/libale_c.so", "lib/ale.cfg"]
  s.homepage    =
    'http://rubygems.org/gems/ale_ruby_interface'
  s.license       = 'MIT'
  s.add_runtime_dependency 'ffi', '~> 1.9', '>= 1.9.0'
  s.add_runtime_dependency 'nmatrix', '~> 0.2', '>= 0.2.4'
end
