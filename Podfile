platform :ios, '10.3'

def testingPods
  pod 'Nimble'
end

def rxPods
  pod 'RxSwift'
  pod 'RxCocoa'
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

end
