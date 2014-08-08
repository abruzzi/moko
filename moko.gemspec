Gem::Specification.new do |s|
    s.name        = "moko"
    s.version     = "0.2.0"
    s.date        = "2014-08-08"
    s.summary     = "moko is a helper for build restful API in secs"
    s.description = "moko is used for build restful API in secs, for testing puropse"
    s.authors     = ["Juntao Qiu"]
    s.email       = "juntao.qiu@gmail.com"
    s.files       = ["lib/moko.rb", "lib/template/resource.erb", "lib/defaults.yml"]
    s.add_runtime_dependency 'activesupport', '>=4.0.2'
    s.add_runtime_dependency 'thor', '>=0.18.1'
    s.executables << "mokoup"
    s.homepage    = "https://github.com/abruzzi/moko"
    s.license     = "MIT"
end
