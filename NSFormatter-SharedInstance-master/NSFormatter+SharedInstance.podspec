Pod::Spec.new do |s|
  s.name         = "NSFormatter+SharedInstance"
  s.version      = "1.0"
  s.summary      = "Category on NSFormatter to simplify formatters sharing and memory managment."

  s.description  = <<-DESC
                   NSFormatter and its subclasses have an speceific behaviour: they are too heavy for
                   many times initializations and should not be used in different threads.
                   
                   Lets simplify formatters' creation and managment with simple and powerful category!
                   
                   DESC
                   
  s.homepage     = "https://github.com/bernikowich/NSFormatter+SharedInstance"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = "Timur Bernikowich"
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/bernikowich/NSFormatter+SharedInstance.git", :tag => "1.0" }
  s.source_files = 'NSFormatter+SharedInstance.{h,m}'
  s.requires_arc = true
end
