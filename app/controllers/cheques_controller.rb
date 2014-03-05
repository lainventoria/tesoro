# encoding: utf-8
class ChequesController < ApplicationController
#  before_action :set_cheque, only: [:show, :edit, :update, :destroy]

  def index
    @cheques = Cheque.all
  end

  def show
  end

  def propios
    @cheques = Cheque.where(situacion: "propio")
    @situacion = "propios"
    render "index"
  end

  def terceros
    @cheques = Cheque.where(situacion: "terceros")
    @situacion = "terceros"
    render "index"
  end
    


    
#  def set_cheque
#    @cheque = Cheque.find(params[:id])
#  end

end
