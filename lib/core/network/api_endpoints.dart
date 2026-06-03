/// Centralized API path constants.
///
/// Use these in retrofit API clients to keep paths DRY.
/// Paths with `:citizenId` are auto-replaced by [AuthInterceptor].
class ApiEndpoints {
  ApiEndpoints._();

  // Config
  static const appConfig = '/app-config';

  // Auth
  static const otpSend = '/auth/otp/send';
  static const otpVerify = '/auth/otp/verify';
  static const logout = '/citizens/:citizenId/auth/logout';
  static const refreshToken = '/citizens/:citizenId/auth/refresh';
  static const deleteAccount = '/citizens/:citizenId/account';

  // Citizen Profile
  static const citizenProfile = '/citizens/:citizenId/profile';
  static const updateProfile = '/citizens/:citizenId/profile/update';
  static const citizenSettings = '/citizens/:citizenId/settings';

  // Notifications
  static const notifications = '/citizens/:citizenId/notifications';
  static const markNotificationsRead =
      '/citizens/:citizenId/notifications/mark-as-read';

  // Activity
  static const activitySummary = '/citizens/:citizenId/activity/summary';

  // Concerns
  static const citizenConcerns = '/citizens/:citizenId/concerns';
  static const constituencyConcerns =
      '/constituencies/{constituencyId}/concerns';

  // Ideas
  static const citizenIdeas = '/citizens/:citizenId/ideas';
  static const constituencyIdeas = '/constituencies/{constituencyId}/ideas';

  // Appreciations
  static const citizenAppreciations = '/citizens/:citizenId/appreciations';
  static const constituencyAppreciations =
      '/constituencies/{constituencyId}/appreciations';

  // MLA & Constituency
  static const mla = '/constituencies/{constituencyId}/mla';
  static const constituencySummary =
      '/constituencies/{constituencyId}/summary';
  static const mlaPosts = '/constituencies/{constituencyId}/posts';
  static const publicEvents = '/constituencies/{constituencyId}/public-events';

  // Conversations
  static const threads = '/citizens/:citizenId/conversations/threads';

  // Geography
  static const constituencies = '/constituencies';
}
