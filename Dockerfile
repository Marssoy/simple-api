FROM public.ecr.aws/docker/library/node:18.15.0

WORKDIR /app

ENV API_PORT=3000
ENV DB_DATABASE=postgres
ENV DB_HOST=DB_HOST_VALUE
ENV DB_USER=kxcadmin
ENV DB_PASSWORD=adminpassword

COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 3000

CMD [ "npm", "run", "start" ]