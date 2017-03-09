function Map ( T: TA ) return TB is
    Y: TB(T'Range);
begin
    for I in T'Range loop
        Y(I) := Op(T(I));
    end loop;
    return Y;
end;
