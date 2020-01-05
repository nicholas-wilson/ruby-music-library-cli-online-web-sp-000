class Song
  extend Concerns::Findable
  attr_accessor :name
  attr_reader :artist, :genre
  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    if artist
      self.artist = artist
    end
    if genre
      self.genre = genre
    end
  end

  def save
    @@all << self
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    if !genre.songs.include?(self)
      genre.add_song(self)
    end
  end

  def self.create(name)
    new_song = Song.new(name)
    new_song.save
    new_song
  end

  def self.new_from_filename(filename)
    name = filename.gsub(".mp3", "")
    song_info = name.split(" - ")

    if !Song.find_by_name(song_info[1])
      Song.new(song_info[1], Artist.find_or_create_by_name(song_info[0]), Genre.find_or_create_by_name(song_info[2]))
    end
  end

  def self.create_from_filename(filename)
    new_song = Song.new_from_filename(filename)
    new_song.save
  end

  def self.sort_by_name
    Song.all.sort! do |song1, song2|
      song1.name <=> song2.name
    end
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all = []
  end
end
