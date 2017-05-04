require_dependency "headway/application_controller"

class Headway
  class Requests::QueriesController < ApplicationController

    def explain
      @request = Request.find(params[:request_id])

      @query = @request.queries.find(params[:id])
      @query.explain!
    end

  end
end
