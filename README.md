```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Graph Visualization and Analysis Project</title>
</head>
<body>

<h1>Graph Visualization and Analysis Project</h1>

<h2>Overview</h2>
<p>This project demonstrates how to create and analyze graphs using Java for data structure construction and R for visualization and analysis. Java code handles graph construction, while R handles the visualization and analysis, such as checking for Hamiltonian and Eulerian paths and cycles.</p>

<hr>

<h2>Java Code</h2>

<h3>1. <strong>Graph Class Definition</strong></h3>
<p>The Graph class defines the graph data structure using an adjacency list. Each vertex is mapped to a list of its neighboring vertices.</p>
<pre>
<code>
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

public class Graph {
    private Map<Integer, List<Integer>> adjacencyList;

    public Graph() {
        adjacencyList = new HashMap<>();
    }
}
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li>A Map&lt;Integer, List&lt;Integer&gt;&gt; is used to represent the graph, where each vertex is an integer, and its adjacent vertices are stored in a List&lt;Integer&gt;.</li>
    <li>The constructor initializes the adjacency list.</li>
</ul>

<hr>

<h3>2. <strong>Methods for Adding and Removing Vertices and Edges</strong></h3>
<p>These methods allow adding and removing vertices and edges, both directed and undirected.</p>
<pre>
<code>
public void addVertex(int vertex) {
    adjacencyList.putIfAbsent(vertex, new ArrayList<>());
}

public void addEdge(int source, int destination) {
    addEdge(source, destination, false); // Default: Directed Graph
}

public void addEdge(int source, int destination, boolean isUndirected) {
    adjacencyList.putIfAbsent(source, new ArrayList<>());
    adjacencyList.putIfAbsent(destination, new ArrayList<>());

    if (!adjacencyList.get(source).contains(destination)) {
        adjacencyList.get(source).add(destination);
    }
    if (isUndirected && !adjacencyList.get(destination).contains(source)) {
        adjacencyList.get(destination).add(source);
    }
}

public void removeVertex(int vertex) {
    if (!adjacencyList.containsKey(vertex)) return;
    adjacencyList.remove(vertex);

    for (List<Integer> neighbors : adjacencyList.values()) {
        neighbors.remove(Integer.valueOf(vertex));
    }
}

public void removeEdge(int source, int destination, boolean isUndirected) {
    if (adjacencyList.containsKey(source) && adjacencyList.get(source).contains(destination)) {
        adjacencyList.get(source).remove(Integer.valueOf(destination));
    }
    if (isUndirected && adjacencyList.containsKey(destination) && adjacencyList.get(destination).contains(source)) {
        adjacencyList.get(destination).remove(Integer.valueOf(source));
    }
}
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li><code>addVertex()</code>: Adds a new vertex if it doesn’t already exist.</li>
    <li><code>addEdge()</code>: Adds an edge between the source and destination. Supports both directed and undirected edges.</li>
    <li><code>removeVertex()</code> and <code>removeEdge()</code>: Remove vertices and edges respectively, ensuring the integrity of the graph.</li>
</ul>

<hr>

<h3>3. <strong>Exporting the Graph to CSV</strong></h3>
<p>This method allows exporting the graph’s edge list to a CSV file for later analysis in R.</p>
<pre>
<code>
public void exportEdgeList(String filename) {
    try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
        for (Map.Entry<Integer, List<Integer>> entry : adjacencyList.entrySet()) {
            for (Integer neighbor : entry.getValue()) {
                writer.write(entry.getKey() + "," + neighbor);
                writer.newLine();
            }
        }
        System.out.println("Edge list exported to " + filename);
    } catch (IOException e) {
        e.printStackTrace();
    }
}
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li>This method writes the edges of the graph to a CSV file, with each edge represented as a pair of integers (source, destination).</li>
</ul>

<hr>

<h3>4. <strong>Graph Example and Execution</strong></h3>
<p>This part demonstrates how to create a graph, add vertices and edges, and export the graph data.</p>
<pre>
<code>
public static void main(String[] args) {
    Graph graph1 = new Graph();

    graph1.addVertex(0);
    graph1.addVertex(1);
    graph1.addVertex(2);
    graph1.addEdge(0, 1, true); // Undirected Edge
    graph1.addEdge(0, 2);
    graph1.addEdge(1, 2, true);

    System.out.println("Graph: ");
    graph1.exportEdgeList("graph1.csv");
    graph1.printGraph();

    Graph graph2 = new Graph();

    graph2.addVertex(0);
    graph2.addVertex(1);
    graph2.addVertex(2);

    graph2.addEdge(0, 0, true);
    graph2.addEdge(0, 1, true);
    graph2.addEdge(2, 1, false);
    graph2.addEdge(2, 1, false);
    System.out.println("Graph 2: ");
    graph2.exportEdgeList("graph2.csv");
    graph2.printGraph();
}
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li>Creates two graphs and adds vertices and edges.</li>
    <li>Exports the graph data to CSV files for further analysis in R.</li>
    <li>Prints the graph structure for visual inspection.</li>
</ul>

<hr>

<h2>R Code</h2>

<h3>1. <strong>Loading Necessary Libraries</strong></h3>
<p>This code loads the required libraries for graph visualization and analysis using igraph and ggraph.</p>
<pre>
<code>
# Install necessary libraries (if not already installed)
install.packages("igraph")
install.packages("ggraph")
install.packages("ggplot2")

# Load necessary libraries
library(igraph)
library(ggraph)
library(ggplot2)
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li><code>igraph</code>: A powerful library for graph manipulation and analysis.</li>
    <li><code>ggraph</code>: For graph visualization using ggplot2 syntax.</li>
</ul>

<hr>

<h3>2. <strong>Reading the CSV and Creating Graphs</strong></h3>
<p>This code reads the CSV file containing the graph data and constructs both directed and undirected graphs using igraph.</p>
<pre>
<code>
# Read the graph data from CSV
graph_data <- read.csv("graph1.csv", header = FALSE, col.names = c("V1", "V2"))

# Check the graph data
print("Original graph data:")
print(graph_data)

# Remove duplicate edges (if any)
graph_data <- unique(graph_data)

# Create directed and undirected graphs using igraph
d_graph <- graph_from_data_frame(graph_data, directed = TRUE)
ud_graph <- graph_from_data_frame(graph_data, directed = FALSE)

# Print graph summary to verify
print("Directed graph summary:")
print(summary(d_graph))

print("Undirected graph summary:")
print(summary(ud_graph))
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li>Reads the CSV file that contains the edge list.</li>
    <li>Constructs both directed and undirected graphs using <code>graph_from_data_frame()</code> from the igraph package.</li>
    <li>Removes duplicate edges and prints a summary of the graphs.</li>
</ul>

<hr>

<h3>3. <strong>Hamiltonian and Eulerian Path/Cycle Checks</strong></h3>
<p>The following functions check whether a graph contains Hamiltonian and Eulerian paths and cycles.</p>
<pre>
<code>
has_hamiltonian_path <- function(graph) {
    n <- vcount(graph)  # Number of vertices
    vertices <- V(graph)  # List of vertices
    
    # Backtracking function to find Hamiltonian path
    find_hamiltonian_path <- function(path) {
        if (length(path) == n) {
            return(TRUE)  # Hamiltonian path found
        }
        last_vertex <- tail(path, 1)
        for (neighbor in neighbors(graph, last_vertex)) {
            if (!(neighbor %in% path)) {
                if (find_hamiltonian_path(c(path, neighbor))) {
                    return(TRUE)
                }
            }
        }
        return(FALSE)
    }
    
    # Try starting from each vertex
    for (start_vertex in vertices) {
        if (find_hamiltonian_path(start_vertex)) {
            return(TRUE)
        }
    }
    return(FALSE)
}
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li>Recursive functions check if a Hamiltonian path/cycle exists by exploring each vertex and checking all possible paths.</li>
    <li>Checks the conditions for Eulerian paths and cycles based on the graph’s degree.</li>
</ul>

<hr>

<h3>4. <strong>Running the Analysis</strong></h3>
<p>This code runs the checks for both Hamiltonian and Eulerian paths and cycles for the directed graph.</p>
<pre>
<code>
# Check for Hamiltonian and Eulerian properties in the directed graph
print("Checking directed graph:")
cat("Hamiltonian path exists:", has_hamiltonian_path(d_graph), "\n")
cat("Hamiltonian cycle exists:", has_hamiltonian_cycle(d_graph), "\n")

print("Checking directed graph:")
cat("Eulerian path exists:", has_eulerian_path(d_graph, directed = TRUE), "\n")
cat("Eulerian cycle exists:", has_eulerian_cycle(d_graph, directed = TRUE), "\n")
</code>
</pre>

<p><strong>Explanation:</strong></p>
<ul>
    <li>The functions are called on the directed graph to check if Hamiltonian or Eulerian paths and cycles exist, and the results are printed.</li>
</ul>

<hr>

<h2>Full Code for Java</h2>
<p>[Insert full Java code here as presented above]</p>

<hr>

<h2>Full Code for R</h2>
<p>[Insert full R code here as presented above]</p>

</body>
</html>
```
