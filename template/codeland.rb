def source_paths
  [
    File.join(File.expand_path(File.dirname(__FILE__)), 'files')
  ] + Array(super)
end

def rails_4?
  Rails.gem_version >= Gem::Version.new('4.2')
end

run 'bundle install --quiet'
git :init
git :add => '.'
git :commit => %Q{ -m 'Initial commit' --quiet }

# Ruby and Rails check
if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('2.2')
  if yes?("You are using #{RUBY_VERSION}. Is the version of the project?")
    insert_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", :after => "source 'https://rubygems.org'\n\n"
  end
else
  puts '******* WARNING *******'
  puts "Your Ruby version #{RUBY_VERSION} is too old"
  puts 'Please upgrade to ruby 2.2 or more'
end

gem_group :development do
  gem 'rack-mini-profiler'
  gem 'letter_opener'
end

gem_group :development, :test do
  unless rails_4?
    gem 'pry-rails', '~> 0.3.4'
  end
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-rails', '~> 3.3.3'
  gem 'awesome_print', '~> 1.6.1', :require => false
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'thin', '~> 1.6.3'
  gem 'dotenv-rails', '~ 2.0.2'
end

create_file '.env'
create_file '.env.example'
append_to_file '.gitignore', ".env\n"

gem_group :test do
  gem 'simplecov', '~> 0.10.0', :require => false
  gem 'database_cleaner', '~> 1.4.1'
  gem 'shoulda-matchers', '~> 2.8.0', :require => false
  gem 'capybara'
  gem 'selenium-webdriver'
end
run 'bundle install --quiet'
run 'bundle exec spring binstub rspec'
generate :'rspec:install'
inside 'spec' do
  insert_into_file 'rails_helper.rb', "\nrequire 'shoulda-matchers'", :after => "require 'rspec/rails'"
  insert_into_file 'rails_helper.rb', "\nrequire 'capybara/rspec'", :after => "require 'rspec/rails'"
  insert_into_file 'rails_helper.rb', "\nrequire 'capybara/rails'", :after => "require 'rspec/rails'"
  insert_into_file 'rails_helper.rb', "\nrequire Rails.root.join('spec', 'support', 'blueprints.rb')

Capybara.javascript_driver = :selenium
Capybara.server_port = 52662
Capybara.exact = true\n", :after => "require 'shoulda-matchers'"
  insert_into_file 'rails_helper.rb', "require 'simplecov'
SimpleCov.start('rails')\n", :before => "require 'spec_helper'"

  insert_into_file 'rails_helper.rb', "\nconfig.before(:suite) do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with(:truncation)
end

config.before(:each) do
  DatabaseCleaner.start
end

config.after(:each) do
  DatabaseCleaner.clean
end", :after => 'config.infer_spec_type_from_file_location!'
end
append_to_file '.gitignore', "coverage/\n"
append_to_file '.gitignore', "public/uploads/\n"
git :add => '.'
git :commit => %Q{ -m 'Development & test setup (specs and utilities)' --quiet }

application <<-CONFIG
config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.template_engine :slim
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false
      g.factory_girl true
    end
CONFIG
git :add => '.'
git :commit => %Q{ -m 'Configure generators' --quiet }

gem 'initjs', '~> 2.1.2'
run 'bundle install --quiet'
generate :'initjs:install'
inside 'app' do
  inside 'assets' do
    inside 'javascripts' do
      gsub_file 'application.js', 'require_tree .', "require_tree ./#{@app_name.underscore}"
      create_file 'lib/.keep'
      insert_into_file 'application.js', "//= require_tree ./lib\n", :after => "//= require turbolinks\n"
    end
  end
end
git :add => '.'
git :commit => %Q{ -m 'Install Initjs' --quiet }

gem 'rails-i18n', '~> 4.0.4'
run 'bundle install --quiet'

if yes?('Config for pt-BR?')
  application %Q{config.i18n.enforce_available_locales = false}
  application %Q{config.i18n.available_locales = %i(pt-BR en)}
  application %Q{config.i18n.default_locale = :'pt-BR'}
  application %Q{config.i18n.locale = :'pt-BR'}
  application %Q{config.time_zone = 'Brasilia'}
end
git :add => '.'
git :commit => %Q{ -m 'Install Rails-i18n' --quiet }

gem 'slim-rails', '~> 3.0.1'
run 'bundle install --quiet'
application %Q(config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }), :env => 'development'
application  'config.action_mailer.delivery_method = :letter_opener', :env => 'development'
application  'Slim::Engine.set_options pretty: true', :env => 'development'
git :add => '.'
git :commit => %Q{ -m 'Install Slim-rails' --quiet }

