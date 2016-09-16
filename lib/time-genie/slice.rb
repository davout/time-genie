module TimeGenie
  class Slice < TimeSpan
    attr_accessor :value

    def initialize(starts_on, ends_on, value)
      @value = value
      super(starts_on, ends_on)
    end

    def to_s
      "(SL : #{super} -> #{@value})"
    end

    def intersect(time_span)
      if time_span.is_a? TimeSpan
        intersects?(time_span) ? Slice.new([@starts_on, time_span.starts_on].max, [@ends_on, time_span.ends_on].min, @value) : nil
      elsif time_span.is_a? SliceCollection
        r = time_span.map { |s| intersect s }.compact
        r.size > 1 ? SliceCollection.new(s) : s
      else
        raise TypeError, 'Argument should be a TimeSpan or a SliceCollection'
      end
    end
  end
end
