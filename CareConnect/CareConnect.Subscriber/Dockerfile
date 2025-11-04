FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the csproj files for caching
COPY ["CareConnect.Subscriber/CareConnect.Subscriber.csproj", "CareConnect.Subscriber/"]
COPY ["CareConnect.Models/CareConnect.Models.csproj", "CareConnect.Models/"]
COPY ["CareConnect.Services/CareConnect.Services.csproj", "CareConnect.Services/"]

# Restore dependencies separately
RUN dotnet restore "CareConnect.Subscriber/CareConnect.Subscriber.csproj"

# Copy the rest of the code
COPY . .

# Build and publish
RUN dotnet publish "CareConnect.Subscriber/CareConnect.Subscriber.csproj" -c Release -o /app --no-restore

# Runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "CareConnect.Subscriber.dll"]