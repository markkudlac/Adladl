class LandingsController < ApplicationController
  before_action :set_landing, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!
  
  def index
    @landings = Landing.all
  end

  def show
  end

  def new
    @landing = Landing.new
  end

  def edit
  end

  def create
    @landing = Landing.new(landing_params)
    upload = @landing[:zipfile]
    @landing[:zipfile] = Base64.encode64(File.read(upload.path()))

    @landing[:zipname] = upload.original_filename
    @landing[:filesize] = upload.size
    @landing[:client_id] = current_admin.id
    
    respond_to do |format|
      if @landing.save
        format.html { redirect_to @landing, notice: 'Landing was successfully created.' }
        format.json { render :show, status: :created, location: @landing }
      else
        format.html { render :new }
        format.json { render json: @landing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /icons/1
  def update
    newparams = landing_params
    upload = newparams[:zipfile]
    
#   puts "In Adverts Update image : #{upload.class.name}"
   
     if !upload.nil? then
       newparams[:zipfile] = Base64.encode64(File.read(upload.path()))
       newparams[:zipname] = upload.original_filename
       newparams[:filesize] = upload.size
     end
    
    respond_to do |format|
      if @landing.update(newparams)
        format.html { redirect_to @landing, notice: 'Landing was successfully updated.' }
        format.json { render :show, status: :ok, location: @landing }
      else
        format.html { render :edit }
        format.json { render json: @landing.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    @landing.destroy
    respond_to do |format|
      format.html { redirect_to icons_url, notice: 'Landing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_landing
      @landing = Landing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def landing_params
      params.require(:landing).permit(:zipfile, :zipname, :filesize)
    end
end
