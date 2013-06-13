# encoding: utf-8

require 'closure-compiler'
require 'coffeelint'

require 'wiselinks/version'

module Wiselinks  
  class Builder
    include Rake::DSL if defined? Rake::DSL

    class << self      
      attr_accessor :instance

      def install
        self.new.install
      end      
    end


    def install
      desc "Build #{self.name}-#{self.version} CoffeeScript sources."
      task 'build' do
        Rake::Task["coffee:lint"].invoke
        Rake::Task["coffee:build"].invoke
      end

      namespace :coffee do
        desc "Run CoffeeLint over #{self.name}-#{self.version} sources."
        task 'lint' do
          Coffeelint.lint_dir(self.sources) do |filename, lint_report|
            Coffeelint.display_test_results(filename, lint_report)
          end
        end

        desc "Build #{self.name}-#{self.version} CoffeeScript sources."
        task 'build' do
          system("echo '#{self.declaration}' > ./build/wiselinks.js")
          system("coffee -o ./build -j temp.js -c #{self.coffee_sources.join(' ')}")    
          system("cat ./build/temp.js >> ./build/wiselinks.js")

          self.js_sources.each do |file|
            system("cat #{file} >> ./build/wiselinks.js")
          end

          system("java -jar ./compiler.jar --charset UTF-8 --js ./build/wiselinks.js --js_output_file=./build/wiselinks.min.js")

          system("rm ./build/temp.js")
        end
      end

    end

  protected

    def sources
      File.expand_path('../../assets/javascripts', __FILE__)
    end

    def js_sources
      Dir.glob(File.join(self.sources, "**/*.js"))
    end

    def coffee_sources
      Dir.glob(File.join(self.sources, "**/*.js.coffee"))
    end

    def version
      self.specification.version
    end

    def declaration
<<-EOS
/**
 * #{self.name.capitalize}-#{self.version}
 * @copyright 2012-#{Date.today.year} #{self.specification.authors.join(', ')}
 * @preserve https://github.com/igor-alexandrov/wiselinks
 */  
EOS
    end

    def name
      self.specification.name
    end

    def specification
      @specification ||= Gem.loaded_specs['wiselinks']
    end
  end
end

Wiselinks::Builder.install