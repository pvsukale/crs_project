# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render
  end

  def results
    rank = params[:search][:rank].to_i
    branch = Branch.find(params[:search][:branch].to_i)
    @results = Score.where(branch: branch).where("rank >= ?", rank).limit(50).order(:rank)
  
  end
end
