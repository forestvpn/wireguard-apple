#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint forestvpn_tunnels_manager.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name                = 'WireGuardKit'
  s.version             = '1.0.15-26.1'
  s.summary             = 'WireGuardKit'
  s.description         = <<-DESC
ForestVPN WireGuardKit
                          DESC
  s.homepage            = 'http://forestvpn.com'
  s.license             = { :type => 'MIT', :file => 'COPYING' }
  s.author              = { 'ForestVPN' => 'support@forestvpn.com' }
  # s.source              = { :path => "." }
  s.source              = { :git => "https://github.com/forestvpn/wireguard-apple.git", :tag => "#{s.version}" }
  # s.source              = { :git => "https://github.com/forestvpn/wireguard-apple.git", :branch => "f/specs" }
  s.platform            = :ios, '12.0'
  s.platform            = :osx, '10.14'
  s.swift_version       = '5.0'
  s.source_files         = 'Sources/WireGuardKit/*'

  s.subspec 'WireGuardKitC' do |sp|
    sp.source_files = 'Sources/WireGuardKitC/*.{c,h}'
    sp.public_header_files = 'Sources/WireGuardKitC/*.h'
    sp.preserve_paths = 'Sources/WireGuardKitC/module.modulemap'
  end

  s.subspec 'WireGuardKitGo' do |sp|
    sp.source_files = 'Sources/WireGuardKitGo/*.{c,h}'
    sp.public_header_files = 'Sources/WireGuardKitGo/*.h'

    sp.preserve_paths = [
      'Sources/WireGuardKitGo/goruntime-boottime-over-monotonic.diff', 
      'Sources/WireGuardKitGo/go.mod', 'Sources/WireGuardKitGo/go.sum', 
      'Sources/WireGuardKitGo/api-apple.go', 'Sources/WireGuardKitGo/Makefile',
      'Sources/WireGuardKitGo/module.modulemap'
    ]
    
    sp.ios.vendored_libraries = [
      'Sources/WireGuardKitGo/lib/ios/libwg-go.a'
    ]

    sp.osx.vendored_libraries = [
      'Sources/WireGuardKitGo/lib/osx/libwg-go.a'
    ]
  end

  s.prepare_command = <<-CMD
      cd Sources/WireGuardKitGo
      
      # Build lib for osx platfrom
      export PLATFORM_NAME="macosx"
      export ARCHS="x86_64 arm64"
      export DESTDIR="lib/osx"
      /usr/bin/make clean && /usr/bin/make build
      
      # Build lib for ios platfrom
      export PLATFORM_NAME="iphoneos"
      export ARCHS="arm64"
      export DESTDIR="lib/ios"
      /usr/bin/make clean && /usr/bin/make build

      # Build lib for ios simulator platfrom
      export PLATFORM_NAME="iphonesimulator"
      export ARCHS="x86_64"
      export DESTDIR="lib/simulator"
      /usr/bin/make clean && /usr/bin/make build

      # For support ios simulator
      /usr/bin/lipo -create -output lib/ios/libwg-go.merged.a \
        lib/ios/libwg-go.a lib/simulator/libwg-go.a
      mv -f lib/ios/libwg-go.merged.a lib/ios/libwg-go.a
    CMD
end
