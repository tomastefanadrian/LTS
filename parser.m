clear all;
clc;

word='CHEAMa';
rules=fullfile(pwd,'rules_mbrola.xml');
op1='d_off';
op2='h_on';
op3='s_on';
op4='hyphen_on';

% op1 - d_on, d_off - dictionar ON sau OFF
% op2 - h_on, h_off - iesire in format HTK ON sau OFF 
% op3 - s_on sau s_off - statistica ON sau OFF
% op4 - hyphen_on sau hyphen_off - pastreaza sau nu pastreaza cratima


[input_word, transcription, htk_transcription, stat, error_code]=lts(word, rules, op1, op2, op3, op4)

mbrola_transcription=convert2mbrola(input_word, transcription)