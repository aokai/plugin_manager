
class PluginManager
  class PluginDefinition
    attr_accessor :name,
                  :version,
                  :object_string,
                  :file,
                  :dependencies,
                  :definition_file,
                  :gems
                  
    def inspect1              
      "<Plugin #{name} #{version} depends:[#{(dependencies||[]).map{|dep| dep.join("")}.join(", ")}] #{required_files.length} files>"
    end
    
    def inspect
      inspect1
    end
    
    def required_files
      @required_files ||= []
    end
    
    def gems
  		@gems ||= []
  	end
    
    def load
      required_files.each {|file| $".delete(file) }
      load_file = File.expand_path(File.join(File.dirname(definition_file), file))
      $:.unshift(File.dirname(load_file))
      puts load_file
      new_files = log_requires do
        require load_file
      end
            
      gems.each do |gem|
      	TipperTruck.get.gem gem[0],gem[1]
      end
      
      required_files.unshift(*new_files)
      if object.respond_to?(:loaded)
        object.loaded
      end
    end
    
    def object
      eval(object_string)
    end
    
    private
    
    def log_requires
      before = $".dup 
      yield
      after = $".dup
      result = after - before
      result
    end
  end
end