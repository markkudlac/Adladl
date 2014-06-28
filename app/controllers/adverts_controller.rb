class AdvertsController < ApplicationController
  before_action :set_advert, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  
  # GET /adverts
  # GET /adverts.json
  def index
    @adverts = Advert.all
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
  end

  # GET /adverts/new
  def new
    @icon =  Icon.where(:client_id => current_admin.id)
    @advert = Advert.new
  end

  # GET /adverts/1/edit
  def edit
    @icon =  Icon.where(:client_id => current_admin.id)
  end

  # POST /adverts
  # POST /adverts.json
  def create
    
    @advert = Advert.new(advert_params)
    upload = @advert[:image]
    
    if !upload.nil? then
      @advert[:image] = Base64.encode64(File.read(upload.path()))
      @advert[:filename] = upload.original_filename
      @advert[:filesize] = upload.size
    end
    
    @advert[:client_id] = current_admin.id
    
    if advert_params[:icon_id].length <= 0 then
      @advert[:icon_id] = -1
    end
    
    respond_to do |format|
      if @advert.save
        format.html { redirect_to @advert, notice: 'Advert was successfully created.' }
        format.json { render :show, status: :created, location: @advert }
      else
        format.html { render :new }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adverts/1
  # PATCH/PUT /adverts/1.json
  def update
     
    newparams = advert_params
    upload = newparams[:image]
    
#   puts "In Adverts Update icon : #{newparams[:icon_id]}"
    if newparams[:icon_id].length <= 0 then
      newparams[:icon_id]= -1
    end
    
   if !upload.nil? then
     newparams[:image] = Base64.encode64(File.read(upload.path()))
     newparams[:filename] = upload.original_filename
     newparams[:filesize] = upload.size
   end
    
    
    respond_to do |format|
      if @advert.update(newparams)
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { render :show, status: :ok, location: @advert }
      else
        format.html { render :edit }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to adverts_url, notice: 'Advert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advert
      @advert = Advert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advert_params
      params.require(:advert).permit(:group, :adtype, :image, :urlhref, :descript, :icon_id)
    end
end
