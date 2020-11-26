class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    # AR based search

    ## 1. With an exact match on one column
    # if params[:query].present?
    #   @movies = @movies.where(title: params[:query])
    #   # "SELECT * FROM movies WHERE title = ?", params[:query]
    # end

    ## 2. With a more permissive match on one column
    # if params[:query].present?
    #   @movies = @movies.where("title ILIKE ?", "%#{params[:query]}%")
    #   # SELECT "movies".* FROM "movies" WHERE (title ILIKE '%Superman%')
    # end

    ## 2.1 With a more permissive match on multiple columns
    # if params[:query].present?
    #   sql_query = "title ILIKE :query OR synopsis ILIKE :query"

    #   @movies = @movies.where(sql_query, query: "%#{params[:query]}%")
    #   # SELECT "movies".* FROM "movies" WHERE (title ILIKE '%superman%' OR synopsis ILIKE '%superman%')
    # end

    ## 3. With search against joined table directors
    # if params[:query].present?
    #   sql_query = <<~SQL
    #     movies.title ILIKE :query
    #       OR movies.synopsis ILIKE :query
    #       OR directors.first_name ILIKE :query
    #       OR directors.last_name ILIKE :query
    #   SQL

    #   # (model | models collection).joins(association name as symbol)
    #   # director.joins(:movies)

    #   @movies = @movies.
    #     joins(:director).
    #     where(sql_query, query: "%#{params[:query]}%")

    #   # SELECT "movies".*
    #   #   FROM "movies"
    #   #   JOIN "directors" ON movies.director_id = directors.id
    #   #   WHERE (movies.title ILIKE '%superman%' OR movies.synopsis ILIKE '%superman%' OR directors.first_name ILIKE '%superman%')
    # end

    ## 4. With simple fulltext search
    # if params[:query].present?
    #   sql_query = " \
    #     movies.title @@ :query \
    #     OR movies.synopsis @@ :query \
    #     OR directors.first_name @@ :query \
    #     OR directors.last_name @@ :query \
    #   "
    #   @movies = @movies.
    #     joins(:director).
    #     where(sql_query, query: "%#{params[:query]}%")
    # end

    # PG search gem based search

    # 1. Search against simple model Movie
    # if params[:query].present?
    #   @movies = @movies.search_by_title_and_syllabus(params[:query])
    # end

    # 2. Search against model Movie with associated Director
    if params[:query].present?
      @movies = @movies.search_by_title_and_synopsis_with_director(params[:query])
    end

    # 3. Multisearch against model Movie & TvShow
    if params[:query].present?
      @results = PgSearch.multisearch(params[:query])
    end
  end
end
