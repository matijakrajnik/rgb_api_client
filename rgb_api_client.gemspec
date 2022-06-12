Gem::Specification.new do |s|
  s.name        = 'rgb_api_client'
  s.version     = '0.0.1'
  s.summary     = 'RGB Web API client.'
  s.description = "Test client used to communicate with RGB Web API."
  s.authors     = ['Matija Krajnik']
  s.email       = 'matija.krajnik90@gmail.com'
  s.license     = 'Nonstandard'
  s.homepage    = 'https://github.com/matijakrajnik/rgb_api_client'
  s.files       = [
    'lib/rgb_api_client.rb',
    'lib/rgb_api_client/rgb_client.rb'
  ] + Dir['lib/rgb_api_client/rgb_api/*.rb']

  s.add_runtime_dependency 'httpclient', '~> 2.8', '>= 2.8.3'
  s.add_runtime_dependency 'httplog', '~> 1.5', '>= 1.5.0'
  s.add_runtime_dependency 'logger', '~> 1.5', '>= 1.5.1'
  s.add_runtime_dependency 'json', '~> 2.6', '>= 2.6.2'
end
