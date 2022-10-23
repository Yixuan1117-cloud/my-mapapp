FROM node:16-alpine AS deps
WORKDIR /app

COPY package.json ./
RUN npm install --legacy-peer-deps
COPY . .



FROM node:16-alpine AS builder
WORKDIR /app
COPY --from=deps /app ./
RUN npm run build


FROM node:16-alpine AS runner
WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
RUN npm install next --legacy-peer-deps

EXPOSE 3000
CMD ["npm","run","dev"]