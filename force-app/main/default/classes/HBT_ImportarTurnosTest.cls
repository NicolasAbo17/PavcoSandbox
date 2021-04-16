@isTest
public class HBT_ImportarTurnosTest {
    
    /**
    * Método para probar que los registros se actualizan adecuadamente con nuevos registros de turnos
     */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-20);
        insert r;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 1, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 2, 25);
        
        //* Prueba de actualización  correcta archivo tipo 1
        String[] csvFileLines;
        Blob csvFileBody;

        String[] strRegistroIng = new String[9];
        strRegistroIng[0] = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
        + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 4:10:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 22:01:24;Salida';
        strRegistroIng[1] = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;28-01-2019 18:01:39;Salida';
        strRegistroIng[2] = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;26-01-2019 18:10:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;27-01-2019 06:01:24;Salida';
        strRegistroIng[3] = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;05-02-2019 17:00:00;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;06-02-2019 6:00:00;Salida';
        strRegistroIng[4] = 'Identificación;Nombre;Horario;marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;06-01-2019 17:46:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;07-01-2019 05:39:24;Salida';
        strRegistroIng[5] = 'Identificación;Nombre;Horario;marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;03-02-2019 7:46:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;03-02-2019 17:39:24;Salida';
        strRegistroIng[6] = 'Núm. Identificación,Nombre,Hora Marca,Tipo Marca\n'
            + ', ARAUJO FERNANDEZ WILVER ANTILIO,2019-02-2 4:10:39,Entrada\n123456, ARAUJO FERNANDEZ WILVER ANTILIO,1-02-2019 22:01:24,Salida';
        strRegistroIng[7] = 'Núm. Identificación,Nombre,Hora Marca,Tipo Marca\n'
            + '1234567890; ARAUJO FERNANDEZ WILVER ANTILIO;04-02-2019 05:59:39;\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;04-02-2019 16:00:24;Salida';
        strRegistroIng[8] = 'Núm. Identificación,Nombre,Hora Marca,Tipo Marca\n';

        String csvAsString;
        for (Integer i=0; i<5; i++) {
            csvFileBody = Blob.valueOf(strRegistroIng[i]);
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            importData.frenteSelected = ft.id;
            importData.csvFileBody = csvFileBody;
            importData.cargarArchivo();
            importData.guardarRegistros();
        }

        importData.getArchivosCargados();
        importData.eliminarCargue();
        importData.generarArchivo();
        
        csvFileBody = Blob.valueOf(strRegistroIng[5]);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        importData.getArchivosCargados();
        
        csvFileBody = Blob.valueOf(strRegistroIng[6]);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        
        HBT_ImportarRegistroTurnosController importData2 = new HBT_ImportarRegistroTurnosController();
        
        csvFileBody = Blob.valueOf(strRegistroIng[7]);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData2.frenteSelected = ft.id;
        importData2.csvFileBody = csvFileBody;
        importData2.cargarArchivo();
        
        HBT_ImportarRegistroTurnosController importData3 = new HBT_ImportarRegistroTurnosController();
        
        csvFileBody = Blob.valueOf(strRegistroIng[8]);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData3.frenteSelected = ft.id;
        importData3.csvFileBody = csvFileBody;
        importData3.cargarArchivo();
    }
    
    /**
    * 
    */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test1(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Historico_Cargue_Archivos__c h = new HBT_Historico_Cargue_Archivos__c();
        h.nombre_archivo__c = 'archivo';
        insert h;
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-20);
        insert r;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 1, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 2, 25);
        
        //Prueba de actualización  correcta
        String[] csvFileLines;
        Blob csvFileBody;
        String strRegistroIng = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 4:20:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 21:32:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        
        //Prueba de actualización existente
        String strRegistroIng2 =  'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;2-02-2019 8:20:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;2-02-2019 18:48:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng2);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        
        importData.archivoSelected = h.id;
        importData.eliminarCargue();
        
        //Prueba de actualización existente
        String strRegistroIng3 =  'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;3-02-2019 17:50:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;4-02-2019 05:48:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng3);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test2(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Historico_Cargue_Archivos__c h = new HBT_Historico_Cargue_Archivos__c();
        h.nombre_archivo__c = 'archivo';
        insert h;
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-20);
        insert r;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 1, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 2, 25);
        //Prueba de actualización  correcta
        String[] csvFileLines;
        Blob csvFileBody;
        String strRegistroIng2 =  'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;2-02-2019 8:20:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;2-02-2019 18:48:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng2);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        
        importData.archivoSelected = h.id;
        importData.eliminarCargue();
        
        //Prueba de actualización existente
        String strRegistroIng3 =  'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;3-02-2019 17:50:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;4-02-2019 05:48:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng3);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test3(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Historico_Cargue_Archivos__c h = new HBT_Historico_Cargue_Archivos__c();
        h.nombre_archivo__c = 'archivo';
        insert h;
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-20);
        insert r;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.today().addDays(-30);
        importData.fechaFinFiltro = Date.today();
        //Prueba de actualización  correcta
        String[] csvFileLines;
        Blob csvFileBody;
        
        
        //Prueba de actualización existente
        String strRegistroIng3 =  'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;3-02-2019 17:50:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;4-02-2019 05:48:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng3);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test4(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-5);
        insert r;
        
        importData.getFrentes();  
        importData.fechaInicioFiltro = Date.today().addDays(-10);
        importData.fechaFinFiltro = Date.today();
        //Prueba de actualización  correcta
        String[] csvFileLines;
        Blob csvFileBody;
        String strRegistroIng = 'Identificación;Nombre;Horario;marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;06-02-2019 07:00:00;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;06-02-2019 17:00:00;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        
        String strRegistroIng2 = 'Identificación;Nombre;Horario;marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;04-02-2019 17:00:00;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;05-02-2019 7:00:00;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng2);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        importdata.generarArchivo();
        
        
    }
    
    
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test5(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today();
        
        insert r;
        
        
        importData.getFrentes();  
        importData.fechaInicioFiltro = Date.today().addDays(-40);
        importData.fechaFinFiltro = Date.today();
        //Prueba de actualización  correcta
        String[] csvFileLines;
        Blob csvFileBody;
        String strRegistroIng = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 6:20:39;Entrada';  
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        
        //Prueba de actualización existente
        String strRegistroIng2 = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;06-01-2019 18:20:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;07-01-2019 6:20:39;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng2);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
        
        
    }
    
    
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test6(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        importData.getFrentes();  
        importData.cargarArchivo();
        
        importData.fechaInicioFiltro = Date.today();
        importData.fechaFinFiltro = Date.today().addDays(-10);
        importData.cargarArchivo();
        
        importData.fechaInicioFiltro = Date.today();
        importData.fechaFinFiltro = Date.today();
        String[] csvFileLines;
        Blob csvFileBody;
        String strRegistroIng = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 4:20:39;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 21:32:24;Salida';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        // importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        
        String strRegistroIng1 = 'Identificación,Nombre,Horario\n'
            + '123456, ARAUJO FERNANDEZ WILVER ANTILIO,06-02-2019 07:00:00,Entrada\n123456, ARAUJO FERNANDEZ WILVER ANTILIO,06-02-2019 17:00:00,Salida';
        csvFileBody = Blob.valueOf(strRegistroIng1);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        
        String strRegistroIng2 = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '12345611; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 6:20:39;Entrada\n212123456; ARAUJO FERNANDEZ WILVER ANTILIO;;Saliiida';  csvFileBody = Blob.valueOf(strRegistroIng);
        csvFileBody = Blob.valueOf(strRegistroIng2);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
    }
    /**
    * Método para probar si 
     */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test7(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;
                
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        HBT_Asociacion_Empleado_Frente__c a = new HBT_Asociacion_Empleado_Frente__c();
        a.Frente_de_Trabajo__c = ft.id;
        a.Empleado__c = e.id;
        insert a;
        
        importData.getFrentes();  
        importData.cargarArchivo();
        
        importData.fechaInicioFiltro = Date.today();
        importData.fechaFinFiltro = Date.today().addDays(-10);
        importData.cargarArchivo();
        
        importData.fechaInicioFiltro = Date.today();
        importData.fechaFinFiltro = Date.today();
        String[] csvFileLines;
        Blob csvFileBody;
        
        String strRegistroIng = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '; ARAUJO FERNANDEZ WILVER ANTILIO;;;\n; ARAUJO FERNANDEZ WILVER ANTILIO;;';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        
        String strRegistroIng1 = 'Identificación,Nombre,Horario\n'
            + '12345611, ARAUJO FERNANDEZ WILVER ANTILIO,34343407:00:00,Entrada1\n12345611, ARAUJO FERNANDEZ WILVER ANTILIO,34343434 17:00:00,Salida1';
        csvFileBody = Blob.valueOf(strRegistroIng1);
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
    }
    
    /** 
    * Método para probar escenario cuando no se envia la marca de salida.
    */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test8(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;
                
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        HBT_Asociacion_Empleado_Frente__c a = new HBT_Asociacion_Empleado_Frente__c();
        a.Frente_de_Trabajo__c = ft.id;
        a.Empleado__c = e.id;
        insert a;
        
        importData.fechaInicioFiltro = Date.today().addDays(-10);
        importData.fechaFinFiltro = Date.today();
        String[] csvFileLines;
        Blob csvFileBody;
        String csvAsString;
        
        String strRegistroIng2 = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456, ARAUJO FERNANDEZ WILVER ANTILIO,06-08-2019 06:00:00,Entrada';
        csvFileBody = Blob.valueOf(strRegistroIng2);
        csvAsString = csvFileBody.toString();
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /** 
    * Método para probar escenarios cuando es un día festivo.
    */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test9(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;
                
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        HBT_Asociacion_Empleado_Frente__c a = new HBT_Asociacion_Empleado_Frente__c();
        a.Frente_de_Trabajo__c = ft.id;
        a.Empleado__c = e.id;
        insert a;
        
        importData.fechaInicioFiltro = Date.today().addDays(-10);
        importData.fechaFinFiltro = Date.today();
        String[] csvFileLines;
        Blob csvFileBody;
        String csvAsString;
        
        String strRegistroIng2 = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456, ARAUJO FERNANDEZ WILVER ANTILIO,07-08-2019 06:00:00,Entrada\n123456, ARAUJO FERNANDEZ WILVER ANTILIO,07-08-2019 16:00:00,Salida';
        csvFileBody = Blob.valueOf(strRegistroIng2);
        csvAsString = csvFileBody.toString();
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }


    /**
    * Método para probar que se cargue adecuadamente la información para el tipo de archivo 2
     */
    static testMethod void Fro_Importar_CSVArchivos_Cargue_Test10(){
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        String[] csvFileLines;
        Blob csvFileBody;

        //Se crea un turno ejemplo
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;

        //Se crea un frente de trabajo ejemplo
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 7, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 8, 25);
        
        // Verifica que se guarden correctamente datos iniciales
        String strRegistroIng = 'Identificacion;Nombre;Fecha Entrada;Entrada;Fecha Salida;Salida\n'
            + '1105680648;CALDERON REPISO OSCAR ANDRES;16/8/2019;07:00:00;16/8/2019;18:00:00\n1105680648;CALDERON REPISO OSCAR ANDRES;20/8/2019;07:00:00;20/8/2019;18:00:00';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que se cargue adecuadamente la información para el tipo de archivo 2
     */
    static testMethod void Fro_Importar_CSVArchivos_Cargue_Test11(){
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        String[] csvFileLines;
        Blob csvFileBody;

        //Se crea un turno ejemplo
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;

        //Se crea un frente de trabajo ejemplo
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 7, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 8, 25);
        
        // Verifica que se genere error cuando el número de identificación es vacío
        String strRegistroIng = 'Identificacion;Nombre;Fecha Entrada;Entrada;Fecha Salida;Salida\n'
            + ';CALDERON REPISO OSCAR ANDRES;16/8/2019;07:00:00;16/8/2019;18:00:00\n1105680648;CALDERON REPISO OSCAR ANDRES;20/8/2019;07:00:00;20/8/2019;18:00:00';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que se cargue adecuadamente la información para el tipo de archivo 2
     */
    static testMethod void Fro_Importar_CSVArchivos_Cargue_Test12(){
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        String[] csvFileLines;
        Blob csvFileBody;

        //Se crea un turno ejemplo
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;

        //Se crea un frente de trabajo ejemplo
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 7, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 8, 25);
           
        //Verifica que los campos Fecha Entrada y Entrada vacíos deben lanzar error
        String strRegistroIng = 'Identificacion;Nombre;Fecha Entrada;Entrada;Fecha Salida;Salida\n'
            + '1105680648;CALDERON REPISO OSCAR ANDRES;;07:00:00;17/8/2019;18:00:00\n1105680648;CALDERON REPISO OSCAR ANDRES;20/8/2019;;20/8/2019;18:00:00';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que se cargue adecuadamente la información para el tipo de archivo 2
     */
    static testMethod void Fro_Importar_CSVArchivos_Cargue_Test13(){
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        String[] csvFileLines;
        Blob csvFileBody;

        //Se crea un turno ejemplo
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;

        //Se crea un frente de trabajo ejemplo
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 7, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 8, 25);

        //Verifica que los campos Fecha Salida y Salida vacíos deben lanzar error
        String strRegistroIng = 'Identificacion;Nombre;Fecha Entrada;Entrada;Fecha Salida;Salida\n'
            + '1105680648;CALDERON REPISO OSCAR ANDRES;18/8/2019;07:00:00;;18:00:00\n1105680648;CALDERON REPISO OSCAR ANDRES;21/8/2019;07:00:00;21/8/2019;';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que se cargue adecuadamente la información para el tipo de archivo 2
     */
    static testMethod void Fro_Importar_CSVArchivos_Cargue_Test14(){
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        String[] csvFileLines;
        Blob csvFileBody;

        //Se crea un turno ejemplo
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;

        //Se crea un frente de trabajo ejemplo
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 7, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 8, 25);

        //Verifica que los campos de fecha tengan el formato correcto
        String strRegistroIng = 'Identificacion;Nombre;Fecha Entrada;Entrada;Fecha Salida;Salida\n'
            + '1105680648;CALDERON REPISO OSCAR ANDRES;16/8/2019;7:00am;16/8/2019;18:00:00\n1105680648;CALDERON REPISO OSCAR ANDRES;8/20/2019;07:00:00;20/8/2019;18:00:00';
            strRegistroIng = strRegistroIng + '1105680648;CALDERON REPISO OSCAR ANDRES;16/8/2019;07:00:00pm;2020/8/16;18:00:00\n1105680648;CALDERON REPISO OSCAR ANDRES;8/20/2019;07:00:00;20/8/2019;1:00';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que se cargue adecuadamente la información para el tipo de archivo 2
     */
    static testMethod void Fro_Importar_CSVArchivos_Cargue_Test15(){
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        String[] csvFileLines;
        Blob csvFileBody;

        //Se crea un turno ejemplo
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
        t.Cantidad_Horas_Turno_Sabado__c = 5.5;
        insert t;

        //Se crea un frente de trabajo ejemplo
        HBT_Frente_de_Trabajo__c ft = new HBT_Frente_de_Trabajo__c();
        ft.Name = 'frente 1';
        ft.Turno__c = t.id;
        insert ft;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 7, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 8, 25);

        //Verifica que los campos de fecha tengan el formato correcto
        String strRegistroIng = 'Identificacion;Nombre;Fecha Entrada;Entrada;Fecha Salida;Salida\n'
            + '1105680648;CALDERON REPISO OSCAR ANDRES;16/8/2019;07:00:00;2018/06/18;8:51am\n1105680648;CALDERON REPISO OSCAR ANDRES;8/20/2019;07:00:00;20/8/2019;1:00';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que los registros se actualizan adecuadamente con nuevos registros de turnos
     */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test16(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-20);
        insert r;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 1, 25);
        importData.fechaFinFiltro = Date.newInstance(2019, 2, 25);
        
        //* Prueba de actualización  correcta archivo tipo 1
        String[] csvFileLines;
        Blob csvFileBody;
        String strRegistroIng = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;1-02-2019 4:10:39;Entrada\n123456;';
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
    
    /**
    * Método para probar que los registros se actualizan adecuadamente con nuevos registros de turnos
     */
    static testmethod void Fro_Importar_CSVArchivos_Cargue_Test17(){
        //Se instancia un objeto de tipo Controlador        
        HBT_ImportarRegistroTurnosController importData = new HBT_ImportarRegistroTurnosController();
        
        HBT_Empleado__c e = new HBT_Empleado__c();
        e.Name = 'pepito perez';
        e.Tipo__c = 'Temporal';
        e.Tipo_de_Documento__c = 'CC';
        e.Numero_de_Documento__c = '123456';
        e.Activo__c = true;
        insert e;
        
        HBT_Turno__c t = new HBT_Turno__c();
        t.Name ='turno 1';
        t.Cantidad_Horas_Turno_Lunes__c = 8.5;
        t.Cantidad_Horas_Turno_Martes__c = 8.5;
        t.Cantidad_Horas_Turno_Miercoles__c = 8.5;
        t.Cantidad_Horas_Turno_Jueves__c = 8.5;
        t.Cantidad_Horas_Turno_Viernes__c = 8.5;
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
        
        HBT_Registro_Turnos__c r = new HBT_Registro_Turnos__c();
        r.Asociacion_Empleado__c = a.id;
        r.Fecha_Registro__c = Date.today().addDays(-20);
        insert r;
        
        importData.getFrentes();    
        importData.fechaInicioFiltro = Date.newInstance(2019, 9, 1);
        importData.fechaFinFiltro = Date.newInstance(2019, 9, 15);
        
        //* Prueba de actualización  correcta archivo tipo 1
        String[] csvFileLines;
        Blob csvFileBody;
        
        String strRegistroIng = 'Núm. Identificación;Nombre;Hora Marca;Tipo Marca\n'
            + '123456; ARAUJO FERNANDEZ WILVER ANTILIO;07-09-2019 06:42:08;Entrada\n123456; ARAUJO FERNANDEZ WILVER ANTILIO;07-09-2019 17:02:06;Salida';
        
        csvFileBody = Blob.valueOf(strRegistroIng);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        importData.frenteSelected = ft.id;
        importData.csvFileBody = csvFileBody;
        importData.cargarArchivo();
        importData.guardarRegistros();
    }
}