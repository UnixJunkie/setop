#! /usr/bin/env ocamlscript
Ocaml.packs := [ "batteries" ]
--

(* set operations on unsorted text file lines *)

open Printf

type set_op = Union | Inter | Diff

module L  = BatList
module F  = BatFile
module S  = BatString
module SS = Set.Make (String)

type all_options =
    { f1   : string ref ; (* first input file *)
      f2   : string ref ; (* second input file *)
      op   : string ref ; (* set operation *)
      sep1 : char ref   ; (* field separator in f1
                             FBR: maybe a string ref later on *)
      sep2 : char ref   ; (* field separator in f2 *)
      osep : char ref   ; (* field separator in output file *)
      out  : string ref ; (* output file *)
      col1 : int ref    ; (* key field number in f1 *)
      col2 : int ref    ; (* key field number in f2 *)
      debug: bool ref   }

(* main *)

(* process options *)
let opts = {
  f1 = ref "";
  f2 = ref "";
  op = ref "";
  sep1 = ref ' ';
  sep2 = ref ' ';
  osep = ref ' ';
  out = ref "/dev/stdout";
  col1 = ref 1;
  col2 = ref 1;
  debug = ref false} in
let cmd_line = Arg.align [
  "-f1", Arg.Set_string opts.f1   , "file1:'sepchar':colnum";
  "-f2", Arg.Set_string opts.f2   , "file2:'sepchar':colnum";
  "-op", Arg.Set_string opts.op   , "opchar u: union; n: intersection; \
                                     m2: set1 - set2; \
                                     m1: set2 - set1"       ;
  "-o ", Arg.Set_string opts.out  , "output:'sepchar'"      ;
  "-v" , Arg.Set        opts.debug, " debug mode"           ] in
let use_msg = sprintf
  "usage: %s -db fragments_file -q query_frag -d 0.5 -n 10 -o out \
             -idx fragments_RMSD_index [-x exclude_file] [-f] [-v] \
                                       [-m {t2t|b2t|b2b}]"
  Sys.argv.(0) in
Arg.parse cmd_line ignore use_msg;

(* create the 1st key set and hash table *)

(* create the 2nd key set and hash table *)

(* operate on the key sets *)

(* create and output concatenated lines *)
()
