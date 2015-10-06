module Imbecile
  class DynamicPayloadBuilder

    attr_reader :data_from_external_api

    def initialize(args)
      @data_from_external_api = args.fetch(:data_from_external_api)
      
    end
    
    def build_data_for_songs_api
      data_from_external_api.map { |raw_data| build_from(raw_data) }
    end

    def build_from(raw_data)
      begin
        subject = raw_data[:genre].gsub(/[^A-Za-z]/,"")
        klass = Object.const_get(subject + "Song")
        klass.build(raw_data)
      rescue
        GeneralSong.build(raw_data)
      end
    end
  end
end