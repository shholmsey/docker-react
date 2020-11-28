# docker file used in production
# the name of the build stage to use for any subsequent instructions that follow 
FROM node:12 as builder 
WORKDIR '/app'
COPY package.json .
RUN npm install
# copy all of our source code directly into the container
COPY . .
RUN npm run build
# end of first temporary container

# use JUST the build result above and setup ngnix image
FROM nginx
# use the builder phase reference defined above
# according to the ngnix docs we need to copy our source code to 
# /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html
# ngnix doesn't need a start/run command as it takes care of it automatically