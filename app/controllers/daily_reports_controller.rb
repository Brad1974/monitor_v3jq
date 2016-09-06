class DailyReportsController < ApplicationController
  before_action :set_child

  def show
    @daily_report = @child.daily_reports.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @daily_report}
    end
  end

  def index
    @daily_reports = @child.daily_reports
    respond_to do |format|
      format.html { redirect_to child_path(@child)}
      format.json { render json: @daily_reports }
    end
  end

  def new
    @daily_report = @child.daily_reports.build
    @kind_act = @daily_report.kind_acts.build(giver_id: @child.id)
  end

  def create
    @daily_report = @child.daily_reports.build(daily_report_params)
    @kind_act = @daily_report.kind_acts.last
    if @daily_report.save
      @child.update_child_stats(@daily_report)
      redirect_to root_path, notice: "daily report generated for #{@child.name}"
    else
      render :new
    end
  end

  def edit
    @daily_report = @child.daily_reports.find(params[:id])
    if !@child.kind_acts.empty?
      @kind_act = @child.kind_acts[0]
    else
      @daily_report.kind_acts.build(giver_id: @child.id)
    end
  end

  def update
    # I know it's ugly, sorry!
    @daily_report = @child.daily_reports.find(params[:id])
    @kind_act = @daily_report.kind_acts.last
    copy = @daily_report.deep_dup
    if @daily_report.update(daily_report_params)
      @child.revise_child_stats(copy, @daily_report)
      if (@daily_report.kind_acts.last != nil && (params[:daily_report][:kind_acts_attributes]["0"]["act"] == "") && (params[:daily_report][:kind_acts_attributes]["0"]["recipient_id"] == "")) || @daily_report.kind_acts.count > 1
        @daily_report.kind_acts.first.destroy
      end
      @daily_report.save
      redirect_to root_path, notice: "daily report updated for #{@child.name}"
    else
      render :edit
    end
  end

  def destroy
    @daily_report = @child.daily_reports.find(params[:id])
    copy = @daily_report.deep_dup
    @daily_report.destroy
    binding.pry
    @child.remove_child_stats(copy)
    binding.pry
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
