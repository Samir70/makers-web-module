require_relative 'album'

class AlbumRepository
  def all
    albums = []

    # Send the SQL query and get the result set.
    sql = 'SELECT id, title, release_year, artist_id FROM albums;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    # The result set is an array of hashes.
    # Loop through it to create a model
    # object for each record hash.
    result_set.each do |record|

      # Create a new model object
      # with the record data.
      album = Album.new
      album.id = record['id'].to_i
      album.title = record['title']
      album.release_year = record['release_year']
      album.artist_id = record['artist_id'].to_i

      albums << album
    end

    return albums
  end

  def find(id)
    sql = 'SELECT albums.id as album_id, title, release_year, name, artist_id FROM albums JOIN artists ON artists.id = artist_id WHERE albums.id = $1;'
    res = DatabaseConnection.exec_params(sql, [id])[0]

    album = Album.new(res["album_id"].to_i, res["title"], res["release_year"].to_i, res["artist_id"].to_i, res["name"])
    # album.id = result_set[0]['id'].to_i
    # album.title = result_set[0]['title']
    # album.release_year = result_set[0]['release_year']
    # album.artist_id = result_set[0]['artist_id'].to_i

    return album
  end

  def create(album)
    sql = 'INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);'
    result_set = DatabaseConnection.exec_params(sql, [album.title, album.release_year, album.artist_id])

    return album
  end

  def delete(id)
    sql = 'DELETE FROM albums WHERE id = $1;';
    DatabaseConnection.exec_params(sql, [id]);
  end
end