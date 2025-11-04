# Use the SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy only the csproj files first to leverage caching
COPY ["CareConnect.API/CareConnect.API.csproj", "CareConnect.API/"]
COPY ["CareConnect.Models/CareConnect.Models.csproj", "CareConnect.Models/"]
COPY ["CareConnect.Services/CareConnect.Services.csproj", "CareConnect.Services/"]

# Restore packages separately for caching
RUN dotnet restore "CareConnect.API/CareConnect.API.csproj"

# Copy the rest of the source code
COPY . .

# Build and publish
RUN dotnet publish "CareConnect.API/CareConnect.API.csproj" -c Release -o /app --no-restore

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "CareConnect.API.dll"]