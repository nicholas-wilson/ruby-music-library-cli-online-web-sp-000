class MusicLibraryController

  def initialize(path = "./db/mp3s")
    @importer = MusicImporter.new(path)
    @importer.import
  end

  def call
    input = ""
    until input == "exit"
      puts "Welcome to your music library!"
      puts "To list all of your songs, enter 'list songs'."
      puts "To list all of the artists in your library, enter 'list artists'."
      puts "To list all of the genres in your library, enter 'list genres'."
      puts "To list all of the songs by a particular artist, enter 'list artist'."
      puts "To list all of the songs of a particular genre, enter 'list genre'."
      puts "To play a song, enter 'play song'."
      puts "To quit, type 'exit'."
      puts "What would you like to do?"
      input = gets.chomp
      run_commands(input)
    end
  end

  def list_songs
    index = 1
    Song.sort_by_name
    Song.all.each do |song|
      puts "#{index}. #{song.artist.name} - #{song.name} - #{song.genre.name}"
      index += 1
    end
  end

  def list_artists
    index = 1
    Artist.remove_dupes
    Artist.all.sort! do |artist1, artist2|
      artist1.name <=> artist2.name
    end
    Artist.all.each do |artist|
      puts "#{index}. #{artist.name}"
      index += 1
    end
  end

  def list_genres
    index = 1
    Genre.all.sort! do |genre1, genre2|
      genre1.name <=> genre2.name
    end
    Genre.all.each do |genre|
      puts "#{index}. #{genre.name}"
      index += 1
    end
  end

  def list_songs_by_artist
    puts "Please enter the name of an artist:"
    input = gets.chomp
    index = 1
    artist = Artist.find_by_name(input)
    if artist
      artist.songs.sort! do |song1, song2|
        song1.name <=> song2.name
      end
      artist.songs.each do |song|
        puts "#{index}. #{song.name} - #{song.genre.name}"
        index += 1
      end
    end
  end

  def list_songs_by_genre
    puts "Please enter the name of a genre:"
    input = gets.chomp
    index = 1
    genre = Genre.find_by_name(input)
    if genre
      genre.songs.sort! do |song1, song2|
        song1.name <=> song2.name
      end
      genre.songs.each do |song|
        puts "#{index}. #{song.artist.name} - #{song.name}"
        index += 1
      end
    end
  end

  def play_song
    puts "Which song number would you like to play?"
    Song.sort_by_name
    songs = Song.all
    input = gets.chomp.to_i
    if input.class == Integer
      if input < Song.all.length && input > 0
        song = songs[input - 1]
        puts "Playing #{song.name} by #{song.artist.name}"
      end
    end
  end

  def run_commands(input_from_user)
    if input_from_user == "list songs"
      list_songs
    elsif input_from_user == "list artists"
      list_artists
    elsif input_from_user == "list genres"
      list_genres
    elsif input_from_user == "list artist"
      list_songs_by_artist
    elsif input_from_user == "list genre"
      list_songs_by_genre
    elsif input_from_user == "play song"
      play_song
    end
  end
end
