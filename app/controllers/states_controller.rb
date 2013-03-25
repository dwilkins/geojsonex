class StatesController < ApplicationController
  respond_to :html, :geojson, :json
  # GET /states
  # GET /states.json
  def index
    @states = Entity.where(entity_type: 'State').order(:entity_name)
    respond_with(@states)
  end

  # GET /states/1
  # GET /states/1.json
  def show
    @state = Entity.where(id: params[:id]).where(entity_type: 'State').first
    respond_with(@state) do |format|
      format.geojson { render text: @state.to_geojson }
    end
  end

end
