# encoding: utf-8

# Indices reales segun http://www.cifrasonline.com.ar/cifras/index.php/content/view/full/76/%28offset%29/cac
[{ periodo: '1/1/2011', valor: 817.20, denominacion: 'Costo de construcción' },
 { periodo: '1/1/2011', valor: 751.60, denominacion: 'Materiales' },
 { periodo: '1/1/2011', valor: 891.10, denominacion: 'Mano de obra' }].each do |datos|
  Indice.find_or_create_by datos
end
