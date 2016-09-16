module TimeGenie
  class TimeSpanCollection < Array
    def initialize(collection = [])
      super()
      collection = [collection].flatten # Support pour ne passer qu'un seul TS
      collection.map { |ts| self << (ts.is_a?(TimeSpan) ? ts : raise(TypeError, "Element is not a TimeGenie::TimeSpan")) }
      sort!
    end

    def to_s
      "{TSC : #{map { |ts| ts.to_s }.join(", ")}}"
    end

    def inspect
      to_s
    end

    def limit_to!(time_span)
      reject! { |ts| !ts.intersects?(time_span) }
      first.starts_on = [first.starts_on, time_span.starts_on].max
      last.ends_on = [last.ends_on, time_span.ends_on].min
      self
    end

    def intersect!(time_span)
      if time_span.is_a? TimeSpan
        map! { |ts| ts.intersect(time_span) }.compact!
      elsif time_span.is_a? TimeSpanCollection
        raise 'Not handling time_span collections yet'
      else
        raise TypeError, "Element is not a TimeGenie::TimeSpan or a TimeGenie::TimeSpanCollection"
      end

      self
    end

    def intersect(tsc)
      res = tsc.inject(TimeSpanCollection.new) do |r, ts|
        r << ts.intersect(self)
      end.compact.sort

      TimeSpanCollection.new(res)
    end

    def intersects?(time_span)
      any? { |ts| ts.intersects? time_span }
    end

    def substract(time_span)
      raise TypeError, "Not a TimeSpan" unless time_span.is_a? TimeSpan

      TimeSpanCollection.new(
        map do |ts|
          ts.substract(time_span)
        end
      )
    end
  end
end
