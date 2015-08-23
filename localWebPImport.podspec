Pod::Spec.new do |s|
  s.name             = "localWebPImport"
  s.version          = "1.local"
  s.requires_arc     = true

  s.subspec 'WebP' do |webp|
    webp.vendored_frameworks = 'WebP.framework'
  end
end
