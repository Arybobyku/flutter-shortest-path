import 'dart:math';

class Graph {
  int vertices;
  List<Node> nodes = [];

  Graph(this.vertices);

  void addNode(Node node) {
    nodes.add(node);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180.0;
  }

  List<int> travelingSalesmanNearestNeighbor(int startingNode) {
    List<int> path = [];
    Set<int> unvisitedNodes = Set.from(List.generate(vertices, (index) => index));
    int current = startingNode;

    while (unvisitedNodes.isNotEmpty) {
      unvisitedNodes.remove(current);
      path.add(current);

      double minDistance = double.infinity;
      int nextNode = current;

      for (int node in unvisitedNodes) {
        double distance = calculateDistance(
            nodes[current].latitude,
            nodes[current].longitude,
            nodes[node].latitude,
            nodes[node].longitude);

        if (distance < minDistance) {
          minDistance = distance;
          nextNode = node;
        }
      }

      current = nextNode;
    }

    path.add(startingNode); // Return to the starting node to complete the loop
    return path;
  }
}

class Node {
  double latitude;
  double longitude;

  Node(this.latitude, this.longitude);
}

void main() {
  // Example usage
  Graph graph = Graph(4);
  graph.addNode(Node(3.407539653091186, 98.35273677975381)); // Medan
  graph.addNode(Node(0.44752096452711254, 101.31109758186207));  // Pekanbaru
  graph.addNode(Node(-0.9465288553484569, 100.48548742688283));  // Padang
  graph.addNode(Node(2.7522784482164693, 98.21330773632826)); // Sidikalang
  graph.addNode(Node(4.906497303037172, 96.27943128787668)); // Aceh

  int startingNode = 0; // Starting from Berlin
  List<int> path = graph.travelingSalesmanNearestNeighbor(startingNode);

  print("Optimal Path:");
  for (int nodeIndex in path) {
    print("Node: ${nodeIndex + 1}, Latitude: ${graph.nodes[nodeIndex].latitude}, Longitude: ${graph.nodes[nodeIndex].longitude}");
  }
}
