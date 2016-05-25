class UsersController < ApplicationController
  before_action :authenticate, only: [:show, :update, :destroy, :login, :logout] #add other actions that require session_key
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
    @user.token = build_token # TODO ensure uniqueness!
    @user.token_expiry = Time.now + 1.day
    @user.username = next_username(@user.date_start.year)
    respond_to do |format|
      if @user.save
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

  def login
    respond_to do |format|
      @user = User.where("username = ? AND token = ? AND status != ? AND token_expiry > ? ",user_params[:username],@token,9,Time.now).take
      format.json {render :create_success, status: :ok}
    end
  end

  def logout
    respond_to do |format|
      @user.token = build_token
      @user.token_expiry = ''
      if @user.save
          format.json {render :logout_success, status: :ok}
      end
    end
  end

  def request_token
    @user = User.find_by username: params[:username]
    #generate new token
    @user.token = build_token
    @user.token_expiry = ''
    @user.save
    #leave token_expiry as blank? (if blank, do not recreate new token to prevent spamming email)
    #email token link to user
    respond_to do |format|
      format.json {render :request_success, status: :accepted}
    end
  end

  def activate_token
    @user = User.find_by username: params[:username], token: params[:token]
    respond_to do |format|
      if @user.terminated?
          @errors = ["User account already terminated"]
          format.json { render "_common/errors", status: 401}
      else @user.token_expiry.blank?
        @user.token_expiry = Time.now + 1.day
        @user.save
        format.json {render :activate_success, status: :ok}
      end
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
        :username,
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

    #todo move this to Usernames controller?
    def next_username(year)
      lastusername = Username.find_by! year: year
      if lastusername
        lastusername.seq = lastusername.seq+1
        lastusername.save
      end
      lastusername.year.to_s.concat(lastusername.seq.to_s.rjust(4,'0'))
    rescue ActiveRecord::RecordNotFound
      lastusername = Username.create(:year => year, :seq => 1)
      lastusername.year.to_s.concat(lastusername.seq.to_s.rjust(4,'0'))
    end


end
