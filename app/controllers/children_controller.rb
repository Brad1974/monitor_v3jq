class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def index
    @children = Child.all
  end

  def show
    @child = Child.find(params[:id])
  end

  def new
    @child = Child.new
  end

  def create
    @child = Child.new(child_params)
    if @child.save
      redirect_to child_path(@child)
    else
      render :new
    end
  end

  def edit
    @child = Child.find(params[:id])
  end

  def update
    @child = Child.find(params[:id])
    if @child.update(child_params)
      redirect_to child_path(@child)
    else
      render :edit
    end
  end

  def destroy
    @child = Child.find(params[:id])
    @child.destroy
    redirect_to root_path
  end

  private

  def child_params
    params.require(:child).permit(:first_name, :last_name, :birthdate, :diapers_inventory)
  end

  def set_child
    @child = Child.find(params[:id])
  end

end