# Install necessary libraries (if not already installed)
install.packages("igraph")   # For graph-related operations
install.packages("ggraph")   # For graph visualization
install.packages("ggplot2")  # For additional plotting functionalities

# Load the required libraries into the environment
library(igraph)   # To work with graph data structures and algorithms
library(ggraph)   # To visualize graphs with ggplot2-based syntax
library(ggplot2)  # For graph plotting and visualizations

# Read the graph data from a CSV file into a data frame
graph_data <- read.csv("graph1.csv", header = FALSE, col.names = c("V1", "V2"))
# Print the original graph data to ensure the input is correctly loaded
print("Original graph data:")
print(graph_data)

# Remove duplicate edges (if any) from the graph data to ensure uniqueness
graph_data <- unique(graph_data)

# Create both directed and undirected graphs using the igraph library
d_graph <- graph_from_data_frame(graph_data, directed = TRUE)  # Directed graph
ud_graph <- graph_from_data_frame(graph_data, directed = FALSE) # Undirected graph

# Print summaries of both directed and undirected graphs for verification
print("Directed graph summary:")
print(summary(d_graph))

print("Undirected graph summary:")
print(summary(ud_graph))

# Function to check if a Hamiltonian path exists in a graph
has_hamiltonian_path <- function(graph) {
  n <- vcount(graph)  # Number of vertices in the graph
  vertices <- V(graph)  # List of vertices in the graph

  # Backtracking function to find a Hamiltonian path
  find_hamiltonian_path <- function(path) {
    if (length(path) == n) {
      return(TRUE)  # Hamiltonian path found when all vertices are visited
    }
    last_vertex <- tail(path, 1)
    for (neighbor in neighbors(graph, last_vertex)) {
      if (!(neighbor %in% path)) {  # Avoid revisiting vertices
        if (find_hamiltonian_path(c(path, neighbor))) {
          return(TRUE)  # Recursively attempt to find the path
        }
      }
    }
    return(FALSE)  # No path found
  }

  # Try starting from each vertex
  for (start_vertex in vertices) {
    if (find_hamiltonian_path(start_vertex)) {
      return(TRUE)  # If a Hamiltonian path is found, return TRUE
    }
  }
  return(FALSE)  # No Hamiltonian path exists
}

# Function to check if a Hamiltonian cycle exists in a graph
has_hamiltonian_cycle <- function(graph) {
  n <- vcount(graph)  # Number of vertices
  vertices <- V(graph)  # List of vertices

  # Backtracking function to find a Hamiltonian cycle
  find_hamiltonian_cycle <- function(path) {
    if (length(path) == n) {
      # Check if the last vertex connects back to the first vertex
      if (are_adjacent(graph, tail(path, 1), path[1])) {
        return(TRUE)  # Hamiltonian cycle found
      }
      return(FALSE)
    }
    last_vertex <- tail(path, 1)
    for (neighbor in neighbors(graph, last_vertex)) {
      if (!(neighbor %in% path)) {  # Avoid revisiting vertices
        if (find_hamiltonian_cycle(c(path, neighbor))) {
          return(TRUE)  # Recursively attempt to find the cycle
        }
      }
    }
    return(FALSE)  # No cycle found
  }

  # Try starting from each vertex
  for (start_vertex in vertices) {
    if (find_hamiltonian_cycle(start_vertex)) {
      return(TRUE)  # If a Hamiltonian cycle is found, return TRUE
    }
  }
  return(FALSE)  # No Hamiltonian cycle exists
}

