# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141027145038) do

  create_table "cajas", force: true do |t|
    t.integer  "obra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo",                         null: false
    t.string   "banco"
    t.string   "numero"
    t.string   "situacion"
    t.boolean  "archivada",    default: false
    t.string   "tipo_factura"
  end

  create_table "cheques", force: true do |t|
    t.string   "situacion",         default: "propio"
    t.integer  "numero"
    t.integer  "monto_centavos",    default: 0,          null: false
    t.string   "monto_moneda",      default: "ARS",      null: false
    t.datetime "fecha_vencimiento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha_emision"
    t.string   "beneficiario"
    t.string   "banco"
    t.integer  "cuenta_id"
    t.string   "estado",            default: "chequera"
    t.integer  "chequera_id"
  end

  add_index "cheques", ["chequera_id"], name: "index_cheques_on_chequera_id", using: :btree
  add_index "cheques", ["cuenta_id"], name: "index_cheques_on_cuenta_id", using: :btree

  create_table "contratos_de_venta", force: true do |t|
    t.integer  "monto_total_centavos", default: 0,     null: false
    t.string   "monto_total_moneda",   default: "ARS", null: false
    t.date     "fecha",                                null: false
    t.integer  "indice_id",                            null: false
    t.integer  "tercero_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "obra_id"
    t.string   "relacion_indice",                      null: false
    t.string   "tipo_factura"
  end

  add_index "contratos_de_venta", ["indice_id"], name: "index_contratos_de_venta_on_indice_id", using: :btree
  add_index "contratos_de_venta", ["obra_id"], name: "index_contratos_de_venta_on_obra_id", using: :btree
  add_index "contratos_de_venta", ["tercero_id"], name: "index_contratos_de_venta_on_tercero_id", using: :btree

  create_table "cuotas", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monto_original_centavos", default: 0,     null: false
    t.string   "monto_original_moneda",   default: "ARS", null: false
    t.date     "vencimiento",                             null: false
    t.string   "descripcion",                             null: false
    t.integer  "contrato_de_venta_id"
    t.integer  "factura_id"
    t.integer  "indice_id"
  end

  add_index "cuotas", ["contrato_de_venta_id"], name: "index_cuotas_on_contrato_de_venta_id", using: :btree
  add_index "cuotas", ["factura_id"], name: "index_cuotas_on_factura_id", using: :btree
  add_index "cuotas", ["indice_id"], name: "index_cuotas_on_indice_id", using: :btree

  create_table "facturas", force: true do |t|
    t.string   "tipo"
    t.string   "numero"
    t.text     "descripcion"
    t.integer  "importe_total_centavos", default: 0,      null: false
    t.string   "importe_total_moneda",   default: "ARS",  null: false
    t.datetime "fecha"
    t.datetime "fecha_pago"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "situacion",              default: "pago"
    t.integer  "importe_neto_centavos",  default: 0,      null: false
    t.string   "importe_neto_moneda",    default: "ARS",  null: false
    t.integer  "iva_centavos",           default: 0,      null: false
    t.string   "iva_moneda",             default: "ARS",  null: false
    t.integer  "tercero_id"
    t.integer  "obra_id"
  end

  add_index "facturas", ["obra_id"], name: "index_facturas_on_obra_id", using: :btree
  add_index "facturas", ["tercero_id"], name: "index_facturas_on_tercero_id", using: :btree

  create_table "indices", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "periodo",                                               null: false
    t.string   "denominacion",                                          null: false
    t.decimal  "valor",        precision: 10, scale: 0,                 null: false
    t.boolean  "temporal",                              default: false
  end

  add_index "indices", ["periodo", "denominacion"], name: "index_indices_on_periodo_and_denominacion", unique: true, using: :btree

  create_table "movimientos", force: true do |t|
    t.integer  "caja_id"
    t.integer  "monto_centavos", default: 0,     null: false
    t.string   "monto_moneda",   default: "ARS", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recibo_id"
    t.integer  "causa_id"
    t.string   "causa_type"
  end

  add_index "movimientos", ["causa_id", "causa_type"], name: "index_movimientos_on_causa_id_and_causa_type", using: :btree

  create_table "obras", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "direccion"
  end

  create_table "recibos", force: true do |t|
    t.datetime "fecha"
    t.integer  "factura_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "situacion",              default: "pago"
    t.integer  "importe_cache_centavos", default: 0,      null: false
    t.string   "importe_cache_moneda",   default: "ARS",  null: false
    t.integer  "recibo_id"
  end

  add_index "recibos", ["factura_id"], name: "index_recibos_on_factura_id", using: :btree
  add_index "recibos", ["recibo_id"], name: "index_recibos_on_recibo_id", using: :btree

  create_table "retenciones", force: true do |t|
    t.integer  "factura_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monto_centavos",         default: 0,           null: false
    t.string   "monto_moneda",           default: "ARS",       null: false
    t.string   "documento_file_name"
    t.string   "documento_content_type"
    t.integer  "documento_file_size"
    t.datetime "documento_updated_at"
    t.integer  "cuenta_id"
    t.integer  "chequera_id"
    t.datetime "fecha_vencimiento"
    t.string   "situacion",              default: "ganancias"
    t.string   "estado",                 default: "emitida",   null: false
  end

  add_index "retenciones", ["chequera_id"], name: "index_retenciones_on_chequera_id", using: :btree
  add_index "retenciones", ["cuenta_id"], name: "index_retenciones_on_cuenta_id", using: :btree
  add_index "retenciones", ["factura_id"], name: "index_retenciones_on_factura_id", using: :btree

  create_table "terceros", force: true do |t|
    t.string   "nombre"
    t.text     "direccion"
    t.text     "telefono"
    t.text     "celular"
    t.string   "email"
    t.float    "iva",        limit: 24
    t.string   "cuit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "relacion"
    t.string   "contacto"
    t.text     "notas"
  end

  create_table "unidades_funcionales", force: true do |t|
    t.integer "obra_id",                                     null: false
    t.integer "precio_venta_centavos",       default: 0,     null: false
    t.string  "precio_venta_moneda",         default: "ARS", null: false
    t.string  "tipo",                                        null: false
    t.integer "contrato_de_venta_id"
    t.integer "precio_venta_final_centavos", default: 0,     null: false
    t.string  "precio_venta_final_moneda",   default: "ARS", null: false
    t.text    "descripcion"
  end

  add_index "unidades_funcionales", ["contrato_de_venta_id"], name: "index_unidades_funcionales_on_contrato_de_venta_id", using: :btree

end
