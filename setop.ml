#! /usr/bin/env ocamlscript
Ocaml.packs := [ "batteries" ]
--

(* set operations on unsorted text file lines *)

open Printf

type set_op = Union | Inter | Diff

module F  = BatFile
module HT = Hashtbl
module L  = BatList
module S  = BatString
module SS = Set.Make (String)

type all_options =
    { f1   : string ref ;
      f2   : string ref ;
      op   : string ref ;
      out  : string ref ;
      debug: bool ref   }

let process_file f sepchar colnum =
  let ht = HT.create 1000 in
  let set = SS.empty in
  ht, set

(* main *)

(* process options *)
let opts = {
  f1 = ref "";
  f2 = ref "";
  op = ref "";
  out = ref "/dev/stdout:' '";
  debug = ref false} in
let cmd_line = Arg.align [
  "-f1", Arg.Set_string opts.f1   , "file1:'sepchar':colnum";
  "-f2", Arg.Set_string opts.f2   , "file2:'sepchar':colnum";
  "-op", Arg.Set_string opts.op   , "opchar u: union; n: intersection; \
                                     m2: set1 - set2; \
                                     m1: set2 - set1"       ;
  "-o ", Arg.Set_string opts.out  , "output:'sepchar'"      ;
  "-v" , Arg.Set        opts.debug, " debug mode"           ] in
let use_msg = sprintf "usage: %s FBR: write this" Sys.argv.(0) in
Arg.parse cmd_line ignore use_msg;

if !(opts.f1) = "" then failwith "-f1 is mandatory";
if !(opts.f2) = "" then failwith "-f2 is mandatory";
if !(opts.op) = "" then failwith "-op is mandatory";

(* extract sep. chars and col. numbers *)
let f1, sep1, col1 =
  Scanf.sscanf !(opts.f1) "%s:%c:%d" (fun f sep col -> f, sep, col) in
let f2, sep2, col2 =
  Scanf.sscanf !(opts.f2) "%s:%c:%d" (fun f sep col -> f, sep, col) in

(* create the 1st key set and hash table *)
let set1, ht1 = process_file f1 sep1 col1 in

(* create the 2nd key set and hash table *)
let set2, ht2 = process_file f2 sep2 col2 in

(* operate on the key sets *)

(* create and output concatenated lines *)
eprintf "The END\n";
exit 0
