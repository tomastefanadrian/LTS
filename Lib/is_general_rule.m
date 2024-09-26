function sem=is_general_rule(group,letters)

temp_letters=letters(1,:);
clear letters;

% for w=1:length(temp_letters)
%     temp_letters{w}=cell2mat(temp_letters{w});
% end
temp_letters=[temp_letters, {'='}];
[a b]=size(group);
sem_general_rules=0;
sem=1;
for w=1:a*b
    if strmatch(group(w),temp_letters,'exact')
        sem_general_rules=sem_general_rules+1;
    end
end
if sem_general_rules==a*b
    sem=0;
end