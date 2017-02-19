
tests = [ get (fromList [])                                        ==  []
        , (head . get) (fromList [1..10])                          ==  1
        , (get . right) (fromList [])                              ==  []
        , (head . get . right) (fromList [1..10])                  ==  2
        , (head . get . right . right . right) (fromList [1..10])  ==  4
        , (get . left) (fromList [])                               ==  []
        , (head . get . right . left) (fromList [1..10])           ==  2
        , (head . get . left . right) (fromList [1..10])           ==  1
        , (toList . insert 2) (fromList [])                        ==  [2]
        , (toList . insert 1 . left . insert 2) (fromList [])      ==  [1,2]
        , (toList . insert 1 . right . insert 2) (fromList [])     ==  [2,1]
        , (toList . insert 1 . insert 2) (fromList [])             ==  [1,2]
        , (toList . insert 1 . left . insert 2) (fromList [3..5])  ==  [1,2,3,4,5]
        , (toList . insert 2 . right . right) (fromList [1..10])   ==  [1,2,2,3,4,5,6,7,8,9,10]
        , (toList . update 0) (fromList [])                        ==  []
        , (toList . update 0 . right) (fromList [1..10])           ==  [1,0,3,4,5,6,7,8,9,10]
        , (toList . delete) (fromList [])                          ==  []
        , (toList . delete . right . right) (fromList [1..10])     ==  [1,2,4,5,6,7,8,9,10] ]
        
        