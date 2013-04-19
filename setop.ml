#!/usr/bin/env ocamlscript
Ocaml.packs := [ "str"; "dolog" ]
--

(* set operations on unsorted text file lines *)

open Printf

module HT = Hashtbl
module L  = List
module S  = String
module SS = Set.Make(String)

type set_op = Union | Inter | Diff

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
  (ht, !set)

(* main *)

(* process options *)

type options =
    { f1   : string ref ;
      f2   : string ref ;
      op   : string ref ;
      out  : string ref ;
      debug: bool ref   }

let opts = { f1 = ref "";
             f2 = ref "";
             op = ref "";
             out = ref "/dev/stdout: ";
             debug = ref false } in

Arg.parse
  [("-f1", Arg.Set_string opts.f1   , "file1:'sepchar':colnum");
   ("-f2", Arg.Set_string opts.f2   , "file2:'sepchar':colnum");
   ("-op", Arg.Set_string opts.op   , "opchar u: union); n: intersection); \
                                       m2: set1 - set2); \
                                       m1: set2 - set1"       );
   ("-o" , Arg.Set_string opts.out  , "output:'sepchar'"      );
   ("-v" , Arg.Set        opts.debug, " debug mode"           )]
  (fun _ -> ())
  "FBR: write this";

if !(opts.f1) = "" then failwith "-f1 is mandatory";
if !(opts.f2) = "" then failwith "-f2 is mandatory";
if !(opts.op) = "" then failwith "-op is mandatory";

(* extract sep. chars and col. numbers *)
let f1, sep1, col1 =
  Scanf.sscanf !(opts.f1) "%s:%c:%d" (fun f sep col -> (f, sep, col)) in
let f2, sep2, col2 =
  Scanf.sscanf !(opts.f2) "%s:%c:%d" (fun f sep col -> (f, sep, col)) in
let out, oset =
  Scanf.sscanf !(opts.out) "%s:%c" (fun f sep -> f, sep) in

(* create the 1st key set and hash table *)
let set1, ht1 = process_file f1 sep1 col1 in

(* create the 2nd key set and hash table *)
let set2, ht2 = process_file f2 sep2 col2 in

(* operate on the key sets *)

(* create and output concatenated lines *)

eprintf "The END\n";
exit 0
