module Fastlane
  module Actions
    class SetChangelogAction < Action
      def self.run(params)
        require 'spaceship'

        Spaceship::Tunes.login(params[:username])
        app = Spaceship::Application.find(params[:app_identifier])

        version_number = params[:version]
        unless version_number
          # Automatically fetch the latest version
          UI.message("Fetching the latest version for this app")
          if app.edit_version and app.edit_version.version
            version_number = app.edit_version.version
          else
            UI.message("You have to specify a new version number: ")
            version_number = STDIN.gets.strip
          end
        end

        UI.message("Going to update version #{version_number}")

        changelog = params[:changelog]
        unless changelog
          path = "./fastlane/changelog.txt"
          UI.message("Looking for changelog in '#{path}'...")
          if File.exist? path
            changelog = File.read(path)
          else
            UI.error("Couldn't find changelog.txt")
            UI.message("Please enter the changelog here:")
            changelog = STDIN.gets
          end
        end

        UI.important("Going to update the changelog to:\n\n#{changelog}\n\n")

        if (v = app.edit_version)
          if v.version != version_number
            # Version is already there, make sure it matches the one we want to create
            UI.message("Changing existing version number from '#{v.version}' to '#{version_number}'")
            v.version = version_number
            v.save!
          else
            UI.message("Updating changelog for existing version #{v.version}")
          end
        else
          UI.message("Creating the new version: #{version_number}")
          app.create_version!(version_number)
          app = Spaceship::Application.find(params[:app_identifier]) # Replace with .reload method once available
          v = app.edit_version
        end

        v.release_notes.languages.each do |lang|
          v.release_notes[lang] = changelog
        end
        UI.message("Uploading changes to iTunes Connect...")
        v.save!

        UI.success("???? Successfully pushed the new changelog to #{v.url}")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Set the changelog for all languages on iTunes Connect"
      end

      def self.details
        "This is useful if you have only one changelog for all languages"
      end

      def self.available_options
        user = CredentialsManager::AppfileConfig.try_fetch_value(:itunes_connect_id)
        user ||= CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)

        [
          FastlaneCore::ConfigItem.new(key: :app_identifier,
                                     short_option: "-a",
                                     env_name: "FASTLANE_APP_IDENTIFIER",
                                     description: "The bundle identifier of your app",
                                     default_value: CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier)),
          FastlaneCore::ConfigItem.new(key: :username,
                                     short_option: "-u",
                                     env_name: "FASTLANE_USERNAME",
                                     description: "Your Apple ID Username",
                                     default_value: user),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "FL_SET_CHANGELOG_VERSION",
                                       description: "The version number to create/update",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :changelog,
                                       env_name: "FL_SET_CHANGELOG_CHANGELOG",
                                       description: "Changelog text that should be uploaded to iTunes Connect",
                                       optional: true)
        ]
      end

      def self.authors
        ["KrauseFx"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include? platform
      end
    end
  end
end
