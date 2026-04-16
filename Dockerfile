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
# Use npx to trigger pm2; it will find the local or global binary automatically
CMD ["sh", "-c", "npx pm2 start pnpm --name backend -- run start:prod:backend && npx pm2 start pnpm --name frontend -- run start:prod:frontend && npx pm2 logs"]

