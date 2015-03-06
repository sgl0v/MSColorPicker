Pod::Spec.new do |s|
  s.name             = "MSColorPicker"
  s.version          = "0.1.0"
  s.summary          = "Color picker component for iOS."
  s.homepage         = "https://github.com/sgl0v/MSColorPicker"
  s.license          = 'MIT'
  s.author           = { "Maksym Shcheglov" => "maxscheglov@gmail.com" }
  s.source           = { :git => "https://github.com/sgl0v/MSColorPicker.git", :tag => "0.1.0" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'MSColorPicker/**/*'

  s.public_header_files = 'MSColorPicker/**/*.h'
end
