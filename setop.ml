#! /usr/bin/env ocamlscript
Ocaml.packs := [ "batteries" ]
--

(* set operations on unsorted text file lines *)

open Printf

type set_op = Union | Inter | Diff

module L = BatList
module F = BatFile
module S = BatString
(* module Set = StringSet *)

type all_options =
    { in1  : string ref ; (* first input file *)
      in2  : string ref ; (* second input file *)
      op   : string ref ; (* set operator *)
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

(* create the 1st key set and hash table *)

(* create the 2nd key set and hash table *)

(* operate on the key sets *)

(* create and output concatenated lines *)
