class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /subjects
  def index
    @subjects = Subject.all

    @aggregate = {}
    @subjects.each do |subject|
      subject_records = subject.studied_records.where(user_id: current_user.id)
      @aggregate[subject.name.to_sym] = 0

      subject_records.each do |subject_record|
        @aggregate[subject.name.to_sym] += subject_record.square_count
      end
    end

    @time ={}
    @aggregate.each do |key, value|
      @time[key] = {hour: value / 6, mimute: value %6}
    end

    render json: @time
  end

  # GET /subjects/1
  def show
    render json: @subject
  end

  # POST /subjects
  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      render json: @subject, status: :created, location: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subjects/1
  def update
    if @subject.update(subject_params)
      render json: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subjects/1
  def destroy
    @subject.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subject_params
      params.require(:subject).permit(:logo, :name, :color)
    end
end
