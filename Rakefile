require "rake"

def run!(command)
  puts "Running: #{command}"
  system(command) || abort("Command failed: #{command}")
end

namespace :docker do
  desc "Build Docker image (override IMAGE_NAME, default: sinatra-skeleton:dev)"
  task :build do
    image = ENV.fetch("IMAGE_NAME", "sinatra-skeleton:dev")
    run!("docker build -t #{image} .")
  end

  desc "Build and push multi-arch images via tools/release.sh"
  task :release do
    script = File.expand_path("tools/release.sh", __dir__)
    abort("Missing release script at #{script}") unless File.exist?(script)
    run!(script)
  end
end
