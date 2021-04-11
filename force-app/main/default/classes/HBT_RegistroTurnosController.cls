public class HBT_RegistroTurnosController {
    public Date fechaCierre{get;set;}  
    //Lista para manejo de los mensajes
    public String elId {get;set;}
    public String acl {get;set;}
    public String agrupadorFiltro{get;set;}
    //Lista de proyectos en los que el usuario tiene items de trabajo ordenado asc
    public List<HBT_Frente_de_Trabajo__c> proyectoUsuario {get;set;}
    public String nombreProyectoSeleccionado {get;set;}
    public List<TablaRegistro> tareas {get;set;}
    public TablaRegistro logSeleccionado {get;set;}
    public HBT_Registro_Turnos__c nuevoLog {get;set;}
    public TablaLogs logConsultado {get;set;}
    public List<TablaLogs> logsConsultados {get;set;}
    public List<HBT_Asociacion_Empleado_Frente__c> tareasTmp {get;set;}
    //Rango de fecha de la semana de registro
    public String rangoFecha {get;set;}
    public String rangoFecha2 {get;set;}
    public String lun {get;set;}
    public String mar {get;set;}
    public String mie {get;set;}
    public String jue {get;set;}
    public String vie {get;set;}
    public String sab {get;set;}
    public String dom {get;set;}
    //Atributos para mantener la información que se muestra en el modal
    public String nombreItem {get;set;}
    public String descripcionLog {get;set;}
    public String diaSeleccionadoDescripcion {get;set;}
    public Boolean indicadorNocturno {get;set;}
    public Boolean indicadorHoraAdicional {get;set;}
    public Boolean indicadorFacturable {get;set;}
    public String ItemConsultado {get;set;}
    public Decimal logAdicional {get;set;}
    public Boolean indicadorTurnoBasico {get;set;}
    public Boolean seleccionindicadorTurnoBasico {get;set;}
    //Atributos para mantener la información del avance y tiempo restante del Item
    public Boolean deslun {get;set;}
    public Boolean desmar {get;set;}
    public Boolean desmie {get;set;}
    public Boolean desjue {get;set;}
    public Boolean desvie {get;set;}
    public Boolean dessab {get;set;}
    public Boolean desdom {get;set;}
    public Integer mes {get;set;}
    public Integer anno {get;set;}
    public Integer mesD {get;set;}
    public Integer annoD {get;set;}
    public String fechaNueva {get;set;}
    //Atributos para manejar la información del total diario de logs, tiempo restante y adicional
    public Decimal totalDia {get;set;}
    public Decimal totalFest {get;set;}
    public Decimal totalSabadoTemp {get;set;}
    public Decimal totallunes {get;set;}
    public Decimal totalmartes {get;set;}
    public Decimal totalmiercoles {get;set;}
    public Decimal totaljueves {get;set;}
    public Decimal totalviernes {get;set;}
    public Decimal totalsabado {get;set;}
    public Decimal totaldomingo {get;set;} 
    public Decimal restantelunes {get;set;}
    public Decimal restantemartes {get;set;}
    public Decimal restantemiercoles {get;set;}
    public Decimal restantejueves {get;set;}
    public Decimal restanteviernes {get;set;}
    public Decimal restantesabado {get;set;}
    public Decimal restantedomingo {get;set;}
    public Boolean adicionallunes {get;set;}
    public Boolean adicionalmartes {get;set;}
    public Boolean adicionalmiercoles {get;set;}
    public Boolean adicionaljueves {get;set;}
    public Boolean adicionalviernes {get;set;}
    public Boolean adicionalsabado {get;set;}
    public Boolean adicionaldomingo {get;set;}
    //atributos para manejar los días festivos de un año
    public Map <String, Boolean> diasFestivos {get;set;}
    public Boolean fesLun {get;set;}
    public Boolean fesMar {get;set;}
    public Boolean fesMie {get;set;}
    public Boolean fesJue {get;set;}
    public Boolean fesVie {get;set;}
    public Boolean fesSab {get;set;}
    public Boolean fesDom {get;set;}
    public Boolean setLun {get;set;}
    public Boolean setMar {get;set;}
    public Boolean setMie {get;set;}
    public Boolean setJue {get;set;}
    public Boolean setVie {get;set;}
    public Boolean setSab {get;set;}
    public Boolean setDom {get;set;}
    public String diaFestivo {get;set;}
    
    //Booleanos que permiten mostrar proyectos donde el usuario está asignado o tiene items asignados
    public Boolean blnProys {get;set;} //Mostrar proyectos    
    public Boolean blnNoProys {get;set;} //Mostrar mensaje si no tiene proyecto asignado o items asignados
    
    //atributo para mostrar mensaje al guardar
    public String alertMsg{get;set;}
    //ID del usuario en sesion
    private String userId;
    //fecha actual
    private Date d;
    //fecha Actual con formato
    private Date hoy;
    //Proyecto seleccionado
    private String selectedId;
    //tipo hora seleccinada
    public string tipoHoraSelected {get;set;}
    //Atributos Paginador
    private Integer counter=0;   //Contador de registros que se van mostrando
    private Integer list_size=10; //Cantidad de filas a mostrar por cada página
    public Integer total_size=0;   //Cantidad total de registros (logs) de la consulta    
    
    //atributos para mantener las tareas cerradas
    public boolean verCerradas{get;set;}
   

    /*Método que se encarga de obtener los anios*/
    public List<SelectOption> getHorasExtras(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption(HBT_HorasExtrasConstantes.REGARGO_NOCTURNO, 'Recargo Nocturno'));
        options.add(new SelectOption(HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA, 'Extra Festiva Nocturna'));
        options.add(new SelectOption(HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA, 'Extra Festiva Diurna'));
        options.add(new SelectOption(HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA, 'Extra Nocturna'));
        options.add(new SelectOption(HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA, 'Extra Diurna'));
        options.add(new SelectOption(HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO, 'Festica Sin Compensación'));
        
        return options;
    }
    
    /*método constructos*/
    public HBT_RegistroTurnosController(){
        //Se inicilia el filtro de agrupadores
        indicadorTurnoBasico = false;
        seleccionindicadorTurnoBasico = false;
        agrupadorFiltro='';
        verCerradas = false;
        nombreItem = '';
        totalDia = 0;
        totallunes = 0;
        totalmartes = 0;
        totalmiercoles = 0;
        totaljueves = 0;
        totalviernes = 0;
        totalsabado = 0;
        totaldomingo = 0;
        restantelunes = 0;
        restantemartes = 0;
        restantemiercoles = 0;
        restantejueves = 0;
        restanteviernes = 0;
        restantesabado = 0;
        restantedomingo = 0;
        adicionallunes = false;
        adicionalmartes = false;
        adicionalmiercoles = false;
        adicionaljueves = false;
        adicionalviernes = false;
        adicionalsabado = false;
        adicionaldomingo = false;
        blnProys = true;
        blnNoProys = false;
        
        if(lun == null || lun == ''){
            //fecha actual
            d = System.today();
            hoy = System.today();
            Date dt = d.toStartofWeek();
            //primer dia de la semana
            Date weekStart = dt.addDays(-1);
            userid = UserInfo.getUserId();
            
            proyectoUsuario = new List<HBT_Frente_de_Trabajo__c>(); //Objeto que mantiene los proyectos donde el usuario está asociado o tiene items de trabajo
            List<HBT_Frente_de_Trabajo__c> proyectoUsuarioTmp = new List<HBT_Frente_de_Trabajo__c>(); //Guarda temporalmente los proyectos asociados al usuario o donde tiene items de trabajo
            
            proyectoUsuario = [select id, name from HBT_Frente_de_Trabajo__c order by name];
            alertMsg = 'Los registros se han guardado exitosamente';
            //id del primer frente de trabajo
            if(proyectoUsuario.size()>0){
                HBT_Frente_de_Trabajo__c p1=proyectoUsuario.get(0);
                selectedId = p1.id;
                //se cargan los emplados que tenga registrados para la semana actual
                cantidadItems(weekStart, selectedId); // Paginador -- Obtención de la cantidad de registros que actualizan el atributo total_size 
                //Permite mostrar en pantalla los frente donde hay empleados asociados 
                obtenerLogs(weekStart, selectedId);
                blnProys = true;
                blnNoProys = false;
            }else{
                blnProys = false;
                blnNoProys = true;
            }
        }
    }
    
    //Método que devuelve la cantidad total de Items de trabajo de la consulta a realizar - Paginador
    private void cantidadItems(Date weekStart, string proyectoid){
        String filtroAgrupoador =  '%'+agrupadorFiltro+'%';
        //se consultan la cantidad de items de trabajo asociados al proyecto seleccionado para el usuario actual
        List<HBT_Asociacion_Empleado_Frente__c> cantItems = new List<HBT_Asociacion_Empleado_Frente__c>();
        
        
        cantItems =[SELECT Id, Empleado__r.name, Empleado__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_sabado__c,
                     (select id, Duracion__c, Comentario__c, Fecha_Registro__c 
                      from Registro_Turnos__r 
                      where Fecha_Registro__c>= :weekStart and  Fecha_Registro__c<= :weekStart.addDays(6) order by Fecha_Registro__c)
                     FROM HBT_Asociacion_Empleado_Frente__c
                     WHERE Frente_de_Trabajo__r.id = :proyectoid and Empleado__r.Numero_de_Documento__c like:filtroAgrupoador];
     
        
        
        total_size  = cantItems.size(); 
        
    }    
    
    
    private void obtenerLogs(Date weekStart, string proyectoid){
        totalDia = 0;
        totallunes = 0;
        totalmartes = 0;
        totalmiercoles = 0;
        totaljueves = 0;
        totalviernes = 0;
        totalsabado = 0;
        totaldomingo = 0;
        restantelunes = 0;
        restantemartes = 0;
        restantemiercoles = 0;
        restantejueves = 0;
        restanteviernes = 0;
        restantesabado = 0;
        restantedomingo= 0;
        adicionallunes = false;
        adicionalmartes = false;
        adicionalmiercoles = false;
        adicionaljueves = false;
        adicionalviernes = false;
        adicionalsabado = false;
        adicionaldomingo = false;
        Integer ral = 0;
        Decimal resta = 0;
        fechaCierre= system.today();
        
        
        nombreProyectoSeleccionado = System.currentPagereference().getParameters().get('nombreProyectoSeleccionado');     
     
        fechaCierre = Date.today().addDays(1);
                
        //Se obtiene el mapa con los festivos del año actual
        if (weekStart.year() == hoy.year()){
            diasFestivos = HBT_Festivos.DiasFestivos(weekStart.year());    
        } else {
            diasFestivos = HBT_Festivos.DiasFestivos(hoy.year());    
        }
      
        
        //Se consulta si algún día de la semana que se está visualizando es festivo
        fesLun = isFestivo (weekStart.addDays(1));
        fesMar = isFestivo (weekStart.addDays(2));
        fesMie = isFestivo (weekStart.addDays(3));
        fesJue = isFestivo (weekStart.addDays(4));
        fesVie = isFestivo (weekStart.addDays(5));
        fesSab = isFestivo (weekStart.addDays(6));
        fesDom = true;
        setLun = false;
        setMar = false;
        setMie = false;
        setJue = false;
        setVie = false;
        setSab = false;
        setDom = false;
        
        //se obtiene el dia por cada dia de la semana para mostrar en pantalla
        if(rangoFecha2 == null){
            rangoFecha2 = obtenerPrimeraSemana(weekStart);            
        }  
        obtenerDias(weekStart);  
        String filtroAgrupoador =  '%'+agrupadorFiltro+'%';
        
        //se consultan los logs por el proyecto seleccionado para la semana seleccionada
        tareasTmp = new List<HBT_Asociacion_Empleado_Frente__c>();
        
        tareasTmp = [SELECT Id, Empleado__r.Numero_de_Documento__c , Empleado__r.name, Empleado__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno__c, Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_sabado__c,
                     (select id, Duracion__c, Comentario__c, Fecha_Registro__c, asociacion_empleado__c 
                      from Registro_Turnos__r 
                      where Fecha_Registro__c>= :weekStart and  Fecha_Registro__c<= :weekStart.addDays(6) order by Fecha_Registro__c)
                     FROM HBT_Asociacion_Empleado_Frente__c
                     WHERE Frente_de_Trabajo__r.id = :proyectoid and Empleado__r.Numero_de_Documento__c like:filtroAgrupoador 
                     limit:list_size offset :counter];
        //se arma lista con los datos a mostrar en la malla
        tareas = new List<TablaRegistro>();
        if(tareasTmp.size()>0){
            totallunes = 0;
            totalmartes = 0;
            totalmiercoles = 0;
            totaljueves = 0;
            totalviernes = 0;
            totalsabado = 0;
            totaldomingo = 0;
            restantelunes = 0;
            restantemartes = 0;
            restantemiercoles = 0;
            restantejueves = 0;
            restanteviernes = 0;
            restantesabado = 0;
            restantedomingo = 0;
            adicionallunes = false;
            adicionalmartes = false;
            adicionalmiercoles = false;
            adicionaljueves = false;
            adicionalviernes = false;
            adicionalsabado = false;
            adicionaldomingo = false;
            for(HBT_Asociacion_Empleado_Frente__c a: tareasTmp){
               
                totalDia = a.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno__c;
                totalsabadoTemp = a.Frente_de_Trabajo__r.turno__r.Cantidad_Horas_Turno_Sabado__c;
                TablaRegistro ttmp = new TablaRegistro();
                ral = 0;
                resta = 0;
                
                //Objeto usado y creado en esta clase para contener la información a pintar en la malla
                ttmp.nombreTarea = a.Empleado__r.name;
                ttmp.proyecto = a.Empleado__r.name;
                ttmp.asignacionItem = a.id;
               	ttmp.abierto = a.Empleado__r.Numero_de_Documento__c;
                ttmp.noctLun = false;
                ttmp.noctMar = false;
                ttmp.noctMie = false;
                ttmp.noctJue = false;
                ttmp.noctVie = false;
                ttmp.noctSab = false;
                ttmp.noctDom = false;
                ttmp.factLun = false;
                ttmp.factMar = false;
                ttmp.factMie = false;
                ttmp.factJue = false;
                ttmp.factVie = false;
                ttmp.factSab = false;
                ttmp.factDom = false;
                
                //se sacan las fechas para cada dia de la semana
                ttmp.fechaDomingo = weekStart.addDays(0);
                ttmp.fechaLunes = weekStart.addDays(1);
                ttmp.fechaMartes = weekStart.addDays(2);
                ttmp.fechaMiercoles = weekStart.addDays(3);
                ttmp.fechaJueves = weekStart.addDays(4);                    
                ttmp.fechaViernes = weekStart.addDays(5);
                ttmp.fechaSabado = weekStart.addDays(6);
                
                if(a.Registro_Turnos__r.size()>0){
                    ttmp.noctLun = false;
                    ttmp.noctMar = false;
                    ttmp.noctMie = false;
                    ttmp.noctJue = false;
                    ttmp.noctVie = false;
                    ttmp.noctSab = false;
                    ttmp.noctDom = false;
                    ttmp.factLun = false;
                    ttmp.factMar = false;
                    ttmp.factMie = false;
                    ttmp.factJue = false;
                    ttmp.factVie = false;
                    ttmp.factSab = false;
                    ttmp.factDom = false;
                    
                   
                    //se llenan los logs que ya estan registrados
                    for(HBT_Registro_Turnos__c log : a.Registro_Turnos__r){
                   
                        if(log.Fecha_registro__c == ttmp.fechaLunes){
                            List <HBT_Registro_Turnos__c> logsLunes = [select Id, Duracion__c from HBT_Registro_Turnos__c where  fecha_registro__c = :ttmp.fechaLunes and asociacion_empleado__c = :log.asociacion_empleado__c  order by CreatedDate]; 
                            if(logsLunes.size()==1){
                                ttmp.lunes = log.Duracion__c;
                                ttmp.idLunes = log.Id;
                                ttmp.descripcionLogLunes = log.Comentario__c;
                                ttmp.noctLun = false;
                                ttmp.factLun = false; 
                                ttmp.editableLun = false; 
                                
                            }
                             
                        }
                      
                        if(log.fecha_registro__c == ttmp.fechaMartes){
                            List <HBT_Registro_Turnos__c> logsMartes = [select Id, Duracion__c from HBT_Registro_Turnos__c where fecha_registro__c = :ttmp.fechaMartes and asociacion_empleado__c = :log.asociacion_empleado__c order by CreatedDate];   
                            if(logsMartes.size()==1){
                                ttmp.martes = log.Duracion__c;
                                ttmp.idMartes = log.Id;
                                ttmp.descripcionLogMartes = log.Comentario__c;
                                ttmp.noctMar = false;
                                ttmp.factMar = false;
                                ttmp.editableMar = false;
                            }
                           
                        }
                        
                        if(log.fecha_registro__c == ttmp.fechaMiercoles){
                            List <HBT_Registro_Turnos__c> logsMiercoles = [select Id, Duracion__c from HBT_Registro_Turnos__c where fecha_registro__c = :ttmp.fechaMiercoles and asociacion_empleado__c = :log.asociacion_empleado__c order by CreatedDate];
                            if(logsMiercoles.size()==1){
                                ttmp.miercoles = log.Duracion__c;
                                ttmp.idMiercoles = log.Id;
                                ttmp.descripcionLogMiercoles = log.Comentario__c;
                                ttmp.noctMie = false;
                                ttmp.factMie = false;
                                ttmp.editableMie = false;
                                
                            }
                           
                        }
                        if(log.fecha_registro__c == ttmp.fechaJueves){
                            List <HBT_Registro_Turnos__c> logsJueves = [select Id, Duracion__c from HBT_Registro_Turnos__c where fecha_registro__c = :ttmp.fechaJueves and asociacion_empleado__c = :log.asociacion_empleado__c order by CreatedDate];      
                            if(logsJueves.size()==1){
                                ttmp.jueves = log.Duracion__c;
                                ttmp.descripcionLogJueves = log.Comentario__c;
                                ttmp.idJueves = log.Id;
                                ttmp.noctJue = false;
                                ttmp.factJue = false;
                                ttmp.editableJue = false;
                               
                            }
                          
                        }
                        
                        if(log.fecha_registro__c == ttmp.fechaViernes){
                            List <HBT_Registro_Turnos__c> logsViernes = [select Id, Duracion__c from HBT_Registro_Turnos__c where fecha_registro__c = :ttmp.fechaViernes and asociacion_empleado__c = :log.asociacion_empleado__c order by CreatedDate];        
                            if(logsViernes.size()==1){
                                ttmp.viernes = log.Duracion__c;
                                ttmp.descripcionLogViernes = log.Comentario__c;
                                ttmp.idViernes = log.Id;
                                ttmp.noctVie = false;
                                ttmp.factVie = false;
                                ttmp.editableVie = false;    
                            }
                           
                        }
                        
                        if(log.fecha_registro__c == ttmp.fechaSabado){
                            List <HBT_Registro_Turnos__c> logsSabado = [select Id, Duracion__c from HBT_Registro_Turnos__c where fecha_registro__c = :ttmp.fechaSabado and asociacion_empleado__c = :log.asociacion_empleado__c order by CreatedDate];    
                            if(logsSabado.size()==1){
                                ttmp.sabado = log.Duracion__c;
                                ttmp.descripcionLogSabado = log.Comentario__c;
                                ttmp.idSabado = log.Id;
                                ttmp.noctSab = false;
                                ttmp.factSab = false;
                                ttmp.editableSab = false;    
                            }
                           
                        }
                        
                        if(log.fecha_registro__c == ttmp.fechaDomingo){
                            List <HBT_Registro_Turnos__c> logsDomingo = [select Id, Duracion__c from HBT_Registro_Turnos__c where fecha_registro__c = :ttmp.fechaDomingo and asociacion_empleado__c = :log.asociacion_empleado__c order by CreatedDate];   
                            if(logsDomingo.size()==1){
                                ttmp.domingo = log.Duracion__c;
                                ttmp.idDomingo = log.Id;
                                ttmp.descripcionLogDomingo = log.Comentario__c;
                                ttmp.noctDom = false;
                                ttmp.factDom = false;
                                ttmp.editableDom = false;
                            }
                           
                        }
                    }
                }
                
                //Se llena el total de logs por día para la semana seleccionada.  
                //Totaliza los logs por día de todos los items de todos los proyectos del usuario.
                AggregateResult[] SUMLogs = [select SUM(Duracion__c)dur, fecha_registro__c 
                                             from HBT_Registro_Turnos__c 
                                             where fecha_registro__c>= :weekStart and  fecha_registro__c<= :weekStart.addDays(6) 
                                             and Asociacion_Empleado__r.Frente_de_Trabajo__r.id = :proyectoid 
                                             group by fecha_registro__c order by fecha_registro__c];    
                
               
                for (AggregateResult varTemp : SUMLogs){
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaDomingo ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totaldomingo = (Decimal)varTemp.get('dur');
                        }else {
                            totaldomingo = totaldomingo;
                        }
                    }
                    
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaLunes ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totallunes = (Decimal)varTemp.get('dur');
                        } 
                        else {
                            totallunes = totallunes;
                        }    
                    }
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaMartes ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totalmartes = (Decimal)varTemp.get('dur');
                        } 
                        else {
                            totalmartes = totalmartes;
                        }
                    }
                    
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaMiercoles ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totalmiercoles = (Decimal)varTemp.get('dur');
                        } 
                        else {
                            totalmiercoles = totalmiercoles;
                        }
                    }
                    
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaJueves ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totaljueves = (Decimal)varTemp.get('dur');
                        } 
                        else {
                            totaljueves = totaljueves;
                        }
                    }
                    
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaViernes ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totalviernes = (Decimal)varTemp.get('dur');
                        } 
                        else {
                            totalviernes = totalviernes;
                        }
                    }
                    
                    if(varTemp.get('fecha_registro__c') == ttmp.fechaSabado ){
                        if ((Decimal)varTemp.get('dur') > 0){
                            totalsabado = (Decimal)varTemp.get('dur');
                        } 
                        else {
                            totalsabado = totalsabado;
                        }
                    }
                }
                
                restantelunes = -1 * (totalDia - totallunes);
                
              
                if(fesLun){
                     restantelunes = -1 * (8 - totallunes);
                }
                if(restantelunes >= 0){
                    adicionallunes = true;
                } 
                if(restantelunes < 0) {
                    adicionallunes = false;
                }
                
                restantemartes = -1 * (totalDia - totalmartes);
                if(fesMar){
                    restantemartes = -1 * (8 - totalmartes);
                }
                if(restantemartes >= 0){
                    adicionalmartes = true;
                } 
                if(restantemartes < 0) {
                    adicionalmartes = false;
                }
                
                restantemiercoles = -1 * (totalDia - totalmiercoles);
                 if(fesMie){
                    restantemiercoles = -1 * (8 - totalmiercoles);
                }
                if(restantemiercoles >= 0){
                    adicionalmiercoles = true;
                } 
                if(restantemiercoles < 0) {
                    adicionalmiercoles = false;
                }
                
                restantejueves = -1 * (totalDia - totaljueves);
                if(fesJue){
                    restantejueves = -1 * (8 - totaljueves);
                }
                if(restantejueves >= 0){
                    adicionaljueves = true;
                } 
                if(restantejueves < 0) {
                    adicionaljueves = false;
                }
                
                restanteviernes = -1 * (totalDia - restanteviernes);
                if(fesJue){
                    restanteviernes = -1 * (8 - restanteviernes);
                }
                if(restanteviernes >= 0){
                    adicionalviernes = true;
                } 
                if(restanteviernes < 0) {
                    adicionalviernes = false;
                }
                
                restantesabado = -1 * (totalsabadoTemp - totalSabado);
                if(restantesabado >= 0){
                    adicionalsabado = true;
                } 
                if(restantesabado < 0) {
                    adicionalsabado = false;
                }
                
                restantedomingo = -1 * (8 - totaldomingo);
                if(restantedomingo >= 0){
                    adicionaldomingo = true;
                } 
                if(restantedomingo < 0) {
                    adicionaldomingo = false;
                }
                tareas.add(ttmp);
                
            }
        }
      system.debug('tareas: '+tareas);
    }
    
    
    //método para determinar si un día es festivo
    private Boolean isFestivo (Date diaConsulta){
        Boolean contains = diasFestivos.containsKey(string.valueof(diaConsulta) + ' 00:00:00');
        
        if(contains){
            return true;
        }
        return false;
        
    }
  
    
    public void changeEditable(){
        if(diaFestivo.contains('Lun')){
            setLun = setLun ? false:true;
        }
        if(diaFestivo.contains('Mar')){
            setMar = setMar ? false:true;
        }
        if(diaFestivo.contains('Mie')){
            setMie = setMie ? false:true;
        }
        if(diaFestivo.contains('Jue')){
            setJue = setJue ? false:true;
        }
        if(diaFestivo.contains('Vie')){
            setVie = setVie ? false:true;
        }
        if(diaFestivo.contains('Sab')){
            setSab = setSab ? false:true;
        }
        if(diaFestivo.contains('Dom')){
            setDom = setDom ? false:true;
        }
    }
    
    private void obtenerDias(Date weekStart){
       if(weekStart  <= hoy ){
            desdom = true;
        }else{
            desdom = false;
        }
        integer primerDia = weekStart.day();
        dom = 'Dom ' + primerDia;
        if(weekStart.addDays(1) <= hoy){
            deslun = true;
        }else{
            deslun = false;
        }
        lun = 'Lun ' + (weekStart.addDays(1).day());
       
        if(weekStart.addDays(2) <= hoy){
            desmar = true;
        }else{
            desmar = false;
        }
        mar = 'Mar ' + (weekStart.addDays(2).day());
       
        if(weekStart.addDays(3) <= hoy){
            desmie = true;
        }else{
            desmie = false;
        }
        mie = 'Mie ' + (weekStart.addDays(3).day());
       
      
        if(weekStart.addDays(4) <= hoy){
           
            desjue = true;
        }else{
           
            desjue = false;
        }
        jue = 'Jue ' + (weekStart.addDays(4).day());
       
      
        if(weekStart.addDays(5) <= hoy){
           
            desvie = true;
        }else{
            
            desvie = false;
        }
        vie = 'Vie ' + (weekStart.addDays(5).day());
       
        if(weekStart.addDays(6) <= hoy){
            dessab = true;
        }else{
            dessab = false;
        }
        sab = 'Sab ' + (weekStart.addDays(6).day());
        
        anno = weekStart.year();
        mes = weekStart.month();
        date weekFinish = weekStart.addDays(6);
        mesD = weekFinish.month();
        annoD = weekFinish.year();
        rangoFecha = getMesLetras(mes) + ' ' + primerDia + ' a ' + getMesLetras(mesD) + ' ' +  (weekStart.addDays(6).day());
    }
    
    private String obtenerPrimeraSemana(Date weekStart){
        
        if(weekStart > hoy){
            desdom = true;
        }else{
            desdom = false;
        }
        integer primerDia = weekStart.day();
        dom = 'Dom ' + primerDia;
        if(weekStart.addDays(1) > hoy){
            deslun = true;
        }else{
            deslun = false;
        }
        lun = 'Lun ' + (weekStart.addDays(1).day());
        
        if(weekStart.addDays(2) > hoy){
            desmar = true;
        }else{
            desmar = false;
        }
        mar = 'Mar ' + (weekStart.addDays(2).day());
        
        if(weekStart.addDays(3) > hoy){
            desmie = true;
        }else{
            desmie = false;
        }
        mie = 'Mie ' + (weekStart.addDays(3).day());
        
        if(weekStart.addDays(4) > hoy){
            desjue = true;
        }else{
            desjue = false;
        }
        jue = 'Jue ' + (weekStart.addDays(4).day());
        
        if(weekStart.addDays(5) > hoy){
            desvie = true;
        }else{
            desvie = false;
        }
      
        vie = 'Vie ' + (weekStart.addDays(5).day());
        
        if(weekStart.addDays(6) > hoy){
            dessab = true;
        }else{
            dessab = false;
        }
        sab = 'Sab ' + (weekStart.addDays(6).day());
        
        anno = weekStart.year();
        mes = weekStart.month();
        date weekFinish = weekStart.addDays(6);
        mesD = weekFinish.month();
        annoD = weekFinish.year();
        rangoFecha2 = getMesLetras(mes) + ' ' + primerDia + ' a ' + getMesLetras(mesD) + ' ' +  (weekStart.addDays(6).day());
        return rangoFecha2;
    }
    
    //COn el numero del mes se obtiene en letras en español
    private string getMesLetras (integer mes){
        string mesLetras='';
        
        if(mes == 01){
            mesLetras ='Enero';
        }
        if(mes == 02){
            mesLetras ='Febrero';
        }
        if(mes == 03){
            mesLetras ='Marzo';
        }
        if(mes == 04){
            mesLetras ='Abril';
        }
        if(mes == 05){
            mesLetras ='Mayo';
        }
        if(mes == 06){
            mesLetras ='Junio';
        }
        if(mes == 07){
            mesLetras ='Julio';
        }
        if(mes == 08){
            mesLetras ='Agosto';
        }
        if(mes == 09){
            mesLetras ='Septiembre';
        }
        if(mes == 10){
            mesLetras ='Octubre';
        }
        if(mes == 11){
            mesLetras ='Noviembre';
        }
        if(mes == 12){
            mesLetras ='Diciembre';
        }
        
        return mesLetras;
    }
    
    //se cambia la semana desde la pantalla
    public PageReference  cambiarSemana(){   
        if(fechaNueva != ''){
            string[] datos = fechaNueva.split('/');
            Date dt = date.newinstance(integer.valueOf(datos[2]), integer.valueOf(datos[0]), integer.valueOf(datos[1]));
            d = dt.addDays(1);
            dt = d.toStartofWeek();
            Date weekStart = dt.addDays(-1);
            obtenerLogs(weekStart, selectedId);
        }
        rangoFecha2 = rangoFecha;  
        return null;
    }
    
    // se cambia de proyecto desde la pantalla
    public PageReference inicializarId(){ 
        elId = System.currentPagereference().getParameters().get('elId');
        acl = System.currentPagereference().getParameters().get('acl');
        return null;
    }
    
    public PageReference cambiarproyecto(){
        agrupadorFiltro='';
        // Inicio: Se restablecen variables del Paginador al cambiar de frente
        counter=0;    //Contador de registros que se van mostrando
        total_size=0; //Se restablece la cantidad de registros
        // Fin: Se restablecen variables del Paginador 
        selectedId = elId;
        Date dt = d.toStartofWeek();
        Date weekStart = dt.addDays(-1);
        
        cantidadItems(weekStart, selectedId); // Paginador -- Obtención de la cantidad de registros que actualizan el atributo total_size 
        obtenerLogs(weekStart, selectedId);
        return null;
    }
   
    //se agrega informacion de horas extras  
    public PageReference agregarDescripcion(){
        logAdicional = 0;
        ItemConsultado = System.currentPagereference().getParameters().get('IdItemTrabajo');
        nuevoLog = new HBT_Registro_Turnos__c();
        nuevoLog.Asociacion_Empleado__c = ItemConsultado;
        nuevoLog.Duracion__c = 0;
        nuevoLog.Comentario__c = '';
        nuevoLog.esFestivo__c = false;
        nuevoLog.esNocturno__c = false;
        
        List <HBT_Registro_Turnos__c> logsMultiples = new List <HBT_Registro_Turnos__c>();
        logsConsultados  = new List<TablaLogs>();
        logSeleccionado = new TablaRegistro();
        for(TablaRegistro trg : tareas){   
            if(trg.asignacionItem.equals(ItemConsultado)){
                logSeleccionado = trg;
                nombreItem = logSeleccionado.nombreTarea;
                logsMultiples = [select id, Duracion__c, Comentario__c, Fecha_Registro__c, esHoraAdicional__c,
                                 esNocturno__c, esFestivo__c, Horas_Recargo_Nocturno__c, Hora_Extra_Diurna__c, Hora_Extra_Nocturna__c, 
                                 Hora_Extra_Festiva_Diurnas__c, Hora_Recargo_Nocturno_Festivo__c, Hora_Extra_Festiva_Nocturna__c, Hora_Festiva_Dominical__c
                                 from HBT_Registro_Turnos__c 
                                 where fecha_registro__c >= :trg.fechaDomingo 
                                 AND fecha_registro__c <= :trg.fechaSabado 
                                 and  Asociacion_Empleado__c = :ItemConsultado 
                                 order by CreatedDate];
            }
        }
        
system.debug('lista: '+logsMultiples);
        indicadorTurnoBasico = false;
        seleccionindicadorTurnoBasico =false;
        if(diaSeleccionadoDescripcion.contains('Lun')){
            String fechaTemp = diaSeleccionadoDescripcion.remove('Lun ');
            for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                
                String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
              
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
            } 
            
        }
        if(diaSeleccionadoDescripcion.contains('Mar')){
            String fechaTemp = diaSeleccionadoDescripcion.remove('Mar ');
           for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
            } 
            
        }
        if(diaSeleccionadoDescripcion.contains('Mie')){
            String fechaTemp = diaSeleccionadoDescripcion.remove('Mie ');
            for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
            } 
            
        }
        if(diaSeleccionadoDescripcion.contains('Jue')){
            String fechaTemp = diaSeleccionadoDescripcion.remove('Jue ');
            for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
            } 
            
        }
        if(diaSeleccionadoDescripcion.contains('Vie')){
            String fechaTemp = diaSeleccionadoDescripcion.remove('Vie ');
            for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
            } 
            
        }
        if(diaSeleccionadoDescripcion.contains('Sab')){
            String fechaTemp = diaSeleccionadoDescripcion.remove('Sab ');
            for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
            } 
            
        }
        if(diaSeleccionadoDescripcion.contains('Dom')){
                String fechaTemp = diaSeleccionadoDescripcion.remove('Dom ');
                for (HBT_Registro_Turnos__c logTempp : logsMultiples){
                    String fechaTemp2 = String.valueOf(logTempp.Fecha_registro__c.Day());
                if(fechaTemp2.equals(fechaTemp)){
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Recargo Nocturno ('+HBT_HorasExtrasConstantes.REGARGO_NOCTURNO+')';
                    logConsultado.logDia = logTempp.Horas_Recargo_Nocturno__c;
                    if(logTempp.Horas_Recargo_Nocturno__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Nocturna__c;
                    if(logTempp.Hora_Extra_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                    }else{
                        logConsultado.esNocturno = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Nocturna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Nocturna__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esNocturno = true;
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esNocturno = false;
                        logConsultado.esFacturable = false;
                    }
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Festiva Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Festiva_Diurnas__c;
                    if(logTempp.Hora_Extra_Festiva_Nocturna__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Extra Diurna ('+HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA+')';
                    logConsultado.logDia = logTempp.Hora_Extra_Diurna__c;
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.esFacturable = false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                    
                    logConsultado  = new TablaLogs();
                    logConsultado.comentarioLog = 'Festivo Sin Compensación ('+HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO+')';
                    logConsultado.logDia = logTempp.Hora_Festiva_Dominical__c;
                    if(logTempp.Hora_Festiva_Dominical__c > 0){
                        logConsultado.esFacturable = true;
                    }else{
                        logConsultado.esFacturable = false;
                    }
                    logConsultado.esNocturno = false;
                    LogConsultado.esHoraAdicional= false;
                    logConsultado.fechaLog = logTempp.Fecha_registro__c;
                    logConsultado.idLog = logTempp.id;
                    logsConsultados.add(logConsultado);
                }
                } 
                
            }    
        
        if(logsConsultados.size() == 0){
            indicadorTurnoBasico = true;
            seleccionindicadorTurnoBasico=false;
        }
        
        
        return null;
    }
    
    public PageReference adicionarLog(){
        date fechaLog = system.today();
        Decimal total = 0;
        string id= '';
        
     
  
        for(TablaRegistro trg : tareas){  
            
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Lun')){
                trg.editableLun = true;
                fechaLog = trg.fechaLunes;
                total = totaldia;
                if(fesLun){
                    total = 8;
                }
                id= trg.idLunes;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Mar')){
                trg.editableMar = true;
                fechaLog = trg.fechaMartes;
                total = totaldia;
                if(fesMar){
                    total = 8;
                }

                id=trg.idmartes;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Mie')){
                trg.editableMie = true;
                fechaLog = trg.fechaMiercoles;
                total = totaldia;
                if(fesMie){
                    total = 8;
                }
                id=trg.idmiercoles;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Jue')){
                trg.editableJue = true;
                fechaLog = trg.fechaJueves;
                total = totaldia;
                if(fesJue){
                    total = 8;
                }
                id=trg.idjueves;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Vie')){
                trg.editableVie = true;
                fechaLog = trg.fechaViernes;
                total = totaldia;
                if(fesVie){
                    total = 8;
                }
                id=trg.idviernes;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Sab')){
                trg.editableSab = true;
                fechaLog = trg.fechaSabado;
                total = totalSabadoTemp;
                if(fesSab){
                    total = 8;
                }
                id=trg.idsabado;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Dom')){
                trg.editableDom = true;
                fechaLog = trg.fechaDomingo;
                total = 8;
                id=trg.iddomingo;
            }
        }
        
        if(id != ''){
              List<HBT_Registro_Turnos__c> tempList = [select id, Horas_Recargo_Nocturno__c, Hora_Extra_Nocturna__c, Hora_Extra_Diurna__c, 
                                      Hora_Extra_Festiva_Nocturna__c, Hora_Extra_Festiva_Diurnas__c, Hora_Festiva_Dominical__c
                                      from HBT_Registro_Turnos__c where id = :id];
            
            if(tempList.size()>0){
                nuevoLog = tempList.get(0);
            }
        
        }
        nuevoLog.Asociacion_Empleado__c = ItemConsultado;
        HBT_Asociacion_Empleado_Frente__c aTemp = [select empleado__c from HBT_Asociacion_Empleado_Frente__c where id =:ItemConsultado limit 1];
        nuevoLog.Empleado__c = atemp.Empleado__c;
        //   nuevoLog.Duracion__c = logAdicional + total;
        nuevoLog.Comentario__c = tipoHoraSelected;
        nuevoLog.Fecha_registro__c = fechaLog;
      
       
     
        if(!seleccionindicadorTurnoBasico && tipoHoraSelected == HBT_HorasExtrasConstantes.REGARGO_NOCTURNO){
            nuevoLog.Horas_Recargo_Nocturno__c = logAdicional;
             if(nuevoLog.Horas_Recargo_Nocturno__c == null){
                nuevoLog.Horas_Recargo_Nocturno__c = 0;
            }
        }else{
            nuevoLog.Horas_Recargo_Nocturno__c = 0;
        }
        if(!seleccionindicadorTurnoBasico && tipoHoraSelected  == HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA){
            nuevoLog.Hora_Extra_Nocturna__c = logAdicional;
            if(nuevoLog.Hora_Extra_Nocturna__c == null){
                nuevoLog.Hora_Extra_Nocturna__c = 0;
            }
        }else{
            nuevoLog.Hora_Extra_Nocturna__c = 0;
        }
        
        if(!seleccionindicadorTurnoBasico && tipoHoraSelected == HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA){
            nuevoLog.Hora_Extra_Diurna__c = logAdicional;
            if(nuevoLog.Hora_Extra_Diurna__c == null){
                nuevoLog.Hora_Extra_Diurna__c = 0;
            }
        }else{
            nuevoLog.Hora_Extra_Diurna__c = 0;
        }
        if(!seleccionindicadorTurnoBasico && tipoHoraSelected == HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA){
            nuevoLog.Hora_Extra_Festiva_Nocturna__c = logAdicional;
            if(nuevoLog.Hora_Extra_Festiva_Nocturna__c == null){
                nuevoLog.Hora_Extra_Festiva_Nocturna__c = 0;
            }
        }else{
            nuevoLog.Hora_Extra_Festiva_Nocturna__c = 0;
        }
        if(!seleccionindicadorTurnoBasico && tipoHoraSelected == HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA){
            nuevoLog.Hora_Extra_Festiva_Diurnas__c = logAdicional;
            if(nuevoLog.Hora_Extra_Festiva_Diurnas__c == null){
                nuevoLog.Hora_Extra_Festiva_Diurnas__c = 0;
            }
        }else{
            nuevoLog.Hora_Extra_Festiva_Diurnas__c = 0;
        }
        if(!seleccionindicadorTurnoBasico && tipoHoraSelected  == HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO){
            nuevoLog.Hora_Festiva_Dominical__c = logAdicional;
            if(nuevoLog.Hora_Festiva_Dominical__c == null){
                nuevoLog.Hora_Festiva_Dominical__c = 0;
            }
        }else{
            nuevoLog.Hora_Festiva_Dominical__c = 0;
        }

        
         if(diaSeleccionadoDescripcion.contains('Dom') 
               || fesSab || fesVie || fesJue || fesMie || fesMar || fesLun){
            nuevoLog.Hora_Festiva_Dominical__c = 8;
        }
         
        
        
 		nuevoLog.Duracion__c = total;
       
        
        if(nuevoLog.Duracion__c>0){
            try{
                upsert nuevoLog;
                alertMsg = 'Los registros se han guardado exitosamente'; 
            } catch (DmlException e) {
                System.debug('Ha ocurrido una excepción DML: ' + e.getMessage());
                alertMsg = 'Los registros no han sido guardados,';
            }
            
        }
        
        ItemConsultado = '';
        logAdicional = null;
        descripcionLog = '';
        indicadorNocturno = false;
        indicadorTurnoBasico = false;
        indicadorHoraAdicional= false;
        indicadorFacturable = false;
        fechaLog = null;
        recargarLogs();
        return null;
    }
    
    //se guarda la descripcion y los check de facturable y nocturno al log que le corresponda
    public PageReference guardarDescripcion(){
       
        date fechaLog = system.today();
        Decimal total = 0;
        string id= '';
        
      
         for(TablaRegistro trg : tareas){    
            
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Lun')){
                trg.editableLun = true;
                fechaLog = trg.fechaLunes;
                total = totaldia;
                if(fesLun){
                    total = 8;
                }
                id= trg.idLunes;
               
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Mar')){
                trg.editableMar = true;
                fechaLog = trg.fechaMartes;
                total = totaldia;
                if(fesMar){
                    total = 8;
                }

                id=trg.idmartes;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Mie')){
                trg.editableMie = true;
                fechaLog = trg.fechaMiercoles;
                total = totaldia;
                if(fesMie){
                    total = 8;
                }
                id=trg.idmiercoles;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Jue')){
                trg.editableJue = true;
                fechaLog = trg.fechaJueves;
                total = totaldia;
                if(fesJue){
                    total = 8;
                }
                id=trg.idjueves;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Vie')){
                trg.editableVie = true;
                fechaLog = trg.fechaViernes;
                total = totaldia;
                if(fesVie){
                    total = 8;
                }
                id=trg.idviernes;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Sab')){
                trg.editableSab = true;
                fechaLog = trg.fechaSabado;
                total = totalSabadoTemp;
                if(fesSab){
                    total = 8;
                }
                id=trg.idsabado;
            }
            if(trg.asignacionItem.equals(ItemConsultado) && diaSeleccionadoDescripcion.contains('Dom')){
                trg.editableDom = true;
                fechaLog = trg.fechaDomingo;
                total = 8;
                id=trg.iddomingo;
            }
        }
        
        List<HBT_Registro_Turnos__c> tempList = [select id, Horas_Recargo_Nocturno__c, Hora_Extra_Nocturna__c, Hora_Extra_Diurna__c, 
                                      Hora_Extra_Festiva_Nocturna__c, Hora_Extra_Festiva_Diurnas__c, Hora_Festiva_Dominical__c
                                      from HBT_Registro_Turnos__c where id = :id];
        
        HBT_Registro_Turnos__c temp = new HBT_Registro_Turnos__c();
        if(templist.size()>0){
            temp = templist.get(0);
        }
        temp.Asociacion_Empleado__c = ItemConsultado;
        temp.id = id;
        
        temp.Comentario__c = tipoHoraSelected;
        temp.esFestivo__c =  indicadorFacturable;        
        temp.esNocturno__c = indicadorNocturno;                
        temp.Fecha_registro__c = fechaLog;
        
        for (TablaLogs tablaTemp : logsConsultados){
            
           temp.esFestivo__c = tablaTemp.esFacturable;
            temp.esNocturno__c = tablaTemp.esNocturno;
            if(tablaTemp.comentarioLog.contains(HBT_HorasExtrasConstantes.REGARGO_NOCTURNO)){
                temp.Horas_Recargo_Nocturno__c = tablaTemp.logDia;
            }
            if(tablaTemp.comentarioLog.contains(HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA)){
                temp.Hora_Extra_Nocturna__c = tablaTemp.logDia;
            }
            if(tablaTemp.comentarioLog.contains(HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA)){
                temp.Hora_Extra_Diurna__c = tablaTemp.logDia;
            }
            if(tablaTemp.comentarioLog.contains(HBT_HorasExtrasConstantes.HORA_EXTRA_NOCTURNA_FESTIVA)){
                temp.Hora_Extra_Festiva_Nocturna__c = tablaTemp.logDia;
            }
            if(tablaTemp.comentarioLog.contains(HBT_HorasExtrasConstantes.HORA_EXTRA_DIURNA_FESTIVA)){
                temp.Hora_Extra_Festiva_Diurnas__c = tablaTemp.logDia;
            }
            if(tablaTemp.comentarioLog.contains(HBT_HorasExtrasConstantes.DOMINICAL_FESTIVO)){
                temp.Hora_Festiva_Dominical__c = tablaTemp.logDia;
            }
            
        }
      
       
        Decimal duracionExtras = 0;
    
        duracionExtras = duracionExtras + temp.Hora_Festiva_Dominical__c;
        duracionExtras = duracionExtras + temp.Hora_Extra_Festiva_Diurnas__c; 
        duracionExtras = duracionExtras + temp.Hora_Extra_Festiva_Nocturna__c;
        duracionExtras = duracionExtras + temp.Horas_Recargo_Nocturno__c;
        duracionExtras = duracionExtras + temp.Hora_Extra_Diurna__c;
        duracionExtras = duracionExtras + temp.Hora_Extra_Nocturna__c;
        decimal calculos = total;
      
        if(temp.Horas_Recargo_Nocturno__c!= null && temp.Horas_Recargo_Nocturno__c > 0){
            system.debug('tiene horas recargo nocturno');
            calculos = total - temp.Horas_Recargo_Nocturno__c;
        }else{
             calculos = total;
        }
        if(diaSeleccionadoDescripcion.contains('Dom') 
           || fesSab || fesVie || fesJue || fesMie || fesMar || fesLun){
               system.debug('es domingo o festivo');
               calculos = 0;
           }else{
                calculos = total;
           }
        if(temp.Hora_Extra_Diurna__c != null && temp.Hora_Extra_Diurna__c > 0 && !diaSeleccionadoDescripcion.contains('Sab') ){
            system.debug('tiene horas extra diurna');
            calculos = total + 1;   
            
        }else{
            calculos = total;
        }
        
        
    
        
        system.debug('cal: '+calculos);
         system.debug('ex: '+duracionExtras);
 		temp.Duracion__c = calculos + duracionExtras;
       
        try{
            Update temp;
            alertMsg = 'Los registros se han guardado exitosamente'; 
        } catch (DmlException e) {
            System.debug('Ha ocurrido una excepción DML: ' + e.getMessage());
            alertMsg = 'Los registros no han sido guardados,';
        }
        recargarLogs();
        return null;
    }
      
    //Inicio: Métodos para moverse con el paginador
    //Método cuando el usuario da click en "Primero"
    public PageReference Beginning() { 
        counter = 0;
        recargarLogs();
        return null;
    }
    
    //Método cuando el usuario da click en "Anterior"
    public PageReference Previous() { 
        counter -= list_size;
        recargarLogs();
        return null;
    }
    
    //Método cuando el usuario da click en "Siguiente"
    public PageReference Next() { 
        counter += list_size;
        recargarLogs();
        return null;
    }
    
    //Método cuando el usuario da click en "Último"
    public PageReference End() { 
        // Si la cantidad de registros por página NO es múltiplo de la cantidad total de registros
        if (math.mod(total_size, list_size) > 0){        
            counter = total_size - math.mod(total_size, list_size);           
        }else{            
            counter = total_size - list_size;        
        }
        recargarLogs();
        return null;
    }
    
    //Deshabilita los botones Primero y Anterior
    public Boolean getDisablePrevious() { 
        if (counter>0) return false; else return true;
    }
    
    //Deshabilita los botones Siguiente y Último
    public Boolean getDisableNext() { 
        if (counter + list_size < total_size) return false; else return true;
    }
    
    //Obtiene la cantidad de registros total (logs) obtenidos en la consulta de logs
    public Integer getTotal_size() {
        return total_size;
    }
    
    //Obtiene el número de página dividiendo el contador actual de registros entre la cantidad de registros a mostrar por página + 1
    public Integer getPageNumber() {
        if (total_size == counter){
            return counter/list_size;
        }else{
            return counter/list_size + 1;
        }
    }
    
    //Obtiene la cantidad total de páginas
    public Integer getTotalPages() {
        if (list_size == 0 || total_size == 0) {
            return 0;
        } 
        else {    
            if (math.mod(total_size, list_size) > 0) {
                return total_size/list_size + 1;
            } else {
                return (total_size/list_size);
            }
        }
    }
 
    // Método que llama obtenerLogs para cargar los logs del proyecto y la semana que se tienen seleccionados
    public PageReference recargarLogs(){
        // Se guarda lo que hay antes de mover los registros entre páginas
        Date dt = d.toStartofWeek();
        Date weekStart = dt.addDays(-1);
        obtenerLogs(weekStart, selectedId);
        cantidadItems(weekStart, selectedId); // Paginador -- Obtención de la cantidad de registros que actualizan el atributo total_size 
        return null;
        
    }
   

    public class TablaRegistro
    {
        public Decimal lunes {get;set;}
        public Decimal martes {get;set;}
        public Decimal miercoles {get;set;}
        public Decimal jueves {get;set;}
        public Decimal viernes {get;set;}
        public Decimal sabado {get;set;}
        public Decimal domingo {get;set;}
        
        public Boolean noctLun {get;set;}
        public Boolean noctMar {get;set;}
        public Boolean noctMie {get;set;}
        public Boolean noctJue {get;set;}
        public Boolean noctVie {get;set;}
        public Boolean noctSab {get;set;}
        public Boolean noctDom {get;set;}
        
        public Boolean factLun {get;set;}
        public Boolean factMar {get;set;}
        public Boolean factMie {get;set;}
        public Boolean factJue {get;set;}
        public Boolean factVie {get;set;}
        public Boolean factSab {get;set;}
        public Boolean factDom {get;set;}
        
        public Boolean editableLun {get;set;}
        public Boolean editableMar {get;set;}
        public Boolean editableMie {get;set;}
        public Boolean editableJue {get;set;}
        public Boolean editableVie {get;set;}
        public Boolean editableSab {get;set;}
        public Boolean editableDom {get;set;}
        
        public ID idLunes {get;set;}
        public ID idMartes {get;set;}
        public ID idMiercoles {get;set;}
        public ID idJueves {get;set;}
        public ID idViernes {get;set;}
        public ID idSabado {get;set;}
        public ID idDomingo {get;set;}
        public ID asignacionItem {get;set;}
        
        public Date fechaLunes {get;set;}
        public Date fechaMartes {get;set;}
        public Date fechaMiercoles {get;set;}
        public Date fechaJueves {get;set;}
        public Date fechaViernes {get;set;}
        public Date fechaSabado {get;set;}
        public Date fechaDomingo {get;set;}
        
        public String duracion {get;set;}  
        public String proyecto {get;set;}  
        public String nombreTarea {get;set;}  
        public String duracionRestante{get;set;}
        public String abierto {get;set;} 
        public String descripcionLogLunes {get;set;}
        public String descripcionLogMartes {get;set;}
        public String descripcionLogMiercoles {get;set;}
        public String descripcionLogJueves {get;set;}
        public String descripcionLogViernes {get;set;}
        public String descripcionLogSabado {get;set;}
        public String descripcionLogDomingo {get;set;}
    
        public TablaRegistro(){
            lunes = 0;
            martes = 0;
            miercoles = 0;
            jueves = 0;
            viernes = 0;
            sabado = 0;
            domingo = 0;
            noctLun = false;
            noctMar = false;
            noctMie = false;
            noctJue = false;
            noctVie = false;
            noctSab = false;
            noctDom = false;
            editableLun = false;
            editableMar = false;
            editableMie = false;
            editableJue = false;
            editableVie = false;
            editableSab = false;
            editableDom = false;
           // actividadFutura=true; //Requerimiento: A-1634 - omgm
        }
    }
    
    public class TablaLogs{
        public Decimal logDia {get;set;}
        public Boolean esNocturno {get;set;}
        public Boolean esHoraAdicional {get;set;}
        public Boolean esFacturable {get;set;}
        public Boolean esEditable {get;set;}
        public ID idLog {get;set;}
        public Date fechaLog {get;set;}
        public String comentarioLog {get;set;}
        public String nombreCliente {get;set;}
        public TablaLogs(){
            logDia = 0;
            esNocturno = false;
            esFacturable = false;
            esEditable = false;
            esHoraAdicional = false;
            comentarioLog = '';
            nombreCliente = '';
        }
    }
    
    
}