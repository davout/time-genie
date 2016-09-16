module TimeGenie
  class SliceCollection < TimeSpanCollection
    attr_accessor :slices

    def initialize(values = nil)
      collection_from_history(values) if values
    end

    def to_s
      "{SLC : #{map(&:to_s) .join(', ')}}"
    end

    # TODO : Méthodes nécessaires ?
    def starts_on
      first.starts_on unless empty?
    end

    def ends_on
      last.ends_on unless empty?
    end

    # Remplit les 'trous' d'une collection de slices par rapport à un time_span de référence
    # en utilisant les valeurs disponibles dans la collection de slices passée en paramètre
    def fill_missing_with!(slices, time_span)
      self << slices.intersect(time_span.substract(self))
      flatten!
      sort!
    end

    def value_for(time_span)
      detect do |slice|
        slice.covers? time_span
      end.value
    end

    def intersect(tsc)
      if tsc.is_a? TimeSpanCollection
        tsc.inject(SliceCollection.new) do |r, s|
          r << intersect(s)
        end.compact.sort
      elsif tsc.is_a? TimeSpan
        map { |s| s.intersect tsc }.compact
      end
    end

    private

    def collection_from_history(values)
      sorted_values = values.sort do |a, b|
        a.starts_on <=> b.starts_on
      end

      previous_slice = nil

      sorted_values.each_with_index do |v, _i|
        slice = Slice.new(v.starts_on, v.ends_on, v.value)

        if previous_slice
          raise 'Overlapping slices!' if slice.starts_on <= previous_slice.ends_on
          not_period_complete! if previous_slice.ends_on.advance(days: 1) < slice.starts_on
        end

        self.<<(slice)
      end
    end

    def self.not_period_complete!
      raise 'Not period complete'
    end

    def <=>(slice_collection)
      (size == slice_collection.slices.size) && all? { |slice| slice_collection.include?(slice) }
    end

    def method_missing(_method, *_args)
      raise SlicedConceptInterrupt
    end
  end
end
