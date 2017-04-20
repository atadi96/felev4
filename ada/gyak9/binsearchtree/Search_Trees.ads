generic
    type Item is private;
    with function "<"(I, J: Item) return Boolean is <>;
package Search_Trees is
    type Search_Tree is private;
    
    function Get_Empty return Search_Tree;
    
    function Construct(I: Item; Left, Right: Search_Tree) return Search_Tree;
    
    function Empty(T: Search_Tree) return Boolean;
    
    procedure Add(T: in out Search_Tree; I: Item);
    
    generic
        with procedure Action(I: in out Item);
    procedure Inorder(T: in out Search_Tree);
private
    type Node;
    type Search_Tree is access Node;
    type Node is record
        Data: Item;
        Left: Search_Tree := null;
        Right: Search_Tree := null;
    end record;
end Search_Trees;