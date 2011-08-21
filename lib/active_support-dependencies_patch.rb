require "active_support-dependencies_patch/version"

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
  
  # take the existing require_or_load method and create a new name for it
  alias_method :require_or_load_without_multiple, :require_or_load
  
  # redefine the method
  def require_or_load(file_name, const_path = nil)
    if file_name.starts_with?( Rails.root.to_s + "/app" )
      relative_name = file_name.gsub( Rails.root.to_s, '' )
      puts "Search for #{relative_name}"
      engine_paths.each do |path|
        engine_file = File.join( path, relative_name )
        
        # call the original method
        if File.file?( engine_file ) then
          require_or_load_without_multiple( engine_file, const_path )
          puts "Found #{engine_file}"
        end
      end
    end
    
    # call the original method
    require_or_load_without_multiple( file_name, const_path )
  end
end
