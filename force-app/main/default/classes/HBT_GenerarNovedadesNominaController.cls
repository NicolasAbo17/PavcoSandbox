/**                                                     
* ==============================================================================================================================
*  Desarrollado por:    Catalina Orozco
*  Fecha:               Diciembre 11 de 2018
*  Decripción:          Clase Controladora para exportar los registros de novedades para nómina
* ==============================================================================================================================
**/
public class HBT_GenerarNovedadesNominaController {
    
    //Atributo para obtener año seleccionado
    public Integer anioSelected{get;set;}
    //Atributo para mantener el mes seleccionado
    public Integer selectedmes{get;set;}
    //Atributo para Almacenar el periodo Seleccionado
    public Integer periodoSeleccionado {get;set;}
    //Atributo para Almacenar el tipo de contrato seleccionado
    public string tipoSeleccionado {get;set;}
    //Atributo para almacenar los mensajes presentados en pantalla
    public List<HBT_MensajesPagina> mensajesError {get;set;}
    //Atributo para almacenar el contentType para generar el archivo.
    public String contentType{get;set;} 
    //Atributo para matener el resultado a exportar.
    public List<TablaReporte> resultado{get;set;}
    //Atributo para mantener el año actual
    private Integer anioActual;
    //Atributo para mantener el año inicial del select.
    private static Integer ANIO_INICIAL = 2018;
    //Atributo para mantener el frente seleccionado para consultar.
    public string frenteSelected {get;set;}
    
