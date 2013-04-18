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
      op   : set_op     ; (* set operation *)
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
  op = Inter;
  sep1 = ref ' ';
  sep2 = ref ' ';
  osep = ref ' ';
  out = ref "/dev/stdout";
  col1 = ref (-1);
  col2 = ref (-1);
  debug = ref false} in
(* let cmd_line = Arg.align [ *)
(*   "-d"  , Arg.Set_float  opts.d    , "distance_to_query (> 0.0)"       ; *)
(*   "-db" , Arg.Set_string opts.db   , "fragments_DB_file"               ; *)
(*   "-f"  , Arg.Set        opts.force, " force reindex (slow)"           ; *)
(*   "-idx", Arg.Set_string opts.index, "fragments_RMSD_index"            ; *)
(*   "-n"  , Arg.Set_int    opts.n    , "n_best only output the n \ *)
(*                                       best fragments"                  ; *)
(*   "-m"  , Arg.Set_string opts.mode , " [MODE] mode may be one of \ *)
(*       {t2t|b2t|b2b} \ *)
(*       (t2t: read and write pdb ATOM lines (default); \ *)
(*        b2t: read binary coordinates and output pdb ATOM lines; \ *)
(*        b2b: read and write binary coordinates)"                        ; *)
(*   "-x"  , Arg.Set_string opts.excl , "exclude_file one PDB id per line"; *)
(*   "-min", Arg.String (parse_min_option_string opts), *)
(*   "N:dx min_nb_frags:query_dist_delta (incompatible with -max)"; *)
(*   "-max", Arg.String (parse_max_option_string opts), *)
(*   "N:dx max_nb_frags:query_dist_delta (incompatible with -min)"; *)
(*   "-np" , Arg.Set_int    opts.np   , "ncores"                          ; *)
(*   "-o"  , Arg.Set_string opts.out_f, "output_file"                     ; *)
(*   "-q"  , Arg.Set_string opts.query, "query_fragment"                  ; *)
(*   "-res", Arg.Set_string opts.res  , "1,2,8,9 \ *)
(*                                       coma-separated residue num. list"; *)
(*   "-seq", Arg.Set_string opts.filt , " sequence_regexp \ *)
(*                                        (use 1 char AA codes)"          ; *)
(*   "-v"  , Arg.Set        opts.debug, " debug mode"                     ] in *)
let use_msg = sprintf
  "usage: %s -db fragments_file -q query_frag -d 0.5 -n 10 -o out \
             -idx fragments_RMSD_index [-x exclude_file] [-f] [-v] \
                                       [-m {t2t|b2t|b2b}]"
  Sys.argv.(0) in
(* Arg.parse cmd_line ignore use_msg; *)

(* create the 1st key set and hash table *)

(* create the 2nd key set and hash table *)

(* operate on the key sets *)

(* create and output concatenated lines *)
()
