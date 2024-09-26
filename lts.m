function [input_word, transcription, htk_transcription, stat, error_code]=lts(word, rules, op1, op2, op3, op4);



%ROMANA
%Functie pentru transcriere fonetica 
%de Toma Stefan-Adrian
%e-mail: toma.stefan.adrian@gmail.com
%
%ENGLISH
%Phonetic transcription function
%by Toma Stefan-Adrian
%e-mail: toma.stefan.adrian@gmail.com
%
%VERSIUNEA 3
%
%Ce este nou:
%1. Functiile care citesc fisierul XML sunt implementate in Java (viteza mult mai mare)
%2. Nu mai este necesara definirea numelor grupurilor de litere
%
%
%
%VERSIUNEA 2
%Ce este nou:
%1. Functia analizeaza cate un singur cuvant 
%2. Parametrii de intrare optimizati pentru lucrul cu cuvinte independente
%3. 5 parametrii de intrare: 1. cuvantul de analizat - word; 
%                            2. fisierul cu reguli - rules;
%                            3. op1 - d_on, d_off - dictionar ON sau OFF
%                            4. op2 - h_on, h_off - iesire in format HTK ON sau OFF 
%                            5. op3 - s_on sau s_off - statistica ON sau OFF
%                            6. op4 - hyphen_on sau hyphen_off - pastreaza
%                            sau nu pastreaza cratima
%
%VERSIUNEA 1.1 BETA
%Ce e nou:
%1. Am scos regulile simple. Acum toate regulile se scriu la fel.
%2. Se tine cont de cratima
%
%VERSIUNEA 1.0 BETA
%Ce e nou:
%1. functia split_word nu mai da eroare. Problema era in functia read_word
%care considera cuvant, in anumite conditii o celula goala.
%2. Reprezentarea datelor in fisierul de iesire este corecta.



%DE AICI INCEPE PROGRAMUL
%THE PROGRAM STARTS FROM HERE

%verificarea argumentelor de intrare ale functiei
%check the input arguments 

import org.jdom.*;
import org.jdom.input.SAXBuilder;
import org.jdom.JDOMException;
% import org.jdom.output.XMLOutputter;
% import org.jdom.output.Format;

%STERGELE DUPA CE TERMINI
% input_word=1;
% transcription=2;
% htk_transcription=3;
% stat=4;
% error_code=5;


if nargin~=6
    disp('You need exactly six input arguments!');
    disp('Sunt necesare exact 6 variabile de intrare!');
    transcription=1;
    htk_transcription=1;
    stat=1;
    error_code=1;
    return
end


% try,
test_fid= fopen(rules, 'r');
% catch,lasterr,return,end

if (test_fid==-1)
    disp('I cannot find the rules file!');
    error_code=2;
    transcription=2;
    htk_transcription=2;
    stat=2;
    return
else
    fclose(test_fid);
end

if (~strcmp(op1,'d_on') & ~strcmp(op1,'d_off'))
    disp('Wrong dictionary option!');
    transcription=3;
    htk_transcription=3;
    stat=3;
    error_code=3;
    return
end

if (~strcmp(op2,'h_on') & ~strcmp(op2,'h_off'))
    disp('Wrong HTK format option!');
    transcription=4;
    htk_transcription=4;
    stat=4;
    error_code=4;
    return
end

if (~strcmp(op3,'s_on') & ~strcmp(op3,'s_off'))
    disp('Wrong statistics option!');
    transcription=5;
    htk_transcription=5;
    stat=5;
    error_code=5;
    return
end

if (~strcmp(op4,'hyphen_on') & ~strcmp(op4,'hyphen_off'))
    disp('Wrong statistics option!');
    transcription=6;
    htk_transcription=6;
    stat=6;
    error_code=6;
    return
end

error_code=0;

%deschide fisierul XML
        try,
        builder = SAXBuilder();
        doc=builder.build(rules);
        catch,lasterr,disp('Cannot open the XML file. Error code 21');error_code=21;return,end

