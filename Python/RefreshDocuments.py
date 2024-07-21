import os 
import sys
import shutil

documents_path = os.path.join(os.path.expanduser("~"), "Documents")
destination_path = rf"D:\\Emre\\PublicDisplay\\{sys.argv[1]}\\{sys.argv[2]}"

if not os.path.exists(destination_path):
    os.makedirs(destination_path)

sqlite_files = ['pd.db', 'pd.db-shm', 'pd.db-wal']

for filename in os.listdir(documents_path):
    if filename.endswith('.tsv') or filename in sqlite_files:
        source_file = os.path.join(documents_path, filename)
        dest_file = os.path.join(destination_path, filename)

        shutil.copy2(source_file, dest_file)
        print(f"Copied {filename} to {dest_file}")

        os.remove(source_file)
        print(f"Deleted {filename} from {documents_path}")

print("Finished copying and deleting files")