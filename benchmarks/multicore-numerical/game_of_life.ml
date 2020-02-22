let n_times = try int_of_string Sys.argv.(1) with _ -> 2

let get g x y =
  try g.(x).(y)
  with _ -> 0

let neighbourhood g x y =
  (get g (x-1) (y-1)) +
  (get g (x-1) (y  )) +
  (get g (x-1) (y+1)) +
  (get g (x  ) (y-1)) +
  (get g (x  ) (y+1)) +
  (get g (x+1) (y-1)) +
  (get g (x+1) (y  )) +
  (get g (x+1) (y+1))

let next_cell g x y =
  let n = neighbourhood g x y in
  match g.(x).(y), n with
  | 1, 0 | 1, 1                      -> 0  (* lonely *)
  | 1, 4 | 1, 5 | 1, 6 | 1, 7 | 1, 8 -> 0  (* overcrowded *)
  | 1, 2 | 1, 3                      -> 1  (* lives *)
  | 0, 3                             -> 1  (* get birth *)
  | _ (* 0, (0|1|2|4|5|6|7|8) *)     -> 0  (* barren *)

let copy g = Array.map Array.copy g

let next g =
  let width = Array.length g
  and height = Array.length g.(0)
  and new_g = copy g in
  for x = 0 to pred width do
    for y = 0 to pred height do
      new_g.(x).(y) <- (next_cell g x y)
    done
  done;
  (new_g)

let print g =
  let width = Array.length g
  and height = Array.length g.(0) in
  for x = 0 to pred width do
    for y = 0 to pred height do
      if g.(x).(y) = 0
      then print_char '.'
      else print_char 'o'
    done;
    print_newline()
  done

let rec repeat n g =
  match n with
  | 0 -> g
  | _ -> repeat (n-1) (next g)

let ()=
  let g = Array.init 1024 (fun _ -> Array.init 1024 (fun _ -> Random.int 2)) in
  print g;
  print (repeat n_times g)