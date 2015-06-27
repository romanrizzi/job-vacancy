class JobVacancy::Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    a_query.split(' & ').inject([]) { |result, query|
      validate_query_syntax(query)

      split_query = query.split('')
      field_index = query.index(split_query.detect { |char| char != ' '})
      separator_index = query.index(split_query.detect { |char| char == ':' })
      field_end_index = separator_index - 1
      field = query[field_index .. field_end_index].to_sym
      validate_field_exists_in_model(field)

      value = query[separator_index + 1 ... query.size]

      result.concat @object_to_filter.all(field.like => "%#{value}%")
    }.uniq
  end

  protected

  def validate_field_exists_in_model(field)
    raise InvalidQuery, "The field #{field} does not exists." unless @object_to_filter.properties.collect(&:name).include? field
  end

  def validate_query_syntax(a_query)
    raise InvalidQuery, "You must add ':' between the field you want to search by and its value, with no whitespaces in the middle." unless a_query.include? ':'
  end
end

class InvalidQuery < Exception

end