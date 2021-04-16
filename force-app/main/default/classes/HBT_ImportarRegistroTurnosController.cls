global class HBT_ImportarRegistroTurnosController {
    //Atributos para realizar la conversión y lectura del contenido del archivo
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public string nombreArchivo{get;set;}
    private String[] csvFileLines{get;set;}
    public string frenteSelected {get;set;}
    
    public String archivoSelected {get;set;}
    
    public Date fechaInicioFiltro{get;set;}
    public Date fechaFinFiltro{get;set;}
    /*Atributo para almacenar el contentType para generar el archivo.*/
    public String contentType{get;set;} 
    //mensajes modal
    public List<HBT_MensajesPagina> mensajesError {get;set;}
    //Listas para almacenar temporalmente los registros durante el proceso de validación
    private List<registroAlmacenar> listaRegistros {get;set;}
    public List<registroAlmacenar> listaRegistrosError {get;set;}
    private List<registroAlmacenar> listaRegistrosTemp {get;set;}
    private Map <String,HBT_Asociacion_Empleado_Frente__c> listaEmpleados{get;set;}
    
    //Lista para almacenar los id de los registros a modificar y consultar en la bd que sí existan
    private List<String> idRegistrosModificar {get;set;}
    
    //Atributo para habilitar el botón de Importar en la página, sólo hasta que todos los registros hayan pasado las validaciones
    public Boolean habilitarBoton {get;set;}
    public Boolean habilitarBotonEliminar {get;set;}
    //atributos para manejar los días festivos de un año
    public Map <String, Boolean> diasFestivos {get;set;}


    // soporte horas fijas
    private static Integer horaNocturna = 21;
    private static Integer horaDiurna = 6;
    private static Integer duracionFestivos = 8;
    private static Integer minimoAlmuerzo = 8;
    
    //método constructor
    public HBT_ImportarRegistroTurnosController(){
        habilitarBotonEliminar=false;
        mensajesError = new List<HBT_MensajesPagina>();
        habilitarBoton = false;
        listaRegistros = new List<registroAlmacenar>();
        listaRegistrosError = new List<registroAlmacenar>();
        listaRegistrosTemp = new List<registroAlmacenar>();
        idRegistrosModificar = new List<String>();
        diasFestivos = new Map <String, Boolean>();
    }
    
    /*Método que se encarga de obtener los anios*/
    public List<SelectOption> getFrentes(){
        List<SelectOption> soList = new List<SelectOption>();
        List<HBT_Frente_de_Trabajo__c> proyectoUsuarioTmp = [select id, name from HBT_Frente_de_Trabajo__c order by name];
        if(proyectoUsuarioTmp.size()>0){
            for(HBT_Frente_de_Trabajo__c ft : proyectoUsuarioTmp){
                soList.add(new SelectOption(ft.id, ft.name));
            }
        }
        return soList;
    }
    
    //Método que realiza las validaciones iniciales a cada línea del archivo ya convertido en un arreglo de Strings
    public void cargarArchivo(){
        habilitarBotonEliminar=false;
        mensajesError = new List<HBT_MensajesPagina>();
        listaRegistros = new List<registroAlmacenar>();
        listaRegistrosError = new List<registroAlmacenar>();
        listaRegistrosError.clear();
        listaRegistrosTemp = new List<registroAlmacenar>();
        listaRegistrosTemp.clear();
        listaRegistros.clear();
        system.debug('inicia carga del archivo');
        
        if(fechaFinFiltro != null && fechaInicioFiltro != null){
            if(fechaFinFiltro >= fechaInicioFiltro){
                
                //Si carga archivo, se lee
                nombreArchivo = csvAsString;
                
                if(csvFileBody!=null){   
                    csvAsString = blobToString(csvFileBody,'utf-8');                 
                }
                
                //Si el archivo no esta vacio
                if(csvAsString != null && csvAsString.length()>0){
                    csvAsString = csvAsString.replaceAll('"\n','"');
                    csvAsString = csvAsString.replaceAll('\n"','"');
                    String validacionSaltoLinea = '';
                    
                    validacionSaltoLinea = csvAsString.substringBetween('"','"');
                    
                    if(!String.isEmpty(validacionSaltoLinea) || !String.isBlank(validacionSaltoLinea)){
                        csvAsString = csvAsString.replaceAll(csvAsString.substringBetween('"','"'),csvAsString.substringBetween('"','"').replaceAll('\n',' '));
                        csvAsString = csvAsString.replaceAll('"','');
                    }
                    
                    //Se saca cada linea del archivo
                    csvFileLines = csvAsString.split('\n'); 
                    
                    //solo si tiene mas de un renglon se realiza el cargue
                    if(csvFileLines.size() > 1){
                        //Se lee la primer línea del archivo para establecer el tipo de separador de campo que tiene
                        String Header = csvFileLines[1];
                        Header = Header.substring(0,Header.length()-1);
                        String separador = '';
                        
                        if(Header.split(';').size() > 1){
                            separador = ';';
                        }
                        else if (Header.split(';').size() == 1){
                            separador = ',';    
                        }
                        
                        System.debug('cantidad columnas' + Header.split(separador).size() );
                        List<Map<string,List<registroAlmacenar>>> datosLista = new List<Map<string,List<registroAlmacenar>>>();
                        Integer numeroDecolumnas = Header.split(separador).size();
                        System.debug('Número de columnas'+numeroDecolumnas);
                        //Se valida que la primera línea del archivo no contenga ni más ni menos columnas de las definidas en la plantilla (Archivo tipo 1 (4) y archivo tipo 2(7))
                        if(numeroDeColumnas == 4  || numeroDeColumnas == 6 ){
                            String numeroIdetificacion = '';
                            System.debug('Sí carga');
                            for(Integer i=1;i<csvFileLines.size();i++){
                                String[] csvRecordData = csvFileLines[i].split(separador);
                                if(csvRecordData.size()>0){
                                    //Se quitan las comillas a cada elemento del arreglo
                                    for(Integer it= 0; it<csvRecordData.size();it++){
                                        String tmp = csvRecordData[it];
                                        if(it == 0){
                                            tmp = tmp.substring(0,tmp.length());
                                        }
                                        csvRecordData[it]= tmp.trim();
                                    }

                                    Integer numLinea = i+1;
                                    Boolean hayError = false;
                                    registroAlmacenar[] registros= crearRegistros(csvRecordData, numeroDecolumnas, numLinea);
                                    //Se verifica si hubo errores
                                    for(Integer r=1;r<registros.size();r++)
                                    {
                                        if(registros.get(r).error != '' && registros.get(r).error != null){ 
                                            hayError= true;
                                            System.debug(registros.get(r).error);
                                        }
                                    }
                                    //Si no hubo error en los registros se agregan
                                    if(!hayError){
                                        agregarRegistros(registros, datosLista);
                                    }
                                    else if(listaRegistrosError.size()< (1000 - registros.size())){
                                        listaRegistrosError.addAll(registros);
                                    }
                                    /******/  
                                } 
                            }
                            if(listaRegistrosError.size() == 0){
                                listaRegistrosTemp = obtenerListaFinal(datosLista);
                                system.debug('lista datos: '+listaRegistrosTemp);
                                if(listaRegistrosTemp == null || listaRegistrosTemp.size() == 0){
                                    mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'No hay información valida para cargar. Los turnos a cargar están fuera del rango de fecha ingresado de inicio y fin.'));
                                }
                            }
                            else{
                                System.debug(listaRegistrosError.size());
                            }
                        } else{
                            mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'El contenido del archivo no corresponde al definido en la plantilla establecida.'));
                        }
                    }else{
                        mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'No hay datos para cargar en el archivo.'));
                    }  
                }else{
                    mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'Seleccione el archivo a cargar.'));
                }
                
                
                //Se consultan los Id de los ingresos a actualizar
                List<HBT_Asociacion_Empleado_Frente__c> empleadosTtmp = new List <HBT_Asociacion_Empleado_Frente__c>(
                    [select Id, Empleado__c, Frente_de_Trabajo__c, Empleado__r.id, Empleado__r.Numero_de_Documento__c, Empleado__r.Tipo__c,
                     Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Lunes__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Martes__c,
                     Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Miercoles__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Jueves__c,
                     Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Viernes__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Sabado__c,
                     Frente_de_Trabajo__r.turno__r.Tiempo_almuerzo_horas__c
                     from HBT_Asociacion_Empleado_Frente__c 
                     where Frente_de_Trabajo__r.id =:frenteSelected and Empleado__r.Numero_de_Documento__c  in: idRegistrosModificar]);
                
                //Se llena un mapa cuya llave es el Id de cada ingreso
                listaEmpleados = new Map <String,HBT_Asociacion_Empleado_Frente__c>();
                for (HBT_Asociacion_Empleado_Frente__c t: empleadosTtmp){
                    listaEmpleados.put(t.Empleado__r.Numero_de_Documento__c,t);
                }
                system.debug('lista: '+empleadosTtmp);
                validarRegistros();
                
            }else{
                mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'La fecha fin debe ser nuevoFinal o igual a la fecha inicio.'));
            }
        }else{
            mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'Los valores de fecha inicio y fecha fin son requeridos para realizar el proceso.'));
        }
    }

    /**
    * Crea los registros de los turnos para una línea del archivo del CSV
    * @param csvRecordData: Array de String que contiene el registro de una fila del archivo
    * @param numColumnas: Integer que contiene el número de columnas que debería tener la fila pasada por parámtro
    */
    public registroAlmacenar[] crearRegistros(String[] csvRecordData, Integer numColumnas,Integer numeroLinea){
        registroAlmacenar[] registros = new List<registroAlmacenar>();
        //Registro para archivo tipo 1 
        registroAlmacenar registro = new registroAlmacenar(numeroLinea);
        registro.error = '';

        //Registros para archivo tipo 2, donde una fila contiene registro entrada y salida
        registroAlmacenar registroEntrada = new registroAlmacenar(numeroLinea);
        registroAlmacenar registroSalida = new registroAlmacenar(numeroLinea);

        //Se verifica que la fila tenga el número de columnas adecuado
        if(csvRecordData.size() == numColumnas){
            //Se procesa la columna de identificación
            if(csvRecordData[0] == null || (String.isEmpty(csvRecordData[0]) || String.isBlank(csvRecordData[0]))){
                registro.error = registro.error+' El campo Identificación no debe estar vacío.'+'<br/>'; 
                registroEntrada.error = registroEntrada.error +' El campo Identificación no debe estar vacío.'+'<br/>'; 
                registroSalida.error = registroSalida.error +' El campo Identificación no debe estar vacío.'+'<br/>'; 
            }else{
                idRegistrosModificar.add(csvRecordData[0].trim());
                registro.identificacion = csvRecordData[0].trim();
            }

            //Si el archivo es tipo 1 (original)
            if(numColumnas == 4)
            {
                if(csvRecordData[2] == null || (String.isEmpty(csvRecordData[2]) || String.isBlank(csvRecordData[2]))){
                    registro.error = registro.error+' El campo Hora Marca no debe estar vacío.'+'<br/>'; 
                }else{
                    try{
                        String fechaTemp = redondearFechas(csvRecordData[2]);
                        Datetime temp =  Datetime.valueof(fechaTemp); 
                        registro.fechaIngreso = obtenerFechaLocal(temp);
                    }catch (exception e){
                        registro.error = registro.error+' El campo Hora Marca tiene un formato de fecha/hora que no es valido (Fomatos correctos dd-MM-aaaa hh:mm:ss - dd/MM/aaaa hh:mm:ss).'+'<br/>'; 
                    }
                }
                if(csvRecordData[3] == null || (String.isEmpty(csvRecordData[3]) || String.isBlank(csvRecordData[3]))){
                    registro.error = registro.error+' El campo Marca no debe estar vacío.'+'<br/>'; 
                }else if(csvRecordData[3] != 'Entrada' && csvRecordData[3] != 'Salida'){
                    registro.error = registro.error+' El campo Marca debe tener el valor "Entrada" o "Salida".'+'<br/>'; 
                }
                registro.marca = csvRecordData[3].trim();
                registros.add(registro);
            }
            else {
                //Si el archivo es tipo 2 (nuevo)
                if(csvRecordData[2] == null || (String.isEmpty(csvRecordData[2]) || String.isBlank(csvRecordData[2]))){
                    registroEntrada.error = registroEntrada.error+' El campo Fecha Entrada no debe estar vacío.'+'<br/>'; 
                }else if(csvRecordData[3] == null || (String.isEmpty(csvRecordData[3]) || String.isBlank(csvRecordData[3]))){
                    registroEntrada.error = registroEntrada.error+' El campo Entrada no debe estar vacío.'+'<br/>'; 
                }
                else {
                    try{
                        String fechaTemp = redondearFechas(csvRecordData[2].trim()+' '+csvRecordData[3].trim());
                        Datetime temp =  Datetime.valueof(fechaTemp); 
                        registroEntrada.identificacion = registro.identificacion;
                        registroEntrada.fechaIngreso = obtenerFechaLocal(temp);
                        registroEntrada.marca = 'Entrada';
                    }catch (exception e){
                        registroEntrada.error = registroEntrada.error+' El campo Fecha Entrada o el campo Entrada no tiene el formato de fecha correcto (Fomatos correctos dd-MM-aaaa hh:mm:ss - dd/MM/aaaa hh:mm:ss).'+'<br/>'; 
                    }
                }
                if(csvRecordData[4] == null || (String.isEmpty(csvRecordData[4]) || String.isBlank(csvRecordData[4]))){
                    registroSalida.error = registroSalida.error+' El campo Fecha Salida no debe estar vacío.'+'<br/>'; 
                } else if(csvRecordData[5] == null || (String.isEmpty(csvRecordData[5]) || String.isBlank(csvRecordData[5]))){
                    registroSalida.error = registroSalida.error+' El campo Salida no debe estar vacío.'+'<br/>'; 
                } else {
                    try{
                        String fechaTemp = redondearFechas(csvRecordData[4].trim()+' '+csvRecordData[5].trim());
                        Datetime temp =  Datetime.valueof(fechaTemp); 
                        registroSalida.identificacion = registro.identificacion;
                        registroSalida.fechaIngreso = obtenerFechaLocal(temp);
                        registroSalida.marca = 'Salida';
                    }catch (exception e){
                        registroSalida.error = registroSalida.error+' El campo Fecha Salida o el campo Salida no tiene el formato de fecha correcto (Fomatos correctos dd-MM-aaaa hh:mm:ss - dd/MM/aaaa hh:mm:ss).'+'<br/>'; 
                    }
                }
                registros.add(registroEntrada);
                registros.add(registroSalida);
            }
        }
        else {
            registro.error = registro.error+' Todos los registros deben tener el mismo número de columnas.'+'<br/>'; 
            registros.add(registro);
        }
        return registros;
    }

    /**
    * Agrega los registros que no tuvieron errores
    * @param registros: Registros a agregar
    */
    public registroAlmacenar[] agregarRegistros(registroAlmacenar[] registros, List<Map<string,List<registroAlmacenar>>> datosLista){
        /***cambio archivo**/
        Map<string,List<registroAlmacenar>> datos = new Map<string,List<registroAlmacenar>>();
        List<registroAlmacenar> registrosActuales = new List<registroAlmacenar>();
        if(datosLista.size()==0){
            datos.put(registros.get(0).identificacion, registros);
            datosLista.add(datos);
        } else{
            boolean encontroMapa = false;
            for(Map<string,List<registroAlmacenar>> maptemp : datosLista){
                if(maptemp.containsKey(registros.get(0).identificacion))
                {
                    maptemp.get(registros.get(0).identificacion).addAll(registros);
                    maptemp.get(registros.get(0).identificacion).sort();
                    encontroMapa = true;
                }
            }
            if(!encontroMapa){
                datos.put(registros.get(0).identificacion, registros);
                datosLista.add(datos);
            }
        }

        return registros;
    }

    //metodo que retorna la informacion lista para procesar
    private List<registroAlmacenar> obtenerListaFinal(List<Map<string,List<registroAlmacenar>>> datosLista){
        
        List<registroAlmacenar> listaFinal = new List<registroAlmacenar>();
        system.debug('NUEVO METODO');
        for(Map<string,List<registroAlmacenar>> maptemp : datosLista){
            
            Set <String> listanIdentificacion = new Set<String>();
            listanIdentificacion = maptemp.keyset();
            
            Integer cantidadDiasCarga = (fechaInicioFiltro).daysBetween(fechaFinFiltro);
            
            system.debug('cantidad dias' + cantidadDiasCarga);
            
            for(string key : listanIdentificacion){
                List<registroAlmacenar> temp = maptemp.get(key);
                if(temp.size() > 0){
                    Integer i = 0;
                    registroAlmacenar actual;
                    // actual se vuelve la primera fecha de entrada en el rango
                    while(i<temp.size()){
                        actual = temp[i];
                        system.debug('Actual: ' + actual);
                        system.debug('Diferencia: ' + actual.fechaIngreso.dateGMT().daysBetween(fechaInicioFiltro));
                        if(fechaInicioFiltro.daysBetween(actual.fechaIngreso.dateGMT()) >= 0
                        && actual.marca.equals('Entrada')){
                            i++;
                            break;
                        }
                        i++;
                    }

                    registroAlmacenar turno;
                    Datetime fechaInicio = actual.fechaIngreso;
                    Datetime diaAnterior = null;
                    
                    while(i<temp.size()){
                        actual = temp[i];
                        system.debug('Actual: ' + actual);
                        if(fechaFinFiltro.daysBetween(actual.fechaIngreso.dateGmt()) > 0 && actual.marca.equals('Salida')){
                            break;
                        }

                        switch on actual.marca {
                            when 'Salida' {
                                if(fechaInicio != null){
                                    turno = new registroAlmacenar();
                                    turno.identificacion = actual.identificacion;
                                    turno.fechaIngreso = fechaInicio;
                                    turno.fechaSalida = actual.fechaIngreso;
                                    turno.esVacio= false;

                                    system.debug('informacion procesada para cada turno: '+turno);  
                                    listaFinal.add(turno);

                                    diaAnterior = fechaInicio;
                                    fechaInicio = null;
                                }
                            }
                            when 'Entrada' {
                                if(fechaInicio == null ){
                                    if(diaAnterior == null || !actual.fechaIngreso.isSameDay(diaAnterior)){
                                        fechaInicio = actual.fechaIngreso;
                                    }
                                }
                                else if(!fechaInicio.isSameDay(actual.fechaIngreso)){
                                    turno = new registroAlmacenar();
                                    turno.identificacion = actual.identificacion;
                                    turno.fechaIngreso = fechaInicio;
                                    turno.fechaSalida = null;
                                    turno.esVacio= true;

                                    system.debug('informacion procesada para cada turno: '+turno);  
                                    listaFinal.add(turno);
                                    fechaInicio = actual.fechaIngreso;
                                }else{
                                    fechaInicio = actual.fechaIngreso;
                                }
                            }
                        }
                        i++;
                    }

                    if(fechaInicio != null && (diaAnterior == null || !fechaInicio.isSameDay(diaAnterior)) ){
                        turno = new registroAlmacenar();
                        turno.identificacion = actual.identificacion;
                        turno.fechaIngreso = fechaInicio;
                        turno.fechaSalida = null;
                        turno.esVacio= true;
                        system.debug('informacion procesada para cada turno: '+turno);  
                        listaFinal.add(turno);
                    }
                }
            }
        }
        return listaFinal;
    }
    
    //Método encargado de redondear las horas de entrada y salida de los empleados
    private string redondearFechas(string f){
        string fechaRedondeo = '';
        if(f.contains('-')){
            f=f.replace('-', '/');
        }
        String[] separarHoras = f.split(' ');
        string[] timeTemp = separarHoras.get(1).split(':');
        
        string[] fechaTemp = separarHoras.get(0).split('/');
        
        string fechaFormato = fechaTemp.get(2) + '-' + fechaTemp.get(1) + '-' + fechaTemp.get(0);
        
        Integer minutos = Integer.valueof(timeTemp.get(1));
        if(minutos >= 0 && minutos <=15){
            fechaRedondeo= fechaFormato + ' ' + timeTemp.get(0) + ':00:00';
        }else if(minutos > 15 && minutos <45){
            fechaRedondeo= fechaFormato + ' ' + timeTemp.get(0) + ':30:00';
        }else if(minutos >= 45  && minutos <= 59){
            Integer horaSiguiente = Integer.valueof(timeTemp.get(0)) + 1;
            fechaRedondeo= fechaFormato + ' ' + horaSiguiente + ':00:00';
        }
        
        return fechaRedondeo;
    }

    //Método que valida que los empleados existan en el sistema
    private void validarRegistros(){
        habilitarBoton = false;
        List<HBT_Registro_Turnos__c> registrosExistentes = new List<HBT_Registro_Turnos__c>();
        Map <String,List<HBT_Registro_Turnos__c>> listaTurnos = new Map <String,List<HBT_Registro_Turnos__c>>();
        if(listaRegistrosTemp.size()>0){
            if(fechaInicioFiltro!= null && fechaFinFiltro !=null){
                Date tempI =  fechaInicioFiltro; 
                Date tempF =  fechaFinFiltro;
                
                registrosExistentes = [select id, Fecha_Registro__c, Asociacion_Empleado__r.empleado__r.Numero_de_Documento__c 
                                       from HBT_Registro_Turnos__c 
                                       where Fecha_Registro__c >= :tempI 
                                       and Fecha_Registro__c <= :tempF
                                       and Asociacion_Empleado__r.Frente_de_Trabajo__r.id =:frenteSelected
                                      ];
                system.debug(registrosExistentes);
                //Se llena un mapa cuya llave es el Id de cada ingreso
                
                for (HBT_Registro_Turnos__c t: registrosExistentes){
                    List<HBT_Registro_Turnos__c> listaTemp = new List<HBT_Registro_Turnos__c>();
                    if(listaTurnos.containsKey(t.Asociacion_Empleado__r.empleado__r.Numero_de_Documento__c)){
                        listaTemp = listaTurnos.get(t.Asociacion_Empleado__r.empleado__r.Numero_de_Documento__c);
                        listaTemp.add(t);
                    }else{
                        listaTemp.add(t);
                    }
                    listaTurnos.put(t.Asociacion_Empleado__r.empleado__r.Numero_de_Documento__c,listaTemp);
                }
            }
        }
       
        for(registroAlmacenar registroTemp : listaRegistrosTemp){
            
            registroAlmacenar registro = registroTemp;
            registro.error='';
            HBT_Asociacion_Empleado_Frente__c temporal = listaEmpleados.get(registro.identificacion);
             Boolean existeError = false;
            if(temporal==null){
                registro.error=registro.error+' El empleado con número de identificación: '+ registro.identificacion +' no corresponde al Frente de Trabajo seleccionado.'+'<br/>';
                existeError = true;
            }else{
                // if(temporal.get) validacion si el empleado es temporal o directo/
                List<HBT_Registro_Turnos__c> listturnoTemp =  listaTurnos.get(registro.identificacion);
                if(listturnoTemp!= null && listturnoTemp.size()>0){
                    for(HBT_Registro_Turnos__c turnoTemp : listturnoTemp){
                       
                        if(registro.fechaIngreso.DateGMT() == turnoTemp.Fecha_Registro__c){
                            registro.error=registro.error+' Ya existe un registro de tiempo asociado al empleado con número de identificacion: ' +registro.identificacion+'  para la fecha: '+registro.fechaIngreso.DateGMT()+ '.'+'<br/>';
                            existeError = true;
                            habilitarBotonEliminar=true;
                            break;
                        }
                    }
                    
                }
            } 
            
            
            //Si el registro contiene error, se agrega a la lista de errores
            if(existeError){
                listaRegistrosError.add(registro);
            } 
            //Si el registro no contiene error, se agrega a la lista de registros validados y listos para cargar
            else {
                listaRegistros.add(registro);
            }   
        }
        //Se muestra mensaje de validación exitosa para los registros que no contienen errores
        if(listaRegistros.size()>0){
            //Sólo hasta que todos los registros hayan pasado las validaciones, se habilita el botón de Importar
            if(listaRegistros.size()==listaRegistrosTemp.size()){
                mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.CONFIRMACION,'El contenido del archivo está completo y listo para ser guardado.'));
                habilitarBoton = true;   
                listaRegistrosError.clear();
            }else{
                habilitarBoton = false; 
                System.debug('no son iguaes');
            }
        } 
        if(listaRegistrosError.size()>0){
            habilitarBoton = false; 
            mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'El contenido del archivo contiene información que no es valida para realizar el cargue. Verifique el detalle de los errores en el botón "Obtener Archivo".'));
        }
    }
    
    /**
    * Método para generar archivo .xls de errores encontrados al cargar información
     */
    public PageReference generarArchivo(){
        contentType = 'application/vnd.ms-excel#ErroresCargue_'+obtenerFechaLocal(Datetime.now())+'.xls';
        PageReference pagRef = Page.HBT_ReporteErroresCargueTurno;
        return pagRef;
    }
    
    /**
     * Método que realiza el calculo y almacenamiento de las horas extras de los turnos reportados
     */
    public void guardarRegistros(){
        system.debug('nombreArchivo PRUEBA'+nombreArchivo);
        // creacion nombre archvico
        HBT_Historico_Cargue_Archivos__c historico = new HBT_Historico_Cargue_Archivos__c();
        historico.nombre_archivo__c	 = nombreArchivo + '/' +obtenerFechaLocal(Datetime.now());
        insert historico;
        
        // soporte para errores
        mensajesError = new List<HBT_MensajesPagina>();

        List<HBT_Registro_Turnos__c> listaTurnos = new List<HBT_Registro_Turnos__c>();

        for(registroAlmacenar registro : listaRegistros){
            // identifica al empleado y su frente de trabajo
            HBT_Asociacion_Empleado_Frente__c empleadosTemp = listaEmpleados.get(registro.identificacion);
            
            // guarda al empleado y otra informacion en objeto turno
            HBT_Registro_Turnos__c turno = new HBT_Registro_Turnos__c();
            turno.Historico__c = historico.id;
            turno.Asociacion_Empleado__c = empleadosTemp.id;
            turno.Empleado__c = empleadosTemp.Empleado__r.id;

            // impresión fecha de entrada y salida
            system.debug('fecha ingreso: '+registro.fechaIngreso);
            system.debug('fecha salida: '+registro.fechaSalida);

            // guarda fechas de registro, entrada y salida en turno
            turno.Fecha_Registro__c = registro.fechaIngreso.DateGMT();
            turno.Fecha_Entrada_Registrada__c = registro.fechaIngreso;
            turno.fecha_Salida_Registrada__c = registro.fechaSalida;
            
            // inicializa lista de festivos si aún esta vacía
            if(diasFestivos.size() == 0){
                diasFestivos = HBT_Festivos.DiasFestivos(registro.fechaIngreso.yearGMT());
            }
            
            // según el día se asigna la duración del turno
            Integer dia = obtenerDia(registro.fechaIngreso);  
            Decimal duracionTurno;
            switch on dia {
                when 1{
                    duracionTurno = empleadosTemp.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Lunes__c;
                }
                when 2{
                    duracionTurno = empleadosTemp.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Martes__c;
                }
                when 3{
                    duracionTurno = empleadosTemp.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Miercoles__c;
                }
                when 4{
                    duracionTurno = empleadosTemp.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Jueves__c;
                }
                when 5{
                    duracionTurno = empleadosTemp.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Viernes__c;
                }
                when 6{
                    duracionTurno = empleadosTemp.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Sabado__c;
                }
                when 7{
                    duracionTurno = duracionFestivos;
                }
                when else{
                    duracionTurno = 0;
                    mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'No se pudo obtener el día de la semana.'));
                }
            }
            if(duracionTurno == null){
                duracionTurno = 0;
            }

            if(registro.esVacio){
                // caso en que registro esté vacío se guardan todas las horas extras vacías
                system.debug('se carga jornada normal, vienen horarios en blanco');
                turno.Duracion__c = duracionTurno;
                turno.esFestivo__c = false;
                turno.esNocturno__c = false;
                turno.Horas_Recargo_Nocturno__c = 0;
                turno.Hora_Extra_Nocturna__c = 0;
                turno.Hora_Recargo_Nocturno_Festivo__c = 0;
                turno.Hora_Extra_Festiva_Nocturna__c = 0;
                turno.Hora_Festiva_Dominical__c = 0;
                turno.Hora_Extra_Diurna__c = 0;
                turno.Hora_Extra_Festiva_Diurnas__c = 0;
                listaTurnos.add(turno);
                system.debug('turno basico '+ listaTurnos);
            }else{
                // se llama al método que calcula las horas extra
                turno = calculoHorasExtra(turno, registro.fechaIngreso, registro.fechaSalida, duracionTurno, empleadosTemp.Frente_de_Trabajo__r.turno__r.Tiempo_almuerzo_horas__c);

                system.debug('turnos: '+turno);
                listaTurnos.add(turno);
            }
            
        }
    
        insert listaTurnos;
        listaRegistros.clear();
        listaRegistrosError.clear();
        listaRegistrosTemp.clear();
        habilitarBoton = false;
        fechaFinFiltro = null;
        fechaInicioFiltro = null;
        csvFileBody = null;
        mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.CONFIRMACION,'Se guardo exitosamente la información.'));
    }

    /**
     * Método que calcula las horas extras de un turno según su fecha de ingreso, salida y duración
     * de su turno de trabajo
     * @param turno: turno a calcularle las horas extra
     * @param ingreso: fecha de ingreso del turno
     * @param salida: fecha de salida del turno
     * @param duracionTurno: duración del turno normalmente
     * @return el turno con las horas extras calculadas
     */
    public HBT_Registro_Turnos__c calculoHorasExtra(HBT_Registro_Turnos__c turno, Datetime ingreso, Datetime salida, Decimal duracionTurno, Decimal almuerzo){
        // se guardan si ese día o el siguiente es festivo
        Integer dia = obtenerDia(ingreso);  
        Integer diaManana = obtenerDia(ingreso.addDays(1));

        boolean esFestivoManana = diaManana == 7 || obtenerFestivo(ingreso.addDays(1));
        boolean esFestivo = dia == 7|| obtenerFestivo(ingreso) ;

        // se guarda cuantas horas trabajo el empleado en total, y cuáles de esas fueron extra
        Decimal cantidadHorasTrabajadas = obtenerTiempoHoras(ingreso, salida);

        if(cantidadHorasTrabajadas >= minimoAlmuerzo){
            duracionTurno += almuerzo;	
        }

        if(esFestivo){
            duracionTurno = duracionFestivos;
        }

        system.debug('/***************************************/');
        system.debug('dia: ' + dia);
        system.debug('festivo: '+esFestivo);
        system.debug('diaManana: ' +diaManana);
        system.debug('festivo mañana '+esFestivoManana);
        system.debug('duracion turno: '+duracionTurno);
        system.debug('cantidad horas trabajadas: '+cantidadHorasTrabajadas);
        system.debug('/***************************************/');

        // inicializamos todas las horas extra en 0
        turno.Duracion__c = cantidadHorasTrabajadas;
        turno.Horas_Recargo_Nocturno__c = 0;
        turno.Hora_Extra_Nocturna__c = 0;
        turno.Hora_Extra_Festiva_Nocturna__c = 0;
        turno.Hora_Festiva_Dominical__c = 0;
        turno.Hora_Extra_Diurna__c = 0;
        turno.Hora_Extra_Festiva_Diurnas__c = 0;    

        // hora de inicio para distintos rangos horarios
        Datetime inicioHoraNocturna = Datetime.newInstanceGMT(ingreso.dateGMT(), time.newInstance(horaNocturna, 00, 00, 00));
        Datetime inicioHoraDiurna = Datetime.newInstanceGMT(ingreso.dateGMT().addDays(1), time.newInstance(horaDiurna, 00, 00, 00));
        Datetime inicioMedianoche = Datetime.newInstanceGMT(ingreso.dateGMT().addDays(1), time.newInstance(00, 00, 00, 00));

        // referencia del final de turno calculado
        Datetime finalTurno = ingreso.addMinutes((duracionTurno * 60).intValue());
        if(finalTurno.getTime() > salida.getTime()){
            finalTurno = salida;
        }
        Datetime nuevoFinal;
        Decimal horasNuevas = 0;

        // cálculo de horas extras si el día de ingreso es festivo
        system.debug(esFestivo);
        if(esFestivo){
            if(!esFestivoManana){
                finalTurno = finalTurno.getTime() > inicioMedianoche.getTime()? inicioMedianoche: finalTurno;
            }
            turno.Hora_Festiva_Dominical__c = obtenerTiempoHoras(ingreso, finalTurno);

            if(finalTurno.getTime() >= salida.getTime()){
                return turno;
            }

            // se calculan las horas extra diurnas
            if(finalTurno.getTime() < inicioHoraNocturna.getTime()){
                nuevoFinal = salida.getTime() > inicioHoraNocturna.getTime()? inicioHoraNocturna: salida;
                turno.Hora_Extra_Festiva_Diurnas__c = obtenerTiempoHoras(finalTurno, nuevoFinal);
                finalTurno = nuevoFinal;
    
                system.debug('Extra diurnas 1');
                system.debug(finalTurno);
                system.debug(turno.Hora_Extra_Diurna__c);
            }
    
            if(finalTurno.getTime() >= salida.getTime()){
                return turno;
            }
    
            // se calculan las horas extra nocturnas
            if(finalTurno.getTime() < inicioMedianoche.getTime()){
                nuevoFinal = salida.getTime() > inicioMedianoche.getTime()? inicioMedianoche: salida;
                turno.Hora_Extra_Festiva_Nocturna__c = obtenerTiempoHoras(finalTurno, nuevoFinal);
                finalTurno = nuevoFinal;
    
                system.debug('Extra nocturnas 1');
                system.debug(finalTurno);
                system.debug(turno.Hora_Extra_Nocturna__c);
    
            }    

            if(finalTurno.getTime() >= salida.getTime()){
                return turno;
            }

            system.debug('Horas festivas');
            system.debug(finalTurno);
            system.debug(turno.Hora_Festiva_Dominical__c);
        }
        else{
            system.debug('final turno org: '+ finalTurno);

            // se calcula el recargo nocturno
            horasNuevas = obtenerTiempoHoras(inicioHoraNocturna, finalTurno);   
            if(horasNuevas >= 0){
                turno.Horas_Recargo_Nocturno__c = horasNuevas;
    
                system.debug('Recargo nocturno');
                system.debug(finalTurno);
                system.debug(turno.Horas_Recargo_Nocturno__c);
            }
    
            // se calculan las horas extra diurnas
            if(finalTurno.getTime() < inicioHoraNocturna.getTime()){
                nuevoFinal = salida.getTime() > inicioHoraNocturna.getTime()? inicioHoraNocturna: salida;
                turno.Hora_Extra_Diurna__c = obtenerTiempoHoras(finalTurno, nuevoFinal);
                finalTurno = nuevoFinal;
    
                system.debug('Extra diurnas 1');
                system.debug(finalTurno);
                system.debug(turno.Hora_Extra_Diurna__c);
            }
    
            if(finalTurno.getTime() >= salida.getTime()){
                return turno;
            }
    
            // se calculan las horas extra nocturnas
            if(finalTurno.getTime() < inicioMedianoche.getTime()){
                nuevoFinal = salida.getTime() > inicioMedianoche.getTime()? inicioMedianoche: salida;
                turno.Hora_Extra_Nocturna__c = obtenerTiempoHoras(finalTurno, nuevoFinal);
                finalTurno = nuevoFinal;
    
                system.debug('Extra nocturnas 1');
                system.debug(finalTurno);
                system.debug(turno.Hora_Extra_Nocturna__c);
    
            }    

            if(finalTurno.getTime() >= salida.getTime()){
                return turno;
            }
        }
        
        
        // cálculo de horas extra nocturnas del siguiente día
        if(finalTurno.getTime() < inicioHoraDiurna.getTime()){
            nuevoFinal = salida.getTime() > inicioHoraDiurna.getTime()? inicioHoraDiurna: salida;
            if(esFestivoManana){
                turno.Hora_Extra_Festiva_Nocturna__c += obtenerTiempoHoras(finalTurno, nuevoFinal);
            }else{
                turno.Hora_Extra_Nocturna__c += obtenerTiempoHoras(finalTurno, nuevoFinal);
            }
            finalTurno = nuevoFinal;

            system.debug('Extra nocturnas 2');
            system.debug(finalTurno);
            system.debug(turno.Hora_Extra_Nocturna__c);

            system.debug('Festivo nocturnas');
            system.debug(turno.Hora_Extra_Festiva_Nocturna__c);
        }

        if(finalTurno.getTime() >= salida.getTime()){
            return turno;
        }

        // cálculo de horas extra diurnas del siguiente día
        if(finalTurno.getTime() >= salida.getTime()){
            if(esFestivoManana){
                turno.Hora_Extra_Festiva_Diurnas__c += obtenerTiempoHoras(finalTurno, salida);
            }else{
                turno.Hora_Extra_Diurna__c += obtenerTiempoHoras(finalTurno, salida);
            }
            finalTurno = salida;

            system.debug('Extra diurnas 2');
            system.debug(finalTurno);
            system.debug(turno.Hora_Extra_Diurna__c);

            system.debug('Festivo diurnas');
            system.debug(turno.Hora_Extra_Festiva_Diurnas__c);
        }

        return turno;
    }
    
    /**
    * Método que retorna la fecha local dado un timestamp
    * @param fechaTemp: Datetime que se desea pasar a fecha local
     */
    private DateTime obtenerFechaLocal(Datetime fechaTemp){
        Integer offset = UserInfo.getTimezone().getOffset(fechaTemp);
        Datetime local = fechaTemp.addSeconds(offset/1000);
        return local;
    }
    
    private boolean obtenerFestivo(dateTime fecha){
        String dateValue = String.valueOf(fecha.dateGMT());

        return diasFestivos.get(dateValue) == null? false: diasFestivos.get(dateValue);
    }

    /**
     * Método que retorna el número del día de la semana de una fecha dada
     * @param fecha: fecha original
     * @return número del día de la semana de fecha
     */
    private Integer obtenerDia(dateTime fecha){        
        return integer.valueof(fecha.format('u'));
    }
    
    private Decimal obtenerTiempoHoras(DateTime fi, dateTime ff){
        Decimal millisecondsBetween = ff.getTime() - fi.getTime(); //NB: ths is important as to convert type
        Decimal timeBetween = millisecondsBetween / 3600000;  //1000 * 60 * 60 * 24
        return timeBetween;
    }
    
    //Este método convierte un blob a un string
    private static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    
    /*Método que se encarga de obtener los anios*/
    public List<SelectOption> getArchivosCargados(){
        
        List<SelectOption> opciones = new List<SelectOption>();
        
        for(HBT_Historico_Cargue_Archivos__c ft : [SELECT Id, nombre_archivo__c 
                                                   FROM HBT_Historico_Cargue_Archivos__c 
                                                   order by CreatedDate desc]){
			opciones.add(new SelectOption(ft.id, ft.nombre_archivo__c));
        }
        
        return opciones;
    }
    
    //Método que elimina los registros del ultimo cargue del archivo seleccionado
    public void eliminarCargue(){
        
        mensajesError.clear();
        
        if(archivoSelected != null){
            try{
                HBT_Historico_Cargue_Archivos__c historico = [select id from HBT_Historico_Cargue_Archivos__c where id = :archivoSelected];
                
                List<HBT_Registro_Turnos__c> borrarList = [select id from HBT_Registro_Turnos__c where historico__r.id = :historico.id];
                
                delete borrarList;
                delete historico;
                
                mensajesError.clear();
                listaRegistros.clear();
                listaRegistrosError.clear();
                listaRegistrosTemp.clear();
                
                habilitarBoton = false;
                habilitarBotonEliminar = false;
                mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.CONFIRMACION,'Se ha eliminado exitosamente la información cargada.'));
            }catch(Exception e){
                mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'Debe seleccionar un archivo para eliminar')); 
            }
            
        }else{
        	mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.ERROR,'Debe seleccionar un archivo para eliminar'));    
        }
    }
    
    //Clase para mantener en un objeto local los registros que luego serán actualizados
    global class registroAlmacenar implements Comparable {
        public String identificacion {get;set;}
        public Integer numeroLinea {get;set;}
        public String error {get;set;}
        public Datetime fechaIngreso{get;set;}
        public Datetime fechaSalida{get;set;}
        public boolean esVacio {get;set;}
        public string marca {get;set;}        


        public registroAlmacenar(Integer pNumeroLinea)
        {
            numeroLinea = pNumeroLinea;
            error = '';
            esVacio = true;
        }

        public registroAlmacenar()
        {
            
        }
        // Implement the compareTo() method
        global Integer compareTo(Object compareTo) {
            registroAlmacenar compareToEmp = (registroAlmacenar)compareTo;
            if (fechaIngreso.getTime() == compareToEmp.fechaIngreso.getTime()) return 0;
            if (fechaIngreso.getTime() > compareToEmp.fechaIngreso.getTime()) return 1;
            return -1;        
        }
    }
}