if yes?('Install Devise?')
  gem 'devise', '~> 3.5.2'
  gem 'devise-i18n', '~> 0.12.1'
  run 'bundle install --quiet'
  generate :'devise:install'
  git :add => '.'
  git :commit => %Q{ -m 'Install Devise' --quiet }
end

if yes?('Install ActiveAdmin?')
  gem 'activeadmin', :github => 'activeadmin'
  run 'bundle install --quiet'
  generate :'active_admin:install'
  git :add => '.'
  git :commit => %Q{ -m 'Install Activeadmin' --quiet }
end

if yes?('Install Simpleform?')
  gem 'simple_form', '~> 3.1.0'
  run 'bundle install --quiet'
  generate :'simple_form:install', '--bootstrap'

  git :add => '.'
  git :commit => %Q{ -m 'Install Simpleform' --quiet }
end

if yes?('Install Pundit?')
  gem 'pundit', '~> 1.0.1'
  run 'bundle install --quiet'
  generate :'pundit:install'
  inside 'app' do
    inside 'controllers' do
      insert_into_file 'application_controller.rb', "  include Pundit\n", :after => "class ApplicationController < ActionController::Base\n"
      insert_into_file 'application_controller.rb', '
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para fazer isso."
    redirect_to(request.referrer || root_path)
  end
', :after => "protect_from_forgery with: :exception\n"
    end
  end
  inside 'spec' do
    insert_into_file 'rails_helper.rb', "\nrequire 'pundit/rspec'", :after => "require 'shoulda-matchers'"
  end
  git :add => '.'
  git :commit => %Q{ -m 'Install Pundit' --quiet }
end

# Front-end stuffs

gem 'autoprefixer-rails', '~> 5.2.1'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'font-awesome-rails', '~> 4.4.0'
gem 'draper', '~> 1.3'
run 'bundle install --quiet'

inside 'app' do
  inside 'assets' do
    inside 'stylesheets' do
      directory 'base'
      directory 'organisms'
      directory 'molecules'
      directory 'atoms'
      remove_file 'application.css'
      copy_file 'application.scss'
    end
  end

  empty_directory 'decorators' do
    create_file '.keep'
  end

  inside 'views' do
    directory 'partials'
  end
end

inside 'spec' do
  empty_directory 'decorators' do
    create_file '.keep'
  end
end

if yes?('Install NProgress?')
  gem 'nprogress-rails', '~> 0.1.6'
  run 'bundle install --quiet'
  inside 'app' do
    inside 'assets' do
      inside 'javascripts' do
        insert_into_file 'application.js', "//= require nprogress\n", :after => "//= require turbolinks\n"
        insert_into_file 'application.js', "//= require nprogress-turbolinks\n", :after => "//= require nprogress\n"
      end

      inside 'stylesheets' do
        append_to_file 'application.scss', <<NPROGRESS

// ==== NProgress
// $nprogress-color : ;
// $nprogress-height: ;
@import "nprogress";
NPROGRESS
      end
    end
  end
end

git :add => '.'
git :commit => %Q{ -m 'Setup front-end files' --quiet }

inside 'app' do
  inside 'assets' do
    inside 'javascripts' do
      template 'flash.js.coffee.erb', "#{app_name.underscore}/flash.js.coffee"
      gsub_file "#{app_name.underscore}/#{app_name.underscore}.js.coffee", '  modules: -> []', <<MODULE
  modules: ->
    [
      #{app_const_base}.Flash
    ]
MODULE
    end
  end
  inside 'views' do
    inside 'layouts' do
      copy_file '_flash.html.slim'
      template 'application.html.slim.erb', 'application.html.slim'
      remove_file 'application.html.erb'
    end
  end
end

git :add => '.'
git :commit => %Q{ -m 'Setup default flash messages' --quiet }

gem_group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'passenger', '~> 5.0'
end
run 'bundle install --quiet'
copy_file 'Procfile'
git :add => '.'
git :commit => %Q{ -m 'Heroku setup' --quiet }

append_to_file '.gitignore', "config/database.yml\n"
inside 'config' do
  git :mv => %Q{ database.yml database.yml.sample }
end
git :commit => %Q{ -a -m 'Ignore database.yml in favor of a example' --quiet }

inside 'bin' do
  uncomment_lines 'setup', /(Copying|end$|config\/database)/
  insert_into_file 'setup', "  system \"vi config/database.yml\"\n", :after => "config/database.yml\"\n"
end

git :commit => %Q{ -a -m 'Change bin/setup to copy database.yml' --quiet }

puts '=' * 60
puts 'Project created. Run `bin/setup` to complete the installation.'
puts '=' * 60
