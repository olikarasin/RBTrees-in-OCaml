
# **Implementing Red-Black Trees in OCaml**

## **Introduction**

A Red-Black Tree is a self-balancing binary search tree (BST) where each node contains an additional bit of information: a color (red or black). This additional property ensures that the tree remains balanced, providing an efficient O(log n) time complexity for insertion, deletion, and search operations.

In this implementation, you will use functional programming principles to implement a Red-Black Tree in OCaml. The project focuses on three key components: **insertion**, **deletion**, and **tree validity checking**. Each of these components ensures that the Red-Black Tree adheres to its five defining properties.

## **Red-Black Tree Properties**

1. **Every node is either red or black.**
2. **The root node is black.**
3. **All leaves (`Nil`) are black.**
4. **Red nodes cannot have red children.**
5. **Every path from a node to its descendant leaves contains the same number of black nodes.** (This is referred to as the black-height.)

Violations of these properties during insertion or deletion must be resolved to maintain the tree's balance and validity.

---

## **Data Type Definitions**

1. **Color Type**: Represents the color of a node.
   ```ocaml
   type color = Red | Black
   ```

2. **Tree Type**: Recursive data structure representing the tree.
   ```ocaml
   type 'a rb_tree =
     | Nil
     | Node of color * 'a * 'a rb_tree * 'a rb_tree
   ```

The `Nil` nodes represent black leaves, while the `Node` stores a value, a color, and references to left and right subtrees.

---

## **1. Insertion**

Insertion involves adding a new node while preserving the tree's properties. After a standard BST insertion, you must **rebalance** the tree using the `balance` function. 

### **Helper Function: `balance`**
The `balance` function handles the four rebalancing cases that occur when a red node has a red parent. The key steps include rotations and recoloring to restore the tree's properties.

```ocaml
let balance (color : color) (value : 'a) (left : 'a rb_tree) (right : 'a rb_tree) : 'a rb_tree = 
  match color, value, left, right with
  | (* TODO: Add pattern matching for the four cases *)
  | _, _, _, _ -> Node (color, value, left, right)
```

### **Insertion Function**
You will implement both non-tail-recursive (`insert`) and tail-recursive (`insert_tr`) versions of the insertion function. 

```ocaml
let insert (tree: 'a rb_tree) (value: 'a): 'a rb_tree =
  let rec insert_aux = function
    | Nil -> (* TODO: Add base case for inserting a new node *)
    | Node (_,_,_,_) -> (* TODO: Add recursive case for BST insertion with balancing *)
  in
  (* TODO: Ensure the root remains black after insertion *)
```

**Key Insight**: The functional implementation of insertion differs from imperative implementations. Okasaki's algorithm emphasizes immutability and elegant recursion, often resulting in structurally distinct but valid trees.

---

## **2. Deletion**

Deletion involves removing a node while maintaining Red-Black properties. If the removed node is black, special handling is required to restore the black-height, often creating a **double-black** situation.

### **Helper Functions**
- **`recolor`**: Ensures that the replacement node remains black.
- **`min_value_node`**: Finds the smallest value in the right subtree when replacing a node with two children.
- **`balance_delete`**: Resolves violations caused by double-black nodes through rotations and recoloring.

```ocaml
let balance_delete (node : 'a rb_tree) : 'a rb_tree =
  match node with
  | (* TODO: Handle rebalancing cases during deletion *)
  | _ -> node
```

### **Deletion Function**
```ocaml
let delete (tree : 'a rb_tree) (value: 'a): 'a rb_tree =
  let rec del node =
    match node with
    | Nil -> (* TODO: Handle the case where the value is not found *)
    | Node (_,_,_,_) -> (* TODO: Implement recursive deletion and rebalancing *)
  in
  (* TODO: Ensure the root remains black after deletion *)
```

---

## **3. Tree Validity**

Validation ensures that the tree adheres to the five Red-Black properties. Use the following helper functions:

1. **`black_height`**: Computes the black-height of each path and checks for consistency.
2. **`no_red_with_red_child`**: Ensures no red node has a red child.

```ocaml
let is_valid (tree : 'a rb_tree) : bool =
  let rec black_height = function
    | Nil -> (* TODO: Implement base case for leaves *)
    | Node (_,_,_,_) -> (* TODO: Compute and validate black-height *)
  in
  let rec no_red_with_red_child = function
    | Nil -> true
    | Node (Red,_,Node (Red,_,_,_),_)
    | Node (Red,_,_,Node (Red,_,_,_)) -> false
    | Node (_,_,_,_) -> (* TODO: Traverse and validate child nodes *)
  in
  (* TODO: Combine black-height and red-violation checks *)
```

---

## **Conclusion**

This problem challenges you to implement Red-Black Tree operations using functional programming principles. Focus on recursive logic, immutability, and balancing strategies. Use helper functions like `balance` and `balance_delete` to encapsulate complex rebalancing logic. By adhering to the Red-Black properties, your implementation will maintain tree balance and efficiency.

Good luck, and remember to test thoroughly at each step!
