# Use official Node.js image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install --production

# Copy app code
COPY app.js .

# Expose port
EXPOSE 3000

# Run the app
CMD ["npm", "start"]
