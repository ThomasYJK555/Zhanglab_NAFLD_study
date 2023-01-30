export GTDBTK_DATA_PATH=/data2/zdh/Database/GTDBTk/release207_v2/
gtdbtk classify_wf --keep_intermediates --genome_dir $INPUT_PATH/SGBs_folder/ --extension fa --out_dir $OUTPUT_PATH/gtdb_results --cpus 30 --tmpdir $TMP_DIRECTORY_PATH
