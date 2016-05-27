class UsersController < ApplicationController
  before_action :authenticate, only: [:show, :update, :destroy, :login, :logout] #add other actions that require session_key
  # before_action :set_user, only: [:show, :edit, :update, :destroy]

   User_status_access_errors = { 
    for_auth: "This user account still needs to be verified by an administrator.", 
    # active: "",
    inactive: "This user account has been deactivated.",
    terminated: "This user account is already terminated."
  }

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
    @user.token_expiry = ''
    @user.username = Username.next_username_in(@user.date_start.year.to_i)
    respond_to do |format|
      if @user.save
        # TODO : send email of login credentials/password
        TokenMailer.accesstoken_email(@user).deliver_now
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
        # format.html { render :edit }
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
      # @user = User.where("username = ? AND token = ? AND status != ? AND token_expiry > ? ",user_params[:username],@token,9,Time.now).take
      #TODO make sure that tokens are correct and unique udring generation
      @user = User.where("token = ?",@token).take
      # puts "STATUS!!!!!!!!!!" + @user.status
      # puts "ERRORL" + User_status_access_errors[@user.status.to_sym]
      if @user.nil? || @user.username != user_params[:username]
        @errors = ["Bad/invalid token"]
      elsif @user.token_expiry.blank?
        @errors = ["Token not yet activated. Please open access link from your email."]
      elsif @user.token_expiry < Time.now
        @errors = ["Expired token"] 
      elsif User_status_access_errors.key?(@user.status.to_sym)
        @errors = [User_status_access_errors[@user.status.to_sym]]
      end

      if @errors
        format.json { render "_common/errors", status: 401 }
      else
        format.json {render :create_success, status: :ok }
      end 
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
    respond_to do |format|
      if @user
        if @user.terminated? || @user.inactive? 
            @errors = [User_status_access_errors[@user.status.to_sym]]
            format.json { render "_common/errors", status: 401 }
        else
          #generate new token
          @user.token = build_token
          #leave token_expiry as blank? (if blank, do not recreate new token to prevent spamming email?)
          @user.token_expiry = ''
          @user.save
          TokenMailer.accesstoken_email(@user).deliver_now
          format.json {render :request_success, status: :accepted}
        end
      else
        @errors = ['Unknown user']
        format.json { render "_common/errors", status: 404 }
      end
    end
  end

  def activate_token
    @user = User.find_by username: params[:username], token: params[:token]
    respond_to do |format|
      if @user
        if @user.status == "active"
          if @user.token_expiry.blank?
            @user.token_expiry = Time.now + 1.day
            @user.save
          elsif @user.token_expiry < Time.now
            @errors = ["Your token has expired."]
            format.json { render "_common/errors", status: 404}
          end
          format.json {render :activate_success, status: :ok}
        else
          if User_status_access_errors.key?(@user.status.to_sym)
            @errors = [User_status_access_errors[@user.status.to_sym]]
          else 
            @errors = ["Activation request invalid. Please try requesting a new token."]
          end
          format.json { render "_common/errors", status: 401}
        end
      else #no user found
          @errors = ["Unknown user"]
          format.json { render "_common/errors", status: 404}
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

end
