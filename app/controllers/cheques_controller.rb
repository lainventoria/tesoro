# encoding: utf-8
class ChequesController < ApplicationController

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

end
