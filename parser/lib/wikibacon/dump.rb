require_relative 'page'
require 'xml'

module WikiBacon
  class Dump
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
end
