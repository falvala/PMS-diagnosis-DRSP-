%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALISIS DE AUTORREGISTRO DE SÍNTOMAS (DRSP) Daily record of severity problems.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Autor: Fátima Alvarez, Universidad Autónoma de Madrid. 11/septiembre/2019.
% Realiza el diagnóstico de SPM en participantes de estudio CICLO18, a partir del las puntuaciones en autorregisto durante 2 meses.
% Este script usa los criterios  diagnósticos de DRSP, para diagnosticar SPM, tras dos ciclos de registro de síntomas.

% 15.01.2020. Modification Fatima Alvarez (UAM) line 15 by line 16 (to
% avoid version incompatibilies).
% modification (section-line 138, line 124 and 285)about external atributions to the symptomatology. do not
% take into account if participants reported external atributions

clc; clear all
%% añadir datos:
ruta_datos= 'F:\Working_Memory\Informes personales_ Autorregistro';
cd(ruta_datos);
% autreg = xlsread('datos_limpios_V04.xlsx'); cycle_length= xlsread('cycle_length.xlsx');
autreg = readmatrix('datos_limpios_V04.xlsx'); cycle_length= readmatrix('cycle_length.xlsx');

%% FOLICULAR PHASE (FOL). Average daily symptom >3 
% 1. During the mild-follicular phase (day 6-10** after onset of menses) does the subject have an average daily symptom rating 
% score greater than 3 (mild) on any of the symptoms, i.e., there any evidence of an ongoing disorder?
% **usamos fase FOL (+6:+12)
% creamos una columna 28 con el promedio de las puntuaciones de severidad en  el autorregistro (col 1:24)

col_ad= NaN (length (autreg),1); % añadimos una columna 28 para poner más alante el promedio de valores de sintomatologia en FOL
autreg = [autreg, col_ad];
   
for c = 1:length (autreg) 
    autreg(c, 28) = nanmean (autreg (c, 1:24)); % calculamos los promedios de sintomatología para todos los días
end
clear c 
crit1 = [];
for c = 1:length (autreg) %saca los sujetos que hay que observar. Igualmente los que saca no tienen SPM.
    if (autreg(c,28)>=3 && (autreg(c,26)>= 6 && autreg(c,26)<= 12))==1 % si:: severidad mayor que 3 && día en fase FOL (+6:+12)
%         fprintf ('Observar sujeto %d\n', autreg(c,25))
        suj= autreg(c,25); crit1 = [crit1, suj]; clear suj
    else 
        autreg(c, 28)= 0;  % si la severidad en FOL no es mayor de 3, ponemos un valor de 0 en la col(28)      
    end
end
crit1 = crit1'; clear c col_ad %generamos "nopms", que usaremos después. son las personas que tienen sintomatologia en FOL, por lo tanto, no SPM
%% LUTHEAL PHASE.(LUT)

col_ad= zeros (length (autreg),1); % La columna 29 se convertirá en la fase Lutea. 
autreg = [autreg, col_ad]; clear col_ad

for c = 1:length (autreg) 
    suj=autreg(c, 25);
    valor= cycle_length (suj,2);
    ppolutea= valor-7; finlutea= valor -2;
    if (autreg(c,26)>= ppolutea) && (autreg(c,26)<= finlutea)==1 % si el dia esta entre longitud del ciclo -2:-7
        autreg(c,29)=1; %asigna un valor (1)a la columna 29 si la participante estaba en fase lútea.
        % fprintf ('Sujeto %d en fase lútea dia %d\n', autreg(c,25), autreg(c,26))        
    else
        autreg(c,29)=0; %asigna un valor 0 en la columna 29 si la participante no esta en fase lútea.
    end
