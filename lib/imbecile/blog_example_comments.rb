    def build_data_for_songs_api

      song_data_for_posting = []

      data_from_external_api.each do |raw_data|
        #These attributes are general to all songs
        data_to_post = {
                #Strip weird comments from title
                 title: raw_data[:title].gsub(/[^A-Za-z ]/," "),
                 content_type: raw_data[:type],
                 languages: ["English"],
                 lyrics: raw_data[:lyrics]
              }

        #If the song has profanities, then it is NSFW
        data_to_post[:nsfw] = profanities?(raw_data[:lyrics]) 

        # Process Indie songs
        if raw_data[:genre] == "Indie" 
          if raw_data[:tags].empty?
            data_to_post[:tags] = ["small label","esoteric","independent"]
          else
            data_to_post[:tags] = raw_data[:tags]
          end
          data_to_post[:theme] = raw_data[:genre]
        # Process Black Metal songs
        elsif raw_data[:genre] == "Black Metal"
          if raw_data[:tags].empty?
            raise NoBlackMetalTagsException
          else
            data_to_post[:tags] = raw_data[:tags]
          end
          data_to_post[:theme] = raw_data[:genre] + " Subgenre"
        else
        # Process all other songs
        # If there's one tag, just make that the theme
          if raw_data[:tags].count == 1
            data_to_post[:theme] = raw_data[:tags].first
          else
            data_to_post[:tags] = []
            data_to_post[:theme] = "General"
          end
        end

        song_data_for_posting << data_to_post
      end

      return song_data_for_posting

    end