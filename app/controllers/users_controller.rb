class UsersController < ApplicationController
  before_action :authenticate, only: [:show, :update, :destroy] #add other actions that require session_key
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @user_identity = UserIdentity.new
        #puts @user.date_start.year.to_s.concat(@user.id.to_s.rjust(6,'0'))
        @user_identity.user_id = @user.id
        @user_identity.username = @user.date_start.year.to_s.concat(@user.id.to_s.rjust(6,'0'))
        @user_identity.password_hash = get_random_string
        @user_identity.save

        #TODO : send email of login credentials/password
        format.json {render :create_success, status: :created}
      else
        #format.json { render json: @user.errors, status: :unprocessable_entity }
        format.json { render :error, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :first_name, 
        :mid_name, 
        :last_name,
        :email,
        :birthday,
        :cellphone_number,
        :telephone_number,
        :address,
        :date_start,
        :gender
      )
    end

    def get_random_string
      ('a'..'z').to_a.shuffle[0,8].join
    end

end
