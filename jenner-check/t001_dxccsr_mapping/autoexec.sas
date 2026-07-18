/* cap input rows for the captured run */
options obs=100;

/* ------------------------------------------------------------------ */
/* Self-contained sample data for the CCSR mapping program.            */
/*                                                                     */
/* 1) The program reads the DXCCSR crosswalk CSV via the INRAW1        */
/*    fileref. Instead of a local path, we materialize a 14-row        */
/*    sample of the crosswalk into a TEMP fileref so the run needs no  */
/*    external files. Every ICD-10-CM code below is drawn from the     */
/*    repo's DXCCSR_v2025-1.csv, weighted toward Type 2 diabetes.      */
/* 2) The program expects a user-supplied SAS discharge dataset of     */
/*    ICD-10-CM codes (KEY, I10_NDX, I10_DX1..I10_DXn). That input is   */
/*    not part of the repo, so we build a tiny five-record stand-in of */
/*    Type 2 diabetes encounters here.                                 */
/* ------------------------------------------------------------------ */

filename INRAW1 temp lrecl=3000;
data _null_;
  file INRAW1;
  put "ICD-10-CM CODE,ICD-10-CM CODE DESCRIPTION,Default CCSR CATEGORY IP,Default CCSR CATEGORY DESCRIPTION IP,Default CCSR CATEGORY OP,Default CCSR CATEGORY DESCRIPTION OP,CCSR CATEGORY 1,CCSR CATEGORY 1 DESCRIPTION,CCSR CATEGORY 2,CCSR CATEGORY 2 DESCRIPTION,CCSR CATEGORY 3,CCSR CATEGORY 3 DESCRIPTION,CCSR CATEGORY 4,CCSR CATEGORY 4 DESCRIPTION,CCSR CATEGORY 5,CCSR CATEGORY 5 DESCRIPTION,CCSR CATEGORY 6,CCSR CATEGORY 6 DESCRIPTION,Rationale for Default Assignment";
  put "E1100,Type 2 diabetes mellitus with hyperosmolarity without nonketotic hyperglycemic-hyperosmolar coma (NKHHC),END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"", ,, ,, ,, ,,02 Diabetes mellitus";
  put "E1110,Type 2 diabetes mellitus with ketoacidosis without coma,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"", ,, ,, ,, ,,02 Diabetes mellitus";
  put "E1121,Type 2 diabetes mellitus with diabetic nephropathy,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"",GEN001,Nephritis; nephrosis; renal sclerosis, ,, ,, ,,02 Diabetes mellitus";
  put "E1122,Type 2 diabetes mellitus with diabetic chronic kidney disease,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"",GEN003,Chronic kidney disease, ,, ,, ,,02 Diabetes mellitus";
  put "E1129,Type 2 diabetes mellitus with other diabetic kidney complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"", ,, ,, ,, ,,02 Diabetes mellitus";
  put "E11311,Type 2 diabetes mellitus with unspecified diabetic retinopathy with macular edema,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"",EYE005,Retinal and vitreous conditions, ,, ,, ,,02 Diabetes mellitus";
  put "E1140,""Type 2 diabetes mellitus with diabetic neuropathy, unspecified"",END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"",NVS020,Other nervous system disorders (neither hereditary nor degenerative), ,, ,, ,,02 Diabetes mellitus";
  put "E1165,Type 2 diabetes mellitus with hyperglycemia,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"", ,, ,, ,, ,,02 Diabetes mellitus";
  put "E1169,Type 2 diabetes mellitus with other specified complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END003,Diabetes mellitus with complication,END005,""Diabetes mellitus, Type 2"", ,, ,, ,, ,,02 Diabetes mellitus";
  put "I10,Essential (primary) hypertension,CIR007,Essential hypertension,CIR007,Essential hypertension,CIR007,Essential hypertension, ,, ,, ,, ,, ,,0 Not Applicable";
  put "E785,""Hyperlipidemia, unspecified"",END010,Disorders of lipid metabolism,END010,Disorders of lipid metabolism,END010,Disorders of lipid metabolism, ,, ,, ,, ,, ,,0 Not Applicable";
  put "N179,""Acute kidney failure, unspecified"",GEN002,Acute and unspecified renal failure,GEN002,Acute and unspecified renal failure,GEN002,Acute and unspecified renal failure, ,, ,, ,, ,, ,,0 Not Applicable";
  put "N186,End stage renal disease,GEN003,Chronic kidney disease,GEN003,Chronic kidney disease,GEN003,Chronic kidney disease, ,, ,, ,, ,, ,,0 Not Applicable";
  put "I509,""Heart failure, unspecified"",CIR019,Heart failure,CIR019,Heart failure,CIR019,Heart failure, ,, ,, ,, ,, ,,0 Not Applicable";
run;

data INPUT_SAS_FILE;
  length KEY 8 I10_NDX 8 I10_DX1-I10_DX5 $7;
  input KEY I10_NDX I10_DX1 $ I10_DX2 $ I10_DX3 $ I10_DX4 $ I10_DX5 $;
  datalines;
1 3 E1122 N186 I10 . .
2 2 E1121 E785 . . .
3 4 E1165 I10 E785 I509 .
4 1 E1140 . . . .
5 3 E11311 E1129 N179 . .
;
run;
