@isTest
public class HBT_RegistroTurnosControllerTest {

    static testmethod void controllertest() {         
        Date fechaTemp = system.today();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;
        
        
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        
        insert ft;
        
        HBT_Frente_de_Trabajo__c ft1 = new HBT_Frente_de_Trabajo__c();
        ft1.Name = 'frente 2';
        ft1.Turno__c = t.id;
        
        insert ft1;
        
        HBT_Asociacion_Empleado_Frente__c a = new HBT_Asociacion_Empleado_Frente__c();
        a.Frente_de_Trabajo__c = ft.id;
        a.Empleado__c = e.id;
        insert a;
        
        
        Date weekstart = system.today();        
        weekstart = weekstart.toStartOfWeek();
        
        List<HBT_Registro_Turnos__c> logs = new List<HBT_Registro_Turnos__c>();
        
        HBT_Registro_Turnos__c loglunes=new HBT_Registro_Turnos__c();
        loglunes.Comentario__c='';//ok
        loglunes.Duracion__c=8.5;//ok
        loglunes.esFestivo__c=true;//ok
        loglunes.Fecha_registro__c= weekstart;//ok
        loglunes.Asociacion_Empleado__c= a.id;//ok
        loglunes.esNocturno__c= true;//ok
        loglunes.Hora_Extra_Diurna__c = 0;
        loglunes.Hora_Extra_Festiva_Diurnas__c = 0;
        loglunes.Hora_Extra_Festiva_Nocturna__c = 0;
        loglunes.Hora_Extra_Nocturna__c = 0;
        loglunes.Hora_Festiva_Dominical__c = 0;
        loglunes.Horas_Recargo_Nocturno__c =0;
        logs.add(loglunes);
                
        HBT_Registro_Turnos__c logmartes=new HBT_Registro_Turnos__c();
        logmartes.Comentario__c='';
        logmartes.Duracion__c=8.5;
        logmartes.esFestivo__c=true;
        logmartes.Fecha_registro__c= weekstart.addDays(1);
        logmartes.Asociacion_Empleado__c= a.id;
        logmartes.esNocturno__c= true;
        logmartes.Hora_Extra_Diurna__c = 0;
        logmartes.Hora_Extra_Festiva_Diurnas__c = 0;
        logmartes.Hora_Extra_Festiva_Nocturna__c = 0;
        logmartes.Hora_Extra_Nocturna__c = 0;
        logmartes.Hora_Festiva_Dominical__c = 0;
        logmartes.Horas_Recargo_Nocturno__c =0;
        logs.add(logmartes);
        
        HBT_Registro_Turnos__c logmiercoles=new HBT_Registro_Turnos__c();
        logmiercoles.Comentario__c='Prueba';
        logmiercoles.Duracion__c=8.5;
        logmiercoles.esFestivo__c=true;
        logmiercoles.Fecha_registro__c= weekstart.addDays(2);
        logmiercoles.Asociacion_Empleado__c= a.id;
        logmiercoles.esNocturno__c= true;
        logmiercoles.Hora_Extra_Diurna__c = 0;
        logmiercoles.Hora_Extra_Festiva_Diurnas__c = 0;
        logmiercoles.Hora_Extra_Festiva_Nocturna__c = 0;
        logmiercoles.Hora_Extra_Nocturna__c = 0;
        logmiercoles.Hora_Festiva_Dominical__c = 0;
        logmiercoles.Horas_Recargo_Nocturno__c =0;
		logs.add(logmiercoles);
        
        HBT_Registro_Turnos__c logjueves=new HBT_Registro_Turnos__c();
        logjueves.Comentario__c='Prueba';
        logjueves.Duracion__c=8.5;
        logjueves.esFestivo__c=true;
        logjueves.Fecha_registro__c= weekstart.addDays(3);
        logjueves.Asociacion_Empleado__c= a.id;
        logjueves.esNocturno__c= true;
        logjueves.Hora_Extra_Diurna__c = 0;
        logjueves.Hora_Extra_Festiva_Diurnas__c = 0;
        logjueves.Hora_Extra_Festiva_Nocturna__c = 0;
        logjueves.Hora_Extra_Nocturna__c = 0;
        logjueves.Hora_Festiva_Dominical__c = 0;
        logjueves.Horas_Recargo_Nocturno__c =0;
        logs.add(logjueves);
        
        HBT_Registro_Turnos__c logviernes=new HBT_Registro_Turnos__c();
        logviernes.Comentario__c='Prueba';
        logviernes.Duracion__c=8.5;
        logviernes.esFestivo__c=true;
        logviernes.Fecha_registro__c= weekstart.addDays(4);
        logviernes.Asociacion_Empleado__c= a.id;
        logviernes.esNocturno__c= true;
        logviernes.Hora_Extra_Diurna__c = 0;
        logviernes.Hora_Extra_Festiva_Diurnas__c = 0;
        logviernes.Hora_Extra_Festiva_Nocturna__c = 0;
        logviernes.Hora_Extra_Nocturna__c = 0;
        logviernes.Hora_Festiva_Dominical__c = 0;
        logviernes.Horas_Recargo_Nocturno__c =0;
        logs.add(logviernes);        
        
        HBT_Registro_Turnos__c logsabado=new HBT_Registro_Turnos__c();
        logsabado.Comentario__c='Prueba';
        logsabado.Duracion__c=8.5;
        logsabado.esFestivo__c=true;
        logsabado.Fecha_registro__c= weekstart.addDays(5);
        logsabado.Asociacion_Empleado__c= a.id;
        logsabado.esNocturno__c= true;
        logsabado.Hora_Extra_Diurna__c = 0;
        logsabado.Hora_Extra_Festiva_Diurnas__c = 0;
        logsabado.Hora_Extra_Festiva_Nocturna__c = 0;
        logsabado.Hora_Extra_Nocturna__c = 0;
        logsabado.Hora_Festiva_Dominical__c = 0;
        logsabado.Horas_Recargo_Nocturno__c =0;
        logs.add(logsabado);
        
        
        HBT_Registro_Turnos__c logdomingo=new HBT_Registro_Turnos__c();
        logdomingo.Comentario__c='Prueba';
        logdomingo.Duracion__c=8.5;
        logdomingo.esFestivo__c=true;
        logdomingo.Fecha_registro__c= weekstart.addDays(-1);
        logdomingo.Asociacion_Empleado__c= a.id;
        logdomingo.esNocturno__c= true;
        logdomingo.Hora_Extra_Diurna__c = 0;
        logdomingo.Hora_Extra_Festiva_Diurnas__c = 0;
        logdomingo.Hora_Extra_Festiva_Nocturna__c = 0;
        logdomingo.Hora_Extra_Nocturna__c = 0;
        logdomingo.Hora_Festiva_Dominical__c = 0;
        logdomingo.Horas_Recargo_Nocturno__c =0;
        logs.add(logdomingo);
        
        insert logs;
        
        
     
        
        //Se crea el controlador       
        HBT_RegistroTurnosController registro= new HBT_RegistroTurnosController();
        registro.elId = ApexPages.currentPage().getParameters().put('elId',a.Id);
        ApexPages.currentPage().getParameters().put('selectedId',ft.Id); 
        registro.getHorasExtras();
        registro.lun = 'Lun 10';
        registro.mar = 'Mar 11';
        registro.mie = 'Mie 12';
        registro.jue = 'Jue 13';
        registro.vie = 'Vie 14';
        registro.sab = 'Sab 15';
        registro.dom = 'Dom 16';     
        
        registro.tareasTmp = new List<HBT_Asociacion_Empleado_Frente__c>();
        registro.tareasTmp.add(a);
   
        registro.logSeleccionado = new HBT_RegistroTurnosController.TablaRegistro();        
        registro.seleccionindicadorTurnoBasico = false;
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Lun '+weekstart.day();  
        system.debug('cata --- Lun '+weekstart.day());
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.adicionarLog();
        registro.ItemConsultado= a.id;
        registro.agregarDescripcion();
        registro.ItemConsultado= a.id;
        registro.tipoHoraSelected = '001066';
        registro.adicionarLog();
        
   
        
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Mar ' +weekstart.addDays(1).day();  
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.tipoHoraSelected = '001060';
        
        registro.agregarDescripcion();
        
        registro.ItemConsultado= a.id;
        registro.adicionarLog();
        
        registro.logConsultado  = new HBT_RegistroTurnosController.TablaLogs();
        registro.logsConsultados = new List <HBT_RegistroTurnosController.TablaLogs>();
        
        registro.ItemConsultado= a.id;
        
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Mie '+weekstart.addDays(2).day();  
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.tipoHoraSelected = '001061';
        registro.agregarDescripcion();
         registro.ItemConsultado= a.id;
          registro.adicionarLog();
        
         
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Dom '+ weekstart.addDays(-1).day();
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.tipoHoraSelected = '001062';
        registro.adicionarLog();
      
   
        
        registro.fechaNueva ='15/08/2018';
        registro.cambiarSemana();  
        registro.diaFestivo='Lunes';
        registro.changeEditable();
        registro.diaFestivo='Martes';
        registro.changeEditable();
        registro.diaFestivo='Miercoles';
        registro.changeEditable();
        registro.diaFestivo='Jueves';
        registro.changeEditable();
        registro.diaFestivo='Viernes';
        registro.changeEditable();    
        registro.diaFestivo='Sabado';
        registro.changeEditable();
        registro.diaFestivo='Domingo';
        registro.changeEditable();
      //  registro.adicionarLog();
        
        
        registro.Beginning();
    }  

