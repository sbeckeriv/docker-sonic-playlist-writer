require "rexml/document"
require "httparty"
require "pp"

remove = ARGV[5]
add = ARGV[6]
playlist_path = ARGV[4] ||"/playlists"

def url(path, argv)
  username = argv[0]
  token = argv[1]
  salt = argv[2]
  host = argv[3]
  question = path.include?("?") ? "&" : "?"
  "http://#{host}/rest/#{path}#{question}u=#{username}&t=#{token}&s=#{salt}&c=rubyplaylist&v=1.16.1"
end

playlists = HTTParty.get(url("getPlaylists", ARGV))
playlists.dig("subsonic_response","playlists", "playlist").each do |e|
  playlist = HTTParty.get(url("getPlaylist?id=#{e["id"]}", ARGV))
  entries = playlist.dig("subsonic_response","playlist","entry")
  if entries
    puts filename= "#{playlist_path}/#{playlist.dig("subsonic_response","playlist","name")}-#{e["id"]}.m3u8"
    file = File.open(filename, "w")
    entries.each do |item|
      path = item["path"]
      path.sub!(remove,"") if remove
      path = "#{add}#{path}"
      file.puts path
    end
  end
end
