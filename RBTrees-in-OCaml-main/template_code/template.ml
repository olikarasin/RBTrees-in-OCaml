(* Prelude *)
exception NotImplemented

(* red black tree colours *)
type color = Red | Black

(* Red-Black Tree nodes *)
type 'a rb_tree = 
  | Nil 
  | Node of color * 'a * 'a rb_tree * 'a rb_tree

(* Functions *)

(* 1. Insertion *)

(* TODO: Implement balance function for insertion *)
let balance (color : color) (a : int) (left : 'a rb_tree) (right : 'a rb_tree) : 'a rb_tree = 
  match color, a, left, right with
  (* pattern match the 4 cases *)
  | _, _, _, _ ->
    raise NotImplemented
  | a, b, c, d -> Node (a, b, c, d)

(* TODO: Implement non-tail-recursive insert function *)
let insert (t: 'a rb_tree) (x: 'a): 'a rb_tree =
  let rec insert_aux = function
  | Nil -> raise NotImplemented
  | Node (_,_,_,_) -> raise NotImplemented
in
raise NotImplemented

(* TODO: Implement tail-recursive insert function *)
let insert_tr (tree: 'a rb_tree) (value: 'a): 'a rb_tree =
  raise NotImplemented

(* 2. deletion *)

(* Helper to recolor a node to black *)
let recolor node =
  match node with
  | Node (_, x, l, r) -> Node (Black, x, l, r)
  | Nil -> Nil

(* Helper to find the min value node in the subtree *)
let rec min_value_node = function
  | Nil -> failwith "Empty subtree: No minimum node"
  | Node (_, x, Nil, _) -> x
  | Node (_, _, left, _) -> min_value_node left

(* TODO: Implement balance_delete function for deletion balancing *)
let balance_delete (node : 'a rb_tree) : 'a rb_tree =
  match node with
  | Node (Black, x, Node (Red, y, a, b), Node (Black, z, c, d))
  | Node (Black, y, Node (Black, x, a, b), Node (Red, z, c, d)) -> raise NotImplemented
  | _ -> node

(* TODO: Implement delete function *)
let delete (tree : 'a rb_tree) (n :'a) : 'a rb_tree =
  let rec del node =
    match node with
    | Nil -> Nil
    | Node (color, x, left, right) ->
        if n < x then
          raise NotImplemented
        else if n > x then
          raise NotImplemented
        else
          (* Found the node to delete *)
          match left, right with
          | Nil, Nil -> Nil
          | Nil, _ -> raise NotImplemented
          | _, Nil -> raise NotImplemented
          | _ -> raise NotImplemented
  in
  match del tree with
  | Node (_, x, left, right) -> Node (Black, x, left, right)
  | Nil -> Nil


(* 3. Tree validity *)

(* TODO: Implement is_valid function to check if the tree satisfies Red-Black properties *)
  let is_valid (tree : 'a rb_tree) : bool =
    let rec black_height = function
      | Nil -> 1
      | Node (c, _, l, r) -> raise NotImplemented
    in
    let rec no_red_with_red_child = function
      | Nil -> true
      | Node (color, _, left, right) ->
        match color with
        | Red -> raise NotImplemented
        | Black -> raise NotImplemented
    in
    (black_height tree > 0) && no_red_with_red_child tree