    class TablaRegistro {
        
    
        Decimal lunes {get;set;}
        Decimal martes {get;set;}
        Decimal miercoles {get;set;}
        Decimal jueves {get;set;}
        Decimal viernes {get;set;}
        Decimal sabado {get;set;}
        Decimal domingo {get;set;}
        Integer avance {get;set;}
        
        public Boolean noctLun {get;set;}
        Boolean noctMar {get;set;}
        Boolean noctMie {get;set;}
        Boolean noctJue {get;set;}
        Boolean noctVie {get;set;}
        Boolean noctSab {get;set;}
        Boolean noctDom {get;set;}
        
        Boolean factLun {get;set;}
        Boolean factMar {get;set;}
        Boolean factMie {get;set;}
        Boolean factJue {get;set;}
        Boolean factVie {get;set;}
        Boolean factSab {get;set;}
        Boolean factDom {get;set;}
        
        Boolean editableLun {get;set;}
        Boolean editableMar {get;set;}
        Boolean editableMie {get;set;}
        Boolean editableJue {get;set;}
        Boolean editableVie {get;set;}
        Boolean editableSab {get;set;}
        Boolean editableDom {get;set;}
        
        ID idLunes {get;set;}
        ID idMartes {get;set;}
        ID idMiercoles {get;set;}
        ID idJueves {get;set;}
        ID idViernes {get;set;}
        ID idSabado {get;set;}
        ID idDomingo {get;set;}
        
