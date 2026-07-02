# Skillet Player

Тёмный минималистичный локальный музыкальный плеер для Android (Flutter).
Приложение само не содержит и не скачивает никакой музыки — оно сканирует
и проигрывает аудиофайлы, уже находящиеся на устройстве пользователя.

## Как получить APK

APK собирается автоматически в GitHub Actions при каждом пуше в `main`.

1. Зайдите во вкладку **Actions** этого репозитория.
2. Откройте последний успешный запуск workflow **Build APK**.
3. Скачайте артефакт **skillet-player-apk** внизу страницы (это `.zip` с
   `app-release.apk` внутри).
4. Перенесите `app-release.apk` на телефон, откройте файл, разрешите
   установку из неизвестных источников — приложение установится.

## Локальная сборка (если на компьютере установлен Flutter + Android SDK)

```bash
flutter create --platforms=android --org com.skilletplayer --project-name skillet_player build_app
cp -r src/lib build_app/lib
cp src/pubspec.yaml build_app/pubspec.yaml
cp -r src/assets build_app/assets
cp overlay_android/app/src/main/AndroidManifest.xml build_app/android/app/src/main/AndroidManifest.xml
cd build_app
flutter pub get
flutter build apk --release
```

Готовый файл: `build_app/build/app/outputs/flutter-apk/app-release.apk`

## Структура

- `src/lib` — исходный код (экраны, состояние плеера, тема)
- `src/pubspec.yaml` — зависимости и конфигурация иконки приложения
- `src/assets/icon/icon.svg` — исходник иконки (генерируется в PNG при сборке)
- `overlay_android/` — файлы, которые накладываются поверх стандартного
  Android-каркаса Flutter (разрешения на доступ к аудио, фоновое воспроизведение)
- `.github/workflows/build-apk.yml` — CI-сборка APK
