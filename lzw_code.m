
close all
clear
%---- Q1 LZW Encoding

dataIn = 'Did you realize that the word stressed spelled backwards is desserts? This is something called semordnilap, which refers to a word, phrase, or sentence that has the property of forming another word, phrase, or sentence when its letters are reversed. A semordnilap differs from a palindrome in that the word or phrase resulting from the reversal is different from the original word or phrase.';
%dataIn = 'aaa'; %check for edge case !
%dataIn = 'abc cba'; %check for optimization !
%initialize with a bigger array of size 1000 entries
codeOut = cell(1000, 2);% this stores the LZW output code, 
% holds integer - string pairs: {encoding for substring, substring}
codeBook = cell(1000, 2);% this stores the LZW code book
codebook_length = 256; %initial codeBook is filled with all 256 ascii characters
codeCount = 1; %keeps track of position in codeOut

for i= 1 : codebook_length  
   codeBook(i, : ) = {i, char(i-1)};  %doing the mapping code-char, the codeBook contains tuples, 
   %tuple indexed i has the first element i(code of character) and second element the actual character
end

previous = ''; % %previous will save the last substring that is present in the codeBook, initially empty
prev_code = 0; % keeps the last encoding found for the previous value

for i = 1 : length(dataIn) % for each character in the input string
    curr = [previous dataIn(i)]; % curr holds the next value to be checked if it's in the codebook 
                                        %or we need to add it to it, we know previous is in the codeBook already or it's empty                                     
    for j = 1 : codebook_length
        curr_code = 0;
        if (strcmp(curr, codeBook{j,2}) == 1) %checking if curr is present in the codeBook
            curr_code = j; %if yes, we take the existing encoding for it
            break;
        end
    end
    if (curr_code > 0) %this means we found curr in the codeBook
        previous = curr; %we need to check if there is a larger substring of dataIn prefixed by curr that is in the codeBook
        prev_code = curr_code; %on the next iteration of the for loop(checking the next char of dataIn) curr will be updated with this previous, 
                               %to check if a larger substring is possible
    else % curr was not found in the codeBook
        codeOut(codeCount, : ) = {prev_code, previous}; %we use the encoding for the last (longest) found substring in the codeBook and we add it to the output
        codeCount = codeCount + 1; 
        codebook_length = codebook_length+1;
        codeBook(codebook_length, :) = {codebook_length, curr}; %we add the new substring(previous+next char) to the codeBook
       %{
       % --------part used for optimization adding the reverse string as well
        codebook_length = codebook_length+1;
        codeBook(codebook_length, :) = {codebook_length, reverse(curr)};
       %}
        previous = dataIn(i); % we reinitialize previous since we encoded the substring from 1 to i-1 of dataIn
        for j=1:codebook_length %finding the encoding for previous in the codeBook, which must exist since we have the initial ascii set encoded
            if (strcmp(previous, codeBook{j,2}) == 1)
                prev_code = j;
                break;
            end
        end
    end
end

codeOut(codeCount, : ) = {prev_code, previous}; % adding the encoding of the last substring to the output

% crop the unused part of the array.
% codeCount is the total number of codes generated
c = codeOut(1:codeCount,1);
% lzw_output is the output filename,
% note: we will only save the code and not the codebook
save lzw_output c
% save only one variable: c. Do not save codeBook