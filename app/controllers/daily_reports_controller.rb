class DailyReportsController < ApplicationController
  before_action :set_child

  def show
    @daily_report = @child.daily_reports.find(params[:id])
  end

  def index
    redirect_to child_path(@child)
  end

  def new
    @daily_report = @child.daily_reports.build
    @kind_act = @daily_report.kind_acts.build(giver_id: @child.id)
  end

  def create
    @daily_report = @child.daily_reports.build(daily_report_params)
    if @daily_report.save
      @child.update_child_stats(@daily_report)
      redirect_to child_daily_report_path(@child, @daily_report), notice: "report generated"
    else
      render :new
    end
  end

  def edit
    @daily_report = @child.daily_reports.find(params[:id])
    @kind_act = @child.kind_acts[0]
  end

  def update
    @daily_report = @child.daily_reports.find(params[:id])
    copy = @daily_report.deep_dup
    if @daily_report.update(daily_report_params)
      @child.remove_stats(copy)
      @child.update_child_stats(@daily_report)
      redirect_to child_daily_report_path(@child, @daily_report), notice: "report updated"
    else
      render :edit
    end
  end

  def destroy
    @daily_report = @child.daily_reports.find(params[:id])
    copy = @daily_report.deep_dup
    @daily_report.destroy
    @child.remove_stats(copy)
    redirect_to root_path
  end


  private

  def daily_report_params
    params.require(:daily_report).permit(:date, :wet_diapers, :poopy_diapers, :bullying_incident, :bullying_report, :ouch_incident, :ouch_report, kind_acts_attributes: [:act, :giver_id, :recipient_id, :daily_report_id])
  end

  def set_child
    @child = Child.find(params[:child_id])
  end
end
