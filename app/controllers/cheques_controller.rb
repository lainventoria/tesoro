# encoding: utf-8
class ChequesController < ApplicationController
  def index
    @cheques = Cheques.all
  end

  def vencidos
    @cheques = Cheques.where(':fecha_vencimiento > now()')

    render 'index'
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

end
