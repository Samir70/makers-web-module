# class Album
#   attr_accessor :id, :title, :release_year, :artist_id
# end

Album = Struct.new(:id, :title, :release_year, :artist_id, :artist_name)