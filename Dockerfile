# Stage 1: Build the Flutter application
# Use the cirrusci/flutter image, which comes with the Flutter SDK pre-installed.
FROM cirrusci/flutter:stable as build

# Set the working directory
WORKDIR /app

# Copy the files required to fetch dependencies
COPY pubspec.yaml ./
COPY pubspec.lock ./

# Fetch Flutter dependencies
RUN flutter pub get

# Copy the rest of the application source code
COPY . .

# Build the Flutter web application
RUN flutter build web --release

# Stage 2: Serve the built application using Nginx
# Use a lightweight Nginx image for the final container
FROM nginx:alpine

# Copy the built web files from the 'build' stage to the Nginx web root
COPY --from=build /app/build/web /usr/share/nginx/html

# Add a custom Nginx configuration for single-page applications (SPAs)
# This ensures that all routes are redirected to index.html for Flutter's router to handle.
RUN echo 'server {     listen 80;     location / {         root /usr/share/nginx/html;         index index.html;         try_files $uri $uri/ /index.html;     } }' > /etc/nginx/conf.d/default.conf

# Expose port 80 to the Railway network
EXPOSE 80
