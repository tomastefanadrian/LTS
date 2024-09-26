function mbrola_transcription=convert2mbrola(input_word, transcription)

L=length(transcription);
% mbrola_transcription=cell(2,L);
j=1;
for i=1:L
    if strcmp(transcription{i},'e_X')
        transcription{i}='E';
    elseif strcmp(transcription{i},'o_X')
        transcription{i}='O';
    elseif strcmp(transcription{i},'dZ')
        transcription{i}='G';
    elseif strcmp(transcription{i},'tS')
        transcription{i}='C';
    elseif strcmp(transcription{i},'ts')
        transcription{i}='T';
    elseif strcmp(transcription{i},'k_j')
        transcription{i}='k';
        if i+2<=L 
            if strcmp(transcription{i+2},'=')
                if strcmp(input_word{i+2},'I')
                    transcription{i+2}='j';
                elseif strcmp(input_word{i+2},'E')
                    transcription{i+2}='E';
                end
            end
        end
    elseif strcmp(transcription{i},'g_j')
        transcription{i}='g';
        if i+2<=L 
            if strcmp(transcription{i+2},'=')
                if strcmp(input_word{i+2},'I')
                    transcription{i+2}='j';
                elseif strcmp(input_word{i+2},'E')
                    transcription{i+2}='E';
                end
            end
        end
    end
    if  (strcmp(transcription{i},'j')||strcmp(transcription{i},'E'))&&strcmp(transcription{i-1},'=')
        mbrola_transcription{1,j}=transcription{i};
        mbrola_transcription{2,j}='SS';
        j=j+1;
    elseif strcmp(transcription{i},'j e')
        mbrola_transcription{1,j}=transcription{i}(1);
        mbrola_transcription{2,j}='SS';
        mbrola_transcription{1,j+1}=transcription{i}(3);
        mbrola_transcription{2,j}='SS';
        j=j+2;
    elseif strcmp(transcription{i},'k s')
        mbrola_transcription{1,j}=transcription{i}(1);
        mbrola_transcription{2,j}='*';
        mbrola_transcription{1,j+1}=transcription{i}(3);
        mbrola_transcription{2,j}='*';
        j=j+2;          
    elseif ~strcmp(transcription{i},'=')
        mbrola_transcription{1,j}=transcription{i};
        mbrola_transcription{2,j}='*';
        j=j+1;

        
    end
end
  
    
