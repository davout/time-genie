module TimeGenie
  class TimeSpan
    include Comparable

    attr_accessor :starts_on, :ends_on

    def initialize(starts_on, ends_on, _options = {})
      @starts_on = starts_on
      @ends_on = ends_on

      check!
    end

    def to_s
      "{ TS : [#{starts_on} | #{ends_on}]}"
    end

    def inspect
      to_s
    end

    # TODO : Refactorer éventuellement pour avoir un algo ~o(1) au lieu de o(n)
    # Utiliser Date#ld comme base pour un algo ~o(1)
    def day_count(excluded = [])
      if excluded.empty?
        1 + (@ends_on - @starts_on).to_i
      else
        (@starts_on..@ends_on).inject(0) { |c, day| c += excluded.include?(day.cwday) ? 0 : 1 }
      end
    end

    def calendaires
      day_count
    end

    def ouvres
      day_count [6, 7]
    end

    def ouvrables
      day_count [7]
    end

    def covers?(time_span)
      (@starts_on <= time_span.starts_on) && (@ends_on >= time_span.ends_on)
    end

    def ==(time_span)
      @starts_on == time_span.starts_on && @ends_on == time_span.ends_on
    end

    def eql?(time_span)
      self.==(time_span) && (self.class == time_span.class)
    end

    def <=>(time_span)
      if @starts_on != time_span.starts_on
        @starts_on <=> time_span.starts_on
      else
        @ends_on <=> time_span.ends_on
      end
    end

    def intersects?(time_span)
      if time_span.respond_to?(:starts_on) && time_span.respond_to?(:ends_on)
        (time_span.ends_on >= @starts_on) && (time_span.starts_on <= @ends_on)
      elsif time_span.is_a?(TimeSpanCollection)
        time_span.any? { |ts| intersects? ts }
      end
    end

    def intersect(time_span)
      if time_span.is_a? TimeSpan
        intersects?(time_span) ? TimeSpan.new([@starts_on, time_span.starts_on].max, [@ends_on, time_span.ends_on].min) : nil
      elsif time_span.is_a? TimeSpanCollection
        # byebug
        r = time_span.map { |ts| intersect ts }.compact
        r.size > 1 ? TimeSpanCollection.new(r) : r.first
      end
    end

    def substract(time_span)
      if time_span.is_a?(TimeSpan)
        if time_span.covers? self
          nil
        elsif !time_span.intersects? self
          dup
        elsif starts_on < time_span.starts_on && ends_on > time_span.ends_on
          TimeSpanCollection.new([
            TimeSpan.new(starts_on, time_span.starts_on - 1),
            TimeSpan.new(time_span.ends_on + 1, ends_on)
          ])
        elsif starts_on < time_span.starts_on && ends_on <= time_span.ends_on
          TimeSpan.new(starts_on, time_span.starts_on - 1)
        elsif starts_on >= time_span.starts_on && ends_on > time_span.ends_on
          TimeSpan.new(time_span.ends_on + 1, ends_on)
        else
          raise "That's one fucked up edge case"
        end
      elsif time_span.is_a?(TimeSpanCollection)
        TimeSpanCollection.new(
          time_span.inject(dup) do |res, ts|
            res.substract(ts)
          end
        )
      else
        raise TypeError, 'Wrong type supplied, should be TimeSpan or TimeSpanCollection'
      end
    end

    def intersect!(time_span)
      @starts_on = [@starts_on, time_span.starts_on].max
      @ends_on = [@ends_on, time_span.ends_on].min
      check!
    end

    private

    def valid?
      @starts_on <= @ends_on
    end

    def check!
      raise "Invalid dates : #{self}" unless valid?
    end
  end
end
