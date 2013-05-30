#! /usr/bin/env ruby
require 'xml'


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
    return text.scan(LINK_REGEX).map{ |l| WikiLink.new self, l }.select{|l| l.valid?}
  end

  def to_s
    "#{@title}\n\t#{links.join("\n\t")}"
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

class WikiLink
  def initialize(page, link)
    @page = page
    @link = link[2..-3]
  end

  def source
    @page.title
  end

  def target
    canonicalize unsection unalias @link
  end

  def valid?
    namespace == "Main" && target != ''
  end

  def to_s
    "#{source} -> #{target}"
  end

  private

  def namespace
    if @link.include? ":"
      @link.split(":").first
    else
      "Main"
    end
  end

  def unalias(link)
    if link.include? '|'
      link.split('|').first
    else
      link
    end
  end

  def unsection(link)
    if link.include? '#'
      link.split('#').first
    else
      link
    end
  end

  def canonicalize(link)
    link = link.gsub(/_+/, ' ')
    link = link.lstrip.rstrip
    link = link.slice(0,1).upcase + link.slice(1..-1) if link.length > 0
    link
  end
end

class Application
  attr_reader :dump_file

  def initialize(dump_file)
    @dump_file = dump_file
  end

  def run
    puts dump.map { |node| Page.new node }
  end

  private :dump_file

  def dump
    WikiDump.new xml
  end

  def xml
    File.new(dump_file)
  end
end


# Oops, my python is showing
if __FILE__ == $0
  Application.new(ARGV[0] || STDIN.fileno).run
end
