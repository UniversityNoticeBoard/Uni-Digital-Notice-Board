# ---- Build stage ----
FROM node:18-alpine AS build-stage

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npx parcel build src/index.html \
  --dist-dir dist \
  --public-url ./ \
  --no-cache

# ---- Production stage ----
FROM nginx:alpine

COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
