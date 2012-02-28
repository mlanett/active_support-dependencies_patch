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
      engine_paths.each do |path|
        engine_file = File.join( path, relative_name )
        
        # call the original method
        if File.file?( engine_file ) then
          observe_require( "engine file #{engine_file} path #{const_path}" ) {
            require_or_load_without_multiple( engine_file, const_path )
          }
        end
      end
    end
    
    # call the original method
    observe_require( "original file #{file_name} path #{const_path}" ) {
      require_or_load_without_multiple( file_name, const_path )
    }
  end

  def observe_require( file )
    yield
  rescue => x
    STDERR.puts "AS:DP Failed to required #{file} due to an error #{x.inspect}"
    raise x
  else
    # STDERR.puts "AS:DP Required #{file}"
  end
end

#puts "AD:SP loaded"
