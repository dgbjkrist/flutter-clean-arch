library auth;

/// Public API for the `auth` package

// Presentation
export 'presentation/screens/screens.dart';
export 'presentation/cubits/cubits.dart';

// Domain
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/entities/user.dart';

// DI
export './core/di/service_locator.dart';
