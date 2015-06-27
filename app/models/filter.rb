class Filter

  def initialize a_class
    @object_to_filter = a_class
  end

  def call a_query
    split_query = a_query.split('')
    field = a_query[0 .. a_query.index(split_query.detect { |char| char == ':' }) - 1]
    index = a_query.index(field)
    if index.present?
      if a_query[index + field.size] == ':'
        value = a_query[index + field.size + 1 ... a_query.size]
        @object_to_filter.all(field.to_sym.like => "%#{value}%")
      end
    end
  end
end