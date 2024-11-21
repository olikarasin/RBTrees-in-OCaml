(* define the colours red and black to be used in tree data type *)
type color = Red | Black

(* define the recursive data type for a tree *)
(* either Nil (Leaf) or a recursvie Node with a colour, a value, a left sub tree and right sub tree*)
type 'a rb_tree = 
  | Nil 
  | Node of color * 'a * 'a rb_tree * 'a rb_tree


(* 1. INSERT *)

(* balance helper function needed to Okasaki's insert algorithm *)
let balance (color, a, left, right) = match color, a, left, right with
  (* case 1 *)
  | Black, z, Node (Red, y, Node (Red, x, a, b), c), d
  (* case 2 *)
  | Black, z, Node (Red, x, a, Node (Red, y, b, c)), d
  (* case 3 *)
  | Black, x, a, Node (Red, z, Node (Red, y, b, c), d)
  (* case 4 *)
  | Black, x, a, Node (Red, y, b, Node (Red, z, c, d)) ->
    (* perform rotation *)
    Node (Red, y, Node (Black, x, a, b), Node (Black, z, c, d))
  | a, b, c, d -> Node (a, b, c, d)


let insert t x =
  let rec insert_aux = function
    | Nil -> Node (Red, x, Nil, Nil) (* colour the new node red *)
    (* BST insert - checking if larger or smaller than a node, and recursing down either the left or right *)
    (* balance is called in order to balance the result of each of the recursive calls *)
    | Node (color, y, a, b) as s ->
      if x < y then balance (color, y, insert_aux a, b)
      else if x > y then balance (color, y, a, insert_aux b)
      else s
  in
  match insert_aux t with
  (* colour the root black *)
  | Node (_, y, a, b) -> Node (Black, y, a, b)
  (* this will never happen, but needed for exhaustive pattern match *)
  | Nil -> failwith "failed"


let insert_tr s x =
  let rec insert_aux path = function
    | Nil ->
        let new_node = Node (Red, x, Nil, Nil) in
        List.fold_left
          (fun acc (color, value, direction) ->
              match direction with
              | `Left -> balance (color, value, acc, Nil)
              | `Right -> balance (color, value, Nil, acc))
          new_node path
    | Node (color, y, left, right) as node ->
        if x < y then insert_aux ((color, y, `Left) :: path) left
        else if x > y then insert_aux ((color, y, `Right) :: path) right
        else
          List.fold_left
            (fun acc (color, value, direction) ->
                match direction with
                | `Left -> balance (color, value, acc, Nil)
                | `Right -> balance (color, value, Nil, acc))
            node path
  in
  match insert_aux [] s with
  | Node (_, value, left, right) -> Node (Black, value, left, right)
  | Nil -> failwith "failed"

(* 2. DELETION *)
(* Helper to recolor a node to black *)
let recolor node =
  match node with
  | Node (_, x, l, r) -> Node (Black, x, l, r)
  | Nil -> Nil

(* Find the minimum value node in the subtree *)
let rec min_value_node = function
  | Nil -> failwith "Empty subtree: No minimum node"
  | Node (_, x, Nil, _) -> x
  | Node (_, _, left, _) -> min_value_node left

(* Balancing the tree after deletion *)
let balance_delete node =
  match node with
  | Node (Black, x, Node (Red, y, a, b), Node (Black, z, c, d))
  | Node (Black, y, Node (Black, x, a, b), Node (Red, z, c, d)) ->
      Node (Red, y, Node (Black, x, a, b), Node (Black, z, c, d))
  | _ -> node

(* Delete a value from the Red-Black Tree *)
let delete tree n =
  let rec del node =
    match node with
    | Nil -> Nil
    | Node (color, x, left, right) ->
        if n < x then
          balance_delete (Node (color, x, del left, right))
        else if n > x then
          balance_delete (Node (color, x, left, del right))
        else
          (* Found the node to delete *)
          match left, right with
          | Nil, Nil -> Nil
          | Nil, _ -> recolor right
          | _, Nil -> recolor left
          | _ ->
              let m = min_value_node right in
              balance_delete (Node (color, m, left, del right))
  in
  match del tree with
  | Node (_, x, left, right) -> Node (Black, x, left, right)
  | Nil -> Nil


(* 3. VALIDITY *)
(* Check for validity of Red-Black Tree *)
let is_valid tree =
  let rec black_height = function
    | Nil -> 1
    | Node (c, _, l, r) ->
        let left_bh = black_height l in
        let right_bh = black_height r in
        if left_bh = 0 || right_bh = 0 || left_bh <> right_bh then 0
        else
          (* Add 1 to black height if the node is Black *)
          left_bh + (if c = Black then 1 else 0)
  in
  let rec no_red_with_red_child = function
    | Nil -> true
    | Node (color, _, left, right) ->
      match color with
      | Red ->
          (match left, right with
           | Node (Red, _, _, _), _ | _, Node (Red, _, _, _) -> false
           | _ -> no_red_with_red_child left && no_red_with_red_child right)
      | Black ->
          no_red_with_red_child left && no_red_with_red_child right
  in
  (black_height tree > 0) && no_red_with_red_child tree


(* tests *)
(* Helper function to insert a list of values into a Red-Black Tree *)
(* Helper function to format a node's display *)
let format_node color value =
  match color with
  | Red -> Printf.sprintf "R - %d" value
  | Black -> Printf.sprintf "B - %d" value

(* Helper to print spaces for indentation *)
let print_spaces n =
  for _ = 1 to n do
    print_string " "
  done

(* Recursive helper to print the tree with indentation *)
let rec print_tree_with_indent tree indent =
  match tree with
  | Nil ->
      print_spaces indent;
      print_endline "Nil"
  | Node (color, value, left, right) ->
      (* Print right subtree first for a sideways view *)
      print_tree_with_indent right (indent + 4);
      (* Print current node with its color and value *)
      print_spaces indent;
      Printf.printf "%s\n" (format_node color value);
      (* Print left subtree *)
      print_tree_with_indent left (indent + 4)

(* Main function to print the entire tree *)
let print_tree tree =
  print_endline "Red-Black Tree Structure:";
  print_tree_with_indent tree 0

let insert_all tree values =
  List.fold_left insert tree values

(* Helper function to print a tree and a separator line *)
let print_and_separator tree =
  print_tree tree;
  Printf.printf "Is valid RBT: %b\n" (is_valid tree);
  print_endline "---------------------------------------"

(* Test 1: Inserting values in ascending order *)
let test_ascending_order () =
  let tree = insert_all Nil [10; 20; 30; 40; 50] in
  print_endline "Test 1: Inserting values in ascending order";
  print_and_separator tree

(* Test 2: Inserting values in descending order *)
let test_descending_order () =
  let tree = insert_all Nil [50; 40; 30; 20; 10] in
  print_endline "Test 2: Inserting values in descending order";
  print_and_separator tree

(* Test 3: Inserting a balanced sequence of values *)
let test_balanced_sequence () =
  let tree = insert_all Nil [30; 15; 45; 10; 20; 40; 50] in
  print_endline "Test 3: Inserting a balanced sequence of values";
  print_and_separator tree

(* Test 4: Inserting values that require left rotation *)
let test_left_rotation () =
  let tree = insert_all Nil [10; 15; 20] in
  print_endline "Test 4: Inserting values that require left rotation";
  print_and_separator tree

(* Test 5: Inserting values that require right rotation *)
let test_right_rotation () =
  let tree = insert_all Nil [20; 15; 10] in
  print_endline "Test 5: Inserting values that require right rotation";
  print_and_separator tree

(* Test 6: Inserting a value that is already in the tree *)
let test_inserting_duplicate () =
  let tree = insert_all Nil [10; 20; 15; 20] in
  print_endline "Test 6: Inserting a duplicate value (20)";
  print_and_separator tree

(* Test 7: Complex sequence of inserts that requires multiple rotations *)
let test_complex_inserts () =
  let tree = insert_all Nil [50; 20; 60; 10; 30; 70; 25; 5; 15] in
  print_endline "Test 7: Complex sequence of inserts";
  print_and_separator tree

(* Test 8: Inserting a single element *)
let test_single_insert () =
  let tree = insert Nil 42 in
  print_endline "Test 8: Inserting a single element (42)";
  print_and_separator tree

(* Test 9: Inserting values to create a tree of height 3 *)
let test_height_3_tree () =
  let tree = insert_all Nil [20; 10; 30; 5; 15; 25; 35] in
  print_endline "Test 9: Creating a tree of height 3";
  print_and_separator tree

(* Test 10: Inserting a sequence that requires rebalancing *)
let test_root_color_change () =
  let tree = insert_all Nil [10; 20; 15] in
  print_endline "Test 10: Inserting values that cause root recoloring";
  print_and_separator tree

(* Run all tests *)
let run_tests () =
  test_ascending_order ();
  test_descending_order ();
  test_balanced_sequence ();
  test_left_rotation ();
  test_right_rotation ();
  test_inserting_duplicate ();
  test_complex_inserts ();
  test_single_insert ();
  test_height_3_tree ();
  test_root_color_change ();;

(* Execute the tests *)
run_tests ()
