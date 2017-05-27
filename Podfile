platform :ios, '10.3'

def testingPods
  pod 'Nimble'
end

target 'Hacker' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Library', :path => '~/Projects/Library'
  pod 'R.swift', '~> 3.2'
  pod 'SwiftLint'

  target 'HackerTests' do
    inherit! :search_paths
    testingPods
  end

  target 'HackerUITests' do
    inherit! :search_paths
    testingPods
  end

  target 'Models' do
    pod "ModelMapper", :git => 'git@github.com:gravicle/mapper.git', :branch => 'master'

    target 'ModelsTests' do
      inherit! :search_paths
      testingPods
    end
  end
end

def enableWholeModuleCompilation(target)
  target.build_configurations.each do |config|
    # -wmo for release, wmo-like building but no optimization for other configs
    if config.name == 'Release'
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
    else
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    end
    
    config.build_settings['SWIFT_WHOLE_MODULE_OPTIMIZATION'] = 'YES'  
  end
end

def indexAfterCheckPodsPhase(target)
  checkPodsIndex = 0
  target.build_phases.each_with_index do |phase, index|
    if phase.to_s == "[CP] Check Pods Manifest.lock"
      checkPodsIndex = index + 1
    end
  end

  return checkPodsIndex
end

def removeShellScriptPhasesWithName(name, target)
  target.build_phases.delete_if { |phase| phase.to_s == name }
end

def enableSwiftLint(project) 
  project.targets.each do |target|
    puts target
    removeShellScriptPhasesWithName("SwiftLint", target)
    
    swiftLintPhase = project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
    swiftLintPhase.name = "SwiftLint"
    swiftLintPhase.shell_script = "\"${PODS_ROOT}/SwiftLint/swiftlint\" autocorrect"  
    index = indexAfterCheckPodsPhase(target)
    target.build_phases.insert(index, swiftLintPhase) 
  end
end

def enableRswiftGeneration(project) 
  project.targets.each do |target|
    removeShellScriptPhasesWithName("R.swift", target)
    rswiftPhase = project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
    rswiftPhase.name = "R.swift"
    rswiftPhase.shell_script = "\"$PODS_ROOT/R.swift/rswift\" \"$SRCROOT\/#{target.name}\/\""
    index = indexAfterCheckPodsPhase(target)
    target.build_phases.insert(index, rswiftPhase)
  end
end

post_install do |installer|
  project = Xcodeproj::Project.open(Dir.glob("*.xcodeproj")[0])

  puts "Enabling Whole Module Compilation"
  project.targets.each do |target|
    enableWholeModuleCompilation(target)
  end
  installer.pods_project.targets.each do |target|
    enableWholeModuleCompilation(target)
  end

  puts "Enabling R.swift Generation"
  enableRswiftGeneration(project)

  puts "Enabling SwiftLint"
  enableSwiftLint(project)

  project.save()
end