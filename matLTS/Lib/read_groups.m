function [groups error_code]=read_groups(doc)

%RO
%Functie pentru 

import org.jdom.*;
import java.util.List;

try,
root=doc.getRootElement();
groups_element=root.getChild('define_letter_groups');
list_of_groups=groups_element.getChildren();
groups_no=list_of_groups.size();


for i=0:1:groups_no-1
     group_element=list_of_groups.get(i);
     group=group_element.getText();
     groups(i+1)={char(group)};
end,
error_code=70;


catch,lasterr,error_code=71;groups=0;return,end;