if strcmp(op1,'d_on')
    %cauta in dictionar
    %daca gasesti cuvantul in dictionar
    %iesi din functie
    dictionary_file=fullfile(matlabroot,'work','LTS','LTS v3.0 Lab','dic.xml');
    [dictionary_trans error_d]=dictionary_lookup(word, dictionary_file);
    
    if ~isempty(dictionary_trans)
                
        [letters error_l]=read_letters(doc);
        letters_no=length(letters);
        stat=letters;
         for i=1:letters_no
             temp=letters{1,i};
             a(i)=length(temp);
         end
         
        l_max=max(a);
        input_word=split_word(word,l_max,letters_no,letters);
        transcription=dictionary_trans;
        if strcmp(op2,'h_on')
            j=1;
            for i=1:length(transcription)
                if strcmp(transcription(i),'=')
                    continue
                end
            htk_transcription(j)=transcription(i);
            j=j+1;
            end
        else
            htk_transcription='HTK format is off.';
        end
        if strcmp(op3,'s_on')
            stat='DICTIONARY';
        else
            stat='Statistics are off';
        end
        return
    end
end

%pregateste cuvatul (scoate cratima - daca exista)
word_aux=regexprep(word,'-','');
%word - structura de tip sir ce contine cuvantul de intrare (inclusiv cratima daca exista)
%word_aux - structura de tip sir ce contine cuvantul de intrare fara
%cratima (daca exista)



%incarca tipurile de grupuri de litere intr-o matrice
%load 

%[groups error]=read_groups(doc);

%incarca fonemele intr-o matrice
%load phonemes into a matrix
[phonemes error]=read_phonemes(doc);
%phonemes=transpose(phonemes) 

% %incarca literele intr-o matrice
% %load letters into a matrix
[letters error_l]=read_letters(doc);


% 
%numarul de litere
%the number of letters
num_letters=length(letters);
% 
%CITESTE GRUPURILE DE LITERE SI FORMEAZA MATRICEA LITERELOR
%READ THE LETTER GROUPS AND MAKE THE LETTER MATRIX
% A vowel   #      #    #
% B #      cons    #    #
% .........
% Z #      cons    #    #
 


try,
    root=doc.getRootElement();                       %citeste elementul radacina al fisierului de reguli
    letter_groups=root.getChild('define_groups');    %citeste elementul "define_groups"
    list_of_groups=letter_groups.getChildren();      %citeste lista de copii din elementul "define_groups"
    groups_no=list_of_groups.size();                 %calculeaza numarul de copii ai elementului "define_groups"
    for i=0:1:groups_no-1                            %pentru fiecare copil din "define_groups"   
        group_element=list_of_groups.get(i);         %citeste-l intr-o variabila de tip element
        group=group_element.getText();               %citeste contintul text al elementului citit anterior 
        group_name=group_element.getName();          %citeste numele elementului  
        groups(i+1)={char(group)};                   %transforma textul continut de element in sir de caractere
        groups_names(i+1)={char(group_name)};        %transforma numele elementului in sir de caractere
    end,
catch,
    lasterr,                                         %ultima eroare aparuta in grupul "try" anterior
    error_code=111;                                  %codul erorii -- mai ai de lucru la astea
    return,                                          %iese din functie daca a primit eroare
end;

letters=[letters;cell(1,num_letters)];               %adauga o linie la sirul literelor
for j=1:num_letters                                  %pentru fiecare litera  
    for i=1:groups_no                                %pentru fiecare grup  
        if ~isempty(strfind(groups{i},letters{1,j})) %verifica daca litera se afla in grupul respectiv
            letters{i+1,j}=groups_names{i};          %daca da marcheaza locul in matricea literelor cu numele grupului
        else                     
            letters{i+1,j}='#';                      %daca nu marcheaza locul cu #   
        end
    end
end


%lungimea maxima a unui caracter grafic
%maximum length of a graphic character

for i=1:num_letters
    temp=letters{1,i};
    a(i)=length(temp);
end
l_max=max(a);
clear a group

%imparte sirul care formeaza cuvantul de intrare in litere
x=split_word(word_aux,l_max,num_letters,letters);
input_word=split_word(word,l_max,num_letters,letters);

%adaugare zone de liniste
liniste={'='};
x=[liniste,x,liniste];
    
%analiza si transcriere fonetica 
y{1}='='; %transcrierea fonetica incepe cu zona de liniste
i=2; %porneste de prima litera dupa zona de liniste

