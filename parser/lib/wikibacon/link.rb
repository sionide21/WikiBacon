module WikiBacon
  class Link
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def prefix
      if prefix = raw[/^:?([^:]+):/, 1]
        clean(prefix).capitalize
      end
    end

    def page_name
      capitalize_first(clean(raw[/^:?([^:]+:)?([^|]+)/, 2]))
    end

    def target
      if prefix
        "#{prefix}:#{page_name}"
      else
        page_name
      end
    end

    def internal?
      # Ignore portals for now
      not prefix
    end

    private

    def capitalize_first(text)
      text.gsub(/^(.)/) { |l| l.upcase }
    end

    def clean(link)
      link.gsub(/[\s_]+/, '_').sub(/^_/, '').sub(/_$/, '')
    end
  end
end
