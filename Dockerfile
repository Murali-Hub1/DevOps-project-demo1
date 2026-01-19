# Use lightweight Node image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files first (layer caching best practice)
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy source code
COPY src ./src

# Expose application port
EXPOSE 3000

# Start application
CMD ["npm", "start"]
