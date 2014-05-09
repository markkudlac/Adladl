class AdListsController < ApplicationController
  before_action :set_ad_list, only: [:show, :edit, :update, :destroy]

  # GET /ad_lists
  # GET /ad_lists.json
  def index
    @ad_lists = AdList.all
  end

  # GET /ad_lists/1
  # GET /ad_lists/1.json
  def show
  end

  # GET /ad_lists/new
  def new
    @ad_list = AdList.new
  end

  # GET /ad_lists/1/edit
  def edit
  end

  # POST /ad_lists
  # POST /ad_lists.json
  def create
    @ad_list = AdList.new(ad_list_params)

    respond_to do |format|
      if @ad_list.save
        format.html { redirect_to @ad_list, notice: 'Ad list was successfully created.' }
        format.json { render :show, status: :created, location: @ad_list }
      else
        format.html { render :new }
        format.json { render json: @ad_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_lists/1
  # PATCH/PUT /ad_lists/1.json
  def update
    respond_to do |format|
      if @ad_list.update(ad_list_params)
        format.html { redirect_to @ad_list, notice: 'Ad list was successfully updated.' }
        format.json { render :show, status: :ok, location: @ad_list }
      else
        format.html { render :edit }
        format.json { render json: @ad_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_lists/1
  # DELETE /ad_lists/1.json
  def destroy
    @ad_list.destroy
    respond_to do |format|
      format.html { redirect_to ad_lists_url, notice: 'Ad list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_list
      @ad_list = AdList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_list_params
      params.require(:ad_list).permit(:device_id, :advert_id, :action)
    end
end
