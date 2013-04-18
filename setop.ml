#! /usr/bin/env ocamlscript
Ocaml.packs := [ "batteries" ]
--

module A  = Array
module F  = Filename
module BL = BatList
module BF = BatFile
module BS = BatString
module L  = List
module S  = String

(* like Python's readlines() *)
let string_list_of_file f =
  BL.of_enum (BF.lines_of f)

let atof = float_of_string

let enforce_file_extension filename ext =
  if not (F.check_suffix filename ext) then
    failwith ("file " ^ filename ^ " not a " ^ ext)
  else
    ()

(* 0                             30      38      46 *)
(* ATOM      1  N   SER A   2     102.339  64.887 -31.457  1.00 90.43 *)
let xyz_of_pdb_line pdb_line =
  let x_str = S.sub pdb_line 30 8 in
  let y_str = S.sub pdb_line 38 8 in
  let z_str = S.sub pdb_line 46 8 in
  try ((atof x_str, atof y_str, atof z_str), pdb_line)
  with _ -> failwith ("can't parse this line:" ^ pdb_line)

let squared_dist (x1, y1, z1) (x2, y2, z2) =
  (x1 -. x2) ** 2. +.
  (y1 -. y2) ** 2. +.
  (z1 -. z2) ** 2.

let is_atom_or_heteroatom l =
  BS.starts_with l "ATOM" ||
  BS.starts_with l "HETATM"

let fail_on_empty_list l f =
  match l with
      [] -> Printf.fprintf stderr "no lines selected from %s\n" f;
            exit 1;
    | _  -> ()
;;

(* main *)
let argc = A.length Sys.argv in
if argc != 4 then begin
  Printf.fprintf stderr "%s"
    (" ERROR: incorrect number of parameters\n" ^
     " USAGE: " ^ Sys.argv.(0) ^ " protein_only_pdb ligand_only_pdb radius\n" ^
  (*              0                1                2               3      4 *)
     " warning: ALL the ATOM and HETATM lines of your files will be\n" ^
     "          considered. Edit PDBs by hand before if you are not happy\n" ^
     "          with this.\n");
  exit 1;
end else begin
  let protein_file, ligand_file = Sys.argv.(1), Sys.argv.(2) in
  enforce_file_extension protein_file ".pdb";
  enforce_file_extension ligand_file  ".pdb";
  let acceptance_radius = (atof (Sys.argv.(3))) ** 2. in
  let protein_atoms     =
    BL.map xyz_of_pdb_line
      (L.filter is_atom_or_heteroatom (string_list_of_file protein_file)) in
  fail_on_empty_list protein_atoms protein_file;
  let ligand_atoms      =
    BL.map xyz_of_pdb_line
      (L.filter is_atom_or_heteroatom (string_list_of_file ligand_file))  in
  fail_on_empty_list ligand_atoms ligand_file;
  let selected_protein_lines =
    L.filter
      (fun (xyz_p, _) ->
       let min_dist = BL.min
         (BL.map (fun (xyz_l, _) -> squared_dist xyz_p xyz_l) ligand_atoms) in
       min_dist < acceptance_radius)
      protein_atoms in
  L.iter (fun (_, l) -> Printf.printf "%s\n" l) selected_protein_lines;
end
