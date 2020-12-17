class UsersController < ApplicationController
  include UsersHelper
  before_action :set_user, only: [:show, :edit, :update]

  def index
  end

  def show
    @posts = @user.posts.order('created_at DESC')
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Profile successfully updated'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'Something went wrong...'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
