Pod::Spec.new do |s|
  s.name         = "HCKitProject"
  s.version      = "0.4.6"
  s.ios.deployment_target = '7.0'
  s.license = 'MIT'
  s.summary      = "a Encapsulation of FMDB."
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
  
  s.default_subspec = 'Whole'

  s.subspec 'Whole' do |wh|
      wh.dependency 'HCKitProject/Core'
      wh.dependency 'HCKitProject/HCDB'
      wh.dependency 'HCKitProject/HCHTTPRequest'

  end

  s.subspec 'Core' do |core|
    	core.source_files = 'HCCore/*.{h,m}','HCCore/Classes/*.{h,m}','HCCore/CommonCategory/*.{h,m}','HCCore/RuntimeInfo/*.{h,m}'
  end

  s.subspec 'HCDB' do |db|
    	db.source_files = 'HCDB/*.{h,m}'
      	db.resource = 'HCDB/Resources/*'
      	db.dependency 'HCKitProject/Core'
		db.ios.dependency  'FMDB', '~> 2.3'
  end

  s.subspec 'HCHTTPRequest' do |ht|
    	ht.source_files = 'HCRequestApi/*.{h,m}'
      	ht.dependency 'HCKitProject/Core'
		ht.ios.dependency  'AFNetworking', '~> 3.0.4'
  end


end

