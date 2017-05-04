require_dependency "headway/application_controller"

class Headway
  class RequestsController < ApplicationController

    def index
      @requests = Request.order_by_recency
    end

    def show
      @request = Request.find(params[:id])
    end

  end
end
