class SearchController < ApplicationController

  set_access_control  "view_repository" => [:do_search, :advanced_search]

  def advanced_search
    @criteria = params_for_backend_search
    terms = (0..2).collect{|i|
      term = search_term(i)

      if term and term[:op] === "NOT"
        term[:op] = "AND"
        term[:negated] = true
      end

      term
    }.compact

    if not terms.empty?
      @criteria["aq"] = JSONModel(:advanced_query).from_hash({"query" => group_queries(terms)}).to_json
      @criteria['facet[]'] = SearchResultData.BASE_FACETS
    end


    @search_data = Search.all(session[:repo_id], @criteria)

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

  def search_term(i)
    if not params["v#{i}"].blank?
      { :field => params["f#{i}"], :value => params["v#{i}"], :op => params["op#{i}"] }
    end
  end


  def group_queries(terms)
    if terms.length > 1
      stack = terms.reverse.clone

      while stack.length > 1
        a = stack.pop
        b = stack.pop

        stack.push(JSONModel(:boolean_query).from_hash({
                                                         :op => b[:op],
                                                         :subqueries => [JSONModel(:field_query).from_hash(a), JSONModel(:field_query).from_hash(b)]
                                                       }))
      end

      stack.pop
    else
      JSONModel(:field_query).from_hash(terms[0])
    end
  end

end
