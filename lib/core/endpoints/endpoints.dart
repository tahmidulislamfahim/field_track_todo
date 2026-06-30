class Endpoints {
  static const String baseUrl = 'https://todo.progressivebyte.com';

  static const String registration = '$baseUrl/api/v1/auth/register';
  static const String login = '$baseUrl/api/v1/auth/login';
  static const String userMe = '$baseUrl/api/v1/me';
  static const String logout = '$baseUrl/api/v1/auth/logout';
  static const String refresh = '$baseUrl/api/v1/auth/refresh';

  static const String locations = '$baseUrl/api/v1/locations';
  static String deleteOrEditLocation(String locationId) =>
      '$baseUrl/api/v1/locations/$locationId';
  static String getAllTodo = '$baseUrl/api/v1/todos';
  static String updateTodo(String todoId) => '$baseUrl/api/v1/todos/$todoId';
  static String syncTodo = '$baseUrl/api/v1/todos/sync';
}
