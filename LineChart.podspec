require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
new_arch_enabled = ENV['RCT_NEW_ARCH_ENABLED']

Pod::Spec.new do |s|
  s.name            = "LineChart"
  s.version         = package["version"]
  s.summary         = package["description"]
  s.description     = package["description"]
  s.homepage        = package["homepage"]
  s.license         = package["license"]
  s.platforms       = { :ios => '12' }
  s.author          = package["author"]
  s.source          = { :git => package["repository"]["url"], :tag => "#{s.version}" }
  s.requires_arc     = true
  s.swift_version    = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.source_files    = [ 
    "ios/**/*.{h,m,mm,swift}",
    "ios/Components/**/*.{h,m,mm,swift}",
    "ios/Formatters/**/*.{h,m,mm,swift}",
    "ios/utils/**/*.{h,m,mm,swift}"
  ]

  if new_arch_enabled
    s.pod_target_xcconfig = {
      'OTHER_SWIFT_FLAGS' => '-D RCT_NEW_ARCH_ENABLED',
    }
  end

  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency 'React-Core', :modular_headers => true
    s.dependency 'DGCharts', '~> 5.1' 
  end
end