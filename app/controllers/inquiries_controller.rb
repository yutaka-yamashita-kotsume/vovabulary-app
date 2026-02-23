# app/controllers/inquiries_controller.rb
class InquiriesController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to contact_path, notice: "お問い合わせを送信しました。ありがとうございます！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :message)
  end
end