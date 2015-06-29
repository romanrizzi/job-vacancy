class JobVacancy::Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    a_query.split(' & ').inject([]) { |result, query|
      validate_query_syntax(query)
      split_query = query.split('')
      separator_index = query.index(split_query.detect { |char| char == ':' })

      field = field_to_search_by query, split_query, separator_index
      value = query[separator_index + 1 ... query.size]
      result.concat @object_to_filter.all(field.like => "%#{value}%")
    }.uniq
  end

  protected

  def field_to_search_by original_query, query_characters, field_limit
    field_index = original_query.index(query_characters.detect { |char| char != ' '})
    field_end_index = field_limit - 1
    field = original_query[field_index .. field_end_index].to_sym
    raise InvalidQuery, "The field '#{field}' does not exist." unless @object_to_filter.properties.collect(&:name).include? field
    field
  end

  def validate_query_syntax(a_query)
    raise InvalidQuery, "You must add ':' between the field you want to search by and its value, with no whitespaces in the middle." unless a_query.include? ':'
  end
end

class InvalidQuery < Exception

end