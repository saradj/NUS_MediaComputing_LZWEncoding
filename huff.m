close all
clear 

%---- Q3 Huffman Tree Encoding

dataIn = 'Did you realize that the word stressed spelled backwards is desserts? This is something called semordnilap, which refers to a word, phrase, or sentence that has the property of forming another word, phrase, or sentence when its letters are reversed. A semordnilap differs from a palindrome in that the word or phrase resulting from the reversal is different from the original word or phrase.';
%dataIn = 'didi has a brother called diiiiidiiiii. didi has a sister called daaaadaaaa.';
nb_unique_chars = length(unique(dataIn)); % getting the number of unique chars in the input
start_range = 257 - nb_unique_chars; %used to get the count only for the needed entries, exclude 0 count entries
end_range = 256;
[count, chars] = sort(hist(double(dataIn), 0:255), 'ascend'); % hist counts the number of occurences for each char (double value 0-255)
% using sort on  the hist output to sort the chars and counts in ascending order
string_ascend = char(chars(start_range : end_range)-1); % extracting only the needed chars hat actually appear in the dataIn
frequencies = count(start_range :end_range); % extracting only the counts > 0

sorted_nodes = cell(nb_unique_chars,1); % list of the nodes in sorted ascending order at all times
global tree_nodes % a global variable since I use it the the get_encoding function
tree_nodes = cell(nb_unique_chars,1); % will keep all the nodes created in the tree, used to extract the needed nodes given their id, while travercing the tree
id = 1; % used to give unique ids to all nodes

for i=1:nb_unique_chars		% filling in the lists of nodes initially to hold all the leaf nodes		
   temp_node = node;						
   temp_node.id = id; % less frequent nodes have smaller ids
   temp_node.code = string_ascend(i); % each leaf node has as code the a unique char appearing in dataIn
   temp_node.value = frequencies(i); % initializing the count respectivly
   sorted_nodes{i} = temp_node;
   tree_nodes{i} = temp_node;
   id = id + 1;
end

while length(sorted_nodes) > 1 					% repeat until we have generated a root node ! 
	[frequencies,i]=sort(frequencies);					% sort the counts ascending
	sorted_nodes=sorted_nodes(i);	% update the list of sorted nodes respectivly, reorder the tree
    new_node = node; % create a new node from merging the 2 least frequent nodes in sorted_nodes
    new_node.id = id;
    left_node = sorted_nodes{1};
    right_node = sorted_nodes{2};
    new_node.value = left_node.value + right_node.value; % updating the value 
    new_node.left = left_node.id; % updating the left node (smallest count)
    new_node.right = right_node.id; % updating the right node (2nd smallest count)
    left_node.parent = new_node.id; % updating the left and right nodes' parent to be the new node
    tree_nodes{left_node.id} = left_node;
    right_node.parent = new_node.id;
    tree_nodes{right_node.id} = right_node;
	sorted_nodes{2}= new_node; % add the new intermediate node to both lists
    tree_nodes{id}= new_node;
    sorted_nodes= sorted_nodes(2:length(sorted_nodes));	% join node 1 to 2 and prune the first node
	frequencies(2)=frequencies(1)+frequencies(2);       % merge the counts respectivly
    frequencies = frequencies(2:length(frequencies));		
    id = id + 1;
end

get_encoding(sorted_nodes{1}, ''); % starting from the root, traverse the tree to get the encoding for all leaf nodes (chars in dataIn)

fprintf("char - count - encoding\n");
for i = 1 : nb_unique_chars
    if(tree_nodes{i}.code == ' ')
        fprintf(1," space %d\t", tree_nodes{i}.value);
    else
        fprintf(1," %c\t%d ", tree_nodes{i}.code, tree_nodes{i}.value);
    end
    fprintf(1," %s\n", tree_nodes{i}.huff);
end

num_bits_huff = 0;
num_bits_normal = 0;
bits_per_char = ceil(log2(nb_unique_chars)); % ceil(log2(30)) = 5

for i = 1 : nb_unique_chars
    num_bits_huff = num_bits_huff + length(tree_nodes{i}.huff) * tree_nodes{i}.value;
    num_bits_normal = num_bits_normal +  bits_per_char * tree_nodes{i}.value;
end

fprintf(1,"The number of bits needed to encode the string with Huffman encoding is %d\n", num_bits_huff);
fprintf(1,"The number of bits needed if we encode the string giving each of the %d unique chars a %d bit (ceil(log_2(%d)) = 5) code is %d\n",nb_unique_chars,bits_per_char,nb_unique_chars, num_bits_normal);
compresion = (num_bits_normal-num_bits_huff)/num_bits_normal *100;
fprintf(1,"The compression achieved is %.3f%% \n", compresion);


function get_encoding(node, huff_code_so_far) 
global tree_nodes 

    if node.code > 0 % meaning it is a  leaf node, holding a symbol 
        node.huff = huff_code_so_far;  % update its huffman encoding, end of recursion
        tree_nodes{node.id} = node; % update the list of nodes holding the tree
    else % it is an intermediate (non leaf) node
        get_encoding(tree_nodes{node.left},[ huff_code_so_far '0']);  % recursivly create the huffman encoding, by adding 0 if moving left
        get_encoding(tree_nodes{node.right},[ huff_code_so_far '1']); % and 1 if moving right
    end
end
