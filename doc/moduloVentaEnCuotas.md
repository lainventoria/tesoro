# Modulo de Ventas #


## Consideraciones Iniciales ##

Pensando en que este paquete de funcionalidades puede no ser requerido por
todos los clientes, creo que lo mas conveniente es que su implementación sea
independiente del modulo central.

No se si para esto es necesario comenzar este trabajo sobre un nuevo
repositorio git, o si podemos continuar utilizando el mismo y luego agrupar
commits en diferentes modulos. Aunque visto que continuaremos debugeando e
introduciendo cambios al modulo core, la diferenciación de los commits puede
volverse engorrosa pasado un tiempo de los mismos.

## Unidades Funcionales y Contratos de Venta ##

- Cada Obra tiene varias Unidades Funcionales (UFs), que son las unidades
  'vendibles' a los clientes
- Cada UF tiene un Precio de Venta, que debe poder modificarse manualmente
- Cada UF es una unidad mínima e indivisible y puede ser vendida a un solo
  Tercero
- Existen diferentes tipos de UFs (ej: departamentos, cocheras, bauleras)
- Cada UF se vende a un Tercero, de tipo Cliente, a traves de un Contrato de
  Venta (CV)
- Se realiza un único CV para todas las UF que compre el Tercero en un momento
  dado (o sea, es posible tener varias UF por CV)
- Un Tercero puede tener más de un CV en la misma Obra, en el caso en que
  compre más UFs luego de haber acordado un primer CV.
- El CV tiene un monto asociado que es la suma de los Precios de Venta de las
  UFs que lo compongan
- El CV tiene diferentes funciones 1. Asocia UFs con Terceros 2. Especifíca el
  Plan de Pagos, consistente en un Pago Inicial y varias Cuotas 3. Especifíca
  el Indice que se utilizará para actualizar los montos de las Cuotas y como se
  aplicará 4. Registra el Valor Base del Indice (I-VB) del punto 3


## Pago Inicial y Cuotas (a.k.a. Plan de Pagos) ##

- Cada CV tiene un Pago Inicial (PI) y varias Cuotas (llamamos al conjunto del
  PI y las Cuotas como Plan de Pagos)
- El Pago Inicial es un monto que el Tercero acuerda pagar al firmar el CV
- Las Cuotas son montos que el Tercero acuerda pagar en determinadas fechas
- Cada Cuota tiene una fecha de vencimiento asociada, a partir de la cual, el
  Tercero adeuda el pago de la misma
- Al crear el CV, el sistema debe generar una Factura de Cobro por el monto del
  PI
- Al vencer una Cuota, el sistema debe generar una Factura de Cobro por el
  monto actualizado de la misma
- En todos los casos, las Facturas de Cobro que se generan tiene Fecha de
  Vencimiento de Factura = Fecha de Emision de Factura = Fecha de Vencimiento
  de Cuota


## Carga de Plan de Pagos (durante la creacion del CV) ##

- La suma del Pago Inicial y las Cuotas debe ser siempre igual al monto del CV
- El PI puede conceptualizarse como una Cuota que vence el mismo dia que se
  crea el CV
- Es práctica común que una vez fijado el PI, el monto remanente en el CV se
  divida en Cuotas iguales y de vencimientos periódicos (ej: PI + 24 Cuotas
  iguales mensuales)
- Durante la creación del CV, cada cuota debe poder modificarse manualmente (ya
  sea fecha o monto) manteniendo siempre la restricción de que al crear el CV
  la suma del PI + Cuotas debe ser igual al monto del CV.
- Una vez creado el CV, no se debe permitir modificar el Plan de Pagos o los
  Precios de Venta de las UFs


## Ajuste de montos de Cuotas ##

- Cada Cuota tiene 2 montos asociados 1. Monto Original (MO), que es el monto
  que consta en el CV 2. Monto Actualizado (MA), que es el monto que se adeuda
  y paga en un determinado momento del tiempo
- El MA se calcula en base al MO y al Valor Actual del Indice (I-VA) que se
  haya escogido en el CV MA = MO * ( I-VA / I-VB )
- El I-VA se determinará según lo que se haya especificado en el CV.
  Generalmente se utiliza uno de los siguientes
  - Valor del Indice del mes anterior al de la fecha de la Factura de Cobro
    (caso más usual que asegura que el indice este disponible al vencimiento de
    la Cuota y emisión de la Factura de Cobro)
  - Valor del Indice del mismo mes que el de la fecha de la Factura de Cobro
    (menos usual por no estar el indice siempre disponible al vencimiento de la
    Cuota y emisión de la Factura de Cobro)
- Al vencer una Cuota, y generarse la Factura de Cobro, el sistema debe
  corroborar que cuenta con el I-VA
- En caso de no existir el I-VA, el sistema, idealmente, genera la Factura de
  Cobro utilizando el I-VA disponible más reciente y avisa al usuario de la
  información faltante con un mensaje recurrente que no debe eliminarse hasta que
  el I-VA necesario se cargue en el sistema.


## Pago Anticipado de Cuotas ##

- Si el Tercero así lo desea, puede pagar Cuotas por adelantado
- Para esto, el sistema debe permitir emitir manualmente la Factura de Cobro de
  la Cuota que se adelanta, antes de su vencimiento
- Al igual que en el caso de una cuota vencida, el MA se calcula en base a la
  Fecha de Emisión de Factura


## Informacion para Reportes ##

- UF: disponibles vs. vendidas, pudiendo diferenciar entre los diferentes tipos
- CV: al día vs. con retrasos, dependiendo de que todas las cuotas vencidas
  esten cobradas o pendientes de cobro
- Cuotas: cobradas vs. pendientes, tanto en montos como en nro de cuotas
- Cuotas: montos originales vs montos acutalizados, pudiendo listar los MA a la
  fecha en que se acceda al reporte

