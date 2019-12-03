output:large_graphs.jpg large_graphs2.jpg
	ls >/dev/null

large_graphs.jpg:large_graphs.dot
	dot -Tjpg large_graphs.dot -o large_graphs.jpg
large_graphs2.jpg:large_graphs2.dot
	dot -Tjpg large_graphs2.dot -o large_graphs2.jpg

clean:
	rm large_graphs.jpg large_graphs2.jpg
