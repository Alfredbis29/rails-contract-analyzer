require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  # Use :none for Rails 7.1+ preferred syntax.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Avoid surprise SSL redirects in request specs.
  config.force_ssl = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  # Skip asset compilation in tests for speed.
  # config.assets.compile = false

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Required if your tests generate mailer URLs.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Reduce test output noise by suppressing info/debug logs.
  config.log_level = :warn

  # Silence logs entirely for faster test runs (comment out log_level above if using this).
  # config.logger = Logger.new(nil)

  # Suppress verbose SQL query logging.
  config.active_record.verbose_query_logs = false

  # Ensure DB schema is kept in sync with migrations.
  config.active_record.maintain_test_schema = true

  # Turn SQL warnings into errors to catch subtle DB issues early.
  config.active_record.sql_warning_handler = :error

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Controls when test parallelization kicks in (number of tests threshold).
  config.active_support.test_parallelization_threshold = 50

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end