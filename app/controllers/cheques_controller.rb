# encoding: utf-8
class ChequesController < ApplicationController
  def index
    @cheques = Cheques.all
  end

  def show
  end

end
