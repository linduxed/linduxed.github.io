# Syntax {% youtube video_id [width height] %}
# Default width and height provided that works well with page layout.
#
# Examples:
# {% youtube a1b2c3d4f5g %}
# {% youtube a1b2c3d4f5g 720 480 %}

module Jekyll
  class Youtube < Liquid::Tag
    def initialize(name, markup, tokens)
      if markup =~ /(\S+{11})( (\d+) (\d+))?/
        @id = $1
        @width = $3 || 605
        @height = $4 || 360
      end
      super
    end

    def render(context)
      %(<div class="embed-video-container"><iframe src="http://www.youtube.com/embed/#{@id}" width="#{@width}" height="#{@height}" frameborder="0" allowfullscreen></iframe></div>)
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::Youtube)
