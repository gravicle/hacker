platform :ios, '10.3'

def testingPods
  pod 'Nimble'
end

def rxPods
  pod 'RxSwift'
  pod 'RxCocoa'
end

def networkingPods
  pod "ModelMapper"
  pod 'Marshal'
end

target 'Hacker' do
  use_frameworks!
  inhibit_all_warnings!

  rxPods

  target 'HackerTests' do
    inherit! :search_paths
    testingPods
  end

  target 'HackerUITests' do
    inherit! :search_paths
    testingPods
  end

  target 'Models' do
    networkingPods

    target 'ModelsTests' do
      inherit! :search_paths
      testingPods
    end
  end
  

end
