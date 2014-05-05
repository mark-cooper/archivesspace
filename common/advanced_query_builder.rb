class AdvancedQueryBuilder

  def self.build(queries)
    new(queries).build_query
  end


  def initialize(queries)
    @queries = queries
  end


  def build_query
    query = if @queries.length > 1
      stack = @queries.reverse.clone

      while stack.length > 1
        a = stack.pop
        b = stack.pop

        stack.push(JSONModel(:boolean_query).from_hash({
                                                         :op => b["op"],
                                                         :subqueries => [as_subquery(a), as_subquery(b)]
                                                       }))
      end

      stack.pop
    else
      JSONModel(:field_query).from_hash(@queries[0])
    end

    JSONModel(:advanced_query).from_hash({"query" => query})
  end


  private

  def as_subquery(query_data)
    if query_data.kind_of? JSONModelType
      query_data
    else
      JSONModel(:field_query).from_hash(query_data)
    end
  end


end