# Function to check if an Eulerian path exists in a graph
has_eulerian_path <- function(graph, directed = TRUE) {
  if (directed) {
    # For directed graphs, check the in-degree and out-degree of each vertex
    in_degree <- degree(graph, mode = "in")
    out_degree <- degree(graph, mode = "out")
    diff <- out_degree - in_degree  # Difference between out-degree and in-degree

    # Check if the Eulerian path conditions are met for directed graphs
    return(sum(diff == 1) == 1 && sum(diff == -1) == 1 && all(diff[diff != 1 & diff != -1] == 0))
  } else {
    # For undirected graphs, check the degree of vertices
    degrees <- degree(graph)

    # Eulerian path condition for undirected graphs: exactly two vertices with odd degree
    return(sum(degrees %% 2 == 1) == 2 && is_connected(graph))
  }
}

# Function to check if an Eulerian cycle exists in a graph
has_eulerian_cycle <- function(graph, directed = TRUE) {
  if (directed) {
    # For directed graphs, check if in-degree equals out-degree for all vertices
    in_degree <- degree(graph, mode = "in")
    out_degree <- degree(graph, mode = "out")

    # Check if the Eulerian cycle conditions are met for directed graphs
    return(all(in_degree == out_degree) && is_connected(graph))
  } else {
    # For undirected graphs, check if all vertices have even degree
    degrees <- degree(graph)

    # Eulerian cycle condition for undirected graphs: all vertices should have even degree
    return(all(degrees %% 2 == 0) && is_connected(graph))
  }
}

# Check for Hamiltonian and Eulerian properties in the directed graph
print("Checking directed graph:")
cat("Hamiltonian path exists:", has_hamiltonian_path(d_graph), "\n")
cat("Hamiltonian cycle exists:", has_hamiltonian_cycle(d_graph), "\n")
cat("Eulerian path exists:", has_eulerian_path(d_graph, directed = TRUE), "\n")
cat("Eulerian cycle exists:", has_eulerian_cycle(d_graph, directed = TRUE), "\n")

# Check for Hamiltonian and Eulerian properties in the undirected graph
print("Checking undirected graph:")
cat("Hamiltonian path exists:", has_hamiltonian_path(ud_graph), "\n")
cat("Hamiltonian cycle exists:", has_hamiltonian_cycle(ud_graph), "\n")
cat("Eulerian path exists:", has_eulerian_path(ud_graph, directed = FALSE), "\n")
cat("Eulerian cycle exists:", has_eulerian_cycle(ud_graph, directed = FALSE), "\n")

# Visualize the directed graph using ggraph with arrows
ggraph(d_graph, layout = "fr") +  # Use Fruchterman-Reingold layout for force-directed graph
  geom_edge_link(
    color = "blue",
    alpha = 0.6,   # Edge transparency
    arrow = arrow(length = unit(2, "mm")),  # Add arrows to edges
    end_cap = circle(3, "mm")  # Adjust arrowhead size
  ) +
  geom_node_point(size = 5, color = "red") +  # Customize node appearance
  geom_node_text(aes(label = name), repel = TRUE, size = 4) +  # Add node labels with repulsion to avoid overlap
  theme_void() +  # Remove axis and background for a clean graph
  ggtitle("Directed Graph from CSV edge list")  # Set graph title

# Another visualization with curved edges for a smoother look
ggraph(d_graph, layout = "fr") +
  geom_edge_arc(
    arrow = arrow(length = unit(2, "mm")),
    color = "blue",
    alpha = 0.6,
    curvature = 0.2  # Adjust curvature for smoother edges
  ) +
  geom_node_point(size = 5, color = "red") +
  geom_node_text(aes(label = name), repel = TRUE, size = 4) +
  theme_void() +
  ggtitle("Directed Graph with Curved Edges")

# Visualize the undirected graph using ggraph
ggraph(ud_graph, layout = "fr") +  # Fruchterman-Reingold layout
  geom_edge_link(color = "green", alpha = 0.6) +  # Customize edges
  geom_node_point(size = 5, color = "purple") +  # Customize node colors
  geom_node_text(aes(label = name), repel = TRUE, size = 4) +  # Add node labels
  theme_void() +  # Remove background and axes for cleaner look
  ggtitle("Undirected Graph from CSV edge list")  # Set graph title
