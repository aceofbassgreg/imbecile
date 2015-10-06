    def build_data_for_songs_api

      song_data_for_posting = []

      #These attributes are general to all songs
      data_from_external_api.each do |raw_data|
        data_to_post = {
                 title: raw_data[:title].gsub(/[^A-Za-z ]/," "),
                 content_type: raw_data[:type],
                 languages: ["English"],
                 lyrics: raw_data[:lyrics]
              }

        data_to_post[:nsfw] = profanities?(raw_data[:lyrics]) 

        # Processing Indie songs
        if raw_data[:genre] == "Indie" 
          if raw_data[:tags].empty?
            data_to_post[:tags] = ["small label","esoteric","independent"]
          else
            data_to_post[:tags] = raw_data[:tags]
          end
          data_to_post[:theme] = raw_data[:genre]
        # Processing Black Metal songs
        elsif raw_data[:genre] == "Black Metal"
          if raw_data[:tags].empty?
            raise NoBlackMetalTagsException
          else
            data_to_post[:tags] = raw_data[:tags]
          end
          data_to_post[:theme] = raw_data[:genre] + " Subgenre"
        else
        # Processing all other songs
        # If there's one tag, just make that the theme
          if raw_data[:tags].count == 1
            data_to_post[:theme] = raw_data[:tags].first
          else
            data_to_post[:theme] = "General"
          end
        end

        song_data_for_posting << data_to_post
      end

      return song_data_for_posting

    end