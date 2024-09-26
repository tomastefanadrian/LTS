function [cuvinte cuvinte_aux]=read_word(fisier,litere,sort_on)

%ROMANA
%Functie citeste fisier
%de Toma Stefan-Adrian
%e-mail:toma.stefa.adrian@gmail.com

%ENGLISH

%numarul de litere in alfabet
num_litere=length(litere);
%caractere "auxiliare"
aux='-';

%deschide fisierul 
fid=fopen(fisier,'r');

%initializeaza semnafoare
prima_litera=0;
sem=0;

%initializeaza variabila pentru cuvant
cuvant='';
cuvant_aux='';

%initializare contor variabila de iesire
j=1;
sem_feof=0;%semafor sfarsit de fisier

while (1)
    
    %citeste un caracter din fisier
    [caracter num]=fread(fid,1,'char=>char');
    %verifica daca s-a ajuns la sfarsitul fisierului
    if (num==0)
        if (~isempty(cuvant))
            cuvinte{j}=cuvant;
            cuvinte_aux{j}=cuvant_aux;
        end
        break
    end
       
    %reinitializeaza semaforul de idenficare a sfarsitului de cuvant
    sem=0;
    
    %identifica prima litera
    if (prima_litera==0)
        for i=1:num_litere
            if (strcmp(litere{i},caracter))
                cuvant=caracter;
                cuvant_aux=caracter;
                prima_litera=1;
                sem=1;
                break
            end
        end    
        continue
    %identifica restul literelor dintr-un cuvant
    else
        for i=1:num_litere
            if (strcmp(litere{i},caracter))
                cuvant=cat(2,cuvant,caracter);
                cuvant_aux=cat(2,cuvant_aux,caracter);
                sem=1;
                break
            elseif caracter==''''
                cuvant=cat(2,cuvant,caracter);
                cuvant_aux=cat(2,cuvant_aux,caracter);
                sem=1;
                break
            end
        end
        if (strcmp(caracter,aux))  %identifica caracter -
           cuvant_aux=cat(2,cuvant_aux,caracter);
           continue;
        end
    end
    %verifica daca s-a ajuns la finalul cuvantului
    if (sem==0)
        cuvinte{j}=cuvant;
        cuvinte_aux{j}=cuvant_aux;
        j=j+1;
        %reinitializeaza semaforului de indentificare a primei litere
        prima_litera=0;
        cuvant='';
        cuvant_aux='';
        continue;
    end
    
end
    
fclose(fid);
if sort_on=='Y'
    cuvinte=unique(cuvinte);
    cuvinte_aux=unique(cuvinte_aux);
end
   
    