# Step 1: Build the application
FROM node:20-alpine AS build

WORKDIR /app

# Copy package configuration files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application files
COPY . .

# Build the project (output will be in /app/dist)
RUN npm run build

# Step 2: Serve the application using Nginx
FROM nginx:alpine

# Copy built assets from build stage to Nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the Nginx container
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
