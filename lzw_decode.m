close all
clear

%---- Q2 LZW Decoding

load lzw_output c % getting the code to decode, stored in c
result = ''; %initializing the end result
prev = ''; % prev will hold the last decoded value for the substring
codebook_length = 256; %initializing the codebook length, we have the codes for all acii chars initially
codeBook = cell(1000, 2);% this stores the LZW code book, recreating it 

for i= 1 : codebook_length  
   codeBook(i, : ) = {i, char(i-1)}; % initializing the codeBook with all known codes for ascii chars
end

for i = 1: length(c) %for each digit of the encoding
    if(c{i} <= codebook_length) % if it is in the codebook, meaning it's less than the codeBook length
        curr = codeBook{c{i},2}; % we get the decoded substring for it from the codebook
    else
        curr = [prev prev(1)]; % this case is needed for the edge case string ex: aaa, 
        % since the decoder is always a step before the encoder, when we see
        % the second a, should add aa to the dict! 
    end
    if(strcmp(prev, '')==0) % if we are not dealing with an existing codeBook entry, prev is not empty, after the second digit has been read
        codebook_length = codebook_length + 1;
        codeBook(codebook_length, : ) = {codebook_length, [prev curr(1)]};  %add the new entry to the codeBook, 
        % which will be the previous found substring concatinated with the first char of the current string
    end
    result = [result curr]; % concatinating the decoded substring to the result
    prev = curr; % update on previous
end

save lzw_output result % saving the result of the decoder
