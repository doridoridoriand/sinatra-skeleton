guard 'livereload' do
  watch(%r{views/.+\.(slim|sass)$})
  watch("webapp.rb")
  watch("config.ru")
end

guard :shotgun, server: "thin", host: "0.0.0.0", port: "3000" do
end
