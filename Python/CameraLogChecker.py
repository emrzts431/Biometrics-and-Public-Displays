log_file = "./logs_0.tsv"
body_parts_for_frames = {}
column_names = []

with open(log_file, "r") as f:
    lines = f.readlines()
    first_line = lines[0]
    first_line_splitted = first_line.split('\t')
    first_line_splitted[-1] = first_line_splitted[-1].replace('\n', '')
    column_names = first_line_splitted
    lines.pop(0)
    for line_index in range(len(lines)):
        seperated_line = lines[line_index].split('\t')
        seperated_line[-1] = seperated_line[-1].replace('\n', '')
        for column_index in range(len(seperated_line)):
            if column_index == 0 or column_index == 1:
                continue

            column_values = seperated_line[column_index].split(',')
            if line_index in body_parts_for_frames:
                body_parts_for_frames[line_index].append()
            





