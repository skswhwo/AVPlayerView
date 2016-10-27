Pod::Spec.new do |s|
s.name             = 'AVPlayerView'
  s.version          = '1.2.3'
  s.platform         = :ios, '7.0'
  s.summary          = 'AVPlayer module that implemented by subclass of UIView class'
  s.homepage         = 'https://github.com/skswhwo/AVPlayerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'skswhwo' => 'skswhwo@gmail.com' }
  s.source           = { :git => 'https://github.com/skswhwo/AVPlayerView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files     = 'AVPlayerView/Classes/**/*.{h,m}'
  s.resources        = 'AVPlayerView/Assets/**/*.{png,bundle,xib,nib,xcassets}'

  s.requires_arc     = true
end
