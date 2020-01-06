class Artist
  extend Concerns::Findable
  attr_accessor :name
  attr_reader :songs
  @@all = []

  def initialize(name)
    @name = name
    @songs = []
    self.save
  end

  def save
    @@all << self
  end

  def songs
    Song.all.each do |song|
      if song.artist == self && !has_song?(song)
        @songs << song
      end
    end
    @songs
  end

  def genres
    genres = []
    @songs.each do |song|
      if !genres.include?(song.genre)
        genres << song.genre
      end
    end
    genres
  end

  def add_song(song)
    if !song.artist
      song.artist=(self)
    elsif !self.has_song?(song)
      @songs << song
    end
  end

  def has_song?(song)
    @songs.any?(song)
  end

  def self.create(name)
    new_artist = Artist.new(name)
    new_artist.save
    new_artist
  end

  def self.remove_dupes
    no_dupes = []
    @@all.each do |artist|
      if !no_dupes.include?(artist)
        no_dupes << artist
      end
    end
    @@all = no_dupes
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all = []
  end
end
