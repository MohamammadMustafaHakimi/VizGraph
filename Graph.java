import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

/**
 * A class representing a Graph using an adjacency list.
 * Supports adding and removing vertices, adding and removing edges,
 * and exporting the graph structure to a file.
 */
public class Graph {
    // The adjacencyList represents the graph's vertices and edges
    // Each vertex is mapped to a list of its neighbors (edges)
    private Map<Integer, List<Integer>> adjacencyList;

    /**
     * Constructor to initialize an empty graph.
     * Initializes the adjacency list as an empty HashMap.
     */
    public Graph() {
        adjacencyList = new HashMap<>();
    }

    /**
     * Adds a vertex to the graph.
     * If the vertex already exists, no action is taken.
     *
     * @param vertex The vertex to add.
     */
    public void addVertex(int vertex) {
        // putIfAbsent ensures that the vertex is only added if it is not already present in the map
        adjacencyList.putIfAbsent(vertex, new ArrayList<>());
    }

    /**
     * Adds a directed edge between two vertices.
     * This method calls the overloaded addEdge method with isUndirected set to false.
     *
     * @param source The source vertex.
     * @param destination The destination vertex.
     */
    public void addEdge(int source, int destination) {
        addEdge(source, destination, false); // Default: Directed Graph
    }

    /**
     * Adds an edge between two vertices, optionally making it undirected.
     *
     * @param source The source vertex.
     * @param destination The destination vertex.
     * @param isUndirected If true, the edge will be undirected (i.e., both directions will be added).
     */
    public void addEdge(int source, int destination, boolean isUndirected) {
        // Ensure both vertices exist in the adjacency list
        adjacencyList.putIfAbsent(source, new ArrayList<>());
        adjacencyList.putIfAbsent(destination, new ArrayList<>());

        // Add the destination vertex to the source's adjacency list if it's not already there
        if (!adjacencyList.get(source).contains(destination)) {
            adjacencyList.get(source).add(destination);
        }

        // For undirected graphs, add the reverse edge (destination -> source)
        if (isUndirected && !adjacencyList.get(destination).contains(source)) {
            adjacencyList.get(destination).add(source);
        }
    }

    /**
     * Removes a vertex from the graph.
     * This also removes all edges associated with this vertex.
     *
     * @param vertex The vertex to remove.
     */
    public void removeVertex(int vertex) {
        // If the vertex does not exist in the graph, exit early
        if (!adjacencyList.containsKey(vertex)) return;

        // Remove the vertex from the adjacency list
        adjacencyList.remove(vertex);

        // Remove any edges that point to the removed vertex
        for (List<Integer> neighbors : adjacencyList.values()) {
            neighbors.remove(Integer.valueOf(vertex)); // Integer.valueOf is used to remove the exact vertex
        }
    }

    /**
     * Removes a specific edge from the graph.
     * For undirected graphs, it also removes the reverse edge.
     *
     * @param source The source vertex of the edge.
     * @param destination The destination vertex of the edge.
     * @param isUndirected If true, the reverse edge will also be removed (undirected graph).
     */
    public void removeEdge(int source, int destination, boolean isUndirected) {
        // Ensure that the edge exists before trying to remove it
        if (adjacencyList.containsKey(source) && adjacencyList.get(source).contains(destination)) {
            adjacencyList.get(source).remove(Integer.valueOf(destination));
        }

        // If the graph is undirected, also remove the reverse edge
        if (isUndirected && adjacencyList.containsKey(destination) && adjacencyList.get(destination).contains(source)) {
            adjacencyList.get(destination).remove(Integer.valueOf(source));
        }
    }

    /**
     * Returns a list of neighbors for a given vertex.
     * If the vertex does not exist, returns an empty list.
     *
     * @param vertex The vertex whose neighbors are to be returned.
     * @return A list of neighbors of the specified vertex.
     */
    public List<Integer> getNeighbors(int vertex) {
        return adjacencyList.getOrDefault(vertex, new ArrayList<>());
    }

    /**
     * Prints the graph in a human-readable format: vertex -> neighbors.
     * Each vertex and its neighbors are printed on a new line.
     */
    public void printGraph() {
        for (Map.Entry<Integer, List<Integer>> entry : adjacencyList.entrySet()) {
            System.out.print(entry.getKey() + " -> ");
            for (Integer neighbor : entry.getValue()) {
                System.out.print(neighbor + " ");
            }
            System.out.println();
        }
    }

    /**
     * Exports the graph's edge list to a CSV file for further analysis or use.
     * Each edge is written on a new line in the format: source,destination.
     *
     * @param filename The name of the file to export the edge list to.
     */
    public void exportEdgeList(String filename) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
            // Iterate over each vertex and its list of neighbors to create an edge list
            for (Map.Entry<Integer, List<Integer>> entry : adjacencyList.entrySet()) {
                for (Integer neighbor : entry.getValue()) {
                    writer.write(entry.getKey() + "," + neighbor);
                    writer.newLine(); // Add a new line after each edge
                }
            }
            System.out.println("Edge list exported to " + filename);
        } catch (IOException e) {
            // Handle file I/O errors
            e.printStackTrace();
        }
    }

    /**
     * Main method demonstrating the usage of the Graph class.
     * Creates two example graphs, adds vertices and edges,
     * and exports the graph to CSV files while printing the graph.
     *
     * @param args Command line arguments.
     */
    public static void main(String[] args) {
        // Create and initialize a directed graph
        Graph graph1 = new Graph();
        graph1.addVertex(0);
        graph1.addVertex(1);
        graph1.addVertex(2);
        graph1.addEdge(0, 1, true); // Undirected Edge
        graph1.addEdge(0, 2); // Directed Edge
        graph1.addEdge(1, 2, true); // Undirected Edge

        // Print and export the graph as an edge list to a CSV file
        System.out.println("Graph 1: ");
        graph1.exportEdgeList("graph1.csv");
        graph1.printGraph();

        // Uncomment the following lines to test edge removal
        // graph1.removeEdge(0, 2, false); // Remove directed edge 0 -> 2
        // System.out.println("Updated graph 1: ");
        // graph1.printGraph();

        // Create and initialize another graph
        Graph graph2 = new Graph();
        graph2.addVertex(0);
        graph2.addVertex(1);
        graph2.addVertex(2);
        graph2.addEdge(0, 0, true); // Self-loop (undirected)
        graph2.addEdge(0, 1, true); // Undirected edge
        graph2.addEdge(2, 1, false); // Directed edge

        // Print and export the second graph
        System.out.println("Graph 2: ");
        graph2.exportEdgeList("graph2.csv");
        graph2.printGraph();
    }
}
