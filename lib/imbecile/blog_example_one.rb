module Imbecile
  class PayloadBuilder

    ProfanitiesRegex = /(badword)/

    attr_reader :data_from_external_api

    def initialize(args)
      @data_from_external_api = args.fetch(:data_from_external_api)
    end

    def build_data_for_songs_api
      [].tap do |arr|

        data_from_external_api.each do |raw_data|
          data_to_post = {
                   title: raw_data[:title].gsub(/[^A-Za-z ]/," "),
                   content_type: raw_data[:type],
                   languages: ["English"],
                   lyrics: raw_data[:lyrics]
                }

          data_to_post[:nsfw] = profanities?(raw_data[:lyrics]) 

          if raw_data[:genre] == "Indie" 
            if raw_data[:tags].empty?
              data_to_post[:tags] = ["small label","esoteric","independent"]
            else
              data_to_post[:tags] = raw_data[:tags]
            end
            data_to_post[:theme] = raw_data[:genre]
          elsif raw_data[:genre] == "Black Metal"
            if raw_data[:tags].empty?
              raise NoBlackMetalTagsException
            else
              data_to_post[:tags] = raw_data[:tags]
            end
            data_to_post[:theme] = raw_data[:genre] + " Subgenre"
          else
            if raw_data[:tags].count == 1
              data_to_post[:theme] = raw_data[:tags].first
            else
              data_to_post[:tags] = []
              data_to_post[:theme] = "General"
            end
          end

          arr << data_to_post
        end
      end
    end

    def profanities?(lyrics)
      !!lyrics[ProfanitiesRegex]
    end

  end
end
