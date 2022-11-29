require_relative "album"

class AlbumRepository
  def all
    # Send the SQL query and get the result set.
    sql = "SELECT albums.id as album_id, title, release_year, artist_id, name FROM albums JOIN artists ON artist_id = artists.id;"
    return DatabaseConnection.exec_params(sql, []).map { |el|
             Album.new(el["album_id"].to_i, el["title"], el["release_year"].to_i, el["artist_id"].to_i, el["name"])
           }
  end

  def find(id)
    sql = "SELECT albums.id as album_id, title, release_year, name, artist_id FROM albums JOIN artists ON artists.id = artist_id WHERE albums.id = $1;"
    res = DatabaseConnection.exec_params(sql, [id])[0]

    return Album.new(res["album_id"].to_i, res["title"], res["release_year"].to_i, res["artist_id"].to_i, res["name"])
  end

  def create(album)
    sql = "INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);"
    result_set = DatabaseConnection.exec_params(sql, [album.title, album.release_year, album.artist_id])
    puts "created album"
    puts album
    DatabaseConnection.exec_params("SELECT * FROM albums", []).each {|el| puts el}
    return album
  end

  def delete(id)
    sql = "DELETE FROM albums WHERE id = $1;"
    DatabaseConnection.exec_params(sql, [id])
  end
end
