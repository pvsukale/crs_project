# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @all_branches = []
    branches = Branch.all
    branches.each do |branch|
      @all_branches.push([branch.name, branch.id])
    end
    render
  end

  def results
    rank = params[:search][:rank].to_i
    branch = Branch.find(params[:search][:branch].to_i)
    @results = Score.where(branch: branch).where("rank >= ?", rank).limit(100).order(:rank)
  
  end

  def college
    @college = College.find(params[:id])
    @cutoffs = Cutoff.where(college: @college)
  end

  def branch

    @branch = Branch.find(params[:branch])

    @colleges = Score.where(branch: @branch).limit(10).order(:rank)
  end

  def algo
  end
end
