# Step 1: Use Node.js for the build stage
FROM node:18 as build-stage

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app's code
COPY . .

ARG BASE_API_URL
ENV VITE_BASE_API_URL=$BASE_API_URL

# Build the Vue app for production
RUN npm run build

# Step 2: Use Nginx to serve the built app
FROM nginx:alpine as production-stage

# Copy the custom nginx.conf to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built files from the build stage to Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 8080
EXPOSE 8080

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]