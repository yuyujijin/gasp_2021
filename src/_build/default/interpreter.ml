open Syntax
open Turtle

(* créer un environnement de base avec toutes les variables avec comme valeur par défaut 0 *)
let rec create_env declarations =
  match declarations with
  | [] -> []
  | h :: t -> (h, 0) :: create_env t

(* Evalue une expression, compte donné des variables *)
let rec eval vars expr = 
  match expr with
  | Entier i -> i
  | Identificateur s -> let (_, v) = 
                        List.find (fun (i, _) -> i = s) vars
                        in v
  | Formule (e1, o, e2) ->
    match o with
    | Plus -> (eval vars e1) + (eval vars e2)
    | Moins -> (eval vars e1) - (eval vars e2)

(* Execute les instructions une a une *)
let rec exec vars instruction turtle =
  match instruction with
  | Avance e -> let v = eval vars e in
                (execute turtle (Forward v), vars)
  | Tourne e -> let v = eval vars e in
                (execute turtle (Turn v), vars)
  | BasPinceau -> (execute turtle BasPinceau, vars)
  | HautPinceau -> (execute turtle HautPinceau, vars)
  | Affectation (s, e) -> let v = eval vars e in
                          (turtle, List.map 
                          (fun (id, valeur) -> 
                            if id = s 
                            then (id, v) 
                            else (id, valeur)
                          ) 
                          vars)
  | BlocInstruction il -> exec_list vars il turtle
(* et execute une liste d'instruction *)
and exec_list vars l turtle =
  match l with
  | [] -> (turtle, vars)
  | h :: t -> let (turtle, vars) = exec vars h turtle
              in exec_list vars t turtle

let interprate (declarations, instruction) = 
  let turtle = create_window 200 200 in
  exec (create_env declarations) instruction turtle


 