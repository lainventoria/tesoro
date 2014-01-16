class ThirdPartiesController < ApplicationController
  before_action :set_third_party, only: [:show, :edit, :update, :destroy]

  # GET /third_parties
  # GET /third_parties.json
  def index
    @third_parties = ThirdParty.all
  end

  # GET /third_parties/1
  # GET /third_parties/1.json
  def show
  end

  # GET /third_parties/new
  def new
    @third_party = ThirdParty.new
  end

  # GET /third_parties/1/edit
  def edit
  end

  # POST /third_parties
  # POST /third_parties.json
  def create
    @third_party = ThirdParty.new(third_party_params)

    respond_to do |format|
      if @third_party.save
        format.html { redirect_to @third_party, notice: 'Third party was successfully created.' }
        format.json { render action: 'show', status: :created, location: @third_party }
      else
        format.html { render action: 'new' }
        format.json { render json: @third_party.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /third_parties/1
  # PATCH/PUT /third_parties/1.json
  def update
    respond_to do |format|
      if @third_party.update(third_party_params)
        format.html { redirect_to @third_party, notice: 'Third party was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @third_party.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /third_parties/1
  # DELETE /third_parties/1.json
  def destroy
    @third_party.destroy
    respond_to do |format|
      format.html { redirect_to third_parties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_third_party
      @third_party = ThirdParty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def third_party_params
      params.require(:third_party).permit(:name, :address, :phone, :cellphone, :email, :tax)
    end
end
