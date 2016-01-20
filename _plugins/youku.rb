# usage: {% youku XNTc2ODk1NjI0 500 400 %} 
class YouKu < Liquid::Tag
    Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/

        def initialize(tagName, markup, tokens)
            super

            if markup =~ Syntax then
                @id = $1

                if $2.nil? then
                    @width = 560
                    @height = 420
                else
                    @width = $2.to_i
                    @height = $3.to_i
                end
            else
                raise "The video id error."
            end
        end

    def render(context)
        # "<iframe width=510 height=498 src="http://player.youku.com/embed/XNTc2ODk1NjI0" frameborder=0 allowfullscreen></iframe>"
        "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://player.youku.com/embed/#{@id}\" frameborder=0 allowfullscreen></iframe>"
    end

    Liquid::Template.register_tag "youku", self
end
