trigger HBT_CalcularDuracionTurno on HBT_Turno__c (before insert, before update) {
    
/*    
    For (HBT_Turno__c turnonuevo : trigger.new){
        //lunes a viernes
        Date dt = date.today();
        
        if( (turnonuevo.hora_F_turno__c.contains('AM')) && (turnonuevo.hora_I_turno__c.contains('PM'))){
            dt = date.today().addDays(1);
        }
        
        Integer year = dt.year();
        Integer month = dt.month();
        Integer day = dt.day();
        String toParse=day + '/' + month + '/' + year + ' ' + turnonuevo.hora_F_turno__c;
        DateTime dtF=DateTime.parse(toParse);
        Datetime nowF = dtF;
        Integer offsetF = UserInfo.getTimezone().getOffset(nowF);
        Datetime dtFinal = nowF.addSeconds(offsetF/1000);
        
        dt = date.today();
        year = dt.year();
        month = dt.month();
        day = dt.day();
        toParse=day + '/' + month + '/' + year + ' ' + turnonuevo.hora_i_turno__c;
        DateTime dtI=DateTime.parse(toParse);
        Datetime nowI = dtI;
        Integer offsetI = UserInfo.getTimezone().getOffset(nowI);
        Datetime dInicial = nowI.addSeconds(offsetI/1000);
        
        Decimal millisecondsBetween =  dtFinal.getTime() - dInicial.getTime(); //NB: ths is important as to convert type
        Decimal timeBetween = millisecondsBetween / 3600000;  //1000 * 60 * 60 * 24
        turnonuevo.Cantidad_Horas_Turno__c = timeBetween;
        
        //sabado
        system.debug('f: '+turnonuevo.hora_F_turno_sabado__c);
        system.debug('i: '+turnonuevo.Hora_I_Turno_Sabado__c);
        dt = date.today();
        if(turnonuevo.hora_F_turno_sabado__c.contains('AM') && turnonuevo.Hora_I_Turno_Sabado__c.contains('PM')){
            dt = date.today().addDays(1);
        }
        year = dt.year();
        month = dt.month();
        day = dt.day();
        toParse=day + '/' + month + '/' + year + ' ' + turnonuevo.hora_F_turno_sabado__c;
        dtF=DateTime.parse(toParse);
        nowF = dtF;
        offsetF = UserInfo.getTimezone().getOffset(nowF);
        dtFinal = nowF.addSeconds(offsetF/1000);
        dt = date.today();
        year = dt.year();
        month = dt.month();
        day = dt.day();
        toParse=day + '/' + month + '/' + year + ' ' + turnonuevo.Hora_I_Turno_Sabado__c;
        dtI=DateTime.parse(toParse);
        nowI = dtI;
        offsetI = UserInfo.getTimezone().getOffset(nowI);
        dInicial = nowI.addSeconds(offsetI/1000);
        system.debug('f: '+dtFinal);
        system.debug('i: '+dInicial);
        millisecondsBetween =  dtFinal.getTime() - dInicial.getTime(); //NB: ths is important as to convert type
        timeBetween = millisecondsBetween / 3600000;  //1000 * 60 * 60 * 24
        turnonuevo.Cantidad_Horas_Turno_Sabado__c = timeBetween;
      
        
    }
    
 
*/
}