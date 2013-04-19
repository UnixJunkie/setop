
(* set operations on unsorted text file lines *)

(* open Log *)
open Printf

module HT = Hashtbl
module L  = List
module S  = String
module SS = Set.Make(String)

type set_op = Union | Inter | Diff1 | Diff2

(* split 's' using separator 'sep' *)
let str_split sep s =
  Str.split (Str.regexp_string sep) s

let process_file f sepchar colnum =
  let input = open_in f in
  let ht = HT.create 1000 in
  let set = ref SS.empty in
  (try
     while true do
       let l = input_line input in
       let split = str_split (S.make 1 sepchar) l in
       let key = L.nth split (colnum - 1) in
       HT.add ht key l;
       set := SS.add key !set;
     done;
   with End_of_file -> ());
  close_in input;
  (!set, ht)

(* parse the set operator option *)
let setop_of_string = function
  | "u" -> Union
  | "n" -> Inter
  | "m1" -> Diff1
  | "m2" -> Diff2
  | s -> failwith ("unknown set operator: %s" ^ s)

type options =
    { f1   : string ref ;
      f2   : string ref ;
      op   : string ref ;
      out  : string ref }

let main () =

  (* set_log_level INFO; *)

  (* process options *)

  (* default ones *)
  let opts = { f1 = ref "";
               f2 = ref "";
               op = ref "";
               out = ref "/dev/stdout: " } in

  Arg.parse
    [("-f1", Arg.Set_string opts.f1   , "\"file1:sepchar:colnum\"");
     ("-f2", Arg.Set_string opts.f2   , "\"file2:sepchar:colnum\"");
     ("-op", Arg.Set_string opts.op   , "opchar u: union; n: intersection; \
                                         m2: set1 - set2; \
                                         m1: set2 - set1"     );
     ("-o" , Arg.Set_string opts.out  , "\"output:sepchar\""  )]
  (fun _ -> ())
    (sprintf "usage: %s -f1 \"in1.csv:,:4\" -f2 \"in2.csv:,:1\" -op n \
                        -o \"out.csv:,\"" Sys.argv.(0));

  if !(opts.f1) = "" then failwith "-f1 is mandatory";
  if !(opts.f2) = "" then failwith "-f2 is mandatory";
  if !(opts.op) = "" then failwith "-op is mandatory";

  (* printf "f1: %s\n" !(opts.f1); *)
  (* printf "f2: %s\n" !(opts.f2); *)
  (* printf "out: %s\n" !(opts.out); *)

  (* extract sep. chars and col. numbers *)
  let f1, sep1, col1 = match str_split ":" !(opts.f1) with
    | f :: sep :: col :: [] -> (f, sep.[0], int_of_string col)
    | _ -> failwith ("strange -f1: " ^ !(opts.f1)) in
  let f2, sep2, col2 = match str_split ":" !(opts.f2) with
    | f :: sep :: col :: [] -> (f, sep.[0], int_of_string col)
    | _ -> failwith ("strange -f2: " ^ !(opts.f2)) in
  let out, osep = match str_split ":" !(opts.out) with
    | f :: sep :: [] -> (f, sep.[0])
    | _ -> failwith ("strange -o: " ^ !(opts.out)) in

  (* create the 1st key set and hash table *)
  let set1, ht1 = process_file f1 sep1 col1 in

  (* create the 2nd key set and hash table *)
  let set2, ht2 = process_file f2 sep2 col2 in

  (* operate on the key sets *)
  let final_set = match setop_of_string !(opts.op) with
    | Union -> SS.union set1 set2
    | Inter -> SS.inter set1 set2
    | Diff1 -> SS.diff  set2 set1
    | Diff2 -> SS.diff  set1 set2
  in

  (* create and output concatenated lines *)
  let output = open_out out in
  SS.iter
    (fun elt ->
      let s1 = HT.find ht1 elt in
      let s2 = HT.find ht2 elt in
      fprintf output "%s%c%s\n" s1 osep s2)
    final_set;
  close_out output
;;

main()
