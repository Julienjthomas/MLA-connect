## ADDED Requirements

### Requirement: Freezed model pattern
The system SHALL use `freezed` + `json_serializable` for all new data models, generating immutable classes with `fromJson`, `toJson`, `copyWith`, and value equality.

#### Scenario: Define a new model
- **WHEN** a developer creates a new model class annotated with `@freezed`
- **THEN** running `dart run build_runner build` generates the `.freezed.dart` and `.g.dart` files with full serialization, equality, and copyWith support

#### Scenario: JSON key mapping
- **WHEN** a model field uses `@JsonKey(name: 'snake_case_key')`
- **THEN** the generated `fromJson` correctly maps the snake_case API response key to the camelCase Dart field

### Requirement: Retrofit API client pattern
The system SHALL use `retrofit` for all new API clients, generating HTTP implementations from abstract Dart classes annotated with route decorators.

#### Scenario: Define a new API client
- **WHEN** a developer creates an abstract class annotated with `@RestApi()` and methods annotated with `@GET`, `@POST`, etc.
- **THEN** running `dart run build_runner build` generates a concrete implementation class that makes the correct HTTP calls via Dio

#### Scenario: API client uses shared Dio instance
- **WHEN** a retrofit API client is instantiated
- **THEN** it receives the app's configured Dio instance (with all interceptors) via constructor injection

### Requirement: Example model exists
The system SHALL include one example freezed model demonstrating the pattern for the team.

#### Scenario: Example model compiles and generates
- **WHEN** `dart run build_runner build` is executed
- **THEN** the example model's `.freezed.dart` and `.g.dart` files are generated without errors

### Requirement: Example API client exists
The system SHALL include one example retrofit API client (e.g. `ConfigApi` for `GET /app-config`) demonstrating the pattern.

#### Scenario: Example API client compiles and generates
- **WHEN** `dart run build_runner build` is executed
- **THEN** the example API client's `.g.dart` file is generated without errors
