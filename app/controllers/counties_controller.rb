class CountiesController < ApplicationController
  respond_to :html, :geojson, :json
  # GET /counties
  # GET /counties.json
  def index
    @counties = Entity.where(entity_type: 'County').order(:entity_name)
    respond_with(@counties)
  end

  # GET /counties/1
  # GET /counties/1.json
  def show
    @county = Entity.where(id: params[:id]).where(entity_type: 'County').first
    respond_with(@county) do |format|
      format.geojson { render text: @county.to_geojson }
    end
  end

end
