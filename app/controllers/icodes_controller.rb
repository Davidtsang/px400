class IcodesController < ApplicationController
  before_action :set_icode, only: [:show, :edit, :update, :destroy]
  before_action :only_admin

  # GET /icodes
  # GET /icodes.json
  def index
    @icodes = Icode.all
  end

  # GET /icodes/1
  # GET /icodes/1.json
  def show
  end

  # GET /icodes/new
  def new
    @icode = Icode.new
    @icode.code= Icode.generate_code
    @icode.user_id = current_user.id


  end

  # GET /icodes/1/edit
  def edit
  end

  # POST /icodes
  # POST /icodes.json
  def create
    @icode = Icode.new(icode_params)

    respond_to do |format|
      if @icode.save
        format.html { redirect_to @icode, notice: 'Icode was successfully created.' }
        format.json { render :show, status: :created, location: @icode }
      else
        format.html { render :new }
        format.json { render json: @icode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /icodes/1
  # PATCH/PUT /icodes/1.json
  def update
    respond_to do |format|
      if @icode.update(icode_params)
        format.html { redirect_to @icode, notice: 'Icode was successfully updated.' }
        format.json { render :show, status: :ok, location: @icode }
      else
        format.html { render :edit }
        format.json { render json: @icode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /icodes/1
  # DELETE /icodes/1.json
  def destroy
    @icode.destroy
    respond_to do |format|
      format.html { redirect_to icodes_url, notice: 'Icode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def batch_gen

  end

  def batch_create

    gen_number = params[:gen_number]
    user_id = params[:user_id]

    @icodes = []
    gen_number.to_i.times do

      icode = Icode.new
      icode.code= Icode.generate_code
      icode.user_id = user_id
      icode.save
      @icodes.append icode

    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_icode
      @icode = Icode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def icode_params
      params.require(:icode).permit(:code, :user_id, :is_used, :used_user_id)
    end
end
