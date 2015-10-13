module Imbecile 
  class TemplatePayloadBuilder

    attr_reader :data_from_external_api

    def initialize(args)
      @data_from_external_api = args.fetch(:data_from_external_api)
    end

    def build_data_for_songs_api
      data_from_external_api.map { |raw_data| build_from(raw_data) }
    end

    def build_from(raw_data)
      case raw_data[:genre]
      when "Indie"
        IndieSongBuilder.build(raw_data)
      when "Black Metal"
        BlackMetalSongBuilder.build(raw_data)
      else
        GeneralSongBuilder.build(raw_data)
      end
    end
  end
end

module Imbecile
  class AbstractSongBuilder

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
      b = self.new(raw_data)
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

class IndieSongBuilder < Imbecile::AbstractSongBuilder

  def assign_tags
    tags.empty? ? ["Indie", "Small Label", "Pitchfork-approved"] : tags
  end

  def assign_theme
    genre
  end
end

class BlackMetalSongBuilder < Imbecile::AbstractSongBuilder

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

class GeneralSongBuilder < Imbecile::AbstractSongBuilder

  def assign_tags
    tags
  end

  def assign_theme
    tags.count == 1 ? tags.first : "General"
  end

end