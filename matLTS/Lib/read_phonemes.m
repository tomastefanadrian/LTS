function [phonemes error_code]=read_phonemes(doc)

%RO
%Functie pentru 

import org.jdom.*;
import java.util.List;

try,
root=doc.getRootElement();
phonemes_element=root.getChild('phonemes');
list_of_phonemes=phonemes_element.getChildren();
phonemes_no=list_of_phonemes.size();


for i=0:1:phonemes_no-1
     phoneme_element=list_of_phonemes.get(i);
     phoneme=phoneme_element.getText();
     phonemes(i+1)={char(phoneme)};
end,
error_code=0;


catch,lasterr,error_code=1;phonemes=0;return,end;

