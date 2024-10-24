(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
(*Defining direct sum, sum, intersection, and isIn for Subspace*)
Subspace/:Subspace[v1s_, gen1s_]\[CirclePlus]Subspace[v2s_, gen2s_]:=CF@Subspace[v1s \[Union]v2s,gen1s \[Union]gen2s];
Subspace/:Subspace[vs_,gen1s_]+Subspace[vs_,gen2s_]:=CF@Subspace[vs,gen1s \[Union]gen2s];
Subspace/:sub1_Subspace\[Intersection]sub2_Subspace:=Perp[Perp[sub1]+Perp[sub2]];
Subspace/:v_\[Element]Subspace[vs_, gens_]:=(Subspace[vs, gens]\[Intersection]Subspace[vs, {v}])[[2]]=!={};


(* ::Input::Initialization:: *)
(*Evaluating a Quadratic form on 1 vector gives a dual element, and on 2 vectors gives a scalar*)
Eval[Q_,v_,w_]:=Expand[Q v w]//. {Subscript[\[Eta], i__] Subscript[y, i__]:>1,\!\(
\*SubsuperscriptBox[\(\[Eta]\), \(i__\), \(2\)] 
\*SubsuperscriptBox[\(y\), \(i__\), \(2\)]\):>2}/.Subscript[(\[Eta]|y), __]->0;

(*Evaluating a dual element on a vector gives a scalar*)
Eval[\[Phi]_,v_]:=Expand[\[Phi] v]/.{Subscript[\[Eta], i__] Subscript[y, i__]:>1, \!\(
\*SubsuperscriptBox[\(\[Eta]\), \(i__\), \(2\)] 
\*SubscriptBox[\(y\), \(i__\)]\):>2Subscript[\[Eta], i]}/.Subscript[y, __]->0;


(* ::Input::Initialization:: *)
(*Getting positions of pivots*)
Pivot[vs_List]:=Position[vs, 1][[1,1]];

(*Defining duals*)
\!\(
\*SubsuperscriptBox[\(y\), \(i__\), \(*\)] := 
\*SubscriptBox[\(\[Eta]\), \(i\)]\); 
\!\(
\*SubsuperscriptBox[\(\[Eta]\), \(i__\), \(*\)] := 
\*SubscriptBox[\(y\), \(i\)]\); 
SuperStar[(vs_List)]:=Table[SuperStar[v],{v,vs}];


(* ::Input::Initialization:: *)
(*Defining direct sum of PQs*)
PQ/:PQ[sub1_, Q1_]\[CirclePlus]PQ[sub2_, Q2_]:=CF@PQ[sub1\[CirclePlus]sub2, Q1+Q2];
PQ/:CirclePlus[PQ1_PQ, PQs__PQ]:=CirclePlus@@Join[{PQ1\[CirclePlus]First[{PQs}]}, {PQs}[[2;;]]];


(* ::Input::Initialization:: *)
Restrict[PQ[sub1_, Q_], sub2_]:=PQ[sub1\[Intersection]sub2, Q];
Restrict[PQ[Subspace[vs_, gens_], Q_], i_, j_]:=Restrict[PQ[Subspace[vs, gens], Q], Subspace[vs,  Join[Complement[vs, {Subscript[y, i], Subscript[y, j]}], {Subscript[y, i]+Subscript[y, j]}]]];


(* ::Input::Initialization:: *)
Project[PQ[Subspace[{},_], _],_]:=PQ[Subspace[{}, {}],0];
Project[PQ[Subspace[vs_,{}], _],pivs_]:=PQ[Subspace[pivs, {}],0];
Project[PQ[_], {}]:=PQ[Subspace[{},{}],0];
Project[PQ[Subspace[vs_, gens_], Q_], pivs_List]:=Module[{rref,newvs,newgens,newQ},
newvs=Join[pivs, Complement[vs,pivs]];
rref=DeleteCases[RowReduce[Table[Coefficient[g, v], {g, gens}, {v, newvs}]],{0..}];
newQ=Sum[Eval[Q,row . newvs,row2 . newvs ]SuperStar[newvs[[Pivot[row]]]] SuperStar[newvs[[Pivot[row2]]]]/2, {row,rref},{row2,rref}];
PQ[Subspace[pivs,rref . newvs/.Alternatives@@Complement[vs, pivs]->0],newQ ]];
Project[PQ[Subspace[vs_, gens_], Q_], i_Integer]:=Project[PQ[Subspace[vs, gens], Q], Complement[vs, {Subscript[y, i]}]];


(* ::Input::Initialization:: *)
CF[PQ[Subspace[vs_, gens_],Q_]]:=Project[PQ[Subspace[vs, gens], Q], Sort[vs]];
CF[sub_Subspace]:=CF[PQ[sub, 0]][[1]];


(* ::Input::Initialization:: *)
Perp[Subsp_]:=Module[{pp, cvs, cgens},
{cvs, cgens}=List@@CF@Subsp;
pp=SuperStar[Complement[cvs,Pivot/@cgens]];
CF@Subspace[SuperStar[cvs],
Table[p-Sum[Coefficient[g,SuperStar[p]]SuperStar[Pivot[g]],{g,cgens}],{p,pp}]
]
]


(* ::Input::Initialization:: *)
Subscript[Ann, PQ[\[ScriptCapitalD]_Subspace,Q_]][Subspace[vs_,gens_]]:=\[ScriptCapitalD]\[Intersection]Perp@Subspace[SuperStar[vs],Table[Eval[Q,g],{g,gens}]]


(* ::Input::Initialization:: *)
Sig[PQ[Subspace[vs_, gens_], Q_]]:=Plus@@Sign@Eigenvalues[Table[Eval[Q, v, w], {v, gens}, {w, gens}]];



