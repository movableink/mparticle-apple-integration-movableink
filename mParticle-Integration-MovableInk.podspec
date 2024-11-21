Pod::Spec.new do |s|
    s.name             = "mParticle-Integration-MovableInk"
    s.version          = "8.0.0"
    s.summary          = "MovableInk integration for mParticle"

    s.description      = <<-DESC
                       This is the MovableInk integration for mParticle.
                       DESC

    s.homepage         = "https://movableink.com"
    s.license          = { :type => "Apache 2.0", :file => "LICENSE" }
    s.author           = { "MovableInk" => "dev@movableink.com" }
    s.source           = { :git => "https://github.com/movableink/mparticle-apple-integration-movableink.git", :tag => s.version.to_s }
    s.swift_version    = "6"
    s.ios.deployment_target = "13.0"
    s.ios.source_files      = "mParticle-MovableInk/*.{h,m}"

    s.ios.dependency "mParticle-Apple-SDK", "~> 8.0"
    s.ios.dependency "MovableInk", "~> 1.7"
end
