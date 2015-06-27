class JobVacancy::Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    a_query.split(' & ').inject([]) { |result, query|
      split_query = query.split('')
      validate_query_syntax(split_query)

      field_index = query.index(split_query.detect { |char| char != ' '})
      field_end_index = query.index(split_query.detect { |char| char == ':' }) - 1
      field = query[field_index .. field_end_index]
      validate_field_exists_in_model(field)

      index = query.index(field)
      value = query[index + field.size + 1 ... query.size]

      result.concat @object_to_filter.all(field.to_sym.like => "%#{value}%")
    }.uniq
  end

  protected

  def validate_field_exists_in_model(field)
    raise InvalidQuery, "The field #{field} does not exists." unless @object_to_filter.properties.collect(&:name).include? field.to_sym
  end

  def validate_query_syntax(a_query)
    raise InvalidQuery, "You must add ':' between the field you want to search by and its value, with no whitespaces in the middle." unless a_query.include? ':'
  end
end

class InvalidQuery < Exception

end