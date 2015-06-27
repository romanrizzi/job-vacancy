class JobVacancy::Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    a_query.split(' & ').inject([]) { |result, query|
      split_query = query.split('')
      field_index = query.index(split_query.detect { |char| char != ' '})
      field_end_index = query.index(split_query.detect { |char| char == ':' }) - 1
      field = query[ field_index .. field_end_index]
      raise InvalidQuery, "The field #{field} does not exists." unless @object_to_filter.properties.collect(&:name).include? field.to_sym
      index = query.index(field)
      if query[index + field.size] == ':'
        value = query[index + field.size + 1 ... query.size]
        result.concat @object_to_filter.all(field.to_sym.like => "%#{value}%")
      end
    }.uniq
  end
end

class InvalidQuery < Exception

end