sealed class AppError implements Exception {
  const AppError(this.message);
  final String message;
}

final class PermissionDeniedError extends AppError {
  const PermissionDeniedError([super.message = 'Permission was denied.']);
}

final class PdfGenerationError extends AppError {
  const PdfGenerationError([super.message = 'Failed to generate PDF.']);
}

final class FileSaveError extends AppError {
  const FileSaveError([super.message = 'Failed to save file.']);
}

final class UnknownError extends AppError {
  const UnknownError([super.message = 'An unexpected error occurred.']);
}
