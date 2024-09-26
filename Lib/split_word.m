function x=split_word(word,l_max,num_letters,letters)    

%imparte cuvantul in litere
p=1;
i=1;%contor pentru literele din cuvant
while i<=length(word)
    temp='';
    sem_p=p;%semafor pentru identificarea caracterului grafic
    
    if i~=length(word)
        temp=word(i:i+l_max-1);
        for k=1:num_letters
            if (strfind(letters{1,k},temp))
                x{p}=temp;p=p+1;i=i+l_max;
                break;
            end
        end
    end
    
    if (sem_p<p)
        continue;
    else
        x{p}=word(i);p=p+1;i=i+1;
    end
 end