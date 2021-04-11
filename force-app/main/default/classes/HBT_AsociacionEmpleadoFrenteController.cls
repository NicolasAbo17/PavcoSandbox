public class HBT_AsociacionEmpleadoFrenteController {
    //mensajes modal
    public List<HBT_MensajesPagina> mensajesError {get;set;}
    //objeto empresa
    public HBT_Frente_de_Trabajo__c frente {get;set;}
    //lista de usuarios disponibles
    public List<SelectOption> listaEmpleadosDisponibles {get;set;}
    //lista usuarios agregados
    public List<SelectOption> listaEmpleadosAgregados {get;set;}
    
     public HBT_AsociacionEmpleadoFrenteController(ApexPages.StandardController stdController){
         mensajesError = new List<HBT_MensajesPagina>();
         frente = (HBT_Frente_de_Trabajo__c)stdController.getRecord();
         cargarInformacion();
     }
    
    public void cargarInformacion(){
        mensajesError = new List<HBT_MensajesPagina>();
        
        listaEmpleadosAgregados   = new List<SelectOption>(); 
    
        listaEmpleadosDisponibles   = new List<SelectOption>(); 
        
        for(HBT_Empleado__c e : [SELECT Id, Name FROM HBT_Empleado__c 
                                 where Activo__c  = true 
                                 and id not in (select Empleado__c  from HBT_Asociacion_Empleado_Frente__c) 
                                 Order By Name]){
            SelectOption eT = new SelectOption(e.id,e.name);
            listaEmpleadosDisponibles.add(eT);
        }
        
        for(HBT_Asociacion_Empleado_Frente__c e : [select Empleado__r.id, Empleado__r.Name, Empleado__r.Apellidos__c 
                                                   from HBT_Asociacion_Empleado_Frente__c 
                                                   where Frente_de_Trabajo__r.id = :frente.id
                                                   ORDER BY Empleado__r.Name
                                                  ])
        {
            if(e != null && e.Empleado__r.id !=null && e.Empleado__r.name != null){                                      
                SelectOption eT = new SelectOption(e.Empleado__r.id,e.Empleado__r.name);
                listaEmpleadosAgregados.add(eT);
            }
        }
    }
    
    
    public void guardar(){
         mensajesError = new List<HBT_MensajesPagina>();
        List<string> empIds = new List<string>();
        //se actualizan los empleados asociados
        List<HBT_Asociacion_Empleado_Frente__c> listaAsociacion = [select id from HBT_Asociacion_Empleado_Frente__c where Frente_de_Trabajo__r.id = :frente.id];
        if(listaAsociacion.size() > 0){
            delete listaAsociacion;
        }
        
        listaAsociacion = new List<HBT_Asociacion_Empleado_Frente__c>();
        
        for(SelectOption so : listaEmpleadosAgregados)
        {
            empIds.add(so.getValue());
           /* system.debug(so.getValue());
            */
        }
        if(empIds.size()>0){
            List<HBT_Empleado__c> empL = [select id from HBT_Empleado__c where id in :empIds];
            for(HBT_Empleado__c e : empL){
                HBT_Asociacion_Empleado_Frente__c ae = new HBT_Asociacion_Empleado_Frente__c();
                ae.Empleado__c = e.id;
                ae.Frente_de_Trabajo__c = frente.id; 
                listaAsociacion.add(ae);
            }
        }
        
        if(listaAsociacion.size() > 0){
            insert listaAsociacion;
        }
        
        cargarInformacion();
        mensajesError.add(new HBT_MensajesPagina(HBT_MensajesPagina.CONFIRMACION,'Se guardo exitosamente la información.'));
    }
}