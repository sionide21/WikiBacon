#! /usr/bin/env ruby
require 'wikibacon/dump'


class Application
  attr_reader :dump_file

  def initialize(dump_file)
    @dump_file = dump_file
  end

  def run
    # puts dump.lazy.map{|x| Page.new x}.find{|p| p.title == "International Atomic Time"}.text

    dump.lazy.map{|x| WikiBacon::Page.new x}.each do |page|
      puts "#{page.title} #{page.links.first.target}"
    end
  end

  private :dump_file

  def dump
    WikiBacon::Dump.new xml
  end

  def xml
    #Bzip2::Reader.new(File.new(dump_file))
    File.new(dump_file)
  end
end


# Oops, my python is showing
if __FILE__ == $0
  Application.new(ARGV[0] || STDIN.fileno).run
end
