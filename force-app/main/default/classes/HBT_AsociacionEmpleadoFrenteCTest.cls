@isTest
public class HBT_AsociacionEmpleadoFrenteCTest {
    
    static testmethod void controlladorTest(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Empleado__c e2 = new HBT_Empleado__c();
        e2.Name = 'pablo perez';
        e2.Tipo__c = 'Temporal';
        e2.Tipo_de_Documento__c = 'CC';
        e2.Numero_de_Documento__c = '123456789';
        e2.Activo__c = true;
        insert e2;
        
        
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
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ft);
        HBT_AsociacionEmpleadoFrenteController controller = new HBT_AsociacionEmpleadoFrenteController(sc);
        
        controller.guardar();
        
        
        HBT_MultiselectController controller2 = new HBT_MultiselectController();
        controller2.leftOptionsHidden ='test';
        controller2.leftOptions = controller.listaEmpleadosDisponibles;
        controller2.rightOptions = controller.listaEmpleadosAgregados;
        controller2.rightOptionsHidden = 'test';
        
    }

}