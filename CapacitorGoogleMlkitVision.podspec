
  Pod::Spec.new do |s|
    s.name = 'CapacitorGoogleMlkitVision'
    s.version = '0.1.4'
    s.summary = 'Use on-device machine learning in your apps to easily solve real-world problems.'
    s.license = 'MIT'
    s.homepage = 'https://github.com/trancee/capacitor-google-mlkit-vision.git'
    s.author = 'Philipp Grosswiler'
    s.source = { :git => 'https://github.com/trancee/capacitor-google-mlkit-vision.git', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.static_framework = true
    s.dependency 'Capacitor'
    s.dependency 'GoogleMLKit/FaceDetection'
  end
