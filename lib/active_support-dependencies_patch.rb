require "active_support-dependencies_patch/version"
require "active_support/deprecation" # must require before dependencies
require "active_support/dependencies"

module ActiveSupport::Dependencies
  
  def engine_paths()
    @engine_paths ||= begin
      begin
        # Rails 3.1 onwards
        Rails::Application::Railties.engines.collect { |engine| engine.config.root.to_s }
      rescue
        begin
          # Rails 3.0
          Rails::Application.railties.engines.collect { |engine| engine.config.root.to_s }
        rescue
          # Rails 2.x
          [] # must be manually registered via ActiveSupport::Dependencies.engine_paths << engine
        end
      end
    end
  end
  
  # alias new name 'require_or_load_without_multiple' to existing method 'require_or_load'
  alias_method :require_or_load_without_multiple, :require_or_load
  
  # redefine the method
  def require_or_load(file_name, const_path = nil)
    if file_name.starts_with?( Rails.root.to_s + "/app" )
      relative_name = file_name.gsub( Rails.root.to_s, '' )
      #puts "AS:DP Require #{relative_name}"
      engine_paths.each do |path|
        engine_file = File.join( path, relative_name )
        #puts "AS:DP Searching for #{engine_file}"
        
        # call the original method
        if File.file?( engine_file ) then
          require_or_load_without_multiple( engine_file, const_path )
          #puts "AS:DP Found #{engine_file}"
        end
      end
    end
    
    # call the original method
    require_or_load_without_multiple( file_name, const_path )
  end
end

#puts "AD:SP loaded"
