class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_service_file
    template "service.rb.erb", File.join("app/services", class_path, "#{file_name}_service.rb")
  end

  def create_test_file
    template "service_test.rb.erb", File.join("test/services", class_path, "#{file_name}_service_test.rb")
  end
end
