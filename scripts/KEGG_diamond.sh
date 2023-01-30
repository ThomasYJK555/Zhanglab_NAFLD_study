## The protein sequences in SGBs were annotated by Prodigal in GTDB-TK suit, we can directly use the sequeces for KEGG annotation 
diamond blastp -q $PATH_gtdb_results/identify/intermediate_results/marker_genes/SGB.protein.faa --db $PATH_TO_KEGG_DATABASE --outfmt 6 --out SGB.KEGG.m8 --threads 40 -e 1e-5