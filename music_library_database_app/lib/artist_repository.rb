require_relative 'artist'

class ArtistRepository
  def all
    artists = []

    # Send the SQL query and get the result set.
    sql = 'SELECT id, name, genre FROM artists;'
    result_set = DatabaseConnection.exec_params(sql, [])
    
    # The result set is an array of hashes.
    # Loop through it to create a model
    # object for each record hash.
    result_set.each do |record|

      # Create a new model object
      # with the record data.
      artist = Artist.new
      artist.id = record['id'].to_i
      artist.name = record['name']
      artist.genre = record['genre']

      artists << artist
    end

    return artists
  end

  def find(id)
    sql = 'SELECT id, name, genre FROM artists WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id]).map {|el| Artist.new(el["id"].to_i, el["name"], el["genre"])}
    return result_set[0]
  end

  def find_by_name(name)
    sql = 'SELECT * FROM artists WHERE name = $1'
    result_set = DatabaseConnection.exec_params(sql, [name]).map {|el| Artist.new(el["id"].to_i, el["name"], el["genre"])}
    return result_set[0]
  end

  def create(artist)
    sql = 'INSERT INTO artists (name, genre) VALUES ($1, $2);'
    result_set = DatabaseConnection.exec_params(sql, [artist.name, artist.genre])

    return find_by_name(artist.name)
  end
end