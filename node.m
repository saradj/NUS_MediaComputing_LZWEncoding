classdef node
    properties
        id = 0 % id of node
        code = 0 % the symbol represented by this node
        value= 1e10 % value of node i.e. frequency of symbols
        % or summation of frequency of symbols in
        % child nodes
        valueForSorting = 1e10 %optional field: temporary storage
        parent=[] % id of parent node
        left=[] % id of left child
        right=[] % id of right child
        huff = [] % Huffman code (empty unless it is a leaf node)
    end
end