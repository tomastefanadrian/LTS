function [letters error_code]=read_letters(doc)

%RO
%Functie pentru 

import org.jdom.*;
import java.util.List;

try,
root=doc.getRootElement();
letters_element=root.getChild('letters');
list_of_letters=letters_element.getChildren();
letters_no=list_of_letters.size();


for i=0:1:letters_no-1
     letter_element=list_of_letters.get(i);
     letter=letter_element.getText();
     letters(i+1)={char(letter)};
end,
error_code=0;


catch,lasterr,error_code=1;letters=0;return,end;
