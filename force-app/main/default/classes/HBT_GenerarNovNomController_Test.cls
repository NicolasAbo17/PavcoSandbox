@isTest
public class HBT_GenerarNovNomController_Test {
    
    @isTest 
    static void test_GenerarNovedades() {
        
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
        
        HBT_Registro_Turnos__c primerlog = new HBT_Registro_Turnos__c();
        
        primerlog.Comentario__c='Prueba';
        primerlog.Duracion__c=8.5;
        primerlog.esFestivo__c=false;
        primerlog.Fecha_registro__c=fechaTemp;
        primerlog.Asociacion_Empleado__c = a.id;
        primerlog.esNocturno__c= true;
        logs.add(primerlog);
        
        HBT_Registro_Turnos__c loglunes = new HBT_Registro_Turnos__c();
        loglunes.Comentario__c = '';//ok
        loglunes.Duracion__c = 8.5;//ok
        loglunes.esFestivo__c = true;//ok
        loglunes.Fecha_registro__c = weekstart;//ok
        loglunes.Asociacion_Empleado__c = a.id;//ok
        loglunes.esNocturno__c = true;//ok
        loglunes.Hora_Extra_Diurna__c = 1;
        loglunes.Hora_Extra_Festiva_Diurnas__c = 1;
        loglunes.Hora_Extra_Festiva_Nocturna__c = 1;
        loglunes.Hora_Extra_Nocturna__c = 1;
        loglunes.Hora_Festiva_Dominical__c = 1;
        loglunes.Horas_Recargo_Nocturno__c = 1;
        logs.add(loglunes);
        
        insert logs;
        
        HBT_GenerarNovedadesNominaController controlador = new HBT_GenerarNovedadesNominaController();
        
        controlador.getFrentes();
        controlador.getAnios();
        controlador.getItems();
        
        controlador.frenteSelected = ft.id;
        controlador.tipoSeleccionado = 'Temporal';
        controlador.periodoSeleccionado = 1;
        controlador.generarArchivo();
        //system.assert(controlador.resultado.size() > 0);
        
        controlador.selectedmes = System.Today().month();
        controlador.anioSelected = System.Today().year();
        controlador.tipoSeleccionado = 'Temporal';
        controlador.periodoSeleccionado = 1;
        controlador.generarArchivo();
    //    system.assert(controlador.resultado.size() == 0);
        
        controlador.selectedmes = System.Today().month();
        controlador.anioSelected = System.Today().year();
        
        controlador.tipoSeleccionado = 'Temporal';
        controlador.periodoSeleccionado = 2;
        controlador.generarArchivo();
    //    system.assert(controlador.resultado.size() > 0);
    }
}