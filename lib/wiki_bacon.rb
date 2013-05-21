require "wiki_bacon/version"
require "wiki_bacon/parser"

module WikiBacon
  def self.run(dump_file)
    xml = File.new(dump_file)
    dump = WikiDump.new xml

    dump.lazy.take(100).map{|x| Page.new x}.each do |page|
      puts "#{page.title} #{page.links.length}"
    end
  end
end
