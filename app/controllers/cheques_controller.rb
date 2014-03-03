# encoding: utf-8
class ChequesController < ApplicationController

  def index
    @cheques = Cheque.all
  end

  def show
  end

end
