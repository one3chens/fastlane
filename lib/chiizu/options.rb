require 'fastlane_core'
require 'credentials_manager'

module Chiizu
  class Options
    def self.available_options
      output_directory = (File.directory?("fastlane") ? "fastlane/screenshots" : "screenshots")

      @@options ||= [
        FastlaneCore::ConfigItem.new(key: :locales,
                                     description: "A list of locales which should be used",
                                     short_option: "-q",
                                     type: Array,
                                     default_value: ['en-US']),
        FastlaneCore::ConfigItem.new(key: :clear_previous_screenshots,
                                     env_name: 'CHIIZU_CLEAR_PREVIOUS_SCREENSHOTS',
                                     description: "Enabling this option will automatically clear previously generated screenshots before running chiizu",
                                     default_value: false,
                                     is_string: false),
        FastlaneCore::ConfigItem.new(key: :output_directory,
                                     short_option: "-o",
                                     env_name: "CHIIZU_OUTPUT_DIRECTORY",
                                     description: "The directory where to store the screenshots",
                                     default_value: output_directory),
        FastlaneCore::ConfigItem.new(key: :skip_open_summary,
                                     env_name: 'CHIIZU_SKIP_OPEN_SUMMARY',
                                     description: "Don't open the HTML summary after running `chiizu`",
                                     default_value: false,
                                     is_string: false),
        FastlaneCore::ConfigItem.new(key: :app_package_name,
                                     env_name: 'CHIIZU_APP_PACKAGE_NAME',
                                     short_option: "-a",
                                     description: "The package name of the app under test (e.g. com.yourcompany.yourapp)",
                                     default_value: ENV["CHIIZU_APP_PACKAGE_NAME"] || CredentialsManager::AppfileConfig.try_fetch_value(:package_name)),
        FastlaneCore::ConfigItem.new(key: :tests_package_name,
                                     env_name: 'CHIIZU_TESTS_PACKAGE_NAME',
                                     optional: true,
                                     description: "The package name of the tests bundle (e.g. com.yourcompany.yourapp.test)"),
        FastlaneCore::ConfigItem.new(key: :use_tests_in_packages,
                                     env_name: 'CHIIZU_USE_TESTS_IN_PACKAGES',
                                     optional: true,
                                     short_option: "-p",
                                     type: Array,
                                     description: "Only run tests in these Java packages"),
        FastlaneCore::ConfigItem.new(key: :use_tests_in_classes,
                                     env_name: 'CHIIZU_USE_TESTS_IN_CLASSES',
                                     optional: true,
                                     short_option: "-l",
                                     type: Array,
                                     description: "Only run tests in these Java classes"),
        FastlaneCore::ConfigItem.new(key: :test_instrumentation_runner,
                                     env_name: 'CHIIZU_TEST_INSTRUMENTATION_RUNNER',
                                     optional: true,
                                     default_value: 'android.support.test.runner.AndroidJUnitRunner',
                                     description: "The fully qualified class name of your test instrumentation runner"),
        FastlaneCore::ConfigItem.new(key: :ending_locale,
                                     env_name: 'CHIIZU_ENDING_LOCALE',
                                     optional: true,
                                     is_string: true,
                                     default_value: 'en-US',
                                     description: "Return the device to this locale after running tests"),
        FastlaneCore::ConfigItem.new(key: :app_apk_path,
                                     env_name: 'CHIIZU_APP_APK_PATH',
                                     optional: true,
                                     description: "The path to the APK for the app under test",
                                     short_option: "-k",
                                     default_value: Dir[File.join("app", "build", "outputs", "apk", "app-debug.apk")].last,
                                     verify_block: proc do |value|
                                       raise "Could not find APK file at path '#{value}'".red unless File.exist?(value)
                                     end),
        FastlaneCore::ConfigItem.new(key: :tests_apk_path,
                                     env_name: 'CHIIZU_TESTS_APK_PATH',
                                     optional: true,
                                     description: "The path to the APK for the the tests bundle",
                                     short_option: "-b",
                                     default_value: Dir[File.join("app", "build", "outputs", "apk", "app-debug-androidTest-unaligned.apk")].last,
                                     verify_block: proc do |value|
                                       raise "Could not find APK file at path '#{value}'".red unless File.exist?(value)
                                     end)
      ]
    end
  end
end
