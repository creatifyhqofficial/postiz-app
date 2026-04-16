FROM node:22-slim
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate
WORKDIR /app
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm build
# Postiz needs pm2 to manage the multiple processes
RUN pnpm add -g pm2
CMD ["sh", "-c", "pm2 start pnpm --name backend -- run start:prod:backend && pm2 start pnpm --name frontend -- run start:prod:frontend && pm2 logs"]
