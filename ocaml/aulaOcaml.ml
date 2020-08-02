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
    | x::xs -> (function l2 -> x::(app xs l2));;

let rec member = function
    | [] -> (function n -> false)
    | x::xs -> (function n  -> if (x=n) then true else member xs n);;

let rec remove = function
    | [] -> (function y::ys -> y::ys)
    | x::xs->(function
                | [] -> []
                | y::ys -> (if (member (x::xs) y) then (remove (x::xs) ys)
                            else y::(remove (x::xs) ys)));;

let add = (+) 1;;

let rec map func= function
    | [] -> []
    | x::xs -> (func x)::(map func xs);;

let rec conta e= function
    | [] -> 0
    | x::xs -> if x=e then 1+(conta e xs)
               else conta e xs;;

let rec remove_element e= function
    | [] -> []
    | x::xs -> if x=e then (remove_element e xs)
               else x::(remove_element e xs);;

let rec contar_elementos = function
    | [] -> []
    | x::xs -> (x,(conta x (x::xs)))::contar_elementos (remove_element x (x::xs));;

let apl1 e = function
    n -> e n;;

let apl2 e = function
    n -> e(e n);;

type 'a abp = N of ('a abp * 'a * 'a abp) | V ;;

let rec lookup = function
    V -> (function _ -> false)
  | N (l,v,r) -> function x ->
                     if x=v then true else
                     if x<v then (lookup l x) else
                                 (lookup r x);;

let rec insert = function
  | V -> (function x -> N (V,x,V))
  | N (l,v,r) -> function x ->
                     if x=v then N (l,x,r) else
                     if x<v then N ((insert l x),v,r) else
                                 N (l,v,(insert r x));;

let rec elements= function
  | V -> []
  | N (r, v, l) -> app (app (elements r) [v]) (elements l);;

type numeral = Z | S of numeral;;

let rec cont = function
  | Z -> 0
  | S (v) -> 1 + cont v;;

let rec num_to_numeral = function
  | 0 -> Z
  | x -> S (num_to_numeral (x-1));;