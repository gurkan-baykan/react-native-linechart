require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "LineChart"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => '12.0'  }
  s.source       = { :git => "https://github.com/gurkan-baykan/LineChart.git", :tag => "#{s.version}" }

  s.source_files = [
    "ios/**/*.{h,c,cc,cpp,m,mm,swift}",  
    "cpp/**/*.{h,cpp}"
  ]
  
  s.module_name = "LineChart"
  s.module_map = "ios/module.modulemap"
  
  s.dependency "React"
  s.dependency "React-Core"
  s.dependency "DGCharts", "~> 5.1.0"

  s.swift_version = '5.0'

  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-D RCT_NEW_ARCH_ENABLED',
   'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',

    "HEADER_SEARCH_PATHS" => '"$(PODS_TARGET_SRCROOT)/cpp/"/**',
    "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
    'CLANG_CXX_LIBRARY' => 'libc++',
  }

  # Use install_modules_dependencies helper to install the dependencies if React Native version >=0.71.0.
  # See https://github.com/facebook/react-native/blob/febf6b7f33fdb4904669f99d795eba4c0f95d7bf/scripts/cocoapods/new_architecture.rb#L79.
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  end
end
