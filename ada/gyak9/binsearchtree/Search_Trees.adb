package body Search_Trees is

    function Get_Empty return Search_Tree is
    begin
        return null;
    end Get_Empty;
    
    function Construct(I: Item; Left, Right: Search_Tree) return Search_Tree is
    begin
        return new Node(I, Left, Right);
    end Construct;
    
    function Empty(T: Search_Tree) return Boolean is
    begin
        return T = null;
    end Empty;
    
    procedure Add(T: in out Search_Tree; I: Item) is
    begin
        if Empty(T) then
            T := Construct(I, Get_Empty, Get_Empty);
        else
            if I < T.Data then
                Add(T.Left, I);
            else
                Add(T.Right, I);
            end if;
        end if;
    end Add;
    
    procedure Inorder(T: in out Search_Tree) is
    begin
        if not Empty(T) then
            Inorder(T.Left);
            Action(T.Data);
            Inorder(T.Right);
        end if;
    end Inorder;
    

end Search_Trees;