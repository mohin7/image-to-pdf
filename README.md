<h1 align="center">PDFlex</h1>

<p align="center">
  <strong>A modern, lightning-fast utility to convert images to PDFs, merge, split, and compress your documents entirely on-device.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter" alt="Flutter version">
  <img src="https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/Architecture-Riverpod-orange.svg" alt="Architecture">
</p>

---

## 🌟 Why PDFlex is the Best

PDFlex isn't just another PDF utility. It is built from the ground up to offer a **premium, 2026-era user experience** while prioritizing speed, security, and aesthetics. Here is why it stands out from the crowd:

### 1. 100% On-Device & Secure 🔒
Most PDF utilities upload your highly sensitive documents (IDs, bank statements, personal photos) to a remote server for processing. **PDFlex does all the heavy lifting locally on your device.** 
- Zero network requests for processing.
- Zero server wait times.
- Absolute privacy and peace of mind.

### 2. State-of-the-Art 2026 UI/UX Design ✨
The app features a gorgeous, modern aesthetic that feels premium:
- **Glassmorphism:** Beautiful frosted glass app bars and bottom navigation.
- **Dynamic Micro-Animations:** Satisfying feedback on buttons, cards, and transitions.
- **OLED Dark Mode:** True blacks and vibrant coral-red accents that make the UI pop while saving battery.
- **Fluid Gestures:** Native-feeling drag-and-drop reordering and slick swipe actions.

### 3. Blazing Fast Performance ⚡
Written purely in Dart with highly optimized image decoding and compression algorithms, PDFlex renders and exports massive PDFs instantly. No lag, no stuttering.

### 4. An All-In-One Toolkit 🧰
Instead of downloading separate apps for different tasks, PDFlex does it all:
- **Image to PDF:** Convert endless images into a single formatted PDF with adjustable page sizes and margins.
- **Merge:** Stitch multiple PDFs together seamlessly.
- **Split:** Extract specific pages from large PDFs.
- **Compress:** Shrink heavy PDFs without losing readability so you can easily share them over email or WhatsApp.

---

## 🛠 Features

* **Advanced PDF Generation:** Support for multiple page formats (A4, Letter, fit-to-image) and orientations.
* **Custom Compression:** Choose your image quality percentage to balance file size and clarity.
* **Seamless File Sharing:** Instantly share generated PDFs via the native iOS/Android share sheets or save them directly to your Files app.
* **Smart File Manager:** Built-in repository for all your generated documents, easily sortable and accessible.

## 🚀 Getting Started

To run this project locally, make sure you have [Flutter](https://docs.flutter.dev/get-started/install) installed on your machine.

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/image-to-pdf.git
   ```
2. Navigate to the project directory:
   ```bash
   cd image-to-pdf
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🏗 Architecture

PDFlex is built using modern Flutter best practices:
- **State Management:** Fully reactive using `Riverpod` (`Notifier` and `AsyncNotifier`).
- **Design System:** Custom token-based design system (`app_colors.dart`, `app_spacing.dart`, `app_typography.dart`) for effortless scalability and consistent theming.
- **Separation of Concerns:** Clear boundaries between UI features and background services (`FileService`, `PdfService`, `PdfKitService`).

## 📄 License

This project is licensed under the MIT License.
