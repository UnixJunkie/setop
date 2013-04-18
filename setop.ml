#! /usr/bin/env ocamlscript
Ocaml.packs := [ "batteries" ]
--

(* set operations on unsorted text file lines *)

open Printf

type set_op = Union | Inter | Diff

module L = BatList
module F = BatFile
module S = BatString

(* main *)

(* create the 1st key set and hash table *)

(* create the 2nd key set and hash table *)

(* operate on the key sets *)

(* create and output concatenated lines *)