end
clear c suj valor finlutea ppolutea
%% 2. During the week prior menses* does the subject have scores of at least 4 (moderate) for at least 2 days on one or 
% more of the items that assess the symptoms of (1) depression, (2) anxiety, (3) affective lability or (4) anger/irritability?
% *usamos la fase lutea para el cálculo (-7:-2)-- SE CALCULA EN: 
% if NO, does not meed criteria (col 1:8)- STOP
%% depression..1a_, 1b_,1c_, 
%* autreg col (1:3)// calcularemos si sí en la col (30)
col_ad= zeros (length (autreg),1); autreg = [autreg, col_ad]; clear col_ad
for c = 1:length (autreg)
    if autreg(c, 29)==1 % primero vamos a buscar las puntuaciones >4 en LUT.
        if autreg(c,1)>=4 % Segun esta planteado  solo refleja si hay un cuatro en col(1)
            autreg (c,30)= autreg(c,30)+1;
        elseif autreg(c,2)>=4 % refleja si hay un 4 o más en col(2)
            autreg (c,30)= autreg(c,30)+1;   % "
        elseif autreg(c,3)>=4
            autreg (c,30)= autreg(c,30)+1;   % "
        else
        end
    else
    end
end
clear c % obtenemos una fila 30 en la que hay un:
% valor 1 si la persona  tuvo sintomatologia >=4 en col (1:4)--> alguna de ellas al menos
% valor 0 si no hubo sintomatologia en LUT

%% anxiety..2_, if YES, proceed to step 3
%* autreg col (4)// calcularemos si cumple en la col (31)
col_ad= zeros (length (autreg),1); autreg = [autreg, col_ad]; clear col_ad
for c = 1:length (autreg)
    if autreg(c, 29)==1
        if autreg(c,4)>=4
            autreg (c,31)= autreg(c,31)+1;
        else
        end
    else
    end
end
clear c % crea una col_31 en "autreg", en la que:
% valor 1: sintomatología >=4 en col_4 en LUT
% valor 0: no sintomatologia en col_4 y LUT

%% lability..3a_, 3b_,
%* autreg col (5:6)// calcularemos si cummple  en la col (32)
col_ad= zeros (length (autreg),1); autreg = [autreg, col_ad]; clear col_ad
for c = 1:length (autreg)
    if autreg(c, 29)==1 % primero vamos a buscar las puntuaciones >4. Segun esta planteado  solo refleja si hay un cuatro en alguna de esas tres columnas. ya esta. no esta sumando pero da igual.
        if autreg(c,5)>=4
            autreg (c,32)= autreg(c,32)+1;
        elseif autreg(c,6)>=4
            autreg (c,32)= autreg(c,32)+1;
        else
        end
    else
    end
end
clear c % crea una col_32 en "autreg", en la que:
% valor 1: sintomatología >=4 en col(5:6) en LUT
% valor 0: no sintomatologia en col(5:6) y LUT

%% anger..4a_, 4b_,,
%* autreg col (7:8)// calcularemos si cummple  en la col (33)
col_ad= zeros (length (autreg),1); autreg = [autreg, col_ad]; clear col_ad
for c = 1:length (autreg)
    if autreg(c, 29)==1 % primero vamos a buscar las puntuaciones >4. Segun esta planteado  solo refleja si hay un cuatro en alguna de esas tres columnas. ya esta. no esta sumando pero da igual.
        if autreg(c,7)>=4
            autreg (c,33)= autreg(c,33)+1;
        elseif autreg(c,8)>=4
            autreg (c,33)= autreg(c,33)+1;
        else
        end
    else
    end
end
clear c % crea una col_33 en "autreg", en la que:
% valor 1: sintomatología >=4 en col(7:8) en LUT
% valor 0: no sintomatologia en col(7:8) y LUT

%% at least 4 for at least 2 days. For one or more: 
% depression (col 1:3),anxiety (col 4), lability (col 5:6) and anger (col 7:8)/// matriz de criterio 2:

% NOTA: no contabiliza el día como día con sintomatología si la participante
% atribuye la sintomatología a una causa externa ( valor -1 en col:27)
crit2= zeros(53,5);
for c= 1:length(autreg)
    suj= autreg(c,25);crit2(suj,1)= suj;
    if autreg(c,30)==1
