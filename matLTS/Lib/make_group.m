function [group]=make_group(group,num_vecini_stanga)

temp_group=group;
[a b]=size(temp_group);
clear group;
group=cell(a,b);
group{num_vecini_stanga+1}=temp_group{num_vecini_stanga+1};
for w=1:length(temp_group)
    if w==num_vecini_stanga+1
        continue
    end
    remain=cell2mat(temp_group(w));
    sem_index=1;
    while 1
    [str,remain] = strtok(remain,'|');
        if isempty(str), break; end;
            str={str};
            [a b]=size(group);
            if (sem_index==1)
                size(group);
                group(1,w)=str;
                sem_index=sem_index+1;
            else    
                group(sem_index,w)=str;
                sem_index=sem_index+1;
            end
    end
end                   
[a b]=size(group);
for i=1:a*b
    if isempty(group{i})
        group{i}='#';
    end
end