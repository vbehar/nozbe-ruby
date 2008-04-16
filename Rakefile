require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform         =   Gem::Platform::RUBY
  s.name             =   "nozbe-ruby"
  s.version          =   "0.1.0"
  s.author           =   "Vincent Behar"
  s.email            =   "v.behar@free.fr"
  s.homepage         =   "http://github.com/vbehar/nozbe-ruby"
  s.summary          =   "Ruby wrapper around the JSON-based Nozbe API (Nozbe is a GTD webapp)"
  s.files            =   FileList['lib/**/*'].to_a
  s.require_path     =   "lib"
  s.add_dependency       'json'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "Latest version (#{spec.version}) has been successfully generated !"
  puts "'sudo gem install pkg/#{spec.name}-#{spec.version}.gem' to install"
end

