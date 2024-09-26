%Script pentru conversia structurii de tip celula care contine statistica
%in structura de tip matrice pentru a putea fi importata in Excell
[a b]=size(stat_matrix);
excell_stat_matrix=cell(a,2*b-1);
excell_stat_matrix(:,1)=stat_matrix(:,1);

for i=1:a
    k=2;
    for j=1:(b-1)
        excell_stat_matrix{i,k}=cell2mat(stat_matrix{i,j+1}(1));
        excell_stat_matrix{i,k+1}=cell2mat(stat_matrix{i,j+1}(2));
        k=k+2;
    end
end
