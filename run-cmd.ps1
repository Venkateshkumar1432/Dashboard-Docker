Write-Host "🚀 Starting deployment..."

# admin-portal
docker build -t admin-portal ./admin-portal
docker run -d --name admin-portal --network ems-network -p 3003:3003 admin-portal

# api-gateway
docker build -t api-gateway ./api-gateway
docker run -d --name api-gateway --network ems-network -p 8000:8000 api-gateway

# postgree-database 
docker run -d --name postgres-db --network ems-network -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=3635 -e POSTGRES_DB=ev91platform_2 -p 5432:5432 postgres:15

# auth-service
docker build -t auth-service ./services/auth-service
docker run -d --name auth-service --network ems-network -p 4001:4001 -p 5555:5555 auth-service
docker exec -it auth-service npx prisma db push
docker exec -it auth-service npx prisma db seed
docker exec -it auth-service npx tsx prisma/seed
docker exec -it auth-service npx prisma studio --hostname 0.0.0.0 --port 5555 --browser none


# client-store-service
docker build -t client-store-service ./services/client-store-service
docker run -d --name client-store-service --network ems-network -p 3006:3006 -p 5556:5556 client-store-service
docker exec -it client-store-service npx prisma db push
docker exec -it client-store-service npx prisma db seed
docker exec -it client-store-service npx tsx prisma/seed
docker exec -it client-store-service npx prisma studio --hostname 0.0.0.0 --port 5556 --browser none

#spare-part-service
docker build -t spare-parts-service ./services/spare-parts-service
docker run -d --name spare-parts-service --env-file .env --network ems-network -p 4010:4010 -p 5558:5558 spare-parts-service
docker exec -it spare-parts-service npx prisma db push
docker exec -it spare-parts-service npx prisma db seed
docker exec -it spare-parts-service npx tsx prisma/seed
docker exec -it spare-parts-service npx prisma studio --hostname 0.0.0.0 --port 5558 --browser none

# vehicle-service
docker build -t vehicle-service ./services/vehicle-service
docker run -d --name vehicle-service --network ems-network -p 4004:4004 -p 5557:5557 vehicle-service
docker exec -it vehicle-service npx prisma db push
docker exec -it vehicle-service npx prisma db seed
docker exec -it vehicle-service npx tsx prisma/seed
docker exec -it vehicle-service npx prisma studio --hostname 0.0.0.0 --port 5557 --browser none

# rider-service
docker build -t rider-service ./services/rider-service
docker run -d --name rider-service --network ems-network -p 4005:4005 -p 5559:5559 rider-service
docker exec -it rider-service npx prisma db push
docker exec -it rider-service npx prisma db seed
docker exec -it rider-service npx tsx prisma/seed
docker exec -it rider-service npx prisma studio --hostname 0.0.0.0 --port 5559 --browser none


Write-Host "✅ Deployment finished successfully!"
