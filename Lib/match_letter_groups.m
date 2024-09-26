function new_group_test=match_letter_groups(group, group_test, letters, groups)

%group contine regula citita din fisierul de reguli
%group_test contine grupul de litere care se testeaza
[a b]=size(group);
new_group_test=cell(a,b);
%new_group_test este un nou grup de litere care are forma similara cu
%grupul de reguli

               
for q=1:b
    for w=1:a
        %verifica daca elementul (w,q) din grupul de reguli se gaseste in
        %sirul grupurilor de litere; p contine pozitia pe care se gaseste
        p=strmatch(group(w,q),groups,'exact');
        if (p) %daca elementul (w,q) se gaseste ....
            if (strmatch(group_test(1,q),'='))  %daca caracterul analizat se afla la inceput de cuvant ...
                new_group_test(1,q)={'='};%primul element de pe coloana 1 este '='
                new_group_test(w,q)={'#'};%restul elementelor de pe coloana w sunt #
            else
                %p identifica pozitia caracteristicii in sirul
                %caracteristicilor - groups
                letter_index=strmatch(group_test(1,q),letters(1,:),'exact');
                temp_l=letters((p+1),letter_index);
                new_group_test(w,q)=temp_l;
            end
        elseif group{w,q}=='#'
            new_group_test(w,q)={'#'};
        elseif (w==1)
            new_group_test(w,q)=group_test(w,q);
        else
            new_group_test(w,q)={'#'};
        end
    end
end