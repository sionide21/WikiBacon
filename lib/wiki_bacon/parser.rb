require 'xml'


module WikiBacon
  class WikiDump
    include Enumerable

    attr_reader :reader

    def initialize(io)
      @reader = XML::Reader.io io
    end

    def each
      while reader.read
        if page_node?
          yield reader.read_outer_xml
        end
      end
    end

    private :reader

    def page_node?
      reader.node_type == XML::Node::ELEMENT_NODE and reader.name == "page" and reader.depth == 1
    end
  end


  class Page
    LINK_REGEX = /\[\[[^\]]+\]\]/
    attr_reader :reader, :title, :text

    def initialize(xml)
      @reader = XML::Reader.string xml
      @title = @text = nil
      parse
    end

    def links
      return text.scan(LINK_REGEX).map{ |l| WikiLink.new l }
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

    class WikiLink
      def initialize(link)
        @link = link
      end
    end
  end
end