        Date fechaLunes {get;set;}
        Date fechaMartes {get;set;}
        Date fechaMiercoles {get;set;}
        Date fechaJueves {get;set;}
        Date fechaViernes {get;set;}
        Date fechaSabado {get;set;}
        Date fechaDomingo {get;set;}
        
        String duracion {get;set;}  
        String proyecto {get;set;}  
        String nombreTarea {get;set;}  
        String duracionReal {get;set;}
        String duracionRestante{get;set;}
        String abierto {get;set;} 
        String descripcionLogLunes {get;set;}
        String descripcionLogMartes {get;set;}
        String descripcionLogMiercoles {get;set;}
        String descripcionLogJueves {get;set;}
        String descripcionLogViernes {get;set;}
        String descripcionLogSabado {get;set;}
        String descripcionLogDomingo {get;set;}
        String nombreAgrupador {get;set;}
        
        Boolean excedido {get;set;}
        
        
        
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
        }
    }
    
    class TablaLogs {
        Decimal logDia {get;set;}
        Boolean esNocturno {get;set;}
        Boolean esFacturable {get;set;}
        Boolean esEditable {get;set;}
        ID idLog {get;set;}
        ID idItemLog {get;set;}        
        Date fechaLog {get;set;}
        String comentarioLog {get;set;}
        
        public TablaLogs(){
            logDia = 0;
            esNocturno = false;
            esFacturable = false;
            esEditable = false;
            comentarioLog = '';
        }
    }
   
    
    public static testMethod void consultaFiltrosSinRangoFechaLogs(){
     Date fechaTemp = system.today();
       HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;
        
        
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        
        insert ft;
        
        HBT_Frente_de_Trabajo__c ft1 = new HBT_Frente_de_Trabajo__c();
        ft1.Name = 'frente 2';
        ft1.Turno__c = t.id;
        
        insert ft1;
        
        HBT_Asociacion_Empleado_Frente__c a = new HBT_Asociacion_Empleado_Frente__c();
        a.Frente_de_Trabajo__c = ft.id;
        a.Empleado__c = e.id;
        insert a;
        
        
        Date weekstart = system.today();        
        weekstart = weekstart.toStartOfWeek();
        
        List<HBT_Registro_Turnos__c> logs = new List<HBT_Registro_Turnos__c>();
        
        HBT_Registro_Turnos__c primerlog=new HBT_Registro_Turnos__c();
        
        primerlog.Comentario__c='Prueba';
        primerlog.Duracion__c=8.5;
        primerlog.esFestivo__c=false;
        primerlog.Fecha_registro__c=fechaTemp;
        primerlog.Asociacion_Empleado__c = a.id;
        primerlog.esNocturno__c= true;
        logs.add(primerlog);
        
         HBT_Registro_Turnos__c loglunes=new HBT_Registro_Turnos__c();
        loglunes.Comentario__c='';//ok
        loglunes.Duracion__c=8.5;//ok
        loglunes.esFestivo__c=true;//ok
        loglunes.Fecha_registro__c= weekstart;//ok
        loglunes.Asociacion_Empleado__c= a.id;//ok
        loglunes.esNocturno__c= true;//ok
        loglunes.Hora_Extra_Diurna__c = 0;
        loglunes.Hora_Extra_Festiva_Diurnas__c = 0;
        loglunes.Hora_Extra_Festiva_Nocturna__c = 0;
        loglunes.Hora_Extra_Nocturna__c = 0;
        loglunes.Hora_Festiva_Dominical__c = 0;
        loglunes.Horas_Recargo_Nocturno__c =0;
        logs.add(loglunes);
                
        HBT_Registro_Turnos__c logmartes=new HBT_Registro_Turnos__c();
        logmartes.Comentario__c='';
        logmartes.Duracion__c=8.5;
        logmartes.esFestivo__c=true;
        logmartes.Fecha_registro__c= weekstart.addDays(1);
        logmartes.Asociacion_Empleado__c= a.id;
        logmartes.esNocturno__c= true;
         logmartes.Hora_Extra_Diurna__c = 0;
        logmartes.Hora_Extra_Festiva_Diurnas__c = 0;
        logmartes.Hora_Extra_Festiva_Nocturna__c = 0;
        logmartes.Hora_Extra_Nocturna__c = 0;
        logmartes.Hora_Festiva_Dominical__c = 0;
        logmartes.Horas_Recargo_Nocturno__c =0;
        logs.add(logmartes);
        
        HBT_Registro_Turnos__c logmiercoles=new HBT_Registro_Turnos__c();
        logmiercoles.Comentario__c='Prueba';
        logmiercoles.Duracion__c=8.5;
        logmiercoles.esFestivo__c=true;
        logmiercoles.Fecha_registro__c= weekstart.addDays(2);
        logmiercoles.Asociacion_Empleado__c= a.id;
        logmiercoles.esNocturno__c= true;
        logmiercoles.Hora_Extra_Diurna__c = 0;
        logmiercoles.Hora_Extra_Festiva_Diurnas__c = 0;
        logmiercoles.Hora_Extra_Festiva_Nocturna__c = 0;
        logmiercoles.Hora_Extra_Nocturna__c = 0;
        logmiercoles.Hora_Festiva_Dominical__c = 0;
        logmiercoles.Horas_Recargo_Nocturno__c =0;
		logs.add(logmiercoles);
        
        HBT_Registro_Turnos__c logjueves=new HBT_Registro_Turnos__c();
        logjueves.Comentario__c='Prueba';
        logjueves.Duracion__c=8.5;
        logjueves.esFestivo__c=true;
        logjueves.Fecha_registro__c= weekstart.addDays(3);
        logjueves.Asociacion_Empleado__c= a.id;
        logjueves.esNocturno__c= true;
        logjueves.Hora_Extra_Diurna__c = 0;
        logjueves.Hora_Extra_Festiva_Diurnas__c = 0;
        logjueves.Hora_Extra_Festiva_Nocturna__c = 0;
        logjueves.Hora_Extra_Nocturna__c = 0;
        logjueves.Hora_Festiva_Dominical__c = 0;
        logjueves.Horas_Recargo_Nocturno__c =0;
        logs.add(logjueves);
        
        HBT_Registro_Turnos__c logviernes=new HBT_Registro_Turnos__c();
        logviernes.Comentario__c='Prueba';
        logviernes.Duracion__c=8.5;
        logviernes.esFestivo__c=true;
        logviernes.Fecha_registro__c= weekstart.addDays(4);
        logviernes.Asociacion_Empleado__c= a.id;
        logviernes.esNocturno__c= true;
        logviernes.Hora_Extra_Diurna__c = 0;
        logviernes.Hora_Extra_Festiva_Diurnas__c = 0;
        logviernes.Hora_Extra_Festiva_Nocturna__c = 0;
        logviernes.Hora_Extra_Nocturna__c = 0;
        logviernes.Hora_Festiva_Dominical__c = 0;
        logviernes.Horas_Recargo_Nocturno__c =0;
        logs.add(logviernes);        
        
        HBT_Registro_Turnos__c logsabado=new HBT_Registro_Turnos__c();
        logsabado.Comentario__c='Prueba';
        logsabado.Duracion__c=8.5;
        logsabado.esFestivo__c=true;
        logsabado.Fecha_registro__c= weekstart.addDays(5);
        logsabado.Asociacion_Empleado__c= a.id;
        logsabado.esNocturno__c= true;
        logsabado.Hora_Extra_Diurna__c = 0;
        logsabado.Hora_Extra_Festiva_Diurnas__c = 0;
        logsabado.Hora_Extra_Festiva_Nocturna__c = 0;
        logsabado.Hora_Extra_Nocturna__c = 0;
        logsabado.Hora_Festiva_Dominical__c = 0;
        logsabado.Horas_Recargo_Nocturno__c =0;
        logs.add(logsabado);
        
        
        HBT_Registro_Turnos__c logdomingo=new HBT_Registro_Turnos__c();
        logdomingo.Comentario__c='Prueba';
        logdomingo.Duracion__c=8.5;
        logdomingo.esFestivo__c=true;
        logdomingo.Fecha_registro__c= weekstart.addDays(-1);
        logdomingo.Asociacion_Empleado__c= a.id;
        logdomingo.esNocturno__c= true;
        logdomingo.Hora_Extra_Diurna__c = 0;
        logdomingo.Hora_Extra_Festiva_Diurnas__c = 0;
        logdomingo.Hora_Extra_Festiva_Nocturna__c = 0;
        logdomingo.Hora_Extra_Nocturna__c = 0;
        logdomingo.Hora_Festiva_Dominical__c = 0;
        logdomingo.Horas_Recargo_Nocturno__c =0;
        logs.add(logdomingo);
        
        insert logs;
        
        //Se crea el controlador       
        HBT_RegistroTurnosController registro= new HBT_RegistroTurnosController();
        ApexPages.currentPage().getParameters().put('selectedId',ft.Id); 
        registro.lun = 'Lun 11';
        registro.mar = 'Mar 12';
        registro.mie = 'Mie 13';
        registro.jue = 'Jue 14';
        registro.vie = 'Vie 15';
        registro.sab = 'Sab 16';
        registro.dom = 'Dom 10';
        
        registro.seleccionindicadorTurnoBasico = false;
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Jue '+ weekstart.addDays(3).day();  
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.tipoHoraSelected = '001063';
        registro.agregarDescripcion();
         registro.ItemConsultado= a.id;
          registro.adicionarLog();
        
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Vie '+weekstart.addDays(4).day();   
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.tipoHoraSelected = '001064';
        registro.agregarDescripcion();
         registro.ItemConsultado= a.id;
          registro.adicionarLog();
        
        registro.ItemConsultado=ApexPages.currentPage().getParameters().put('IdItemTrabajo',a.id);
        registro.diaSeleccionadoDescripcion='Sab '+weekstart.addDays(5).day();    
        registro.logAdicional=10;
        registro.descripcionLog='RN';
        registro.indicadorNocturno=false;
        registro.indicadorFacturable=false;       
        registro.indicadorHoraAdicional=false;  
        registro.nuevoLog = new HBT_Registro_Turnos__c();
        registro.nuevoLog.Asociacion_Empleado__c = registro.ItemConsultado;
        registro.nuevoLog.Horas_Recargo_Nocturno__c = registro.logAdicional;
        registro.nuevoLog.Comentario__c = 'RN';
        registro.indicadorNocturno = false;
        registro.indicadorTurnoBasico = false;
        registro.indicadorFacturable = false;
        registro.tipoHoraSelected = '100000';
        registro.agregarDescripcion();
         registro.ItemConsultado= a.id;
          registro.adicionarLog();
        
        registro.acl = 'true';
        registro.cambiarproyecto();
        String Item = ApexPages.currentPage().getParameters().put('IdItem',a.Id);
 
        registro.restantelunes = 0;
        registro.restantemartes = 0;
        registro.restantemiercoles = 0;
        registro.restantejueves = 0;
        registro.restanteviernes = 0;
        registro.totalDia = 540;
        registro.totaldomingo = 0;
        registro.totallunes = 0;
        registro.totalmartes = 0;
        registro.totalmiercoles = 0;
        registro.totaljueves = 0;
        registro.totalviernes = 0;
        registro.totalsabado = 0;
        registro.adicionallunes=false;
        registro.adicionalmartes=false;
        registro.adicionalmiercoles=false;
        registro.adicionaljueves=false;
        registro.adicionalviernes=false;
    
        registro.getDisableNext();
        registro.getDisablePrevious();
        registro.getPageNumber();
        registro.getTotal_size();
        registro.total_size=0;
        registro.getTotalPages();       
               
      
        registro.inicializarId();
        registro.restantelunes = 0;
        registro.restantemartes = 0;
        registro.restantemiercoles = 0;
        registro.restantejueves = 0;
        registro.restanteviernes = 0;
        registro.totalDia = 540;
        registro.totaldomingo = 0;
        registro.totallunes = 600;
        registro.totalmartes = 0;
        registro.totalmiercoles = 0;
        registro.totaljueves = 0;
        registro.totalviernes = 0;
        registro.totalsabado = 0;
        registro.adicionallunes=false;
        registro.adicionalmartes=true;
        registro.adicionalmiercoles=false;
        registro.adicionaljueves=false;
        registro.adicionalviernes=false;
        registro.Beginning();
        
      
    }
           
            
   
}