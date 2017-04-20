with Search_Tree;
procedure Sort(A: in out My_Array) is
    type Item_Search_Trees is new Search_Trees(Item); use Item_Search_Trees;
    Current_Pos: Index := A'Range'First;
    
    procedure Array_Sort(I: in out Item) is 
    begin
        A(Current_Pos) := I;
        I := Index'Succ(I);
    end Array_Sort;
    function Sort_Inorder is new Inorder(Array_Sort);
    T: Search_Tree := Get_Empty;
    
begin
    for I in A'Range loop
        Add(T, A(I));
    end loop;
    Sort_Inorder(T);
end Sort;