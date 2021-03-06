$:.unshift File.join(File.dirname(__FILE__), "..")

require "task_manager"
require "migration_generator"
require "postgres"
require "environment"
require "tempfile"

load "active_record/railties/databases.rake"

db_namespace = namespace :db do
  namespace :migration do
    desc 'Create new migration'
    task :new => ["db:set_migration_paths"] do |t, args|
      if ([:name, :group].all?{|key| options[key].present?})
        ActiveRecord::Migrator.migrations_paths.each do |path|
          Rails::Generators.invoke "sql_migration", [options[:name], "--location=#{path}"],
            :destination_root => Rails.root
        end
      else
        puts "Error: you must provide name and group to generate migration."
        puts "For example: rake #{t.name} NAME=add_field_to_form GROUP=items"
      end
    end
  end


  task :establish_connection do
    if (ENV["DATABASE_URL"].blank?)
      puts "You should specify DATABASE_URL variable to establist connection to database"
      puts "Example: rake db:migrate DATABASE_URL=postgres://avasenin@localhost/test_db GROUP=items"
      abort
    end
    ActiveRecord::Base.configurations = {Rails.env => database_url_config}
    ActiveRecord::Base.establish_connection database_url_config
  end

  task :set_migration_paths do
    if (options[:group].blank?)
      puts "You should specify GROUP variable to set correct migration folder"
      puts "Example: rake db:migration:new NAME=test_migration GROUP=items"
      abort
    end

    ActiveRecord::Base.schema_format = :sql

    root_folder = File.join(Rails.root, "db", options[:group])
    FileUtils.mkdir_p root_folder

    ActiveRecord::Migrator.migrations_paths = [File.join(root_folder, "migrate")]
    Rails.application.paths['db/seeds'] = File.join(root_folder, "seed.rb")
    ENV['DB_STRUCTURE'] = File.join(root_folder, "structure.sql")
  end

  override_task :load_config => [:establish_connection, :set_migration_paths] do
  end

  override_task :create
  override_task :drop

  override_task :setup => [:environment, :load_config] do
    Rake::Task['db:setup:original'].invoke
  end

  namespace :structure do
    override_task :dump => [:environment, :load_config] do
      tempfile = Tempfile.new('migrator-structure').tap(&:close)
      begin
        config = current_config
        unless config['adapter'] =~ /postgres/
          Rake::Task['db:structure:dump:original'].invoke
          next
        end
        set_psql_env(config)
        `pg_dump -i -s -O -f #{Shellwords.escape(tempfile.path)} #{Shellwords.escape(config['database'])}`
        raise 'Error dumping database' if $?.exitstatus == 1
        if ActiveRecord::Base.connection.supports_migrations?
          File.open(tempfile.path, "a") { |f| f << ActiveRecord::Base.connection.dump_schema_information }
        end
        filename = ENV['DB_STRUCTURE'] || File.join(Rails.root, "db", "structure.sql")
        FileUtils.cp tempfile.path, filename
        db_namespace['structure:dump'].reenable
      ensure
         tempfile.unlink   # deletes the temp file
      end
    end
  end
end

def options
  Hash[ENV.map{|key,value| [key.to_s.downcase.parameterize.underscore.to_sym,value]}]
end
