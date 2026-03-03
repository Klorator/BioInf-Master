from sys import argv

paralog_file = argv[1]

dict = {}
current_query = None

blast_data = []

for line in open(paralog_file):
    blast_data.append(line.strip().split('\t'))

paralog_name = []

for hit in range(0,len(blast_data)):
    if current_query is None:
        gene_name = blast_data[hit][0]
        paralog_name.append(str(blast_data[hit][1]))
        current_query = gene_name
        if hit+1 < len(blast_data) and blast_data[hit+1][0] != blast_data[hit][0]:
            dict[gene_name] = paralog_name
            current_query = None
            paralog_name = []
    elif len(current_query) > 0 and blast_data[hit-1][0] == blast_data[hit][0]:
        paralog_name.append(str(blast_data[hit][1]))
        current_query = gene_name
        if hit+1 < len(blast_data) and blast_data[hit+1][0] != blast_data[hit][0]:
            dict[gene_name] = paralog_name
            current_query = None
            paralog_name = []
dict[gene_name] = paralog_name

for key in dict:
    copy_names = dict[key]
    n_copies = len(copy_names)
    #print(copy_names, n_copies)
    if n_copies > 1:
        for copy in range(0, len(copy_names)):
            paralog_copies = dict[copy_names[copy]]
            copy_names = copy_names + paralog_copies
        copy_names = list(dict.fromkeys(copy_names))

    n_copies_new = len(copy_names)
    print(key, n_copies_new, ','.join(copy_names), sep = '\t')
