const baseUrl = "http://10.0.2.2:8055";

enum ApiEndpoints {
  getDocuments("$baseUrl/auth/get-docs"),
  addDocument("$baseUrl/auth/add-doc"),
  currentUser("$baseUrl/auth/current"),
  googleLogin("$baseUrl/auth/google");

  final String endPoint;
  const ApiEndpoints(this.endPoint);
}