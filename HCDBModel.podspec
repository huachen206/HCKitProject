Pod::Spec.new do |s|
  s.name         = “HCKitProject”
  s.version      = "0.0.1"
  s.summary      = "a Encapsulation of FMDB."
  s.ios.deployment_target = '7.1'
  s.license = 'MIT'
  s.homepage     = "https://github.com/huachen206/HCKitProject.git"

  s.author             = { "HuaChen" => "huachen206@163.com" }
  s.source       = { :git => "https://github.com/huachen206/HCKitProject.git", :tag => s.version }

  s.description  = <<-DESC
                   A longer description of HCDBModel in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.requires_arc = true
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    	core.source_files = 'HCDB/*.{h,m}'
	mk.ios.dependency  'FMDB', '~> 2.3'

  end

  s.subspec 'HCDB' do |mk|
    	mk.source_files = 'HCDB/*.{h,m}'
	mk.ios.dependency  'FMDB', '~> 2.3'
  end

end

