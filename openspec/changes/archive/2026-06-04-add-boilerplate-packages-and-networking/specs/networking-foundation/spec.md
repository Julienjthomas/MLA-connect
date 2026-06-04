## ADDED Requirements

### Requirement: Dio HTTP client singleton
The system SHALL provide a single configured `Dio` instance managed via GetX DI (`Get.put`) that all API clients use for HTTP communication.

#### Scenario: Dio instance available globally
- **WHEN** any controller or service requests Dio via `Get.find<Dio>()`
- **THEN** the same configured Dio instance is returned with all interceptors attached

### Requirement: Auth interceptor injects JWT token
The system SHALL automatically inject the stored JWT token into the `Authorization` header of every outgoing request.

#### Scenario: Authenticated request
- **WHEN** a request is made and a valid JWT token exists in secure storage
- **THEN** the request header includes `Authorization: Bearer <token>`

#### Scenario: No token available
- **WHEN** a request is made and no JWT token exists in secure storage
- **THEN** the request proceeds without an Authorization header (for public endpoints like OTP send)

### Requirement: Auth interceptor injects citizenId into URL path
The system SHALL replace the `:citizenId` placeholder in request URLs with the stored citizen ID.

#### Scenario: citizenId path replacement
- **WHEN** a request URL contains `:citizenId` and a citizen ID is stored
- **THEN** the placeholder is replaced with the actual citizen ID before the request is sent

### Requirement: Token refresh on 401
The system SHALL automatically attempt to refresh the JWT token when a 401 response is received, then retry the original request.

#### Scenario: Successful token refresh
- **WHEN** a request returns 401 and the refresh token is valid
- **THEN** the system calls `POST /citizens/:citizenId/auth/refresh`, stores the new token, and retries the original request with the new token

#### Scenario: Failed token refresh
- **WHEN** a request returns 401 and the refresh token is expired or invalid
- **THEN** the system clears the stored session and navigates to the login screen

#### Scenario: Concurrent requests during refresh
- **WHEN** multiple requests return 401 simultaneously
- **THEN** only one refresh call is made; all pending requests are queued and retried after the refresh completes

### Requirement: Error interceptor maps HTTP errors to AppException
The system SHALL map HTTP error responses to typed `AppException` subtypes for consistent error handling.

#### Scenario: Network unavailable
- **WHEN** a request fails due to no internet connection
- **THEN** a `NetworkException` is thrown

#### Scenario: Server error
- **WHEN** a request returns a 5xx status code
- **THEN** a `ServerException` is thrown with the status code and message

#### Scenario: Not found
- **WHEN** a request returns 404
- **THEN** a `NotFoundException` is thrown

#### Scenario: Validation error
- **WHEN** a request returns 422 with field-level errors
- **THEN** a `ValidationException` is thrown containing the field error map

### Requirement: Debug logging
The system SHALL log HTTP request and response details in debug mode only.

#### Scenario: Debug build
- **WHEN** the app is running in debug mode
- **THEN** all HTTP requests and responses are logged via `pretty_dio_logger` (URL, headers, body)

#### Scenario: Release build
- **WHEN** the app is running in release mode
- **THEN** no HTTP request/response logging occurs

### Requirement: Connectivity detection
The system SHALL provide a way to check current network connectivity status.

#### Scenario: Check connectivity before request
- **WHEN** the app checks network status via `connectivity_plus`
- **THEN** it returns whether the device has an active network connection