while i<=length(x)-1    %cat timp i este mai mic decat lungimea cuvantului de transcris
    temp=x{i};%grafemul care se analizeaza
   
    %x{1} este zona cu liniste, de aceea porneste de la i=2
   
    try,%incearca sa caute reguli
        rule_group=root.getChild(strcat('for_',temp));
        list_of_rules=rule_group.getChildren();
        rules_no=list_of_rules.size();     %determina numarul de reguli pentru caracterul respectiv
        
        for k=1:rules_no %pentru fiecare regula a caracterului analizat....
            rule=list_of_rules.get(k-1);
            
            %determina numarul de vecini in stanga
            left_context_list=rule.getChildren('left');
            left_context_no=left_context_list.size();
            %determina numarul de vecini in dreapta
            right_context_list=rule.getChildren('right');
            right_context_no=right_context_list.size();
            
            if (i<=left_context_no)|((i+right_context_no)>length(x)) 
                %daca numarul vecinilor stanga sau dreapta este mai
                %mare decat sirul de caractere pe care-l analizam
                %-cuvantul - atunci....
                clear group; %sterge din memorie structura group 
                continue %mergi la urmatoare regula
            end
            
            if left_context_no~=0 % daca exista vecini la stanga....
                for l=1:left_context_no %...fiecare vecin din stanga ... 
                    left_context_element=left_context_list.get(l-1);         %citeste-l intr-o variabila de tip element
                    left_context=left_context_element.getText();      
                    group(l)={char(left_context)};         %... salveaza-l in structura group (de tip celula)
                end                
                group(l+1)={temp};   %inregistreaza grafemul pe care-l se analizam
            else %daca nu sunt vecini la stanga 
                group(1)={temp};%inregistreaza grafemul pe care-l se analizam
            end

            if right_context_no~=0 % daca exista vecini la dreapta....
                for l=1:right_context_no %...fiecare vecin din dreapta ... 
                    right_context_element=right_context_list.get(l-1);         %citeste-l intr-o variabila de tip element
                    right_context=right_context_element.getText();      
                    group(left_context_no+l+1)={char(right_context)};       %... salveaza-l in structura group (de tip celula)
                end                
            end
            
          
         
         %formeaza sirul caracterelor pe care le testam
         group_test=x(i-left_context_no:i+right_context_no);
          
         %prelucreaza grupul caracterelor care reprezinta regula
         group=make_group(group,left_context_no);

         
                              
         if (~is_general_rule(group,letters))%daca regula nu contine elemente de generalitare
            
             if sum(strcmp(group,group_test))==left_context_no+right_context_no+1
                if strcmp(op3,'s_on')
                    stat(i-1)={cell2mat(group)};                              
                end
                clear group;
                rule_t=rule.getChild('t');
                phoneme=rule_t.getText();
                y{i}=char(phoneme);
                i=i+1;
                break;
            end
         else%daca regula contine elemente de generalitate
            new_group_test=match_letter_groups(group, group_test, letters, groups_names);

            %verifica daca regula corespunde cu grupul de litere de test
            [a b]=size(group);
            if sum(strcmp(group,new_group_test))==a*b %daca regulile corespund
                if strmatch(op3,'s_on')
                   stat(i-1)={cell2mat(group)};
                end
                clear group;%sterge celula group
                rule_t=rule.getChild('t');
                phoneme=rule_t.getText();
                y{i}=char(phoneme);i=i+1;
                break;%iese din "for"
            end
         end
          clear group
        end
    catch, %daca nu gaseste reguli pentru caracterul grafic respectiv
        disp('Error:'),lasterr, y{i}='*';i=i+1; %inlocuieste litera cu "*"
    end
end
             

%y=[y,{'='}];
y(1)=[];

if strcmp(op4,'hyphen_on')
    if length(word)~=length(word_aux)%daca dupa scoaterea cratimei cele doua cuvinte sunt diferite
        %introdu cratima in transcrierea fonetica
        temp_y=y;
        x_aux=split_word(word,l_max,num_letters,letters);
        y=cell(1,length(x_aux));
        j=1;
        for i=1:length(x_aux)
            if strcmp(x_aux(i),'-')
                y(i)={'-'};
            else
                y(i)=temp_y(j);
                j=j+1;
            end
        end 
    end        
end
    

if strcmp(op2,'h_on')
    j=1;
    for i=1:length(y)
        if strcmp(y(i),'=')
            continue
        end
        htk_y(j)=y(i);
        j=j+1;
    end
else
    htk_y='HTK format is off.';
end

if strcmp(op3,'s_off')
    stat='Statistics are off.';
end
transcription=y;
htk_transcription=htk_y;









