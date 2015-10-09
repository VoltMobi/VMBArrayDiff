Pod::Spec.new do |s|
  s.name         = "VMBArrayDiff"
  s.version      = "1.0"
  s.license      = { :type => 'MIT' }
  s.summary      = "Library provides a way to diff two arrays"
  s.homepage     = "https://github.com/VoltMobi/VMBArrayDiff"
  s.author       = { "VoltMobi" => "hello@voltmobi.com" }

  s.source       = { :git => "https://github.com/VoltMobi/VMBArrayDiff.git", :tag => "#{s.version}" }
  s.source_files = "ArrayDiff/VMBArrayDiff.{h,m}"
  s.public_header_files = "ArrayDiff/VMBArrayDiff.h"
  s.requires_arc = true
end
