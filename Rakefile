require 'spec/rake/spectask'
require 'rake/rdoctask'

require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform         =   Gem::Platform::RUBY
  s.name             =   "nozbe-ruby"
  s.version          =   "0.1.0"
  s.author           =   "Vincent Behar"
  s.email            =   "v.behar@free.fr"
  s.homepage         =   "http://nozbe-ruby.rubyforge.org"
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

namespace :spec do
  spec_opts = 'spec/spec.opts'
  spec_glob = FileList['spec/nozbe_*.rb']
 
  desc 'Run all specs in spec directory'
  Spec::Rake::SpecTask.new(:run) do |t|
    t.spec_opts = ['--options', spec_opts]
    t.spec_files = spec_glob
  end

  desc 'Print Specdoc for all specs'
  Spec::Rake::SpecTask.new(:show) do |t|
    t.spec_opts = ['--options', spec_opts, '--dry-run']
    t.spec_files = spec_glob
  end
end

desc 'Generate RDoc documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_files.add ['README.rdoc', 'MIT-LICENSE', 'lib/**/*.rb']
  rdoc.main = 'README.rdoc'
  rdoc.title = 'Nozbe API - Ruby Wrapper'
  
  rdoc.rdoc_dir = 'doc'
  rdoc.options << '--inline-source'
  rdoc.options << '--all'
  rdoc.options << '--line-numbers'
  rdoc.options << '--charset=UTF-8'
end
