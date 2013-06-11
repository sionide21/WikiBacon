require_relative 'link'
require 'xml'


module WikiBacon
  class Page
    LINK_REGEX = /\[\[([^\]]+)\]\]/
    attr_reader :reader, :title, :text

    def initialize(xml)
      @reader = XML::Reader.string xml
      @title = @text = nil
      parse
    end

    def normal_article?
      not title.include? ':'
    end

    def links
      return text.scan(LINK_REGEX).map{ |l,| Link.new l }
    end

    private :reader

    def parse
      while reader.read
        if reader.node_type == XML::Node::ELEMENT_NODE
          if reader.name == "title"
            @title = reader.read_string
          elsif reader.name == "text"
            @text = reader.read_string
          end
        end
      end
    end
  end
end
