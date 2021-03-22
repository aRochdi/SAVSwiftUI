#!/usr/bin/env bash

set -e
export PATH=$PATH:/usr/local/bin

bundle config path local/gems
bundle config without documentation:test
bundle config set no-cache 'true'

bundle install --quiet
bundle binstubs --all

#be sure to use last ugap
./bin/pod cache clean 'UGAP' --all

./bin/pod install || if [[ $? != 0 ]]; then ./bin/pod install --repo-update; fi

#optimize Xcode compilation (max 5 concurrent builds)
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks $((( $(sysctl -n hw.ncpu) > 5) ? 5 : $(sysctl -n hw.ncpu) ))
#display compilation duration
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES
#parallelize commands
defaults write com.apple.dt.Xcode BuildSystemScheduleInherentlyParallelCommandsExclusively -bool YES
echo "Xcode tweaks installed"