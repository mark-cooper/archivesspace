class SearchController < ApplicationController

  set_access_control  "view_repository" => [:do_search, :advanced_search]

  def advanced_search
    criteria = params_for_backend_search

    queries = advanced_search_queries.reject{|field| field["value"].blank?}

    if not queries.empty?
      criteria["aq"] = JSONModel(:advanced_query).from_hash({"query" => build_queries(queries)}).to_json
      criteria['facet[]'] = SearchResultData.BASE_FACETS
    end


    @search_data = Search.all(session[:repo_id], criteria)

    respond_to do |format|
      format.json {
        render :json => @search_data
      }
      format.js {
        if params[:listing_only]
          render_aspace_partial :partial => "search/listing"
        else
          render_aspace_partial :partial => "search/results"
        end
      }
      format.html {
        render "search/do_search"
      }
    end
  end

  def do_search
    @search_data = Search.all(session[:repo_id], params_for_backend_search.merge({"facet[]" => SearchResultData.BASE_FACETS.concat(params[:facets]||[]).uniq}))

    respond_to do |format|
      format.json {
        render :json => @search_data
      }
      format.js {
        if params[:listing_only]
          render_aspace_partial :partial => "search/listing"
        else
          render_aspace_partial :partial => "search/results"
        end
      }
      format.html {
      }
    end
  end


  private

  def build_queries(queries)
    if queries.length > 1
      stack = queries.reverse.clone

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
      JSONModel(:field_query).from_hash(queries[0])
    end
  end


  def as_subquery(query_data)
    if query_data.kind_of? JSONModelType
      query_data
    else
      JSONModel(:field_query).from_hash(query_data)
    end
  end

end
