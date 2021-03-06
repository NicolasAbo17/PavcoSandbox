public class HBT_Festivos {

    public static Map<String, Boolean> DiasFestivos(Integer anio){
        
        Integer lunes = 1;
        Integer jueves = 4;
        Integer viernes = 5;
        Integer domingo = 7;
        Datetime pascua = calcularPascua(anio);
        Map<String, Boolean> diasFestivos = new Map<String, Boolean>();
        
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 1, 1)); //Primero de Enero 
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 1, 6, 1, 0, 0),false, true)); //Reyes magos
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 3, 19, 1, 0, 0),false, true)); //San Jose
        IncluirFecha(diasFestivos, SiguienteDiaSemana(domingo, pascua, true, false)); //Domingo de Ramos
        IncluirFecha(diasFestivos, SiguienteDiaSemana(jueves, pascua, true,true)); //Jueves Santo
        IncluirFecha(diasFestivos, SiguienteDiaSemana(viernes, pascua, true,true)); //Viernes Santo
        //IncluirFecha(diasFestivos, pascua); //Pascua
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 5, 1)); //Dia del trabajo
        
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, pascua,false, true).AddDays(42)); //Ascensión de Jesús
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, pascua,false, true).AddDays(63)); //Corpus Christi
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, pascua,false, true).AddDays(70)); //Sagrado Corazón
        
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 6, 29, 1, 0, 0),false, true)); //san Pedro y san Pablo
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 7, 20)); //Grito de Independencia
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 8, 7)); // Batalla de Boyacá
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 8, 15, 1, 0, 0),false, true)); //Asuncion de la virgen
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 10, 12, 1, 0, 0),false, true)); //Día de la Raza
        //IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 10, 12),false, true)); //Todos los Santos
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 11, 1, 1, 0, 0),false, true)); //Independencia de Cartagena
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 11, 11, 1, 0, 0),false, true)); //Independencia de Cartagena
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 12, 8, 1, 0, 0)); // Inmaculada Concepción
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 12, 25, 1, 0, 0)); // Navidad
        
        return diasFestivos;
    }
    	
    private static void IncluirFecha(Map<String, Boolean> diasFestivos, Datetime fecha)
    {
        //string[] datos = fecha.date().format().split('/');
        String temp = String.valueOf(fecha.date());
        
  //      system.debug('festivo: '+temp);
        diasFestivos.put(temp, true);     
    }
    
    private static Datetime calcularPascua(integer Anio)
    {
        
        integer a, b, c, d, e;
        integer m = 24;
        integer n = 5;
        
        if (Anio >= 1583 && Anio <= 1699)
        {
            m = 22;
            n = 2;
        }
        else if (Anio >= 1700 && Anio <= 1799)
        {
            m = 23;
            n = 3;
        }
        else if (Anio >= 1800 && Anio <= 1899)
        {
            m = 23;
            n = 4;
        }
        else if (Anio >= 1900 && Anio <= 2099)
        {
            m = 24;
            n = 5;
        }
        else if (Anio >= 2100 && Anio <= 2199)
        {
            m = 24;
            n = 6;
        }
        else if (Anio >= 2200 && Anio <= 2299)
        {
            m = 25;
            n = 0;
        }
        
        a= math.mod(Anio, 19);
        b = math.mod(Anio, 4);
        c = math.mod(Anio, 7);
        d = math.mod(((a*19) + m),30);
        e = math.mod(((2*b)+(4*c)+(6*d)+n),7);

       // a = Anio % 19;
       // b = Anio % 4;
       // c = Anio % 7;
       // d = ((a * 19) + m) % 30;
      //  e = ((2 * b) + (4 * c) + (6 * d) + n) % 7;
        
        integer dia = d + e;
        
        if (dia < 10) //Marzo
            return Datetime.newInstance(Anio, 3, dia + 22);
        else //Abril
        {
            
            if (dia == 26)
                dia = 19;
            else if (dia == 25 && d == 28 && e == 6 && a > 10)
                dia = 18;
            else
                dia -= 9;
            
            return Datetime.newInstance(Anio, 4, dia);
        }
    }
    
    
    private static Datetime SiguienteDiaSemana(Integer diaSemana, Datetime fecha, Boolean haciaAtras, Boolean inclusive)
    {
        Integer aumento = haciaAtras? -1: 1;
        if (inclusive && Integer.valueOf(fecha.format('u')) == diaSemana){
            return fecha;
        }
        
        fecha = fecha.AddDays(aumento);
        
        while (Integer.valueOf(fecha.format('u')) != diaSemana){
            fecha = fecha.AddDays(aumento);
        }
        return fecha;
    }
    
}