%         crit2(suj,2)= crit2(suj,2)+1+autreg(c,27);
        crit2(suj,2)= crit2(suj,2)+1; %% no tiene en cuenta las atribuciones externas **** ¡¡¡¡¡ ****
    else
    end
    if autreg(c,31)==1
%         crit2(suj,3)= crit2(suj,3)+1+autreg(c,27);
        crit2(suj,3)= crit2(suj,3)+1; %% no tiene en cuenta las atribuciones externas **** ¡¡¡¡¡ ****
    else
    end
    if autreg(c,32)==1
%         crit2(suj,4)= crit2(suj,4)+1+autreg(c,27);
        crit2(suj,4)= crit2(suj,4)+1; %% no tiene en cuenta las atribuciones externas **** ¡¡¡¡¡ ****
    else
    end
    if autreg(c,33)==1
%         crit2(suj,5)= crit2(suj,5)+1+autreg(c,27);
         crit2(suj,5)= crit2(suj,5)+1; %% no tiene en cuenta las atribuciones externas **** ¡¡¡¡¡ ****
    else
    end
end
clear c suj % Obtenemos "crit2", donde:
% col(1): indica el número del sujeto. Se ve que sujeto 8 y 28 no existen
% col (2): número de días con sintomatología depresiva.
% col (3): número de días con sintomatología ansiógena.
% col (4): número de días con sintomatología labilidad afectiva
% col (5): número de días con sintomatología enfado

%%  A partir de este punto se seleccionarán como gente sin PMS ("genteguay"):
% Participantes que ya han mostrado sintomatología en FOL: por lo tanto no
% hay PMS (seleccionadas en varible "sel")
% Participantes cuyo número de días con sintomatología en LUT en cualquiera de las columnas de
% "crit2" es >=2 // tener en cuenta que pueden haber mostrado
% sintomatología pero si se atribuye a causa externa no se ha tenido en
% cuenta (se refleja en la columna 27 con valor -1).

% Se selecciona la gente que pasa a criterio 3:
sinpms= [];
for c= 1: length (crit2)
    valor= sum((crit1(:)==c));
%     if  (crit2(c, 2:5)<=2) || valor>=1 % la doble barra ||, daba error
    if  (crit2(c, 2:5)<=2) | valor>=1
        sele=c; sinpms= [sinpms sele];
    else
    end
