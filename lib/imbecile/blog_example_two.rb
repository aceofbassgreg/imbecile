module Imbecile 
  class PayloadBuilder

    attr_reader :data_from_external_api

    def build_data_for_songs_api
      data_from_external_api.map { |raw_data| build_from(raw_data) }
    end

    def build_from(raw_data)
      case raw_data[:genre]
      when "Indie"
        IndieSong.build(raw_data)
      when "Black Metal"
        BlackMetalSong.build(raw_data)
      else
        GeneralSong.build(raw_data)
      end
    end
  end
end

module Imbecile
  class Song

    ProfanitiesRegex = /(badword)/

    attr_reader :raw_data, :tags, :genre, :lyrics, :title, :type

    def initialize(raw_data)
      @raw_data = raw_data
      @tags     = raw_data.fetch(:tags,[])
      @genre    = raw_data.fetch(:genre,nil)
      @lyrics   = raw_data.fetch(:lyrics)
      @title    = raw_data.fetch(:title)
      @type     = raw_data.fetch(:type)
    end

    def self.build(raw_data)
      b = self.create_instance(raw_data)
      b.build_post
    end

    def profanities?
      !!lyrics[ProfanitiesRegex]
    end

    def build_post
      {
        title: title.gsub(/[^A-Za-z ]/," "),
        content_type: type,
        languages: ["English"],
        lyrics: lyrics,
        nsfw: profanities?,
        tags: assign_tags,
        theme: assign_theme
      }
    end

    private


      def assign_tags
        raise NotImplementedError
      end

      def assign_theme
        raise NotImplementedError
      end
  end
end

class IndieSong < Imbecile::Song
  def self.create_instance(raw_data)
    IndieSong.new(raw_data)
  end

  def assign_tags
    tags.empty? ? ["DIY","cost-cutting","home project"] : tags
  end

  def assign_theme
    genre
  end
end

class BlackMetalSong < Imbecile::Song
  def self.create_instance(raw_data)
    BlackMetalSong.new(raw_data)
  end

  def assign_tags
    if tags.empty? 
      raise NoBlackMetalTagsException
    else
      tags
    end
  end

  def assign_theme
    genre + " Subgenre"
  end
end

class GeneralSong < Imbecile::Song
  def self.create_instance(raw_data)
    GeneralSong.new(raw_data)
  end

  def assign_tags
    tags
  end

  def assign_theme
    tags.count == 1 ? tags.first : "General"
  end

end