#!/usr/bin/env fish

function show_progress
    set percentage (math "$processed_files * 100 / $total_files")
    echo -ne "Progress: $percentage% ($processed_files/$total_files)\r"
end

function process_archive
    set ARCHIVE $argv[1]
    set TARGET_DIR $argv[2]

    # 檢查檔案類型並解壓縮
    if string match -q "*.zip" $ARCHIVE
        unzip -q -d "$TARGET_DIR" "$ARCHIVE"
    else if string match -q "*.rar" $ARCHIVE
        unrar x -inul "$ARCHIVE" "$TARGET_DIR"
    else
        echo "Unsupported archive format"
        return 1
    end
end

# 檢查是否提供了兩個參數
if test (count $argv) -ne 2
    echo "Usage: extract_and_organize.fish <source_directory> <target_directory>"
    exit 1
end

set SOURCE_DIR $argv[1]
set TARGET_DIR $argv[2]

# 確認源目錄存在
if not test -d $SOURCE_DIR
    echo "Source directory does not exist: $SOURCE_DIR"
    exit 1
end

# 確認目標目錄存在
if not test -d $TARGET_DIR
    echo "Target directory does not exist: $TARGET_DIR"
    exit 1
end

# 計算總檔案數量
set total_files (find $SOURCE_DIR -type f \( -name "*.rar" -o -name "*.zip" \) | count)
set processed_files 0

# 遍歷所有子目錄中的壓縮檔案
for file in (find $SOURCE_DIR -type f \( -name "*.rar" -o -name "*.zip" \))
    if test -f $file
        set sub_dir (dirname (string replace -r "^$SOURCE_DIR/" "" "$file"))
        set target_subdir "$TARGET_DIR/$sub_dir"
        mkdir -p "$target_subdir"
        process_archive $file $target_subdir
        set processed_files (math "$processed_files + 1")
        show_progress
    end
end

echo -e "\nAll files processed."
