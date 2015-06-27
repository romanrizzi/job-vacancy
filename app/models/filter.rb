class JobVacancy::Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    a_query.split(' & ').inject([]) { |result, query|
      split_query = query.split('')
      field = query[0 .. query.index(split_query.detect { |char| char == ':' }) - 1]
      index = query.index(field)
      if query[index + field.size] == ':'
        value = query[index + field.size + 1 ... query.size]
        result.concat @object_to_filter.all(field.to_sym.like => "%#{value}%")
      end
    }
  end
end