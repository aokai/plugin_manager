require 'rubygems'
require 'rubygems/dependency_installer'

# This loads and installs gems if needed. This is stolen and modified from: 
# http://github.com/mdub/gem_collector/blob/master/lib/gem_collector.rb
class TipperTruck

	def self.get
		@truck ||= TipperTruck.new
	end
	
	def initialize home = nil
	  if home
	  	Gem.use_paths(home,[home])
	  end
	end
	
	def gem(name, requirements = ">= 0")
	  if !Gem.available? name, requirements
	    puts "Installing #{name} with version #{requirements}"
        installer.install(name, requirements)
      else
	    puts "#{name} with version #{requirements} is already installed"
	  end
	end
	 
	  # Evaluate a block (or String) in a context that auto-installs missing gems
	def eval(*args)
	  instance_eval(*args)
	end
	 
  # Load a Ruby file, auto-installing missing gems
  	def load(file)
    	eval(File.read(file), file)
  	end
 
  	private
 
  	def installer
  		@installer ||= Gem::DependencyInstaller.new 
  	end
end