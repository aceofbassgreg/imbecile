module Imbecile

  class SimplePayloadBuilder

    attr_reader :data_from_external_api

    def initialize(args)
      @data_from_external_api = args.fetch(:data_from_external_api)
      
    end
    
    def build_data_for_songs_api
      data_from_external_api.map { |raw_data| build_from(raw_data) }
    end

    def build_from(raw_data)
      SongBuilder.build(raw_data)
    end

  end

  class SongBuilder

    ProfanitiesRegex = /(badword)/

    attr_reader :raw_data, :raw_tags, :genre, :lyrics, :title, :type

    def initialize(raw_data)
      @raw_data = raw_data
      @raw_tags = raw_data.fetch(:tags,[])
      @lyrics   = raw_data.fetch(:lyrics)
      @title    = raw_data.fetch(:title)
      @type     = raw_data.fetch(:type)
      @genre    = raw_data.fetch(:genre,nil)
    end

    def self.build(raw_data)
      b = self.new(raw_data)
      b.build_song
    end

    def profanities?
      !!lyrics[ProfanitiesRegex]
    end

    def build_song
      {
        title:        title.gsub(/[^A-Za-z ]/," "),
        content_type: type,
        languages:    ["English"],
        lyrics:       lyrics,
        nsfw:         profanities?,
        tags:         build_tags,
        theme:        build_theme
      }
    end

    def formatted_genre
      genre.gsub(/[^A-Za-z]/,"") 
    rescue NoMethodError
      "General"
    end

    def genre_builder_instance
      klass = Object.const_get("#{formatted_genre}ComponentBuilder")
      klass.new(raw_tags: raw_tags, genre: genre)
    end

    def build_tags
      genre_builder_instance.tags
    end

    def build_theme
      genre_builder_instance.theme
    end
  end
end

class IndieComponentBuilder

  attr_reader :raw_tags, :genre

  def initialize(opts)
    @raw_tags = opts.fetch(:raw_tags)
    @genre = opts.fetch(:genre)
  end

  def tags
    raw_tags.empty? ? ["Indie", "Small Label", "Pitchfork-approved"] : raw_tags
  end

  def theme
    genre
  end
end

class BlackMetalComponentBuilder

  attr_reader :raw_tags, :genre

  def initialize(opts)
    @raw_tags = opts.fetch(:raw_tags)
    @genre = opts.fetch(:genre)
  end

  def tags
    if raw_tags.empty? 
      raise NoBlackMetalTagsException
    else
      raw_tags
    end
  end

  def theme
    genre + " Subgenre"
  end
end

class GeneralComponentBuilder

  attr_reader :raw_tags, :genre

  def initialize(opts)
    @raw_tags = opts.fetch(:raw_tags)
    @genre = opts.fetch(:genre)
  end

  def tags
    raw_tags
  end

  def theme
    raw_tags.count == 1 ? raw_tags.first : "General"
  end
end






# class TagBuilder

#   attr_reader :tags, :genre

#   def initialize(args)
#     @tags = args.fetch(:theme)
#     @genre = args.fetch(:genre)
#   end

#   def self.build
#     case genre
#     when "Indie"
#     when "Black Metal"
#     else
#     end
#   end

# end

# class ThemeBuilder

#   attr_reader :theme, :tags, :genre
  
#   def initialize(args)
#     @theme = args.fetch(:theme)
#     @tags  = args.fetch(:tags)
#     @genre = args.fetch(:genre)
#   end

#   def self.build
#     case genre
#     when "Indie"
#     when "Black Metal"
#     else
#     end
#   end

# end