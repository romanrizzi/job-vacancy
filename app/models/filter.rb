class Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    splitted_query = a_query.split('')
    field = 'title'
    index = a_query.index(field)
    if index.present?
      if a_query[index + field.size] == ':'
        end_index = field.size + 2 + (a_query[index + field.size + 2 ... a_query.size].index(''))
        value = a_query[index + field.size + 2 ... index + end_index]
        @object_to_filter.all(field.to_sym.like => "%#{value}%")
      end
    end
  end
end