end
sinpms=sinpms';
borrasuj= sinpms==8; sinpms(borrasuj)= []; 
borrasuj= sinpms==28; sinpms(borrasuj)= [];
clear c valor sele borrasuj nopms % borramos los sujetos 8 y 28.
% obtenemos "sinpms" que es la gente que hasta ESTE punto NO obtiene
% diagnóstico de SPM. (aqui estan incluidas las personas que se descartaron
% el el criterio 1 (sintomatología en FOL)

%% seleccionar gente para criterio 3
% seleccionamos las personas en las que aún no se pueda descartar SPM
suj = (1:7); vect= (9:27); suj = [suj vect]; vect= (29:55);suj = [suj vect]; clear vect %creamos un vector con el ID de todas las participantes (sin participante 8 y 28)
selcrit3=[]; 
for i=1:length (suj)
    esta= sum(find(suj(i)== sinpms)); %esta= sum (ans); %busca el valor (i) de "suj" dentro de la posicion que ocupa en el vector
    if esta>=1
    else
        selcrit3= [selcrit3 suj(i)];
    end
end
selcrit3= selcrit3';
clear  i esta suj
% Obtenemos un vector columna "selcrit3" en el que aparecen las
% participantes que pueden tener PMS

%% Aplicamos el criterio 3 // During the week prior to menses does the subjecty have scores that reach a level of 4 (moderate) 
% for at least two days on at least FIVE of the symptoms (1a through 11d) listed? //// col (1:21)
  
col_ad= NaN (length (autreg),1); % añadimos una columna 34 para  poner valor 1 o 0 si hay mas de 5 sintomas con severidad >= 4(col 1:21) de sintomatologia en LUT
autreg = [autreg, col_ad]; clear col_ad
for c = 1:length (autreg)
    if autreg(c,29)==1 %busca en fase LUT
        valor= autreg(c,1:21)>=4;
        valor = sum (valor);
        if valor >= 5
            autreg(c,34)=1;
        elseif valor<5
            autreg(c,34)=0;
        end
    else
    end
end
clear c valor 
% este bucle pone en la columna 34 un valor (1) si pa participante cumplia con sintomatologia >=4 en 5 síntomas   

%% creamos crit3:
crit3= zeros(53,2);
for c= 1:length(autreg)
    suj= autreg(c,25);crit3(suj,1)= suj;
    if autreg(c,34)==1
%         crit3(suj,2)= crit3(suj,2)+1+autreg(c,27); % ¿tenener en cuenta valoración subjetiva?-- no cambian los valores
         crit3(suj,2)= crit3(suj,2)+1; %  no tenener en cuenta valoración subjetiva-- no cambian los valores?         **** ¡¡¡ ****

    else
    end
end
clear c suj 
% "crit3" contiene la info en numero de días que se ha puntuado severidad>=4 en >=sintomas en LUT.
%% crea selcrit4; para seleccionar participantes que cumplen criterio 3
selcrit4=[]; 
for i= 1:length (crit3)
    suj= crit3(i,1); 
    if (crit3(i,2)> 2) && (sum (suj==selcrit3(1:end)==1))
        %fprintf ('Participante %d seleccionada para criterio 4 diagnóstico PMS\n', suj)
        selcrit4=[selcrit4 suj]; 
    else  
    end
end
clear i suj 

%% CRITERIO 4- During the week prior to menses (LUT) dos the subject have scores of at least 4 (moderate) for at least 2 days on at least one of the three IMPAIRMENT  items (ABC)?
% *** col (22:24)
col_ad= NaN (length (autreg),1); % añadimos una columna 35 para  poner valor 1 o 0 si algun sintomas ABC con severidad >= 4(col 22:24) de sintomatologia en LUT
autreg = [autreg, col_ad]; clear col_ad
for c = 1:length (autreg)
    if autreg(c,29)==1 %busca en fase LUT
        valor= autreg(c,22:24)>=4;        
        valor = sum (valor);
        if valor >= 1
            autreg(c,35)=1;
        elseif valor<1
            autreg(c,35)=0;
        end
    else
    end
end
clear c valor % este bucle pone en la columna 35 un valor (1) si pa participante cumplia con sintomatologia >=4 en impairment Intems ABC   

%% creamos crit4:
crit4= zeros(53,2);
for c= 1:length(autreg)
    suj= autreg(c,25);crit4(suj,1)= suj;
    if autreg(c,35)==1
%         crit4(suj,2)= crit4(suj,2)+1+autreg(c,27); %¿tenener en cuenta valoración subjetiva?-- no cambian los valores
        crit4(suj,2)= crit4(suj,2)+1; % no tenener en cuenta valoración subjetiva?-- no cambian los valores?  **** ¡¡¡ ****
    else
    end
end
clear c suj 
% "crit4" contiene la info en numero de días que se ha puntuado severidad>=4 en sintomas ABC en LUT.

%% imprime las participantes que finalmente muestran SPM
diagnPMS=[];
for i= 1:length (crit4)
    suj= crit4(i,1); 
    if (crit4(i,2)> 2) && (sum (suj==selcrit4(1:end)==1))
        fprintf ('Participante %d cumple criterios para diagnóstico PMS\n', suj)
        diagnPMS=[diagnPMS suj];
    else  
    end
end
clear i suj ; %save diagnPMS
