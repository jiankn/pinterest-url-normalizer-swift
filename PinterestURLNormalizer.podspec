Pod::Spec.new do |spec|
  spec.name = 'PinterestURLNormalizer'
  spec.version = '0.1.0'
  spec.summary = 'Parse and normalize Pinterest URLs without network requests.'
  spec.description = <<-DESC
    A zero-dependency Swift library that parses, classifies, and normalizes
    supported Pinterest URLs using an exact hostname allowlist.
  DESC
  spec.homepage = 'https://savepinner.com/pinterest-downloader/'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'SavePinner' => 'jiankn@users.noreply.github.com' }
  spec.source = {
    :git => 'https://github.com/jiankn/pinterest-url-normalizer-swift.git',
    :tag => "v#{spec.version}"
  }
  spec.source_files = 'Sources/PinterestURLNormalizer/**/*.swift'
  spec.swift_versions = ['5.9', '6.0']
  spec.ios.deployment_target = '13.0'
  spec.osx.deployment_target = '10.15'
  spec.tvos.deployment_target = '13.0'
  spec.watchos.deployment_target = '6.0'
end
