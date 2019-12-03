let average a b = (a + b)/2;;

let rec range a b =
    if a > b then []
    else a :: range (a+1) b;;

let par a =
    a mod 2 =0;;

let rec pares = function
    | [] -> []
    | x::xs -> if par x then x:: pares xs else pares xs;;

let rec filter func = function
    | [] -> []
    | x::xs -> if func x then x:: filter func xs else filter func xs;;

let rec app = function
    | [] -> (function x -> x)
    | x::xs -> (function l2 -> x::(apy xs l2));;