function stat_matrix=make_stat_matrix(stat_matrix,phoneme,letter)

[m n]=size(stat_matrix);
x=find_element(stat_matrix,phoneme,letter);

if (n==1)
    temp=cell(m,1); 
    for i=1:m
        temp(i)={cell(1,2)};
    end
    stat_matrix=cat(2,stat_matrix,temp);
    stat_matrix{x(1),n+1}(1)={phoneme};
    stat_matrix{x(1),n+1}(2)={1};
else
    if x(2)~=0
        stat_matrix{x(1),x(2)}(2)={cell2mat(stat_matrix{x(1),x(2)}(2))+1};
        return
    end
        for i=2:n
            a(i-1)=isempty(stat_matrix{x(1),i}{1});
        end
        for i=1:length(a)
        if a(i)==1
            stat_matrix{x(1),i+1}(1)={phoneme};
            stat_matrix{x(1),i+1}(2)={1};
            break
        end
        end
    if sum(a)==0
        temp=cell(m,1);
        for i=1:m
            temp(i)={cell(1,2)};
        end
        stat_matrix=cat(2,stat_matrix,temp);
        stat_matrix{x(1),n+1}(1)={phoneme};
        stat_matrix{x(1),n+1}(2)={1};
        
    end
end