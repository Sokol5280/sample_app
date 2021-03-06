class MicropostsController < ApplicationController
	#before_action :set_micropost, :signed_in_user, only: [:show, :edit, :update, :create, :destroy]
	before_action :signed_in_user, only: [:show, :edit, :update, :create, :destroy]
  before_action :correct_user,   only: :destroy
  

	# POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Сообщение было успешно создано!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
		flash[:success] = "Сообщение было удалено."
    redirect_to request.referrer || root_url
  end
	
	# GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1
  # GET /microposts/1.json
  def show
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
  end

  # PATCH/PUT /microposts/1
  # PATCH/PUT /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to @micropost, notice: 'Сообщение было успешно обновлено.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_micropost
     # @micropost = Micropost.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
		def micropost_params
      params.require(:micropost).permit(:content)
    end

  	#def correct_user
	  	#@micropost = current_user.microposts.find(params[:id])
		#rescue
  		#redirect_to root_url
		#end
	
		def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
	
end
