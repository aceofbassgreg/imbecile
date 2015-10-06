require_relative '../test_setup'
require 'imbecile/blog_example_three'

class BlogExampleThreeTests < MiniTest::Test

  def setup
    @builder = Imbecile::DynamicPayloadBuilder.new(
                          data_from_external_api: SAMPLE_DATA
                          )
  end

  def test_that_proper_payload_is_returned
    data = @builder.build_data_for_songs_api

    expected_result = 
      [
        {
          title: "Every Rose Has Its Thorn",
          content_type: "song",
          languages: ["English"],
          lyrics: "blah blah blah",
          nsfw:  false,
          tags: [],
          theme: "General"          
        },
        {
          title: "Sorrows of the Moon",
          content_type:  "song",
          languages: ["English"],
          lyrics: "baz badword baz",
          nsfw:   true,
          tags: ["Celtic Frost"],
          theme: "Black Metal Subgenre"
        },
        {
          title: "Gloaming and Bellyaching",
          content_type:  "song",
          languages: ["English"],
          lyrics: "baz blahhhhhhhh baz",
          nsfw:   false,
          tags: ["independent music"],
          theme: "Indie"
        }
      ]

      assert_equal expected_result, data
  end

end