    /*Constructor de la clase.*/
    public HBT_GenerarNovedadesNominaController(){
        mensajesError = new List<HBT_MensajesPagina>();
        anioActual = System.Today().year();
        anioSelected = System.Today().year();
        selectedmes = System.Today().month();
        resultado = new List<TablaReporte>();
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
    
    /*Método para obtener los meses para generar novedad*/
    public List<SelectOption> getItems() {
        //Se puede alimentar de un objeto custom
        return getMeses();
    }
    
    /*Método que se encarga de obtener los anios*/
    public List<SelectOption> getAnios(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        for(Integer i = ANIO_INICIAL ; i <= anioActual;i++){
            options.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
        }
        return options;
    }
    
    /*Método para generar el archivo con las novedades*/
    public PageReference generarArchivo(){
        mensajesError = new List<HBT_MensajesPagina>();
        this.contentType = 'application/vnd.ms-excel#NOVEDADES_NOVA_SOFT_'+anioSelected+'_'+selectedmes+'_'+'Periodo_'+periodoSeleccionado+'_'+tipoSeleccionado+'.xls';
        resultado = obtenerInformacionReporte();
        if(resultado.size() > 0){
            
            PageReference pagRef = Page.HBT_ReporteNovedadesNomina; 
            return pagRef;
        }else{
            mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.WARNING,'No hay información que coincida con los parametros de busqueda para generar el archivo.'));
        }
        return null;
    }
    
    /*Método para generar los datos de las novedades por empleado*/
    private List<TablaReporte> obtenerInformacionReporte(){
        
        Date fechaInicial = date.newinstance(anioSelected, selectedmes, 01);
        Date fechaFinal = date.newinstance(anioSelected, selectedmes, 15);
        
        if(periodoSeleccionado == 2){
            fechaInicial = date.newinstance(anioSelected, selectedmes, 16);
            
            Integer numberOfDays = Date.daysInMonth(anioSelected, selectedmes);
            fechaFinal = date.newinstance(anioSelected, selectedmes, numberOfDays);
        }
        
        List<TablaReporte> temp = new List<TablaReporte>();
        
        for(AggregateResult rt : [SELECT Asociacion_Empleado__r.Empleado__r.Numero_de_Documento__c numEmpleado, 
                                  sum(Hora_Extra_Diurna__c) HED, sum(Hora_Festiva_Dominical__c) HFD, sum(Hora_Extra_Festiva_Diurnas__c) HEFD,
                                  sum(Hora_Extra_Festiva_Nocturna__c) HEFN, sum(Hora_Extra_Nocturna__c) HEN, sum(Horas_Recargo_Nocturno__c) HRN
                                  FROM HBT_Registro_Turnos__c
                                  WHERE Fecha_Registro__c >= :fechaInicial 
                                  AND Fecha_Registro__c <= :fechaFinal
                                  AND  Asociacion_Empleado__r.Empleado__r.tipo__c = :tipoSeleccionado
                                  AND Asociacion_Empleado__r.Frente_de_Trabajo__c = :frenteSelected
                                  GROUP BY Asociacion_Empleado__r.Empleado__r.Numero_de_Documento__c])
        {
            
            TablaReporte tr = new TablaReporte();
            
            if((Decimal)rt.get('HRN') != null && (Decimal)rt.get('HRN') >0){
                //RECARGO NOCTURNOS
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.REGARGO_NOCTURNO;
                tr.cantidadHoras = (Decimal)rt.get('HRN');
                temp.add(tr);    
            }
            
            /*if((Decimal)rt.get('HEFN') != null && (Decimal)rt.get('HEFN') >0){
                //no se que valor va para este item
                //RECARGO NOCTURNO FESTIVO
                tr = new TablaReporte();
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.RECARGO_NOCTURNO_FESTIVO;
                tr.cantidadHoras = (Decimal)rt.get('HEFN');
                temp.add(tr);
            }*/
            
            if((Decimal)rt.get('HED') != null && (Decimal)rt.get('HED') >0){
                //HORA EXTRA DIURNA
                tr = new TablaReporte();
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA;
                tr.cantidadHoras = (Decimal)rt.get('HED');
                temp.add(tr);
            }
            
            if((Decimal)rt.get('HEN') != null && (Decimal)rt.get('HEN') >0){
                // HORA EXTRA NOCTURNA
                tr = new TablaReporte();
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA;
                tr.cantidadHoras = (Decimal)rt.get('HEN');
                temp.add(tr);
            }
            
            if((Decimal)rt.get('HFD') != null && (Decimal)rt.get('HFD') >0){
                //DOMINICAL O FESTIVO
                tr = new TablaReporte();
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO;
                tr.cantidadHoras = (Decimal)rt.get('HFD');
                temp.add(tr);
            }
            
            if((Decimal)rt.get('HEFD') != null && (Decimal)rt.get('HEFD') >0){
                //HORA EXTRA DIURNA FESTIVO 
                tr = new TablaReporte();
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA;
                tr.cantidadHoras = (Decimal)rt.get('HEFD');
                temp.add(tr);
            }
            
            if((Decimal)rt.get('HEFN') != null && (Decimal)rt.get('HEFN') > 0){
                //HORA EXTRA NOCTURNA FESTIVO
                tr = new TablaReporte();
                tr.identificacion = (String)rt.get('numEmpleado');
                tr.item = HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA;
                tr.cantidadHoras = (Decimal)rt.get('HEFN');
                temp.add(tr);
            }
        }
        return temp;
    }
    
    /*Método encargado de obtener la lista de SelecOptions para los meses.*/
    private List<SelectOption> getMeses(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Enero'));
        options.add(new SelectOption('2','Febrero'));
        options.add(new SelectOption('3','Marzo'));
        options.add(new SelectOption('4','Abril'));
        options.add(new SelectOption('5','Mayo'));
        options.add(new SelectOption('6','junio'));
        options.add(new SelectOption('7','Julio'));
        options.add(new SelectOption('8','Agosto'));
        options.add(new SelectOption('9','Septiembre'));
        options.add(new SelectOption('10','Octubre'));
        options.add(new SelectOption('11','Noviembre'));
        options.add(new SelectOption('12','Diciembre'));
        return options;
    }
    
    /*Clase para presentar el archivo con las novedades para un periodo seleccionado*/
    public class TablaReporte{
        public string identificacion {get;set;}
        public string item {get;set;}
        public Decimal cantidadHoras {get;set;}
        public Decimal valor {get;set;}
        
        //Constructor
        public TablaReporte(){
            cantidadhoras = 0;
            valor = 0;
        }
    }
}