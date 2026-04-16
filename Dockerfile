FROM node:22-slim

# 1. Set the environment variables pnpm needs
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# 2. Enable corepack
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

WORKDIR /app
COPY . .

# 3. Install and build
RUN pnpm install --frozen-lockfile
RUN pnpm build

# 4. Install pm2 (This will now work because PNPM_HOME is set)
RUN pnpm add -g pm2

# 5. Start command
CMD ["sh", "-c", "pm2 start pnpm --name backend -- run start:prod:backend && pm2 start pnpm --name frontend -- run start:prod:frontend && pm2 logs"]
